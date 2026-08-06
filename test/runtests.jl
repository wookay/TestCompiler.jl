using Jive
targets = split("""
compiler/precompile.jl
testcompiler/ext.jl
core/
corecompiler/
base/
stdlibs/
src/
compiler/
testcompiler/
""")
on_ci = haskey(ENV, "CI")
if false # takes 18.83 seconds
    !on_ci && push!(targets, "pkgs/revise")
    !on_ci && push!(targets, "pkgs/juliainterpreter")
end

# j  runtests.jl compiler/takes_long_time/typeinf_ext_toplevel.jl  takes  9.06 seconds
# jc runtests.jl compiler/takes_long_time/typeinf_ext_toplevel.jl  takes  0.05 seconds
skip = split("""
corecompiler/takes_long_time/
pkgs/
""")
runtests(@__DIR__, targets=targets, skip=skip, into=Main)
