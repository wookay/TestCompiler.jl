# module TestCompiler.EffectBits

struct EffectLetter
    prefix::Char   # + ! ? _
    suffix::Char   # c e n t s m u o r
    bitmask::UInt8 # 0x02 CONSISTENT_IF_NOTRETURNED
                   # 0x04 CONSISTENT_IF_INACCESSIBLEMEMONLY
                   # 0x02 EFFECT_FREE_IF_INACCESSIBLEMEMONLY
                   # 0x03 EFFECT_FREE_GLOBALLY
                   # 0xFF
    EffectLetter(prefix::Char, suffix::Char) = new(prefix, suffix, 0xFF)
    EffectLetter(bitmask::UInt8, suffix::Char) = new('_', suffix, bitmask)
end

struct EffectSuffix
    suffix::Char
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
    EffectLetter('+', effect_suffix.suffix)
end

function !(effect_suffix::EffectSuffix)::EffectLetter # !
    EffectLetter('!', effect_suffix.suffix)
end

function ~(effect_suffix::EffectSuffix)::EffectLetter # ?
    EffectLetter('?', effect_suffix.suffix)
end

### effects_field_name
function effects_field_name(letter::EffectLetter)::Symbol
    effects_field_name(letter.suffix)
end

function effects_field_name(effect_suffix::EffectSuffix)::Symbol
     effects_field_name(effect_suffix.suffix)
end

function effects_field_name(char::Char)::Symbol
    if char == 'c'
        :consistent
    elseif char == 'e'
        :effect_free
    elseif char == 'n'
        :nothrow
    elseif char == 't'
        :terminates
    elseif char == 's'
        :notaskstate
    elseif char == 'm'
        :inaccessiblememonly
    elseif char == 'u'
        :noub
    elseif char == 'o'
        :nonoverlayed
    elseif char == 'r'
        :nortcall
    else
         throw(EffectsArgumentError(string("unsupported effectbits: ", char)))
    end
end

function effects_suffix(field_name::Symbol)::Char
    if field_name === :consistent
        'c'
    elseif field_name === :effect_free
        'e'
    elseif field_name === :nothrow
        'n'
    elseif field_name === :terminates
        't'
    elseif field_name === :notaskstate
        's'
    elseif field_name === :inaccessiblememonly
        'm'
    elseif field_name === :noub
        'u'
    elseif field_name === :nonoverlayed
        'o'
    elseif field_name === :nortcall
        'r'
    else
         throw(EffectsArgumentError(string("unsupported effectbits: ", field_name)))
    end
end

# julia/Compiler/src/effects.jl
function effect_bits_const_name(field_name::Symbol, effect::UInt8)::Symbol
    if effect ==             ALWAYS_TRUE                        # 0x00
        return              :ALWAYS_TRUE
    elseif effect ==         ALWAYS_FALSE                       # 0x01
        return              :ALWAYS_FALSE
    else
        if field_name === :consistent
            if effect ==     CONSISTENT_IF_NOTRETURNED          # 0x01 << 1
                return      :CONSISTENT_IF_NOTRETURNED
            elseif effect == CONSISTENT_IF_INACCESSIBLEMEMONLY  # 0x01 << 2
                return      :CONSISTENT_IF_INACCESSIBLEMEMONLY
            end
        elseif field_name === :effect_free
            if effect ==     EFFECT_FREE_IF_INACCESSIBLEMEMONLY # 0x02
                return      :EFFECT_FREE_IF_INACCESSIBLEMEMONLY
            elseif effect == EFFECT_FREE_GLOBALLY               # 0x03
                return      :EFFECT_FREE_GLOBALLY
            end
        elseif field_name === :nothrow
        elseif field_name === :terminates
        elseif field_name === :notaskstate
        elseif field_name === :inaccessiblememonly
            if effect ==     INACCESSIBLEMEM_OR_ARGMEMONLY      # 0x01 << 1
                return      :INACCESSIBLEMEM_OR_ARGMEMONLY
           end
        elseif field_name === :noub
            if effect ==     NOUB_IF_NOINBOUNDS                 # 0x01 << 1
                return      :NOUB_IF_NOINBOUNDS
            end
        elseif field_name === :nonoverlayed
            if effect ==     CONSISTENT_OVERLAY                 # 0x01 << 1
                return      :CONSISTENT_OVERLAY
            end
        end
    end
    throw(EffectsArgumentError(string("unsupported effectbits: ", field_name, " ", effect)))
end

function EffectLetter(effects::Effects, suffix::Char)::EffectLetter
    name::Symbol = effects_field_name(suffix)
    effect::Union{Bool, UInt8} = getfield(effects, name)
    typ = typeof(effect)
    if typ === Bool
        return EffectLetter(effect ? '+' : '!', suffix)
    elseif typ === UInt8
        if effect == ALWAYS_TRUE # 0x00
            return EffectLetter('+', suffix)
        elseif effect == ALWAYS_FALSE # 0x01
            return EffectLetter('!', suffix)
        else
            if suffix in ('c', 'e')
                return EffectLetter(effect, suffix)
            else
                if 0x02 == effect
                    return EffectLetter('?', suffix)
                else
                    return EffectLetter(effect, suffix)
                end
            end
        end
    end
end # function EffectLetter(effects::Effects, suffix::Char)::EffectLetter

function Base.in(letter::EffectLetter, effects::Effects)
    name::Symbol = effects_field_name(letter)
    effect::Union{Bool, UInt8} = getfield(effects, name)
    typ = typeof(effect)
    if letter.prefix == '+'
        if typ === UInt8
            return effect == ALWAYS_TRUE
        elseif typ === Bool
            return effect
        end
    elseif letter.prefix == '!'
        if typ === UInt8
            return effect == ALWAYS_FALSE
        elseif typ === Bool
            return !effect
        end
    elseif letter.prefix == '?'
        if typ === UInt8
            return effect == 0x02
        end
    elseif letter.prefix == '_'
        return effect == letter.bitmask
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
        name::Symbol = effects_field_name(letter)
        effect::Union{Bool, UInt8} = getindex(effects_dict, name)
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
                else # _
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
