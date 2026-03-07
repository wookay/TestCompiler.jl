module test_corecompiler_ipo

using Test
using Core.Compiler: Compiler as CC

# Interprocedural optimization (IPO)

Core.CodeInstance
#   - ipo_purity_bits::UInt32

# from julia/Compiler/src/types.jl
CC.InferenceResult
#   - ipo_effects::Effects
#
CC.InferenceParams
#   - ipo_constant_propagation::Bool
#
# function ipo_lattice(::AbstractInterpreter)
CC.ipo_lattice

# from julia/Compiler/src/abstractlattice.jl
# const fallback_ipo_lattice::InferenceLattice
CC.fallback_ipo_lattice

# from julia/Compiler/src/optimize.jl
# function run_passes_ipo_safe(ci::CodeInfo, sv::OptimizationState, optimize_until::Union{Nothing, Int, String} = nothing)
CC.run_passes_ipo_safe

end # module test_corecompiler_ipo
