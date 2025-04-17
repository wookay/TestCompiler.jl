module test_compiler_inference

using Test
using Core: Compiler

# julia/Compiler/test/inference.jl
Compiler.argtypes_to_type
@test Compiler.argtypes_to_type(Any[])           === Tuple{}
@test Compiler.argtypes_to_type(Any[Int])        === Tuple{Int}
@test Compiler.argtypes_to_type(Any[Union{Int}]) === Tuple{Union{Int}}

f() = 42
Base.return_types
@test Base.return_types(f) == DataType[Int] == Any[Int]

Base.infer_return_type
Base.infer_return_type(f) === Int

end # test_compiler_inference
