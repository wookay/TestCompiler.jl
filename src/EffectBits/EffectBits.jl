module EffectBits # TestCompiler

export c, e, n, t, s, m, u, o, r
export EffectLetter, EffectSuffix, EffectsArgumentError
export effect_bits, detect

using LogicalOperators: AND, OR
using Core: Compiler
import .Compiler: Effects

struct EffectLetter
    prefix::Char
    suffix::Char
    bitmask::UInt8
    EffectLetter(prefix::Char, suffix::Char) = new(prefix, suffix, 0xFF)
    EffectLetter(bitmask::UInt8, suffix::Char) = new('_', suffix, bitmask)
end

struct EffectSuffix
    char::Char
end

c = EffectSuffix('c')
e = EffectSuffix('e')
n = EffectSuffix('n')
t = EffectSuffix('t')
s = EffectSuffix('s')
m = EffectSuffix('m')
u = EffectSuffix('u')
o = EffectSuffix('o')
r = EffectSuffix('r')

import Base: +, !, ~, nameof

function +(effect_suffix::EffectSuffix)::EffectLetter
    EffectLetter('+', effect_suffix.char)
end

function !(effect_suffix::EffectSuffix)::EffectLetter
    EffectLetter('!', effect_suffix.char)
end

function ~(effect_suffix::EffectSuffix)::EffectLetter
    EffectLetter('?', effect_suffix.char)
end

function nameof(letter::EffectLetter)::Symbol
    nameof(EffectSuffix(letter.suffix))
end

function nameof(suffix::EffectSuffix)::Symbol
    if suffix.char == 'c'
        :consistent
    elseif suffix.char == 'e'
        :effect_free
    elseif suffix.char == 'n'
        :nothrow
    elseif suffix.char == 't'
        :terminates
    elseif suffix.char == 's'
        :notaskstate
    elseif suffix.char == 'm'
        :inaccessiblememonly
    elseif suffix.char == 'u'
        :noub
    elseif suffix.char == 'o'
        :nonoverlayed
    elseif suffix.char == 'r'
        :nortcall
    else
        @info :suffix suffix.char
        :unknown_effectbits
    end
end

using Core.Compiler: ALWAYS_TRUE, ALWAYS_FALSE

function EffectLetter(effects::Effects, suffix::Char)::EffectLetter
    name = nameof(EffectSuffix(suffix))
    effect = getfield(effects, name)
    typ = typeof(effect)
    if typ === Bool
        return EffectLetter(effect ? '+' : '!', suffix)
    elseif typ === UInt8
        if effect === ALWAYS_TRUE # 0x00
            return EffectLetter('+', suffix)
        elseif effect === ALWAYS_FALSE # 0x01
            return EffectLetter('!', suffix)
        else
            if 'c' == suffix
                return EffectLetter(effect, suffix)
            else
                if 0x02 === effect
                    return EffectLetter('?', suffix)
                else
                    return EffectLetter(effect, suffix)
                end
            end
        end
    end
end # function EffectLetter(effects::Effects, suffix::Char)::EffectLetter

function Base.in(letter::EffectLetter, effects::Effects)
    name = nameof(letter)
    effect = getfield(effects, name)
    typ = typeof(effect)
    if letter.prefix == '+'
        if typ === Bool
            return effect
        elseif typ === UInt8
            return effect === ALWAYS_TRUE
        end
    elseif letter.prefix == '!'
        if typ === Bool
            return !effect
        elseif typ === UInt8
            return effect === ALWAYS_FALSE
        end
    elseif letter.prefix == '?'
        if typ === UInt8
            return effect === 0x02
        end
    elseif letter.prefix == '_'
        return effect === letter.bitmask
    end
    return false
end

struct EffectsArgumentError <: Exception
    msg
end

