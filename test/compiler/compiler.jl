module test_compiler_compiler

using Test
using Compiler: Compiler as C
using Core.Compiler: Compiler as CC

on_ci = haskey(ENV, "CI")

if on_ci
    @test C !== CC
end

end # module test_compiler_compiler
