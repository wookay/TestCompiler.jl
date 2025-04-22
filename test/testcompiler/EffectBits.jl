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

EffectLetter

using Core.Compiler: EFFECT_FREE_IF_INACCESSIBLEMEMONLY, INACCESSIBLEMEM_OR_ARGMEMONLY, NOUB_IF_NOINBOUNDS, CONSISTENT_OVERLAY
@test Effects(~e, ~m, ~u, ~o) == Effects(; effect_free = EFFECT_FREE_IF_INACCESSIBLEMEMONLY,
                                           inaccessiblememonly = INACCESSIBLEMEM_OR_ARGMEMONLY,
                                           noub = NOUB_IF_NOINBOUNDS,
                                           nonoverlayed = CONSISTENT_OVERLAY)
@test_throws EffectsArgumentError Effects(~n)

using LogicalOperators: AND, OR
@test effect_bits(Compiler.is_effect_free_if_inaccessiblememonly) == AND(~e)
@test effect_bits(Compiler.is_inaccessiblemem_or_argmemonly)      == AND(~m)
@test effect_bits(Compiler.Compiler.is_consistent_overlay)        == AND(~o)

effects = EFFECTS_TOTAL
@test Compiler.is_consistent(effects)
@test Compiler.is_foldable(effects)
effects = EFFECTS_UNKNOWN
@test !Compiler.is_foldable(effects)

using Jive
effects = Effects(+c)
@test sprint_plain(detect(Compiler.is_foldable, effects)) == """
AND(+c, OR(+u, ?u), +e, +t, OR(true, +r))
        !u          !e  !t  !r\
"""

effects = Effects(+c)
@test sprint_plain(detect(Compiler.is_consistent_if_notreturned, effects)) == """
AND(EffectLetter('c', CONSISTENT_IF_NOTRETURNED))
    +c\
"""

end # module test_testcompiler_EffectBits
