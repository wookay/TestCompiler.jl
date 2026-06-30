using Jive
@If VERSION >= v"1.12" module test_corecompiler_utilities

# from julia/Compiler/src/utilities.jl

using Test
using Core: Compiler as CC

# generic #
CC.contains_is
CC.anymap

# inlining #
CC.MAX_INLINE_CONST_SIZE
CC.count_const_size

# MethodInstance/CodeInfo #
CC.invoke_api
CC.use_const_api
CC.get_staged
CC.call_get_staged
CC.get_cached_uninferred
CC.retrieve_code_info
CC.get_compileable_sig
CC.isa_compileable_sig
CC.is_declared_inline
CC.is_declared_noinline
CC.is_aggressive_constprop
CC.is_no_constprop

# types #
CC.singleton_type
CC.maybe_singleton_const

# SSAValues/Slots #
if VERSION >= v"1.14-DEV"
CC.SSAUses
CC.SSAUseList
end # if

# options #
CC.inlining_enabled

end # module test_corecompiler_utilities
