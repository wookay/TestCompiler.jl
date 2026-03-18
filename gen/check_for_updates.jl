using Test

function check_for_updates(modules...)
    if isempty(ARGS)
        target_modules = modules
    else
        target_pkgs = Symbol.(ARGS)
        module_syms = collect(nameof.(modules))
        target_modules = getindex(modules, indexin(target_pkgs, module_syms))
    end

    julia_cmd = Base.julia_cmd()
    for mod in target_modules
        printstyled(stdout, "### ", mod, "\n"; color = :yellow)
        pkg_filepath = pathof(mod)
        script_path = normpath(pkg_filepath, "../../gen/check_for_updates_using_sugar_cubes.jl")
        @test isfile(script_path)
        args = ["--color=yes", script_path]
        cmd = Cmd([julia_cmd..., args...])
        @test success(run(cmd))
    end
end

if false
using             TestCompiler
check_for_updates(TestCompiler)
end

using             FemtoCompiler, Jive, EmojiSymbols, DumpTruck
check_for_updates(FemtoCompiler, Jive, EmojiSymbols, DumpTruck)
