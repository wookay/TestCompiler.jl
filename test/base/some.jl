module test_base_some

using Test

@test_throws ArgumentError something()
@test_throws ArgumentError something(nothing)
@test_throws ArgumentError something(nothing, nothing)
@test_throws MethodError Some{Int}(nothing)

@test something(Some(nothing)) === nothing
@test something(Some{nothing}) === Some{nothing}
@test something(Nothing) === Nothing
@test something(something) === something

@test something(nothing, 1, 2) == something(1, 2, nothing) == 1

end # module test_base_some
