using Jive
targets = split("corecompiler testcompiler pkgs/juliainterpreter")
on_ci = haskey(ENV, "CI")
if false # takes 18.83 seconds
    !on_ci && VERSION >= v"1.12-beta" && push!(targets, "pkgs/cthulhu")
end
if false # takes long
    !on_ci && push!(targets, "pkgs/revise")
end
runtests(@__DIR__, targets=targets)
