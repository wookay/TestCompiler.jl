using Jive
@If VERSION >= v"1.14-DEV" module test_corecompiler_effects

# see also test/base/reflection.jl

#=
:consistent            +c
                       ?c                                       CONSISTENT_IF_NOTRETURNED
                       ?c                                       CONSISTENT_IF_INACCESSIBLEMEMONLY
:effect_free              +e
                          ?e                                    EFFECT_FREE_IF_INACCESSIBLEMEMONLY
:reset_safe                  +re
                             ?re                                RESET_SAFE_IF_INACCESSIBLEMEMONLY
:nothrow                         +n
:terminates_globally                +t
:terminates_locally                 +t
:notaskstate                           +s
:inaccessiblememonly                     +m
                                         ?m                     INACCESSIBLEMEM_OR_ARGMEMONLY
:noub                                        +u
:noub_if_noinbounds                          ?u                 NOUB_IF_NOINBOUNDS
:nonoverlayed                                   +o
:consistent_overlay                             ?o              CONSISTENT_OVERLAY
:nortcall                                          +r
:foldable              +c,+e,       +t,      +u,   +r
:removable                +e,    +n,+t
:total                 +c,+e,    +n,+t,+s,+m,+u,   +r           :terminates_globally true
                                                                :terminates_locally false
                                                                :noub_if_noinbounds false
                                                                :consistent_overlay false
=#

using Test
using Core: Compiler as CC
using .CC: ALWAYS_TRUE, ALWAYS_FALSE,
           CONSISTENT_IF_NOTRETURNED, CONSISTENT_IF_INACCESSIBLEMEMONLY,
           EFFECT_FREE_IF_INACCESSIBLEMEMONLY, EFFECT_FREE_GLOBALLY,
           RESET_SAFE_IF_INACCESSIBLEMEMONLY,
           INACCESSIBLEMEM_OR_ARGMEMONLY,
           NOUB_IF_NOINBOUNDS,
           CONSISTENT_OVERLAY
using .CC: EFFECTS_TOTAL, EFFECTS_THROWS, EFFECTS_UNKNOWN, EFFECTS_MINIMAL

# julia/base/reflection.jl
# julia/Compiler/src/effects.jl

code_coverage = Base.JLOptions().code_coverage != 0

f1(x) = x * 2
effects = Base.infer_effects(f1, (Int,))
@test effects isa CC.Effects
@test effects.consistent == ALWAYS_TRUE
if code_coverage
@test string(effects) == "(+c,!e,+re,+n,+t,+s,+m,+u,+o,+r)" # !e
@test effects.effect_free == ALWAYS_FALSE
else
@test string(effects) == "(+c,+e,+re,+n,+t,+s,+m,+u,+o,+r)" # +e
@test effects.effect_free == ALWAYS_TRUE
end
@test effects.reset_safe == ALWAYS_TRUE
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
# @test string(effects) == "(+c,+e,+re,+n,+t,+s,+m,+u,+o,+r)"
#                          "(+c,+e,+re,!n,+t,+s,+m,+u,+o,+r)"
@test effects.nothrow === false
@test !CC.is_nothrow(effects)            # !n

@test string(EFFECTS_TOTAL)   == "(+c,+e,+re,+n,+t,+s,+m,+u,+o,+r)"
@test string(EFFECTS_THROWS)  == "(+c,+e,+re,!n,+t,+s,+m,+u,+o,+r)"
@test string(EFFECTS_UNKNOWN) == "(!c,!e,!re,!n,!t,!s,!m,!u,+o,!r)" # unknown mostly, but it's not overlayed at least (e.g. it's not a call)
@test string(EFFECTS_MINIMAL) == "(!c,!e,!re,!n,!t,!s,!m,!u,!o,!r)"

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


# from julia/base/essentials.jl
Base._is_internal

# from julia/base/expr.jl
# macro assume_effects(args...)

# Base._is_internal(::typeof(@__MODULE__)) = true
# @test Base._is_internal(@__MODULE__)

function f1()
    Base.@_terminates_locally_meta
    while true
    end
end

function f2()
    Base.@assume_effects :terminates_locally
    while true
    end
end

function f3()
    while true
    end
end

effects_f1 = Base.infer_effects(f1, Tuple{})
effects_f2 = Base.infer_effects(f2, Tuple{})
effects_f3 = Base.infer_effects(f3, Tuple{})