function Effects(letters::Vararg{EffectLetter, N})::Effects where N
    effects_dict = Dict{Symbol, Union{Bool, UInt8}}(
        :consistent => ALWAYS_FALSE,
        :effect_free => ALWAYS_FALSE,
        :nothrow => false,
        :terminates => false,
        :notaskstate => false,
        :inaccessiblememonly => ALWAYS_FALSE,
        :noub => ALWAYS_FALSE,
        :nonoverlayed => ALWAYS_FALSE,
        :nortcall => false
    )
    for letter::EffectLetter in letters
        name = nameof(letter)
        effect = getindex(effects_dict, name)
        typ = typeof(effect)
        if typ === Bool
            setindex!(effects_dict, letter.prefix == '+', name)
        elseif typ === UInt8
            if letter.prefix == '+'
                setindex!(effects_dict, ALWAYS_TRUE, name)
            elseif letter.prefix == '!'
                setindex!(effects_dict, ALWAYS_FALSE, name)
            elseif letter.prefix == '?'
                # effect_free = EFFECT_FREE_IF_INACCESSIBLEMEMONLY
                # inaccessiblememonly = INACCESSIBLEMEM_OR_ARGMEMONLY
                # noub = NOUB_IF_NOINBOUNDS
                # nonoverlayed = CONSISTENT_OVERLAY
                setindex!(effects_dict, 0x02, name)
            else
                setindex!(effects_dict, letter.bitmask, name)
            end
        end
    end
    Effects(getindex(effects_dict, :consistent),
            getindex(effects_dict, :effect_free),
            getindex(effects_dict, :nothrow),
            getindex(effects_dict, :terminates),
            getindex(effects_dict, :notaskstate),
            getindex(effects_dict, :inaccessiblememonly),
            getindex(effects_dict, :noub),
            getindex(effects_dict, :nonoverlayed),
            getindex(effects_dict, :nortcall))
end

# const EffectLetters = NTuple{9, EffectLetter}

using .Compiler: CONSISTENT_IF_NOTRETURNED, CONSISTENT_IF_INACCESSIBLEMEMONLY


### effect_bits
effect_bits(::typeof(Compiler.is_consistent))::AND{EffectLetter}          = AND(+c                           )
effect_bits(::typeof(Compiler.is_effect_free))::AND{EffectLetter}         = AND(   +e                        )
effect_bits(::typeof(Compiler.is_nothrow))::AND{EffectLetter}             = AND(      +n                     )
effect_bits(::typeof(Compiler.is_terminates))::AND{EffectLetter}          = AND(         +t                  )
effect_bits(::typeof(Compiler.is_notaskstate))::AND{EffectLetter}         = AND(            +s               )
effect_bits(::typeof(Compiler.is_inaccessiblememonly))::AND{EffectLetter} = AND(               +m            )
effect_bits(::typeof(Compiler.is_noub))::AND{EffectLetter}                = AND(                  +u         )
effect_bits(::typeof(Compiler.is_noub_if_noinbounds))::AND{EffectLetter}  = AND(                     ~u      ) # .noub === NOUB_IF_NOINBOUNDS
effect_bits(::typeof(Compiler.is_nonoverlayed))::AND{EffectLetter}        = AND(                        +o   )
effect_bits(::typeof(Compiler.is_nortcall))::AND{EffectLetter}            = AND(                           +r)

function effect_bits(::typeof(Compiler.is_foldable), check_rtcall::Bool=false)::AND
    AND(+c, OR(+u, ~u), +e, +t, OR(!check_rtcall, +r))
end
function effect_bits(::typeof(Compiler.is_foldable_nothrow), check_rtcall::Bool=false)::AND
    AND(effect_bits(Compiler.is_foldable, check_rtcall)..., +n)
end
function effect_bits(::typeof(Compiler.is_removable_if_unused))::AND{EffectLetter}
    AND(+e, +t, +n)
end
function effect_bits(::typeof(Compiler.is_finalizer_inlineable))::AND{EffectLetter}
    AND(+n, +s)
end
function effect_bits(::typeof(Compiler.is_consistent_if_notreturned))::AND{EffectLetter}
    AND(EffectLetter(CONSISTENT_IF_NOTRETURNED, 'c'))
end
function effect_bits(::typeof(Compiler.is_consistent_if_inaccessiblememonly))::AND{EffectLetter}
    AND(EffectLetter(CONSISTENT_IF_INACCESSIBLEMEMONLY, 'c'))
end
function effect_bits(::typeof(Compiler.is_effect_free_if_inaccessiblememonly))::AND{EffectLetter}
    AND(~e) # .effect_free === EFFECT_FREE_IF_INACCESSIBLEMEMONLY
end
function effect_bits(::typeof(Compiler.is_inaccessiblemem_or_argmemonly))::AND{EffectLetter}
    AND(~m) # .inaccessiblememonly === INACCESSIBLEMEM_OR_ARGMEMONLY
end
function effect_bits(::typeof(Compiler.is_consistent_overlay))::AND{EffectLetter}
    AND(~o) # .nonoverlayed === CONSISTENT_OVERLAY
end

include("detect.jl")
include("show.jl")

end # module TestCompiler.EffectBits
