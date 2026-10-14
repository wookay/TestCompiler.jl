module test_src_jltypes

# from julia/src/jltypes.c
#
# static int has_free_typevars(jl_value_t *v, jl_typeenv_t *env) JL_NOTSAFEPOINT
#
# JL_DLLEXPORT int jl_has_free_typevars(jl_value_t *v) JL_NOTSAFEPOINT
# {
#    return has_free_typevars(v, NULL);
# }

if VERSION >= v"1.12"
Core.has_free_typevars
end

end # module test_src_jltypes
