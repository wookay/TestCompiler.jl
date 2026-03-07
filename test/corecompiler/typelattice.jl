using Jive
@If VERSION >= v"1.14-DEV" module test_corecompiler_typelattice

using Test
using Core: Compiler as CC

# from julia/Compiler/src/typelattice.jl
@test CC.may_form_limited_typ isa Function

# Conditional
CC.Conditional

# MustAlias
CC.MustAlias
Core.InterMustAlias
@test hasmethod(CC.InterMustAlias, Tuple{CC.MustAlias})

CC.PartialTypeVar
CC.StateUpdate
CC.StateRefinement

# LimitedAccuracy
CC.LimitedAccuracy

CC.NotFound

# lattice order
@test CC.:⊑ isa Function

end # module test_corecompiler_typelattice
