module test_corecompiler_EscapeAnalysis

# from julia/Compiler/src/ssair/EscapeAnalysis.jl

using Test
using Core: Compiler as CC
using .CC: EscapeAnalysis as EA
using .EA # analyze_escapes getaliases isaliased has_no_escape has_arg_escape
          # has_return_escape has_thrown_escape has_all_escape
using .EA: EscapeInfo, ⊑ₑ, ⊏ₑ, ⋤ₑ, ⊔ₑ
using .EA: ⊥, NotAnalyzed
using .EA: ⊤, AllEscape
using .EA: NoEscape

analyze_escapes
getaliases
isaliased
has_no_escape
has_arg_escape
has_return_escape
has_thrown_escape
has_all_escape

# EscapeInfo
# `x.Analyzed::Bool`: not formally part of the lattice, only indicates whether `x` has been analyzed
@test ⊥ isa EscapeInfo

@test ⊥ == NotAnalyzed()
@test ⊥.Analyzed === false

# `AllEscape()`: the topmost element of this lattice, meaning it will escape to everywhere
@test ⊤ == AllEscape()
@test ⊤.Analyzed

# `NoEscape()`: the bottom(-like) element of this lattice, meaning it won't escape to anywhere
@test NoEscape().Analyzed

⊑ₑ
# The non-strict partial order over [`EscapeInfo`](@ref).
@test ⊥ ⊑ₑ ⊤

⊏ₑ
# The strict partial order over [`EscapeInfo`](@ref).
# This is defined as the irreflexive kernel of `⊏ₑ`.

⋤ₑ
# This order could be used as a slightly more efficient version of the strict order `⊏ₑ`,
# where we can safely assume `x ⊑ₑ y` holds.

⊔ₑ
# Computes the join of `x` and `y` in the partial order defined by [`EscapeInfo`](@ref).

end # module test_corecompiler_EscapeAnalysis
