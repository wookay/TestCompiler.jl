module test_base_char

using Test

# from julia/base/boot.jl
# abstract type AbstractChar end
# primitive type Char <: AbstractChar 32 end

emoji::Char = first("🖨️")
@test isprint(emoji)

@test isabstracttype(AbstractChar)
@test Base.ispacked(Char)
if VERSION >= v"1.14-DEV"
@test Core.bitsizeof(Char) == 32
end

end # module test_base_char
