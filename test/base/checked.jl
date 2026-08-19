module test_base_checked

using Test

Base.checked_mul

# from julia/base/checked.jl
#      julia/test/checked.jl

@test                                     *(typemax(UInt32), UInt32(2)) == 0xfffffffe
@test_throws OverflowError Base.checked_mul(typemax(UInt32), UInt32(2))

end # module test_base_checked
