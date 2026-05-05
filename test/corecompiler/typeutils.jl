module test_corecompiler_typeutils

using Test
using Core: Compiler as CC
using .CC: Const

# from julia/Compiler/src/typeutils.jl

@test CC.isconstType(Type{Const})
@test !(CC.isconstType(Const))
@test !(CC.isconstType(1))
@test !(CC.isconstType(Const(1)))

end # module test_corecompiler_typeutils
