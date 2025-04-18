module EffectBits # TestCompiler

export c, e, n, t, s, m, u, o, r
export EffectLetter, EffectSuffix, EffectsArgumentError
export effect_bits

using LogicalOperators: OR, AND
using Core: Compiler
import .Compiler: Effects

struct EffectLetter
    prefix::Char
    suffix::Char
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
        :unknown_effectbits
    end
end

function Base.show(io::IO, mime::MIME"text/plain", letter::EffectLetter)
    color = if letter.prefix == '+'
        :green
    else
        letter.prefix == '!' ? :red : :yellow
    end
    printstyled(io, string(letter.prefix, letter.suffix); color = color)
end

function Base.show(io::IO, mime::MIME"text/plain", suffix::EffectSuffix)
    name = nameof(suffix)
    printstyled(io, repr(name); color = :cyan)
end

using Core.Compiler: ALWAYS_TRUE, ALWAYS_FALSE

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
            return !(effect in (ALWAYS_TRUE, ALWAYS_FALSE))
        end
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
        if letter.prefix == '+'
            if typ === Bool
                setindex!(effects_dict, true, name)
            elseif typ === UInt8
                setindex!(effects_dict, ALWAYS_TRUE, name)
            end
        elseif letter.prefix == '!'
            if typ === Bool
                setindex!(effects_dict, false, name)
            elseif typ === UInt8
                setindex!(effects_dict, ALWAYS_FALSE, name)
            end
        elseif letter.prefix == '?'
            if name in (:effect_free, :inaccessiblememonly, :noub, :nonoverlayed)
                setindex!(effects_dict, 0x01 << 1, name)
            else
                throw(EffectsArgumentError(letter))
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

effect_bits(::typeof(Compiler.is_consistent))          = (+c, )
effect_bits(::typeof(Compiler.is_effect_free))         = (   +e, )
effect_bits(::typeof(Compiler.is_nothrow))             = (      +n, )
effect_bits(::typeof(Compiler.is_terminates))          = (         +t, )
effect_bits(::typeof(Compiler.is_notaskstate))         = (            +s, )
effect_bits(::typeof(Compiler.is_inaccessiblememonly)) = (               +m, )
effect_bits(::typeof(Compiler.is_noub))                = (                  +u, )
effect_bits(::typeof(Compiler.is_noub_if_noinbounds))  = (                     ~u, ) # .noub === NOUB_IF_NOINBOUNDS
effect_bits(::typeof(Compiler.is_nonoverlayed))        = (                        +o, )
effect_bits(::typeof(Compiler.is_nortcall))            = (                           +r, )

function effect_bits(::typeof(Compiler.is_foldable), check_rtcall::Bool=false)
    AND((+c, OR(+u, ~u), +e, +t, OR(!check_rtcall, +r)))
end
function effect_bits(::typeof(Compiler.is_foldable_nothrow), check_rtcall::Bool=false)
    AND((effect_bits(Compiler.is_foldable, check_rtcall)..., +n))
end
function effect_bits(::typeof(Compiler.is_removable_if_unused))
    AND((+e, +t, +n))
end
function effect_bits(::typeof(Compiler.is_finalizer_inlineable))
    AND((+n, +s))
end
function effect_bits(::typeof(Compiler.is_consistent_if_notreturned))
    c & CONSISTENT_IF_NOTRETURNED
end
function effect_bits(::typeof(Compiler.is_consistent_if_inaccessiblememonly))
    c & CONSISTENT_IF_INACCESSIBLEMEMONLY
end
function effect_bits(::typeof(Compiler.is_effect_free_if_inaccessiblememonly))
    ~e # .effect_free === EFFECT_FREE_IF_INACCESSIBLEMEMONLY
end
function effect_bits(::typeof(Compiler.is_inaccessiblemem_or_argmemonly))
    ~m # .inaccessiblememonly === INACCESSIBLEMEM_OR_ARGMEMONLY
end
function effect_bits(::typeof(Compiler.is_consistent_overlay))
    ~o # .nonoverlayed === CONSISTENT_OVERLAY
end

end # module TestCompiler.EffectBits
