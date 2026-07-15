using Test
using Pkg

const emojis = Dict(
    :FemtoCompiler => "🛣️ ",
    :Jive => "👣",
    :TestJiveRunMoreTests => "👟",
    :EmojiSymbols => "🤔",
    :DumpTruck => "🚚",
    :TestJETLS => "✈️ ",
    :TestCompiler => "🚗",
    :TestJuliaLowering => "📉",
)

function get_target_modules(modules::Vector{Any})
    if isempty(ARGS)
        target_modules = modules
    else
        target_pkgs = Symbol.(ARGS)
        inds = indexin(target_pkgs, modules)
        if all(isnothing, inds)
            throw(ArgumentError(string("ARGS = ", ARGS)))
            return
        else
            target_modules = getindex(modules, inds)
        end
    end
    return target_modules
end

function check_for_updates(mod::Symbol)
    pkg = string(mod)
    printstyled(stdout, "### ", emojis[mod], " ", pkg, "\n"; color = :yellow, bold = true)
    pkg_dir = normpath(Pkg.devdir(), pkg)
    script_path = normpath(pkg_dir, "gen/check_for_updates_using_sugar_cubes.jl")
    @test isfile(script_path)
    julia_cmd = Base.julia_cmd()
    args = ["--color=yes", script_path]
    cmd = Cmd([julia_cmd..., args...])
    @test success(run(cmd))
end

macro check_for_updates(sym::Symbol)
    node = QuoteNode(sym)
    quote
        check_for_updates($node)
    end
end

macro check_for_updates(expr::Expr)
    modules = expr.args
    target_modules = get_target_modules(modules)
    for mod in target_modules
        check_for_updates(mod)
    end
end

if false
@check_for_updates TestCompiler
end

@check_for_updates FemtoCompiler, Jive, TestJiveRunMoreTests, EmojiSymbols, DumpTruck, TestJETLS, TestJuliaLowering
