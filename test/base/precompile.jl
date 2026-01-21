module test_base_precompile

using Test

# from julia/test/precompile.jl

function _write_module_to(modul::Module, dir::Union{Nothing, String}, name::Union{Nothing, Symbol}, m::Expr)
    if m.head !== :module
        throw(ArgumentError(string("need a module: ", m.head)))
    end
    if name !== nothing
        m.args[2] = name
    end
    Base.remove_linenums!(m)
    jl_file_path = joinpath(dir, string(name, ".jl"))
    write(jl_file_path, string(m))
end

valueof(modul::Module, v::Union{Symbol, Expr}) = Base.eval(modul, v)
valueof(::Module, v::QuoteNode) = v.value

macro write_module_to(exprs::Vararg{Expr})
    dir = nothing
    name = nothing
    m = nothing
    for expr in exprs
        if :(=) === expr.head
            (k, v) = expr.args
            if :dir === k
                dir = valueof(__module__, v)
            elseif :name === k
                name = valueof(__module__, v)
            end
        elseif :module === expr.head
            m = expr
        end
    end
    _write_module_to(__module__, dir, name, m)
end


temp = mktempdir(@__DIR__)
@test isdir(temp)
load_path = load_cache_path = temp
pushfirst!(LOAD_PATH, load_path)
pushfirst!(DEPOT_PATH, load_cache_path)

StaleA = :StaleA_0xab07d60518763a7e
@write_module_to dir=temp name=StaleA module StaleA
    # bindings
    struct InvalidatedBinding
        x::Int
    end
    struct Wrapper
        ib::InvalidatedBinding
    end
    makewib(x) = Wrapper(InvalidatedBinding(x))
    const gib = makewib(1)
    fib() = gib.ib.x
end # module StaleA

@test isfile(joinpath(temp, string(StaleA, ".jl")))

pkg = Base.PkgId(string(StaleA))
cachefile, ocachefile = Base.compilecache(pkg)

@test isdir(Base.compilecache_dir(pkg)) # jl_WLpTC8/compiled/v1.13/
@test isfile(cachefile)  # StaleA_0xab07d60518763a7e.ji
@test isfile(ocachefile) # StaleA_0xab07d60518763a7e.dylib

@eval using $StaleA
MA = invokelatest(getglobal, @__MODULE__, StaleA)

@test MA.fib() == 1

# clean up
rm(temp, recursive = true)
@test !isfile(joinpath(temp, string(StaleA, ".jl")))

end # module test_base_precompile
