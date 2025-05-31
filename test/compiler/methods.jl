module test_compiler_methods

using Test
using Core: Compiler as CC

# from julia/Compiler/src/utilities.jl
CC.is_declared_inline

@inline g_inline() = 42
method = only(methods(g_inline))
@test CC.is_declared_inline(method)

g() = 42
method = only(methods(g))
@test !CC.is_declared_inline(method)

using Jive
Jive.delete(g)

h = (::Int) -> 42
method = only(methods(h))
@test first(String(method.name)) == '#'
@test method.sig.types[1] === typeof(h)
@test method.sig.types[2] === Int

method = only(methods(Base.read, Tuple{String, Type{String}}))
ast = Base.uncompressed_ast(method)
@test ast isa Core.CodeInfo
@test ast.code[1] === GlobalRef(Base, :open)
bodyfunc = Base.bodyfunction(method)
@test bodyfunc === Base.open


f(x) = 42
method = only(methods(f))
@test Base.specializations(method) == Base.MethodSpecializations(Core.svec())

f(0)
method = only(methods(f))
@test Base.specializations(method).specializations ==
    Base.method_instance(f, Tuple{Int})

f("")
method = only(methods(f))
@test Base.specializations(method).specializations == Core.svec(
    Base.method_instance(f, Tuple{Int}),
    Base.method_instance(f, Tuple{String}),
    nothing, nothing, nothing, nothing, nothing)

end # module test_compiler_methods