if code_coverage
@test string(effects_f1) == "(+c,!e,+re,+n,!t,+s,+m,+u,+o,+r)" # !e !t
@test string(effects_f2) == "(+c,!e,+re,+n,+t,+s,+m,+u,+o,+r)" # !e +t
@test string(effects_f3) == "(+c,!e,+re,+n,!t,+s,+m,+u,+o,+r)" # !e !t
else
@test string(effects_f1) == "(+c,+e,+re,+n,!t,+s,+m,+u,+o,+r)" # +e !t
@test string(effects_f2) == "(+c,+e,+re,+n,+t,+s,+m,+u,+o,+r)" # +e +t
@test string(effects_f3) == "(+c,+e,+re,+n,!t,+s,+m,+u,+o,+r)" # +e !t
end

# from julia/Compiler/test/effects.jl
# `getfield_effects` handles access to union object nicely
𝕃 = CC.fallback_lattice
@test CC.is_consistent(CC.getfield_effects(𝕃, Any[Some{Symbol}, Core.Const(:value)], Symbol))
@test CC.is_consistent(CC.getfield_effects(𝕃, Any[Some{String}, Core.Const(:value)], String))
@test CC.is_consistent(CC.getfield_effects(𝕃, Any[Union{Some{Symbol},Some{String}}, Core.Const(:value)], Union{Symbol,String}))

end # module test_corecompiler_effects


# from julia/base/expr.jl
#=
function compute_assumed_setting(override::EffectsOverride, @nospecialize(setting), val::Bool=true)
    if isexpr(setting, :call) && setting.args[1] === :(!)
        return compute_assumed_setting(override, setting.args[2], !val)
    elseif isa(setting, QuoteNode)
        return compute_assumed_setting(override, setting.value, val)
    end
    if setting === :consistent
        return EffectsOverride(override; consistent = val)
    elseif setting === :effect_free
        return EffectsOverride(override; effect_free = val)
    elseif setting === :nothrow
        return EffectsOverride(override; nothrow = val)
    elseif setting === :terminates_globally
        return EffectsOverride(override; terminates_globally = val)
    elseif setting === :terminates_locally
        return EffectsOverride(override; terminates_locally = val)
    elseif setting === :notaskstate
        return EffectsOverride(override; notaskstate = val)
    elseif setting === :inaccessiblememonly
        return EffectsOverride(override; inaccessiblememonly = val)
    elseif setting === :noub
        return EffectsOverride(override; noub = val)
    elseif setting === :noub_if_noinbounds
        return EffectsOverride(override; noub_if_noinbounds = val)
    elseif setting === :foldable
        consistent = effect_free = terminates_globally = noub = nortcall = val
        return EffectsOverride(override; consistent, effect_free, terminates_globally, noub, nortcall)
    elseif setting === :removable
        effect_free = nothrow = terminates_globally = val
        return EffectsOverride(override; effect_free, nothrow, terminates_globally)
    elseif setting === :total
        consistent = effect_free = nothrow = terminates_globally = notaskstate =
            inaccessiblememonly = noub = nortcall = val
        return EffectsOverride(override;
            consistent, effect_free, nothrow, terminates_globally, notaskstate,
            inaccessiblememonly, noub, nortcall)
    end
    return nothing
end # function compute_assumed_setting
=#


# from julia/Compiler/src/typeinfer.jl
#=
function adjust_effects(ipo_effects::Effects, def::Method)
    # override the analyzed effects using manually annotated effect settings
    override = decode_effects_override(def.purity)
    if is_effect_overridden(override, :consistent)
        ipo_effects = Effects(ipo_effects; consistent=ALWAYS_TRUE)
    end
    if is_effect_overridden(override, :effect_free)
        ipo_effects = Effects(ipo_effects; effect_free=ALWAYS_TRUE)
    end
    if is_effect_overridden(override, :nothrow)
        ipo_effects = Effects(ipo_effects; nothrow=true)
    end
    if is_effect_overridden(override, :terminates_globally)
        ipo_effects = Effects(ipo_effects; terminates=true)
    end
    if is_effect_overridden(override, :notaskstate)
        ipo_effects = Effects(ipo_effects; notaskstate=true)
    end
    if is_effect_overridden(override, :inaccessiblememonly)
        ipo_effects = Effects(ipo_effects; inaccessiblememonly=ALWAYS_TRUE)
    end
    if is_effect_overridden(override, :noub)
        ipo_effects = Effects(ipo_effects; noub=ALWAYS_TRUE)
    elseif is_effect_overridden(override, :noub_if_noinbounds) && ipo_effects.noub !== ALWAYS_TRUE
        ipo_effects = Effects(ipo_effects; noub=NOUB_IF_NOINBOUNDS)
    end
    if is_effect_overridden(override, :consistent_overlay)
        ipo_effects = Effects(ipo_effects; nonoverlayed=CONSISTENT_OVERLAY)
    end
    if is_effect_overridden(override, :nortcall)
        ipo_effects = Effects(ipo_effects; nortcall=true)
    end
    return ipo_effects
end # function adjust_effects
=#
