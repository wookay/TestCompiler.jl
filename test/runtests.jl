using Jive
targets = split("""
testcompiler
corecompiler
pkgs/juliainterpreter
""")
on_ci = haskey(ENV, "CI")
if false # takes 18.83 seconds
    !on_ci && VERSION >= v"1.12-beta" && push!(targets, "pkgs/cthulhu")
    !on_ci && push!(targets, "pkgs/revise")
end

# corecompiler/takes_long_time/typeinf_ext_toplevel.jl  takes 14.70 seconds
skip = split("""
corecompiler/setup_Compiler.jl
corecompiler/newinterp.jl
corecompiler/takes_long_time/
""")
runtests(@__DIR__, targets=targets, skip=skip)
