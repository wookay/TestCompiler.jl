module test_core_finalizers

using Test

# from julia/test/core.jl

let A = [9], x = 0
    @test ismutable(A)
    finalizer(_->(x+=1), A)
    @test x == 0
    finalize(A)
    @test x == 1
end

let A = [9], x = 0
    finalizer(_->(x+=1), A)

    A = []
    finalize(A)
    @test x == 0
end

@test !isdefined(@__MODULE__, :A)

end # module test_core_finalizers
