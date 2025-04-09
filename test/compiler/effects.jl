module test_compiler_effects

using Test
using Core.Compiler: Compiler,
                     ALWAYS_TRUE, ALWAYS_FALSE,
                     CONSISTENT_IF_NOTRETURNED, CONSISTENT_IF_INACCESSIBLEMEMONLY,
                     EFFECT_FREE_IF_INACCESSIBLEMEMONLY, EFFECT_FREE_GLOBALLY,
                     INACCESSIBLEMEM_OR_ARGMEMONLY,
                     NOUB_IF_NOINBOUNDS,
                     CONSISTENT_OVERLAY

# julia/base/reflection.jl
# julia/Compiler/src/effects.jl

f1(x) = x * 2
effects = Base.infer_effects(f1, (Int,))
@test effects isa Compiler.Effects
# @test string(effects) == "(+c,+e,+n,+t,+s,+m,+u,+o,+r)"
#                           (+c,!e,+n,+t,+s,+m,+u,+o,+r)
@test effects.consistent == ALWAYS_TRUE
# @test effects.effect_free == ALWAYS_TRUE
#                              ALWAYS_FALSE
@test effects.nothrow === true
@test effects.terminates === true
@test effects.notaskstate === true
@test effects.inaccessiblememonly == ALWAYS_TRUE
@test effects.noub == ALWAYS_TRUE
@test effects.nonoverlayed == ALWAYS_TRUE
@test effects.nortcall === true
@test Compiler.is_consistent(effects)          # +c
# @test Compiler.is_effect_free(effects)       # +e !e
@test Compiler.is_nothrow(effects)             # +n
@test Compiler.is_terminates(effects)          # +t
@test Compiler.is_notaskstate(effects)         # +s
@test Compiler.is_inaccessiblememonly(effects) # +m
@test Compiler.is_noub(effects)                # +u
@test Compiler.is_nonoverlayed(effects)        # +o
@test Compiler.is_nortcall(effects)            # +r

f2(x::Int) = x * 2
effects = Base.infer_effects(f2, (Integer,))
@test effects isa Compiler.Effects
# @test string(effects) == "(+c,+e,!n,+t,+s,+m,+u,+o,+r)"
#                           (+c,!e,!n,+t,+s,+m,+u,+o,+r)
@test effects.nothrow === false
@test !Compiler.is_nothrow(effects)            # !n

using Core.Compiler: EFFECTS_TOTAL, EFFECTS_THROWS, EFFECTS_UNKNOWN
@test string(EFFECTS_TOTAL)   == "(+c,+e,+n,+t,+s,+m,+u,+o,+r)"
@test string(EFFECTS_THROWS)  == "(+c,+e,!n,+t,+s,+m,+u,+o,+r)"
@test string(EFFECTS_UNKNOWN) == "(!c,!e,!n,!t,!s,!m,!u,+o,!r)" # unknown mostly, but it's not overlayed at least (e.g. it's not a call)


Compiler.is_consistent
Compiler.is_consistent_if_notreturned
Compiler.is_consistent_if_inaccessiblememonly
Compiler.is_consistent_overlay
Compiler.is_effect_free
Compiler.is_effect_free_if_inaccessiblememonly
Compiler.is_nothrow
Compiler.is_terminates
Compiler.is_notaskstate
Compiler.is_inaccessiblememonly
Compiler.is_inaccessiblemem_or_argmemonly
Compiler.is_noub
Compiler.is_noub_if_noinbounds
Compiler.is_nonoverlayed
Compiler.is_nortcall

Compiler.is_foldable # +c,+e,  ,+t,+s,+m,+u,  ,+r
                     #                   ?u
Compiler.is_foldable_nothrow # is_foldable && is_nothrow
Compiler.is_removable_if_unused # is_effect_free && is_terminates && is_nothrow
Compiler.is_finalizer_inlineable # is_nothrow && is_notaskstate

#=
Base.@assume_effects :foldable
                     :removable
                     :total
                     :effect_free
                     :nothrow
                     :terminates_globally
                     :terminates_locally
                     :notaskstate
                     :noub

Base.@constprop :aggressive
                :none
=#

end # module test_compiler_effects
