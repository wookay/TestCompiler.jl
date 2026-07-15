using Jive
# julia commit afdac9edc2
@If VERSION >= v"1.14.0-DEV.1859" module test_compilerdevtools_compiler_plugins

using Test

# from julia/base/optimized_generics.jl
using Core.OptimizedGenerics.CompilerPlugins: typeinf, typeinf_edge

# from julia/Compiler/extras/CompilerDevTools/test/runtests.jl
using Base: inferencebarrier
using Compiler: code_cache
using CompilerDevTools: lookup_method_instance, SplitCacheInterp, with_new_compiler

@testset "CompilerDevTools" begin
    do_work(x, y) = x + y
    f1() = do_work(inferencebarrier(1), inferencebarrier(2))
    interp = SplitCacheInterp()
    cache = code_cache(interp)
    mi = lookup_method_instance(f1)
    @test !haskey(cache, mi)
    @test with_new_compiler(f1, interp.owner) === 3
    @test haskey(cache, mi)
    # Here `do_work` is compiled at runtime, and so must have
    # required extra work to be cached under the same cache owner.
    mi = lookup_method_instance(do_work, 1, 2)
    @test haskey(cache, mi)

    # Should not error with a builtin whose type we do not know
    f_unknown_builtin() = Base.compilerbarrier(:type, isa)(1, Int)
    @test with_new_compiler(f_unknown_builtin, interp.owner) === true
end

end # module test_compilerdevtools_compiler_plugins
