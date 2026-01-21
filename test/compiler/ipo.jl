module test_compiler_ipo

using Test

# Interprocedural optimization (IPO)

# Core.CodeInstance
#   - ipo_purity_bits::UInt32

# from julia/Compiler/src/types.jl
# InferenceResult
#   - ipo_effects::Effects
#
# InferenceParams
#   - ipo_constant_propagation::Bool
#
# function ipo_lattice(::AbstractInterpreter)

# from julia/Compiler/src/abstractlattice.jl
# const fallback_ipo_lattice::InferenceLattice

# from julia/Compiler/src/optimize.jl
# function run_passes_ipo_safe(ci::CodeInfo, sv::OptimizationState, optimize_until::Union{Nothing, Int, String} = nothing)

end # module test_compiler_ipo
