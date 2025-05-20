using Jive
targets = split("compiler juliainterpreter pkg testcompiler")
if false # 18.83 seconds
    if !haskey(ENV, "CI")
        VERSION >= v"1.12-beta" && push!(targets, "cthulhu")
    end
end
runtests(@__DIR__, targets=targets)
