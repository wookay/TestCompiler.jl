using Jive
@useinside Main module test_compiler_AbstractInterpreter

using Test
using Compiler
using Core: Compiler as CC

# from Compiler/test/runtests.jl
@test Compiler.AbstractInterpreter === CC.AbstractInterpreter


# from julia/Compiler/test/AbstractInterpreter.jl
using Base.Experimental: @MethodTable, @overlay, @consistent_overlay

@MethodTable RT_METHOD_DEF
@overlay RT_METHOD_DEF Base.sin(x::Float64)::Float64 = cos(x)

method = only(Base.MethodList(RT_METHOD_DEF))
@test method.sig === Tuple{typeof(sin), Float64}

end # module test_compiler_AbstractInterpreter
