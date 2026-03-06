module test_base_assert

using Test

@assert true "hello"
@test_throws AssertionError("world") (@assert false "world")

end # module test_base_assert
