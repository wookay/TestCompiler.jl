using Jive
@If VERSION >= v"1.13.0-DEV.518" module test_customcompiler_custom

using Pkg
Pkg.develop(path=normpath(@__DIR__, "../../src/BaseCompiler.jl"))

using Compiler
Compiler.activate!(; codegen = true)

using Test

@test Compiler.return_type(+, Tuple{Int, Int}) === Int

@test Compiler.BaseCompiler !== Compiler
@test Compiler.hello() == 42

end # @If VERSION >= v"1.13.0-DEV.518" module test_customcompiler_custom
