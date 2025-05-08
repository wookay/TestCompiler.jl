module test_testcompiler_ext

using Test

using Core: Compiler as CC
@test !Core.isdefined(CC, :hello_ext)

using Pkg
Pkg.develop(path=normpath(@__DIR__, "../../src/BaseCompiler.jl"))

using Compiler
# Compiler.activate!(; codegen = true)

@test Core.isdefined(Compiler, :hello_ext)
@test Compiler.BaseCompiler === Core.Compiler
@test Compiler.BaseCompiler !== Compiler

using TestCompiler
@test Base.hasmethod(Compiler.hello_ext, Tuple{Int})

ext = Base.get_extension(TestCompiler, :TestCompilerExt)
@test ext isa Module

@test Compiler.hello_ext(0) == 42

end # module test_testcompiler_ext
