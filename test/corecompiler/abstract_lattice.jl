module test_corecompiler_abstract_lattice

using Test
using Core: Compiler as CC

using .CC: ConstsLattice, PartialsLattice, ConditionalsLattice, InferenceLattice,
           SimpleInferenceLattice, BaseInferenceLattice

@test PartialsLattice(ConstsLattice()) isa SimpleInferenceLattice
@test ConditionalsLattice(SimpleInferenceLattice.instance) isa BaseInferenceLattice
@test CC.fallback_lattice == InferenceLattice(BaseInferenceLattice.instance)


# from julia/Compiler/src/abstractlattice.jl
#=
"""
A singleton type representing the lattice of Julia types, without any inference extensions.
"""
struct JLTypeLattice <: AbstractLattice; end

"""
A lattice extending `JLTypeLattice` and adjoining `Const` and `PartialTypeVar`.
"""
struct ConstsLattice <: AbstractLattice; end

"""
A lattice extending a base lattice `𝕃` and adjoining `PartialStruct` and `PartialOpaque`.
"""
struct PartialsLattice{𝕃<:AbstractLattice} <: AbstractLattice

"""
A lattice extending a base lattice `𝕃` and adjoining `Conditional`.
"""
struct ConditionalsLattice{𝕃<:AbstractLattice} <: AbstractLattice

"""
The full lattice used for abstract interpretation during inference.
Extends a base lattice `𝕃` and adjoins `LimitedAccuracy`.
"""
struct InferenceLattice{𝕃<:AbstractLattice} <: AbstractLattice

"""
A lattice extending a base lattice `𝕃` and adjoining `Conditional`.
"""
struct ConditionalsLattice{𝕃<:AbstractLattice} <: AbstractLattice

"""
A lattice extending a base lattice `𝕃` and adjoining `InterConditional`.
"""
struct InterConditionalsLattice{𝕃<:AbstractLattice} <: AbstractLattice

"""
A lattice extending lattice `𝕃` and adjoining `MustAlias`.
"""
struct MustAliasesLattice{𝕃<:AbstractLattice} <: AbstractLattice

"""
A lattice extending lattice `𝕃` and adjoining `InterMustAlias`.
"""
struct InterMustAliasesLattice{𝕃<:AbstractLattice} <: AbstractLattice

const AnyConditionalsLattice{𝕃<:AbstractLattice} = Union{ConditionalsLattice{𝕃}, InterConditionalsLattice{𝕃}}
const AnyMustAliasesLattice{𝕃<:AbstractLattice} = Union{MustAliasesLattice{𝕃}, InterMustAliasesLattice{𝕃}}

const SimpleInferenceLattice = typeof(PartialsLattice(ConstsLattice()))
const BaseInferenceLattice = typeof(ConditionalsLattice(SimpleInferenceLattice.instance))
const IPOResultLattice = typeof(InterConditionalsLattice(SimpleInferenceLattice.instance))

"""
The full lattice used for abstract interpretation during inference.
Extends a base lattice `𝕃` and adjoins `LimitedAccuracy`.
"""
struct InferenceLattice{𝕃<:AbstractLattice} <: AbstractLattice
=#

end # module test_corecompiler_abstract_lattice
