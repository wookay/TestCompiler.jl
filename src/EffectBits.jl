module EffectBits # TestCompiler

export c, e, n, t, s, m, u, o, r
export EffectLetter, EffectSuffix

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

function Base.in(letter::EffectLetter, effects::Core.Compiler.Effects)
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

# const EffectLetters = NTuple{9, EffectLetter}

end # module TestCompiler.EffectBits
