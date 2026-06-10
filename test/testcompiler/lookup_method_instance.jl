module test_CompilerDevTools_lookup_method_instance

using Test
using TestCompiler: CompilerDevTools

# from julia/Compiler/extras/CompilerDevTools/test/runtests.jl
using .CompilerDevTools: lookup_method_instance

do_work(x, y) = x + y
mi = lookup_method_instance(do_work, 1, 2)
@test mi isa Core.MethodInstance

# from julia/Compiler/src/ssair/ir.jl
#      julia/Compiler/test/ssair.jl
di = Core.DebugInfo(mi)
@test di.def === mi
@test di.linetable === nothing
@test di.edges == Core.svec()
@test di.codelocs == ""

end # using test_CompilerDevTools_lookup_method_instance
