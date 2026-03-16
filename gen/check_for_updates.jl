using Test
using FemtoCompiler, Jive, EmojiSymbols

function check_for_updates(modules...)
    julia_cmd = Base.julia_cmd()
    for mod in modules
        printstyled(stdout, "### ", mod, "\n"; color = :yellow)
        pkg_filepath = pathof(mod)
        script_path = normpath(pkg_filepath, "../../gen/check_for_updates_using_sugar_cubes.jl")
        @test isfile(script_path)
        args = ["--color=yes", script_path]
        cmd = Cmd([julia_cmd..., args...])
        @test success(run(cmd))
    end
end

check_for_updates(FemtoCompiler, Jive, EmojiSymbols)
