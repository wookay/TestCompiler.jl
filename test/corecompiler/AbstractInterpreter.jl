using Jive
@If VERSION >= v"1.12-beta" @useinside Main module test_corecompiler_AbstractInterpreter

using Test
using Core: Compiler

# from julia/Compiler/test/AbstractInterpreter.jl
using Base.Experimental: @MethodTable, @overlay, @consistent_overlay

@MethodTable RT_METHOD_DEF
@overlay RT_METHOD_DEF Base.sin(x::Float64)::Float64 = cos(x)

method = only(Base.MethodList(RT_METHOD_DEF))
@test method.sig === Tuple{typeof(sin), Float64}


# from julia/Compiler/test/AbstractInterpreter.jl
using Core: CodeInstance, CodeInfo
source_mode = Compiler.SOURCE_MODE_ABI
@test source_mode == 0x01
include(normpath(@__DIR__, "newinterp.jl"))
@newinterp InvokeInterp
struct InvokeOwner end
codegen = IdDict{CodeInstance, CodeInfo}()
Compiler.cache_owner(::InvokeInterp) = InvokeOwner()
Compiler.codegen_cache(::InvokeInterp) = codegen
let interp = InvokeInterp()
    f = error
    args = "test"
    mi = @ccall jl_method_lookup(Any[f, args...]::Ptr{Any}, (1+length(args))::Csize_t, Base.tls_world_age()::Csize_t)::Ref{Core.MethodInstance}
    ci = Compiler.typeinf_ext_toplevel(interp, mi, source_mode)
    result = nothing
    try
        invoke(f, ci, args...)
    catch e
        result = sprint(Base.show_backtrace, catch_backtrace())
    end
    @test isa(result, String)
    @test contains(result, "[1] error(::Char, ::Char, ::Char, ::Char)")
end

end # module test_corecompiler_AbstractInterpreter
