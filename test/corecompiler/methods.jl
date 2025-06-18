using Jive
@useinside Main module test_corecompiler_methods

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


f(x) = 42  # line 35
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

if VERSION >= v"1.13.0-DEV.710" && # julia commit 2a9f33c94dd66ffb96beaea86d595a138a1a8bc7
                                   # Base.show_method(; print_signature_only)
    basename(PROGRAM_FILE) == "runtests.jl"
method = only(methods(f))
@test @sprint_plain(Base.show_method(stdout, method; print_signature_only = true))                           == "f(x)"
@test @sprint_plain(Base.show_method(stdout, method; modulecolor = :yellow, print_signature_only = false))   == "f(x)\n     @ Main ~/.julia/dev/TestCompiler/test/corecompiler/methods.jl:35"
@test @sprint_colored(Base.show_method(stdout, method; modulecolor = :yellow, print_signature_only = false)) == "f(\e[90mx\e[39m)\n\e[90m     @\e[39m \e[33mMain\e[39m \e[90m~/.julia/dev/TestCompiler/test/corecompiler/\e[39m\e[90m\e[4mmethods.jl:35\e[24m\e[39m"
end

end # module test_corecompiler_methods
