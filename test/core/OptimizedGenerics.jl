using Jive
@If VERSION >= v"1.12.0-DEV.1713" module test_core_OptimizedGenerics

using Core.OptimizedGenerics.CompilerPlugins: typeinf, typeinf_edge

# typeinf(owner, mi, source_mode)::CodeInstance
# Return a `CodeInstance` for the given `mi` whose valid results include at
# the least current tls world and satisfies the requirements of `source_mode`.
typeinf

# typeinf_edge(owner, mi, parent_frame, world, abi_mode)::CodeInstance
typeinf_edge

end # module test_core_OptimizedGenerics
