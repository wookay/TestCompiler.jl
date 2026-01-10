using Jive
# @useinside module test_corecompiler_constprop_heuristic
@If VERSION >= v"1.12" module test_corecompiler_constprop_heuristic

using Test
using Core: Compiler
using .Compiler: typename

# julia/base/boot.jl
# typename(_).constprop_heuristic
# const FORCE_CONST_PROP      = 0x1
# const ARRAY_INDEX_HEURISTIC = 0x2
# const ITERATE_HEURISTIC     = 0x3
# const SAMETYPE_HEURISTIC    = 0x4

if VERSION >= v"1.12.0-DEV.949"
@test typename(typeof(getproperty)).constprop_heuristic == Core.FORCE_CONST_PROP
@test typename(typeof(setproperty!)).constprop_heuristic == Core.FORCE_CONST_PROP

@test typename(typeof(getindex)).constprop_heuristic == Core.ARRAY_INDEX_HEURISTIC
@test typename(typeof(setindex!)).constprop_heuristic == Core.ARRAY_INDEX_HEURISTIC

@test typename(typeof(iterate)).constprop_heuristic == Core.ITERATE_HEURISTIC

for f in (+, -, *, ==, !=, <=, >=, <, >)
    @test typename(typeof(f)).constprop_heuristic == Core.SAMETYPE_HEURISTIC
end
end # if VERSION >= v"1.12.0-DEV.949"


# julia/Compiler/src/abstractinterpretation.jl
Compiler.force_const_prop
Compiler.const_prop_function_heuristic

include("newinterp.jl")
@newinterp Interp1

using .Compiler: AbstractInterpreter
@test Interp1 <: AbstractInterpreter
interp = Interp1()
@test interp isa AbstractInterpreter

# TODO
# test Compiler.const_prop_function_heuristic

end # module test_corecompiler_constprop_heuristic
