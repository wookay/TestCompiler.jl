# julia/base/runtime_internals.jl
#=
function delete_method(m::Method)
    ccall(:jl_method_table_disable, Cvoid, (Any, Any), get_methodtable(m), m)
end

function get_methodtable(m::Method)
    mt = ccall(:jl_method_get_table, Any, (Any,), m)
    if mt === nothing
        return nothing
    end
    return mt::Core.MethodTable
end
=#

# julia/base/reflection.jl
#=
function method_instance(@nospecialize(f), @nospecialize(t);
                         world=Base.get_world_counter(), method_table=nothing)
    tt = signature_type(f, t)
    mi = ccall(:jl_method_lookup_by_tt, Any,
                (Any, Csize_t, Any),
                tt, world, method_table)
    return mi::Union{Nothing, MethodInstance}
end
=#

#=============================================================================================================#

# julia/src/gf.c
#=
// add a backedge from a non-existent signature to caller
JL_DLLEXPORT void jl_method_table_add_backedge(jl_methtable_t *mt, jl_value_t *typ, jl_code_instance_t *caller)

JL_DLLEXPORT void jl_method_table_disable(jl_methtable_t *mt, jl_method_t *method)

JL_DLLEXPORT void jl_method_table_insert(jl_methtable_t *mt, jl_method_t *method, jl_tupletype_t *simpletype)
=#
