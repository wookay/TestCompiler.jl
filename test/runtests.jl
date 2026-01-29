using Jive
targets = split("""
compiler/precompile.jl
testcompiler/ext.jl
core
corecompiler
base
src
compiler
testcompiler
""")
on_ci = haskey(ENV, "CI")
if false # takes 18.83 seconds
    !on_ci && VERSION >= v"1.12-beta" && push!(targets, "pkgs/cthulhu")
    !on_ci && push!(targets, "pkgs/revise")
    !on_ci && push!(targets, "pkgs/juliainterpreter")
end

# j  runtests.jl compiler/takes_long_time/typeinf_ext_toplevel.jl  takes  9.06 seconds
# jc runtests.jl compiler/takes_long_time/typeinf_ext_toplevel.jl  takes  0.05 seconds
if on_ci
skip = []
else
skip = split("""
""")
#=
compiler/takes_long_time/
=#
end
runtests(@__DIR__, targets=targets, skip=skip)
