# from julia/Compiler/extras/CompilerDevTools/src/CompilerDevTools.jl
module CompilerDevTools # TestCompiler

function lookup_method_instance(f, args...)
    @ccall jl_method_lookup(Any[f, args...]::Ptr{Any}, (1+length(args))::Csize_t, Base.tls_world_age()::Csize_t)::Ref{Core.MethodInstance}
end

end # module TestCompiler.CompilerDevTools
