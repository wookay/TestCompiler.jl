module test_testcompiler_assume_effects

using Test
using Core: Compiler as CC
using .CC: Effects

# julia/base/strings/util.jl
# @assume_effects :removable :foldable function chomp(s::Union{String, SubString{String}})
effects = Base.infer_effects(chomp, Tuple{Union{String, SubString{String}}})
if VERSION >= v"1.13.0-DEV.544"
    # :removable                  +e,    +n,+t
    # :foldable                +c,+e,       +t,      +u,   +r
    @test string(effects) == "(+c,+e,!re,+n,+t,!s,!m,+u,+o,+r)"
elseif VERSION >= v"1.12-beta"
    @test string(effects) == "(!c,!e,!n,!t,!s,!m,!u,+o,!r)"
else
    #                                               !o
    @test string(effects) == "(!c,!e,!n,!t,!s,!m,!u,!o,!r)"
end

end # module test_testcompiler_assume_effects
