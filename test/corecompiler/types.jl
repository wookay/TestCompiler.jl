module test_corecompiler_types

using Test
using Core: Compiler as CC
using .CC: AbstractInterpreter, AbstractLattice, ArgInfo, StmtInfo, VarState, AnalysisResults, InferenceResult, InferenceParams, OptimizationParams, NativeInterpreter
if VERSION >= v"1.12.0-DEV.1571" # julia commit cd7250da83837d3e72f8b82aff73418b01bd425a
using .CC: InvalidIRError, SpecInfo
else
struct InvalidIRError <: Exception end
struct SpecInfo
    nargs::Int
    isva::Bool
    propagate_inbounds::Bool
    method_for_inference_limit_heuristics::Union{Nothing,Method}
end
end

# from julia/Compiler/src/types.jl
AbstractInterpreter
AbstractLattice
InvalidIRError <: Exception
ArgInfo
StmtInfo
SpecInfo
VarState
AnalysisResults
InferenceResult
InferenceParams
OptimizationParams
NativeInterpreter <: AbstractInterpreter

end # module test_corecompiler_types
