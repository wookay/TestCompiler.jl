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


module test_base_array_Cube

using Test

R = reshape(1:(3 ^ 2), (3, 3, 1))
S = reshape(1:(3 ^ 3), (3, 3, 3))
@test R[:,:,1] == S[:,:,1] == [1 4 7; 2 5 8; 3 6 9]

const Cube = Array{T, 3} where T
C = Cube(R)
@test C == R
@test C.size == R.dims == (3, 3, 1)

end # module test_base_array_Cube


module test_base_array_filter

using Test

# indexing functions
firstindex
lastindex
findfirst
findall

first
# filterfirst
filter

@test firstindex(5:7) == 1
@test lastindex(5:7) == 3
@test findfirst(isodd, 5:9) == 1
@test findfirst(isodd, [8, 10]) === nothing
@test findall(isodd, 5:9) == 1:2:5

@test first(5:7) == 5
if VERSION >= v"1.15.0-DEV.315" # julia commit e0ff20a8ad
@test filterfirst(isodd, 5:9) == 5
@test_throws ArgumentError filterfirst(isodd, [8, 10])
end
@test filter(isodd, 5:9) == 5:2:9

end # module test_base_array_filter
