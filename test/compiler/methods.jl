module test_compiler_methods

using Test
using Core: Compiler as CC

# from julia/Compiler/src/utilities.jl
CC.is_declared_inline

@inline f_inline() = 42
method = only(methods(f_inline))
@test CC.is_declared_inline(method)

f() = 42
method = only(methods(f))
@test !CC.is_declared_inline(method)

using Jive
Jive.delete(f)

g = (::Int) -> 42
method = only(methods(g))
@test first(String(method.name)) == '#'
@test method.sig.types[1] === typeof(g)
@test method.sig.types[2] === Int

method = only(methods(Base.read, Tuple{String, Type{String}}))
ast = Base.uncompressed_ast(method)
@test ast isa Core.CodeInfo
@test ast.code[1] === GlobalRef(Base, :open)
bodyfunc = Base.bodyfunction(method)
@test bodyfunc === Base.open

end # module test_compiler_methods
