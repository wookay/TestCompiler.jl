using Jive
@If VERSION >= v"1.12-beta" module test_compiler_threads

using Test

const str = OncePerProcess{String}() do
    return "Hello"
end

@test str() == "Hello"

# from julia/test/threads.jl
alls = OncePerThread() do
    return [nothing]
end

@test alls() == [nothing]

end # module test_compiler_threads
