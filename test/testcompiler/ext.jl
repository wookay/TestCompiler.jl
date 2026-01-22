using Jive
@If VERSION >= v"1.14-DEV" module test_testcompiler_ext

using Test
using TestCompiler

if isempty(filter(pkgid -> pkgid.name == "Compiler", keys(Base.loaded_modules)))
@test isempty(methods(TestCompiler.extension_interface, Tuple{Symbol}))
@test Base.get_extension(TestCompiler, :TestCompilerExt) === nothing
end

using Compiler: Compiler as C
using Core.Compiler: Compiler as CC
# @test C === CC

@test !isempty(methods(TestCompiler.extension_interface, Tuple{Symbol}))
ext = Base.get_extension(TestCompiler, :TestCompilerExt)
@test ext isa Module

(C2, CC2) = TestCompiler.extension_interface(:hello)
@test C2 === C
@test CC2 === CC

end # module test_testcompiler_ext
