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
