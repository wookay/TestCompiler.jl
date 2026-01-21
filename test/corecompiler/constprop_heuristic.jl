using Jive
# @useinside module test_corecompiler_constprop_heuristic
@If VERSION >= v"1.12" module test_corecompiler_constprop_heuristic

using Test
using Core: Compiler as CC
using Core: typename

# julia/base/boot.jl
# typename(_).constprop_heuristic
# const FORCE_CONST_PROP      = 0x1
# const ARRAY_INDEX_HEURISTIC = 0x2
# const ITERATE_HEURISTIC     = 0x3
# const SAMETYPE_HEURISTIC    = 0x4

if VERSION >= v"1.12.0-DEV.949"
@test typename(typeof(getproperty)).constprop_heuristic == Core.FORCE_CONST_PROP
@test typename(typeof(setproperty!)).constprop_heuristic == Core.FORCE_CONST_PROP

@test typename(typeof(getindex)).constprop_heuristic == Core.ARRAY_INDEX_HEURISTIC
@test typename(typeof(setindex!)).constprop_heuristic == Core.ARRAY_INDEX_HEURISTIC

@test typename(typeof(iterate)).constprop_heuristic == Core.ITERATE_HEURISTIC

for f in (+, -, *, ==, !=, <=, >=, <, >)
    @test typename(typeof(f)).constprop_heuristic == Core.SAMETYPE_HEURISTIC
end
end # if VERSION >= v"1.12.0-DEV.949"


# julia/Compiler/src/abstractinterpretation.jl
CC.force_const_prop
CC.const_prop_function_heuristic

using FemtoCompiler: FemtoInterpreter
using .CC: InferenceLattice, ConditionalsLattice, typeinf_lattice

interp = FemtoInterpreter()
𝕃ᵢ = typeinf_lattice(interp)
@test 𝕃ᵢ isa InferenceLattice{<:ConditionalsLattice}

using .CC: InternalCodeCache, code_cache
if VERSION >= v"1.14.0-DEV.60"
    using .CC: OverlayCodeCache
    @test code_cache(interp) isa OverlayCodeCache{InternalCodeCache}
else
    using .CC: WorldView
    @test code_cache(interp) isa WorldView{InternalCodeCache}
end

f = +
@test typename(typeof(f)).constprop_heuristic == Core.SAMETYPE_HEURISTIC
mi = first(only(methods(f, Tuple{Int, Int})).specializations)::Core.MethodInstance

using .CC: InferenceResult, InferenceState
inf_result = InferenceResult(mi, 𝕃ᵢ)
sv = InferenceState(inf_result, #=cache_mode=# :no, interp)

using .CC: ArgInfo
arginfo = ArgInfo([1, 2], Any[Int, Int])
all_overridden = CC.is_all_overridden(interp, arginfo, sv)
@test !all_overridden
@test !CC.const_prop_function_heuristic(interp, f, arginfo, all_overridden, sv)

end # module test_corecompiler_constprop_heuristic
