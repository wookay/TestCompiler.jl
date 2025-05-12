# module TestCompiler.EffectBits

# get_affected
function get_affected(letter::EffectLetter, effects::Effects)::Bool
    return letter in effects
end

function get_affected(or::OR{EffectLetter}, effects::Effects)::Bool
    for el in or.elements
        el in effects && return true
    end
    return false
end

function get_affected(or::OR{Union{Bool, EffectLetter}}, effects::Effects)::Bool
    for el in or.elements
        if el isa Bool
            !(el::Bool) && return false
        elseif el isa EffectLetter
            el in effects && return true
        end
    end
    return false
end

struct EffectCause
    and::AND
    cause::Vector
end

function detect_cause(and::AND, effects::Effects)::EffectCause
    T = Union{EffectLetter, OR}
    cause = Vector{Tuple{Int, T}}()
    for (idx, el) in enumerate(and)
        b::Bool = get_affected(el, effects)
        if b
        else
            if el isa EffectLetter
                letter = EffectLetter(effects, el.suffix)
                push!(cause, (idx, letter))
            elseif el isa OR
                last_el = last(el.elements)
                if last_el isa EffectLetter
                    letter = EffectLetter(effects, last_el.suffix)
                    push!(cause, (idx, letter))
                end
            end
        end
    end
    EffectCause(and, cause)
end

### detect
function detect(f::Function, effects::Effects)::EffectCause
    detect_cause(effect_bits(f), effects)
end

function detect(f::Function, effects::Effects, check_rtcall::Bool)::EffectCause
    detect_cause(effect_bits(f, check_rtcall), effects)
end

# module TestCompiler.EffectBits
