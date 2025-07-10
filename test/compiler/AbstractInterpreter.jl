using Jive
@If VERSION >= v"1.12-beta" @useinside Main module test_compiler_AbstractInterpreter

using Test
using Compiler
using Core: Compiler as CC

# from Compiler/test/runtests.jl
@test Compiler.AbstractInterpreter === CC.AbstractInterpreter

end # module test_compiler_AbstractInterpreter
