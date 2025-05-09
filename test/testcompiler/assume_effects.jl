module test_testcompiler_assume_effects

using Test
using Core: Compiler as CC
using .CC: Effects
using TestCompiler.EffectBits # c e n t s m u o r

# julia/base/strings/util.jl
# @assume_effects :removable :foldable function chomp(s::Union{String, SubString{String}})
effects = Base.infer_effects(chomp, Tuple{Union{String, SubString{String}}})
if VERSION >= v"1.13.0-DEV.544"
    # :removable     +e,+n,+t
    # :foldable   +c,+e,   +t,      +u,   +r
    #                               ?u
    @test Effects(+c,+e,+n,+t,!s,!m,+u,+o,+r) == effects
else
    @test Effects(!c,!e,!n,!t,!s,!m,!u,!o,!r) == effects
end

end # module test_testcompiler_assume_effects
