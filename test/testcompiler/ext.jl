module test_testcompiler_ext

using Test
using Core: Compiler as CC
using Compiler

@test Compiler.BaseCompiler === CC
@test Compiler.BaseCompiler !== Compiler

using TestCompiler
ext = Base.get_extension(TestCompiler, :TestCompilerExt)
@test ext isa Module

end # module test_testcompiler_ext
