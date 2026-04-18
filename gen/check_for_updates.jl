using Test

const emojis = Dict(
    :FemtoCompiler => "🛣️ ",
    :Jive => "👣",
    :TestJiveRunMoreTests => "👟",
    :EmojiSymbols => "🤔",
    :DumpTruck => "🚚",
    :TestCompiler => "🚗",
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

function check_for_updates(mod::Module)
    printstyled(stdout, "### ", emojis[nameof(mod)], " ", mod, "\n"; color = :yellow)
    pkg_filepath = pathof(mod)
    script_path = normpath(pkg_filepath, "../../gen/check_for_updates_using_sugar_cubes.jl")
    @test isfile(script_path)
    julia_cmd = Base.julia_cmd()
    args = ["--color=yes", script_path]
    cmd = Cmd([julia_cmd..., args...])
    @test success(run(cmd))
end

macro check_for_updates(expr::Expr)
    modules = expr.args
    target_modules = get_target_modules(modules)
    for mod in target_modules
        @eval begin
            using $mod
            check_for_updates($mod)
        end
    end
end

if false
using             TestCompiler
check_for_updates(TestCompiler)
end

@check_for_updates FemtoCompiler, Jive, TestJiveRunMoreTests, EmojiSymbols, DumpTruck
