# module TestCompiler.EffectBits

function Base.show(io::IO, mime::MIME"text/plain", letter::EffectLetter)
    if letter.prefix == '_'
        print(io, "EffectLetter")
        print(io, "(")
        if letter.suffix == 'c'
            if letter.bitmask == CONSISTENT_IF_NOTRETURNED
                printstyled(io, :CONSISTENT_IF_NOTRETURNED; color = :cyan)
            elseif letter.bitmask == CONSISTENT_IF_INACCESSIBLEMEMONLY
                printstyled(io, :CONSISTENT_IF_INACCESSIBLEMEMONLY; color = :cyan)
            end
        end
        print(io, ", ")
        print(io, repr(letter.suffix))
        print(io, ")")
    else
        color = if letter.prefix == '+'
            :green
        else
            letter.prefix == '!' ? :red : :yellow
        end
        printstyled(io, string(letter.prefix, letter.suffix); color = color)
    end
end

function Base.show(io::IO, mime::MIME"text/plain", suffix::EffectSuffix)
    name = nameof(suffix)
    printstyled(io, repr(name); color = :cyan)
end

function Base.show(io::IO, mime::MIME"text/plain", and::AND{<:Union{EffectLetter, OR}})
    lastidx = lastindex(and.elements)
    print(io, "AND(")
    for (idx, el) in enumerate(and.elements)
        show(io, mime, el)
        lastidx != idx && print(io, ", ")
    end
    print(io, ")")
end

function Base.show(io::IO, mime::MIME"text/plain", or::OR{<:Union{EffectLetter, Bool}})
    lastidx = lastindex(or.elements)
    print(io, "OR(")
    for (idx, el) in enumerate(or.elements)
        show(io, mime, el)
        lastidx != idx && print(io, ", ")
    end
    print(io, ")")
end

function sprint_plain(x)::String
    sprint(io -> show(io, MIME"text/plain"(), x))
end

function Base.show(io::IO, mime::MIME"text/plain", effect::EffectCause)
    pads = Dict{Int, Int}()
    lastidx = lastindex(effect.and.elements)
    n = 0
    n += write(io, "AND(")
    for (idx, el) in enumerate(effect.and)
        setindex!(pads, n, idx)
        Base.show(io, mime, el)
        str = sprint_plain(el)
        n += length(str)
        if lastidx != idx
            n += write(io, ", ")
        end
    end
    print(io, ")")
    println(io)
    n = 0
    for (idx, el) in effect.cause
        pad = pads[idx] - n
        n += write(io, repeat(' ', pad))
        Base.show(io, mime, el)
        str = sprint_plain(el)
        n += length(str)
    end
end

# module TestCompiler.EffectBits
