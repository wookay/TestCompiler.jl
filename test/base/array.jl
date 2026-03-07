module test_base_array

using Test

@test Base.allocatedinline(Int)
@test Base.allocatedinline(String) === false

end # module test_base_array
