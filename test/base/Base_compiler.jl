module test_base_Base_compiler

using Test

# from julia/base/Base_compiler.jl

is_primary_base_mod = ccall(:jl_module_parent, Ref{Module}, (Any,), Base) === Core.Main
@test is_primary_base_mod == Base.is_primary_base_module
@test parentmodule(Base) === Main
@test parentmodule(Main) === Main

end # module test_base_Base_compiler
