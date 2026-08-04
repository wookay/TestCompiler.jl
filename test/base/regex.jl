module test_base_regex

using Test

function Base.:(==)(a::T, b::T) where {T <: RegexMatch}
    a.match == b.match &&
    a.captures == b.captures &&
    a.offset == b.offset &&
    a.offsets == b.offsets &&
    a.regex == b.regex
end

m = match(r"\d{3}", "123")
@test m == RegexMatch(SubString("123"), Union{Nothing, SubString{String}}[], 1, Int[], r"\d{3}")

@test match(r"\d{3}", "abc") === nothing

@test replace("123", r"\d{3}" => "0") == "0"


s = "### [`JULIA_DEBUG`](@id JULIA_DEBUG)\n"
@test (first ∘ match)(r"`(\w*)`", s) == "JULIA_DEBUG"
s = "### `JULIA_FALLBACK_REPL`\n"
@test (first ∘ match)(r"`(\w*)`", s) == "JULIA_FALLBACK_REPL"

end # module test_base_regex
