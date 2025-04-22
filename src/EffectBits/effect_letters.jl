# module TestCompiler.EffectBits

struct EffectLetter
    prefix::Char   # + ! ? _
    suffix::Char   # c e n t s m u o r
    bitmask::UInt8 # 0x02 CONSISTENT_IF_NOTRETURNED
                   # 0x04 CONSISTENT_IF_INACCESSIBLEMEMONLY
                   # 0xFF
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

function +(effect_suffix::EffectSuffix)::EffectLetter # +
    EffectLetter('+', effect_suffix.char)
end

function !(effect_suffix::EffectSuffix)::EffectLetter # !
    EffectLetter('!', effect_suffix.char)
end

function ~(effect_suffix::EffectSuffix)::EffectLetter # ?
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
        @info :nameof_EffectSuffix suffix.char
        :unknown_effectbits
    end
end

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
        if typ === UInt8
            return effect === ALWAYS_TRUE
        elseif typ === Bool
            return effect
        end
    elseif letter.prefix == '!'
        if typ === UInt8
            return effect === ALWAYS_FALSE
        elseif typ === Bool
            return !effect
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

# import Core.Compiler: Effects
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
        if letter.prefix == '?'
            # e .effect_free = EFFECT_FREE_IF_INACCESSIBLEMEMONLY
            # m .inaccessiblememonly = INACCESSIBLEMEM_OR_ARGMEMONLY
            # u .noub = NOUB_IF_NOINBOUNDS
            # o .nonoverlayed = CONSISTENT_OVERLAY
            if name in (:effect_free, :inaccessiblememonly, :noub, :nonoverlayed)
                setindex!(effects_dict, 0x02, name)
            else
                throw(EffectsArgumentError(letter))
            end
        else
            if typ === Bool
                setindex!(effects_dict, letter.prefix == '+', name)
            elseif typ === UInt8
                if letter.prefix == '+'
                    setindex!(effects_dict, ALWAYS_TRUE, name)
                elseif letter.prefix == '!'
                    setindex!(effects_dict, ALWAYS_FALSE, name)
                else
                    setindex!(effects_dict, letter.bitmask, name)
                end
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

# module TestCompiler.EffectBits
