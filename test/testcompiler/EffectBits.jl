module test_testcompiler_EffectBits

using Test
using Core: Compiler as CC
using .CC: Effects, EFFECTS_TOTAL, EFFECTS_THROWS, EFFECTS_UNKNOWN
using .CC: EFFECT_FREE_IF_INACCESSIBLEMEMONLY, # 0x02
           EFFECT_FREE_GLOBALLY,               # 0x03
           INACCESSIBLEMEM_OR_ARGMEMONLY,      # 0x02
           NOUB_IF_NOINBOUNDS,                 # 0x02
           CONSISTENT_OVERLAY,                 # 0x02
           CONSISTENT_IF_NOTRETURNED,          # 0x02
           CONSISTENT_IF_INACCESSIBLEMEMONLY   # 0x04
using TestCompiler.EffectBits # c e n t s m u o r
                              # EffectLetter EffectSuffix
                              # effects_field_name
                              # effects_suffix
                              # effect_bits
using LogicalOperators: AND, OR
using Jive # sprint_plain sprint_colored

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
@test effects_field_name( n) === :nothrow
@test effects_field_name(~n) === :nothrow
@test effects_suffix(:nothrow) == 'n'

@test Effects(~e, ~m, ~u, ~o) == Effects(; effect_free = EFFECT_FREE_IF_INACCESSIBLEMEMONLY,
                                           inaccessiblememonly = INACCESSIBLEMEM_OR_ARGMEMONLY,
                                           noub = NOUB_IF_NOINBOUNDS,
                                           nonoverlayed = CONSISTENT_OVERLAY)
@test_throws EffectsArgumentError Effects(~n)

@test effect_bits(CC.is_effect_free_if_inaccessiblememonly) == AND(~e)
@test effect_bits(CC.is_inaccessiblemem_or_argmemonly)      == AND(~m)
@test effect_bits(CC.is_consistent_overlay)        == AND(~o)

effects = EFFECTS_TOTAL
@test CC.is_consistent(effects)
@test CC.is_foldable(effects)
effects = EFFECTS_UNKNOWN
@test !CC.is_foldable(effects)

effects = Effects(+c)
@test sprint_plain(detect(CC.is_foldable, effects)) == """
AND(+c, OR(+u, ?u), +e, +t, OR(true, +r))
        !u          !e  !t  !r\
"""

letter = EffectLetter(CONSISTENT_IF_NOTRETURNED, 'c')
@test sprint_plain(letter) == "EffectLetter(CONSISTENT_IF_NOTRETURNED, 'c')"
effects = Effects(letter)
@test sprint_plain(effects) == "(?c,!e,!n,!t,!s,!m,!u,!o,!r)"

letter = EffectLetter(EFFECT_FREE_GLOBALLY, 'e')
@test sprint_plain(letter) == "EffectLetter(EFFECT_FREE_GLOBALLY, 'e')"

letter = EffectLetter(CONSISTENT_IF_INACCESSIBLEMEMONLY, 'c')
@test sprint_plain(letter) == "EffectLetter(CONSISTENT_IF_INACCESSIBLEMEMONLY, 'c')"
effects = Effects(letter)
@test sprint_plain(effects) == "(?c,!e,!n,!t,!s,!m,!u,!o,!r)"
@test sprint_plain(detect(CC.is_consistent_if_notreturned, effects)) === """
AND(EffectLetter(CONSISTENT_IF_NOTRETURNED, 'c'))
    EffectLetter(CONSISTENT_IF_INACCESSIBLEMEMONLY, 'c')\
"""

effects = Effects(+c)
@test sprint_plain(detect(CC.is_consistent_if_notreturned, effects)) == """
AND(EffectLetter(CONSISTENT_IF_NOTRETURNED, 'c'))
    +c\
"""
@test sprint_colored(detect(CC.is_consistent_if_notreturned, effects)) == """
AND(EffectLetter(\e[36mCONSISTENT_IF_NOTRETURNED\e[39m, 'c'))
    \e[32m+c\e[39m\
"""

end # module test_testcompiler_EffectBits
