module test_base_tasks

using Test

f() = 42

t = Task(f)
@test t isa Task
@test !istaskdone(t)

ret = yield(t)
@test ret === nothing
@test istaskdone(t)

end # module test_base_tasks


using Jive
@If VERSION >= v"1.12" module test_base_tasks_task_metrics

using Test

# from julia/test/threads_exec.jl

f() = 42

t = Task(f)
yield(t)
if VERSION >= v"1.14.0-DEV.2829" # julia commit 10d617e311
@test Core.task_result_type(t) === Any
end

@test !t.metrics_enabled
@test Base.Experimental.task_running_time_ns(t) ===
      Base.Experimental.task_wall_time_ns(t) ===
      nothing


Base.Experimental.task_metrics(true)

t = Task(f)
yield(t)
@test t.metrics_enabled
@test Base.Experimental.task_running_time_ns(t) > 100
@test Base.Experimental.task_wall_time_ns(t)    > 1000

pairs_running = []
pairs_wall    = []
pairs_sub     = []
for n in ("-1", "1", "2", "3", "1e2", "1e308", "1e309")
    t = Task(() -> try Meta.parse(n) catch end)
    yield(t)
    running_t = Base.Experimental.task_running_time_ns(t)
    wall_t    = Base.Experimental.task_wall_time_ns(t)
    push!(pairs_running, n => running_t)
    push!(pairs_wall,    n => wall_t)
    push!(pairs_sub,     n => wall_t - running_t)
end

@test first.(sort(pairs_running, by=last, rev=true)[1:2]) ==
      first.(sort(pairs_wall, by=last, rev=true)[1:2]) ==
      ["-1", "1e309"]
@test all(<(10000), last.(pairs_sub))

Base.Experimental.task_metrics(false)

end # module test_base_tasks_task_metrics
