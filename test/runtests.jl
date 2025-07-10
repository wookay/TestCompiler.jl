using Jive
targets = split("testcompiler compiler corecompiler pkgs/juliainterpreter")
on_ci = haskey(ENV, "CI")
if false # takes 18.83 seconds
    !on_ci && VERSION >= v"1.12-beta" && push!(targets, "pkgs/cthulhu")
end
if false # takes long
    !on_ci && push!(targets, "pkgs/revise")
end
skip = ["corecompiler/setup_Compiler.jl", "corecompiler/newinterp.jl"]
runtests(@__DIR__, targets=targets, skip=skip)
