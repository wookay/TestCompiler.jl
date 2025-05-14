using Jive
@If VERSION >= v"1.12-beta" module test_compiler_lock

using Test

# from julia/base/lock.jl

const global_state = Base.OncePerProcess{Vector{UInt32}}() do
    # println("Making lazy global value...done.")
    return [Libc.rand()]
end

procstate = global_state()
@test procstate === global_state()
@test procstate === fetch(@async global_state())
@test procstate === fetch(@async global_state())

const thread_state = Base.OncePerThread{Vector{UInt32}}() do
    # println("Making lazy thread value...done.")
    return [Libc.rand()]
end

threadvec = thread_state()
@test threadvec === fetch(@async thread_state())
@test threadvec === thread_state[Threads.threadid()]
@test threadvec === fetch(@async thread_state())
@test threadvec === thread_state[Threads.threadid()]

const task_state = Base.OncePerTask{Vector{UInt32}}() do
    # println("Making lazy task value...done.")
    return [Libc.rand()]
end

taskvec = task_state()
@test taskvec === task_state()
@test taskvec !== fetch(@async task_state())
@test taskvec !== fetch(@async task_state())

end # module test_compiler_lock
