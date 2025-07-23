using Jive
@If VERSION >= v"1.13" module test_corecompiler_misc_semaphore

using Test

# from julia/test/misc.jl
sem_size = 2
s = Base.Semaphore(sem_size)
Base.acquire(s)
1+2
Base.release(s)

Base.@acquire s 1+2

end # module test_corecompiler_misc_semaphore
