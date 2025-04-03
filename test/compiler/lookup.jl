using Test
using TestCompiler: CompilerDevTools

# from julia/Compiler/extras/CompilerDevTools/test/runtests.jl
using .CompilerDevTools: lookup_method_instance

do_work(x, y) = x + y
mi = lookup_method_instance(do_work, 1, 2)
@test mi isa Core.MethodInstance
