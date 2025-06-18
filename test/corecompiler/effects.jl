module test_corecompiler_effects

using Test
using Core: Compiler as CC
using .CC: ALWAYS_TRUE, ALWAYS_FALSE,
           CONSISTENT_IF_NOTRETURNED, CONSISTENT_IF_INACCESSIBLEMEMONLY,
           EFFECT_FREE_IF_INACCESSIBLEMEMONLY, EFFECT_FREE_GLOBALLY,
           INACCESSIBLEMEM_OR_ARGMEMONLY,
           NOUB_IF_NOINBOUNDS,
           CONSISTENT_OVERLAY
using .CC: EFFECTS_TOTAL, EFFECTS_THROWS, EFFECTS_UNKNOWN

# julia/base/reflection.jl
# julia/Compiler/src/effects.jl

f1(x) = x * 2
effects = Base.infer_effects(f1, (Int,))
@test effects isa CC.Effects
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
@test CC.is_consistent(effects)          # +c
# faild at 1.12.0-beta2
# @test CC.is_effect_free(effects)       # +e
@test CC.is_nothrow(effects)             # +n
@test CC.is_terminates(effects)          # +t
@test CC.is_notaskstate(effects)         # +s
@test CC.is_inaccessiblememonly(effects) # +m
@test CC.is_noub(effects)                # +u
@test CC.is_nonoverlayed(effects)        # +o
@test CC.is_nortcall(effects)            # +r

f2(x::Int) = x * 2
effects = Base.infer_effects(f2, (Integer,))
@test effects isa CC.Effects
# @test string(effects) == "(+c,+e,!n,+t,+s,+m,+u,+o,+r)"
#                           (+c,!e,!n,+t,+s,+m,+u,+o,+r)
@test effects.nothrow === false
@test !CC.is_nothrow(effects)            # !n

@test string(EFFECTS_TOTAL)   == "(+c,+e,+n,+t,+s,+m,+u,+o,+r)"
@test string(EFFECTS_THROWS)  == "(+c,+e,!n,+t,+s,+m,+u,+o,+r)"
@test string(EFFECTS_UNKNOWN) == "(!c,!e,!n,!t,!s,!m,!u,+o,!r)" # unknown mostly, but it's not overlayed at least (e.g. it's not a call)

@test  EFFECT_FREE_IF_INACCESSIBLEMEMONLY == 0x02
@test ~EFFECT_FREE_IF_INACCESSIBLEMEMONLY == 0xfd
@test bitstring( 0x02) == "00000010"
@test bitstring(~0x02) == "11111101"

CC.is_consistent
CC.is_consistent_if_notreturned
CC.is_consistent_if_inaccessiblememonly
CC.is_consistent_overlay
CC.is_effect_free
CC.is_effect_free_if_inaccessiblememonly
CC.is_nothrow
CC.is_terminates
CC.is_notaskstate # :notaskstate setting asserts that the method does not use or modify the local task state
CC.is_inaccessiblememonly # :inaccessiblememonly setting asserts that the method does not access or modify externally accessible mutable memory
CC.is_inaccessiblemem_or_argmemonly
CC.is_noub # :noub settings that the method will not execute any undefined behavior
CC.is_noub_if_noinbounds
CC.is_nonoverlayed
CC.is_nortcall # :nortcall setting asserts that the method does not call Core.Compiler.return_type

CC.is_foldable # +c,+e,   +t,      +u,   +r
               #                   ?u
CC.is_foldable_nothrow # is_foldable && is_nothrow
CC.is_removable_if_unused # is_effect_free && is_terminates && is_nothrow
CC.is_finalizer_inlineable # is_nothrow && is_notaskstate

end # module test_corecompiler_effects
