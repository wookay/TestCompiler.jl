using Jive
targets = split("""
corecompiler/AbstractInterpreter.jl
testcompiler
compiler
corecompiler
pkgs/juliainterpreter
""")
on_ci = haskey(ENV, "CI")
if false # takes 18.83 seconds
    !on_ci && VERSION >= v"1.12-beta" && push!(targets, "pkgs/cthulhu")
end
if false # takes long
    !on_ci && push!(targets, "pkgs/revise")
end

# corecompiler/AbstractInterpreter.jl
# (compile: 14.04, recompile: 0.01, elapsed: 14.52 seconds)
skip = split("""
corecompiler/AbstractInterpreter.jl
corecompiler/setup_Compiler.jl
corecompiler/newinterp.jl
""")
runtests(@__DIR__, targets=targets, skip=skip)
