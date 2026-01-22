using Jive
targets = split("""
testcompiler
base
core
compiler
corecompiler
""")
on_ci = haskey(ENV, "CI")
if false # takes 18.83 seconds
    !on_ci && VERSION >= v"1.12-beta" && push!(targets, "pkgs/cthulhu")
    !on_ci && push!(targets, "pkgs/revise")
    !on_ci && push!(targets, "pkgs/juliainterpreter")
end

# j  runtests.jl compiler/takes_long_time/typeinf_ext_toplevel.jl  takes 17.94 seconds
# jc runtests.jl compiler/takes_long_time/typeinf_ext_toplevel.jl  takes  3.16 seconds
skip = split("""
compiler/takes_long_time/
""")
runtests(@__DIR__, targets=targets, skip=skip)
