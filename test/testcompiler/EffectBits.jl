module test_testcompiler_EffectBits

using Test
using TestCompiler.EffectBits # c e n t s m u o r
                              # EffectLetter EffectSuffix
                              # Effects

using Core.Compiler: EFFECTS_TOTAL, EFFECTS_THROWS, EFFECTS_UNKNOWN
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

using Core.Compiler: INACCESSIBLEMEM_OR_ARGMEMONLY, NOUB_IF_NOINBOUNDS, CONSISTENT_OVERLAY
@test Effects(~m,~u,~o) == Effects(; inaccessiblememonly = INACCESSIBLEMEM_OR_ARGMEMONLY,
                                     noub = NOUB_IF_NOINBOUNDS,
                                     nonoverlayed = CONSISTENT_OVERLAY)
@test_throws EffectsArgumentError Effects(~n)

end # module test_testcompiler_EffectBits
