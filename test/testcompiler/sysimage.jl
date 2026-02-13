module test_testcompiler_sysimage

using Test
using TestCompiler: SysImage

@test "base/Base_compiler.jl" in SysImage.COMPILER_SRCS
@test "JuliaSyntax/src/core/parse_stream.jl" in SysImage.COMPILER_FRONTEND_SRCS
@test "base/Base.jl" in SysImage.BASE_SRCS
@test "base/sysimg.jl" in SysImage.STDLIB_SRCS
@test "usr/share/julia/JuliaLowering/src/desugaring.jl" in SysImage.JULIALOWERING_SRCS

end # module test_testcompiler_sysimage
