module test_base_array

using Test

# from julia/base/runtime_internals.jl
@test Base.aligned_sizeof(Int) == 8
@test Base.aligned_sizeof(String) == 8
@test Base.aligned_sizeof(Type{Union}) == 8
if VERSION >= v"1.12"
@test Base.aligned_sizeof(Type{Union{}}) == 0
end # if

@test Base.datatype_alignment(Int) == 8
@test Base.datatype_alignment(String) == 1

# from julia/base/array.jl
# allocatedinline(@nospecialize T::Type) = (@_total_meta; ccall(:jl_stored_inline, Cint, (Any,), T) != Cint(0))
@test Base.allocatedinline(Int)
@test Base.allocatedinline(String) === false

end # test_base_array


module test_base_array_equal

using Test

@test  Any[]  == Char[]
@test Char[]  == Char[]
@test     []  ==     []

@test  Any[] !== Char[]
@test Char[] !== Char[]
@test  Any[] !==  Any[]
@test     [] !==     []


function array_equal(a::Vector{T}, b::Vector{T}) where T
    return a == b
end

function array_equal(a::Vector{T}, b::Vector{U}) where {T, U}
    return false
end

@test array_equal(Any[],  Char[]) === false
@test array_equal(Char[], Char[])

end # module test_base_array_equal
