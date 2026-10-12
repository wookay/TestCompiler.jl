module test_base_syntax

using Test

@test (1;     ) == 1
@test (1; 2   ) == 2
@test (1; 2; 3) == 3

@test (;) === NamedTuple()

end # module test_base_syntax
