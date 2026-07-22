module test_base_stacktraces

using Test
using Base.StackTraces: StackFrame

# from julia/test/client.jl

frames = [
    StackFrame(:foo, "foo.jl", 1)
]
@test Base.scrub_repl_backtrace(frames) == frames

end # module test_base_stacktraces
