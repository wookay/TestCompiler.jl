module test_src_gf

# from julia/src/gf.c
#=
  Generic Functions
  . method table and lookup
  . GF constructor
  . dispatch
  . static parameter inference
  . method specialization and caching, invoking type inference
=#

# record_precompile_statement
# static void record_precompile_statement(jl_method_instance_t *mi, double compilation_time, int is_recompile)
# if (def->is_for_opaque_closure)
#     return; // OpaqueClosure methods cannot be looked up by their types, so are incompatible with `precompile(...)`

# jl_compile_method_internal
# jl_code_instance_t *jl_compile_method_internal(jl_method_instance_t *mi, size_t world)
# // Is a recompile if there is cached code, and it was compiled (not only inferred) before
# int is_recompile = 0;
# jl_code_instance_t *codeinst_old = jl_atomic_load_relaxed(&mi->cache);
# while (codeinst_old != NULL) {
#     if (jl_atomic_load_relaxed(&codeinst_old->invoke) != NULL) {
#         is_recompile = 1;
#         break;
#     }
#     codeinst_old = jl_atomic_load_relaxed(&codeinst_old->next);
# }
# if (codeinst) {
#     if (jl_is_compiled_codeinst(codeinst)) {
#         jl_typeinf_timing_end(inference_start, is_recompile);
#         // Already compiled - e.g. constabi, or compiled by a different thread while we were waiting.
#         return codeinst;
#     }
#     int did_compile = jl_compile_codeinst(codeinst);
#     double compile_time = jl_hrtime() - compilation_start;
#     if (jl_atomic_load_relaxed(&codeinst->invoke) == NULL) {
#         // Something went wrong. Bail to the fallback path.
#         codeinst = NULL;
#     }
#     else if (did_compile && codeinst->owner == jl_nothing) {
#         record_precompile_statement(mi, compile_time, is_recompile);
#     }

end # module test_src_gf
