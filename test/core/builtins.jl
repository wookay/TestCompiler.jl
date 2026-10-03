module test_core_builtins

using Test

# ≡
@test (===) isa Core.Builtin

# from julia/src/method.c
#=
JL_DLLEXPORT jl_method_t* jl_method_def(jl_svec_t *argdata,
                                        jl_methtable_t *mt,
                                        jl_code_info_t *f,
                                        jl_module_t *module)
=#

# cannot add methods to builtin function `===`
#                           Core.:(===)(x, y) = nothing
@test_throws ErrorException Core.:(===)(x, y) = nothing

# from julia/src/datatype.c
#=
void jl_check_valid_supertype(jl_value_t *super, const char *type_name)
=#

# invalid subtyping in definition of Egal: cannot add subtypes to Core.Builtin
#                           struct Egal <: supertype(typeof((===))) end
@test_throws ErrorException struct Egal <: supertype(typeof((===))) end

struct Eq <: supertype(typeof((==))) end

end # module test_core_builtins
