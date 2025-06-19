using Jive
targets = split("corecompiler juliainterpreter pkg testcompiler")
on_ci = haskey(ENV, "CI")
if false # takes 18.83 seconds
    !on_ci && VERSION >= v"1.12-beta" && push!(targets, "cthulhu")
end
if false # takes long
    !on_ci && push!(targets, "revise")
end
runtests(@__DIR__, targets=targets)
