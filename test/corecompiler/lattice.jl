module test_corecompiler_lattice

using Test
using Core: Compiler as CC

# from julia/Compiler/src/abstractlattice.jl
# from julia/Compiler/src/typelattice.jl
using .CC: AbstractLattice, JLTypeLattice, ConstsLattice, PartialsLattice,
           ConditionalsLattice, InterConditionalsLattice,
           MustAliasesLattice, InterMustAliasesLattice,
           AnyConditionalsLattice, AnyMustAliasesLattice,
           SimpleInferenceLattice, BaseInferenceLattice, IPOResultLattice,
           InferenceLattice,
           widenlattice, is_valid_lattice_norec,
           ⊑, ⊏, ⋤,
           is_lattice_equal, has_nontrivial_extended_info, is_const_prop_profitable_arg, is_forwardable_argtype,
           widenreturn, widenreturn_noslotwrapper,
           tmeet, tmerge, tmerge_field,
           partialorder, strictpartialorder, strictneqpartialorder,
           fallback_lattice, fallback_ipo_lattice

AbstractLattice

# A singleton type representing the lattice of Julia types, without any inference extensions.
JLTypeLattice <: AbstractLattice

# A lattice extending `JLTypeLattice` and adjoining `Const` and `PartialTypeVar`.
ConstsLattice <: AbstractLattice

# A lattice extending a base lattice `𝕃` and adjoining `PartialStruct` and `PartialOpaque`.
# '𝕃': Unicode U+1D543 (category Lu: Letter, uppercase), input as \bbL<tab>
PartialsLattice{𝕃 where 𝕃<:AbstractLattice} <: AbstractLattice

# A lattice extending a base lattice `𝕃` and adjoining `Conditional`.
ConditionalsLattice{𝕃 where 𝕃<:AbstractLattice} <: AbstractLattice

# A lattice extending a base lattice `𝕃` and adjoining `InterConditional`.
InterConditionalsLattice{𝕃 where 𝕃<:AbstractLattice} <: AbstractLattice

# A lattice extending lattice `𝕃` and adjoining `MustAlias`.
MustAliasesLattice{𝕃 where 𝕃<:AbstractLattice} <: AbstractLattice

# A lattice extending lattice `𝕃` and adjoining `InterMustAlias`.
InterMustAliasesLattice{𝕃 where 𝕃<:AbstractLattice} <: AbstractLattice

@test (AnyConditionalsLattice{𝕃} where 𝕃<:AbstractLattice) === Union{ConditionalsLattice{𝕃}, InterConditionalsLattice{𝕃}} where 𝕃<:AbstractLattice
@test (AnyMustAliasesLattice{𝕃} where 𝕃<:AbstractLattice)  === Union{MustAliasesLattice{𝕃}, InterMustAliasesLattice{𝕃}} where 𝕃<:AbstractLattice

@test SimpleInferenceLattice === PartialsLattice{ConstsLattice}
@test PartialsLattice(ConstsLattice()) isa SimpleInferenceLattice

@test BaseInferenceLattice === ConditionalsLattice{SimpleInferenceLattice}
@test ConditionalsLattice(SimpleInferenceLattice.instance) isa BaseInferenceLattice

@test IPOResultLattice === InterConditionalsLattice{SimpleInferenceLattice}

# The full lattice used for abstract interpretation during inference.
# Extends a base lattice `𝕃` and adjoins `LimitedAccuracy`.
InferenceLattice{𝕃 where 𝕃<:AbstractLattice} <: AbstractLattice
@test CC.fallback_lattice == InferenceLattice(BaseInferenceLattice.instance)

widenlattice
is_valid_lattice_norec

# tmeet(𝕃::AbstractLattice, a, b::Type)
# Compute the lattice meet of lattice elements `a` and `b` over the lattice `𝕃`,
# dropping any results that will not be inhabited at runtime.
# If `𝕃` is `JLTypeLattice`, this is equivalent to type intersection plus the
# elimination of results that have no concrete subtypes.
# Note that currently `b` is restricted to being a type
# (interpreted as a lattice element in the `JLTypeLattice` sub-lattice of `𝕃`).
tmeet

# tmerge(𝕃::AbstractLattice, a, b)
# Compute a lattice join of elements `a` and `b` over the lattice `𝕃`.
# Note that the computed element need not be the least upper bound of `a` and
# `b`, but rather, we impose additional limitations on the complexity of the
# joined element, ideally without losing too much precision in common cases and
# remaining mostly associative and commutative.
tmerge

# tmerge_field(𝕃::AbstractLattice, a, b) -> nothing or lattice element
# Compute a lattice join of elements `a` and `b` over the lattice `𝕃`,
# where `a` and `b` are fields of `PartialStruct` or `Const`.
# This is an opt-in interface to allow external lattice implementation to provide its own
# field-merge strategy. If it returns `nothing`, `tmerge(::PartialsLattice, ...)`
# will use the default aggressive type merge implementation that does not use `tmerge`
# recursively to reach convergence.
tmerge_field

# ⊑(𝕃::AbstractLattice, a, b)
# Compute the lattice ordering (i.e. less-than-or-equal) relationship between
# lattice elements `a` and `b` over the lattice `𝕃`.
# If `𝕃` is `JLTypeLattice`, this is equivalent to subtyping.
⊑  # '⊑': Unicode U+2291 (category Sm: Symbol, math), input as \sqsubseteq<tab>

# ⊏(𝕃::AbstractLattice, a, b)::Bool
# The strict partial order over the type inference lattice.
# This is defined as the irreflexive kernel of `⊑`.
⊏  # '⊏': Unicode U+228F (category Sm: Symbol, math), input as \sqsubset<tab>

