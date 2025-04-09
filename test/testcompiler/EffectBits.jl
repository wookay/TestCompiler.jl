module test_testcompiler_EffectBits

using Test
using TestCompiler.EffectBits # c e n t s m u o r
                              # EffectLetter EffectSuffix

using Core.Compiler: EFFECTS_TOTAL, EFFECTS_THROWS, EFFECTS_UNKNOWN
@test string(EFFECTS_TOTAL)   == "(+c,+e,+n,+t,+s,+m,+u,+o,+r)"
@test string(EFFECTS_THROWS)  == "(+c,+e,!n,+t,+s,+m,+u,+o,+r)"
@test string(EFFECTS_UNKNOWN) == "(!c,!e,!n,!t,!s,!m,!u,+o,!r)"

@test +n in EFFECTS_TOTAL
@test !n in EFFECTS_THROWS
@test !c in EFFECTS_UNKNOWN

@test ~n == EffectLetter('?', 'n')
@test  n == EffectSuffix('n')
@test nameof(~n) === :nothrow
@test nameof(n) === :nothrow

end # module test_testcompiler_EffectBits
