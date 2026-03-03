using Jive
# @useinside module test_corecompiler_constprop_heuristic
@If VERSION >= v"1.12" module test_corecompiler_constprop_heuristic

using Test
using Core: Compiler as CC
using Core: typename

# julia/base/boot.jl
# typename(_).constprop_heuristic
# const FORCE_CONST_PROP           = 0x01
# const ARRAY_INDEX_HEURISTIC      = 0x02
# const ITERATE_HEURISTIC          = 0x04
# const SAMETYPE_HEURISTIC         = 0x08
# const DISABLE_SEMI_CONCRETE_EVAL = 0x10

if VERSION >= v"1.14.0-DEV.1809" # julia commit 5308f13b01
@test typename(typeof(getproperty)).constprop_heuristic == Base.or_int(Core.FORCE_CONST_PROP, Core.DISABLE_SEMI_CONCRETE_EVAL)
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
using .CC: InferenceLattice, MustAliasesLattice, typeinf_lattice

interp = FemtoInterpreter()
𝕃ᵢ = typeinf_lattice(interp)
if VERSION >= v"1.14.0-DEV.1809" # julia commit 5308f13b01
@test 𝕃ᵢ isa InferenceLattice{<:MustAliasesLattice}
end

using .CC: InternalCodeCache, code_cache
if VERSION >= v"1.14.0-DEV.60"
    using .CC: OverlayCodeCache
    @test code_cache(interp) isa OverlayCodeCache{InternalCodeCache}
else
    using .CC: WorldView
    @test code_cache(interp) isa WorldView{InternalCodeCache}
end

f = +
types = Tuple{Int, Int}

@test typename(typeof(f)).constprop_heuristic == Core.SAMETYPE_HEURISTIC
mi::Core.MethodInstance = Base.method_instance(f, types)

using .CC: InferenceResult, InferenceState
inf_result = InferenceResult(mi, 𝕃ᵢ)
sv = InferenceState(inf_result, #=cache_mode=# :no, interp)

using .CC: ArgInfo
arginfo = ArgInfo([1, 2], Any[Int, Int])
all_overridden = CC.is_all_overridden(interp, arginfo, sv)
@test !all_overridden
@test !CC.const_prop_function_heuristic(interp, f, arginfo, all_overridden, sv)

end # module test_corecompiler_constprop_heuristic
