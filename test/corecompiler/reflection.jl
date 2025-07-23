using Jive
# Core.OptimizedGenerics  julia commit efa917e8775cd40fdd74b657d1e5d2db2342cd07
@If VERSION >= v"1.12.0-DEV.1713" module test_corecompiler_reflection_REFLECTION_COMPILER

using Test

# from julia/Compiler/test/setup_Compiler.jl
if !isdefined(Main, :__custom_compiler_active)

if VERSION >= v"1.12.0-DEV.1571"
@test Base.REFLECTION_COMPILER[] === nothing
end

@eval Main begin
    __custom_compiler_active = true
end

end # if !isdefined(Main, :__custom_compiler_active)


# julia/Compiler/src/bootstrap.jl
# WARNING: Method definition typeinf(Nothing, Core.MethodInstance, UInt8) in module Compiler at ../usr/share/julia/Compiler/src/bootstrap.jl:12 overwritten on the same line (check for duplicate calls to `include`).
using Jive
Jive.delete(Core.OptimizedGenerics.CompilerPlugins.typeinf, Tuple{Nothing, Core.MethodInstance, UInt8})

using Core: Compiler as CC
CC.activate!(; codegen = true)

@test isdefined(Main, :__custom_compiler_active)
@test Base.REFLECTION_COMPILER[] == CC

end # module test_corecompiler_reflection_REFLECTION_COMPILER
