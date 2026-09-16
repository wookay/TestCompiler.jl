module test_corecompiler_timing

# see also TestCompiler/test/base/timing.jl

# from julia/Compiler/src/timing.jl
#      julia/Compiler/src/typeinfer.jl

using Test
using Core: Compiler as CC

if VERSION >= v"1.13"
using .CC: @zone
end

@test CC.Timings.ROOTmi isa Core.MethodInstance

end # module test_corecompiler_timing