# ⋤(𝕃::AbstractLattice, a, b)::Bool
# This order could be used as a slightly more efficient version of the strict order `⊏`,
# where we can safely assume `a ⊑ b` holds.
⋤  # '⋤': Unicode U+22E4 (category Sm: Symbol, math), input as \sqsubsetneq<tab>

# is_lattice_equal(𝕃::AbstractLattice, a, b)::Bool
# Check if two lattice elements are partial order equivalent.
# This is basically `a ⊑ b && b ⊑ a` in the lattice of `𝕃`
# but (optionally) with extra performance optimizations.
is_lattice_equal

# has_nontrivial_extended_info(𝕃::AbstractLattice, t)::Bool
# Determines whether the given lattice element `t` of `𝕃` has non-trivial extended lattice
# information that would not be available from the type itself.
has_nontrivial_extended_info

# is_const_prop_profitable_arg(𝕃::AbstractLattice, t)::Bool
# Determines whether the given lattice element `t` of `𝕃` has new extended lattice information
# that should be forwarded along with constant propagation.
is_const_prop_profitable_arg

is_forwardable_argtype

# widenreturn(𝕃ᵢ::AbstractLattice, @nospecialize(rt), info::BestguessInfo) -> new_bestguess
# widenreturn_noslotwrapper(𝕃ᵢ::AbstractLattice, @nospecialize(rt), info::BestguessInfo) -> new_bestguess
# Appropriately converts inferred type of a return value `rt` to such a type
# that we know we can store in the cache and is valid and good inter-procedurally,
# E.g. if `rt isa Conditional` then `rt` should be converted to `InterConditional`
# or the other cacheable lattice element.
# External lattice `𝕃ᵢ::ExternalLattice` may overload:
# - `widenreturn(𝕃ᵢ::ExternalLattice, @nospecialize(rt), info::BestguessInfo)`
# - `widenreturn_noslotwrapper(𝕃ᵢ::ExternalLattice, @nospecialize(rt), info::BestguessInfo)`
widenreturn
widenreturn_noslotwrapper

# from julia/Compiler/src/abstractinterpretation.jl
# struct BestguessInfo{Interp<:AbstractInterpreter}
#   interp::Interp
#   bestguess
#   nargs::Int
#   slottypes::Vector{Any}
#   changes::VarTable
CC.BestguessInfo

partialorder
strictpartialorder
strictneqpartialorder
@test fallback_lattice     === InferenceLattice(BaseInferenceLattice.instance)
@test fallback_ipo_lattice === InferenceLattice(IPOResultLattice.instance)


# from julia/src/jltypes.c

# struct Core.Const
#   val :: Any
Core.Const

# struct Core.PartialStruct
#   typ    :: Any
#   fields :: Vector{Any}
Core.PartialStruct

# struct Core.PartialOpaque
#   typ    :: Type
#   env    :: Any
#   parent :: Core.MethodInstance
#   source :: Any
Core.PartialOpaque

# cnd::InterConditional
# Similar to Conditional, but conveys inter-procedural constraints imposed on
# call arguments. This is separate from Conditional to catch logic errors: the
# lattice element name is InterConditional while processing a call, then
# Conditional everywhere else. Thus InterConditional does not appear in
# CompilerTypes —  these type's usages are disjoint— though we define the lattice
# for InterConditional.
Core.InterConditional

# from julia/Compiler/src/typelattice.jl
# N.B.: Const/PartialStruct/InterConditional are defined in Core, to allow them to be used
# inside the global code cache.

# struct PartialTypeVar
#   tv::TypeVar
#   # N.B.: Currently unused, but would allow turning something back
#   # into Const, if the bounds are pulled out of this TypeVar
#   lb_certain::Bool
#   ub_certain::Bool
CC.PartialTypeVar

# struct LimitedAccuracy
#   typ
#   causes::IdSet{InferenceState}
CC.LimitedAccuracy

# from julia/Compiler/src/inferencestate.jl
# mutable struct InferenceState
# * information about this method instance
#   - linfo, world, mod, sptypes, slottypes, src, cfg, spec_info
# * intermediate states for local abstract interpretation
#   - currbb, currpc, ip (current active instruction pointers), handler_info,
#   - ssavalue_uses (ssavalue sparsity and restart info),
#   - bb_vartables (nothing if not analyzed yet),
#   - bb_saw_latestworld, ssavaluetypes, ssaflags, edges, stmt_info
# * intermediate states for interprocedural abstract interpretation
#   - tasks, pclimitations, limitations, cycle_backedges
# * IPO tracking of in-process work, shared with all frames given AbstractInterpreter
#   - callstack
#   - parentid (index into callstack of the parent frame that originally added this frame (call cycle_parent to extract the current parent of the SCC))
#   - frameid (index into callstack at which this object is found (or zero, if this is not a cached frame and has no parent))
#   - cycleid (index into the callstack of the topmost frame in the cycle (all frames in the same cycle share the same cycleid))
# * results
#   - result (remember where to put the result),
#   - unreachable (statements that were found to be statically unreachable),
#   - bestguess, exc_bestguess, ipo_effects, time_start, time_caches, time_paused, time_self_ns
# * flags: Whether to restrict inference of abstract call sites to avoid excessive work
#          Set by default for toplevel frame.
#   - restrict_abstract_call_sites, cache_mode, insert_coverage
# * interp: The interpreter that created this inference state. Not looked at by
#           NativeInterpreter. But other interpreters may use this to detect cycles
CC.InferenceState

end # module test_corecompiler_lattice
