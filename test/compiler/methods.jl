module test_compiler_methods

using Test
using Core.Compiler

# from julia/Compiler/src/utilities.jl
Compiler.is_declared_inline

@inline f_inline() = 42
method = only(methods(f_inline))
@test Compiler.is_declared_inline(method)

f() = 42
method = only(methods(f))
@test !Compiler.is_declared_inline(method)

using Jive
Jive.delete(f)

g = (::Int) -> 42
method = only(methods(g))
@test method.name === Symbol("#1")
@test method.sig.types[1] === typeof(g)
@test method.sig.types[2] === Int

end # module test_compiler_methods
