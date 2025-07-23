module test_testcompiler_ext

using Test
using TestCompiler

if isempty(filter(pkgid -> pkgid.name == "Compiler", keys(Base.loaded_modules)))
@test isempty(methods(TestCompiler.extension_interface, Tuple{Symbol}))
@test Base.get_extension(TestCompiler, :TestCompilerExt) === nothing
end

using Compiler

@test !isempty(methods(TestCompiler.extension_interface, Tuple{Symbol}))
ext = Base.get_extension(TestCompiler, :TestCompilerExt)
@test ext isa Module

(C, CC) = TestCompiler.extension_interface(:hello)
@test C === Compiler
@test C !== CC

end # module test_testcompiler_ext
