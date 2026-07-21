using Jive
@If VERSION >= v"1.12" module test_base_threads

using Test

# from julia/test/threads.jl

using Base.Threads

done = Threads.Atomic{Bool}(false)

if VERSION >= v"1.14.0-DEV.2707" # julia commit 5cf338b053
@atomic done[] = true

@test done[]
end # if

end # module test_base_threads
