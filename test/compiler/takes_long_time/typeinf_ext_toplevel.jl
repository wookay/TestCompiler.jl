using Jive
@If VERSION >= v"1.14-DEV" @useinside Main module test_compiler_takes_long_time_typeinf_ext_toplevel

using Test
using Compiler: Compiler as C
using Core: CodeInstance, CodeInfo
using FemtoCompiler: FemtoInterpreter

InvokeInterp = FemtoInterpreter

# from julia/Compiler/test/AbstractInterpreter.jl
#=
struct InvokeOwner end
global codegen::IdDict{CodeInstance, CodeInfo} = IdDict{CodeInstance, CodeInfo}()
C.cache_owner(::InvokeInterp) = InvokeOwner()
C.codegen_cache(::InvokeInterp) = codegen
=#
let interp = InvokeInterp()
    source_mode = C.SOURCE_MODE_ABI
    f = (+)
    args = (1, 1)
    mi = @ccall jl_method_lookup(Any[f, args...]::Ptr{Any}, (1+length(args))::Csize_t, Base.tls_world_age()::Csize_t)::Ref{Core.MethodInstance}
    ci = C.typeinf_ext_toplevel(interp, mi, source_mode)
    @test invoke(f, ci, args...) == 2

    f = error
    args = "test"
    mi = @ccall jl_method_lookup(Any[f, args...]::Ptr{Any}, (1+length(args))::Csize_t, Base.tls_world_age()::Csize_t)::Ref{Core.MethodInstance}
    ci = C.typeinf_ext_toplevel(interp, mi, source_mode)
    result = nothing
    try
        invoke(f, ci, args...)
    catch e
        result = sprint(Base.show_backtrace, catch_backtrace())
    end
    @test isa(result, String)
    @test contains(result, "[1] error(::Char, ::Char, ::Char, ::Char)")
end

end # module test_compiler_takes_long_time_typeinf_ext_toplevel
