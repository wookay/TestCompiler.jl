module test_testcompiler_EffectBits

using Test
using TestCompiler.EffectBits # c e n t s m u o r
                              # EffectLetter EffectSuffix
                              # effect_bits
using Core: Compiler
using .Compiler: Effects, EFFECTS_TOTAL, EFFECTS_THROWS, EFFECTS_UNKNOWN
@test string(EFFECTS_TOTAL)   == "(+c,+e,+n,+t,+s,+m,+u,+o,+r)"
@test string(EFFECTS_THROWS)  == "(+c,+e,!n,+t,+s,+m,+u,+o,+r)"
@test string(EFFECTS_UNKNOWN) == "(!c,!e,!n,!t,!s,!m,!u,+o,!r)"

@test +n in EFFECTS_TOTAL
@test !n in EFFECTS_THROWS
@test !c in EFFECTS_UNKNOWN

@test EFFECTS_TOTAL   == Effects(+c,+e,+n,+t,+s,+m,+u,+o,+r)
@test EFFECTS_THROWS  == Effects(+c,+e,!n,+t,+s,+m,+u,+o,+r) ==
                         Effects(+c,+e,   +t,+s,+m,+u,+o,+r)
@test EFFECTS_UNKNOWN == Effects(!c,!e,!n,!t,!s,!m,!u,+o,!r) ==
                         Effects(                     +o   )

@test  n == EffectSuffix('n')
@test ~n == EffectLetter('?', 'n')
@test nameof( n) === :nothrow
@test nameof(~n) === :nothrow

using Core.Compiler: EFFECT_FREE_IF_INACCESSIBLEMEMONLY, INACCESSIBLEMEM_OR_ARGMEMONLY, NOUB_IF_NOINBOUNDS, CONSISTENT_OVERLAY
@test Effects(~e, ~m, ~u, ~o) == Effects(; effect_free = EFFECT_FREE_IF_INACCESSIBLEMEMONLY,
                                           inaccessiblememonly = INACCESSIBLEMEM_OR_ARGMEMONLY,
                                           noub = NOUB_IF_NOINBOUNDS,
                                           nonoverlayed = CONSISTENT_OVERLAY)
@test_throws EffectsArgumentError Effects(~n)

@test effect_bits(Compiler.is_effect_free_if_inaccessiblememonly) == ~e
@test effect_bits(Compiler.is_inaccessiblemem_or_argmemonly)      == ~m
@test effect_bits(Compiler.Compiler.is_consistent_overlay)        == ~o

end # module test_testcompiler_EffectBits
