module test_compiler_return_type

using Test
using Core.Compiler

f() = 1
@test Compiler.return_type(f, Tuple{}) == Int64

# from julia/test/worlds.jl
# Invalidation
# function method_instance(f, types=Base.default_tt(f))
types = Base.default_tt(f)
@test types == Tuple{}
tt = Base.signature_type(f, types)
@test tt == Tuple{typeof(f)}

end # module test_compiler_return_type
