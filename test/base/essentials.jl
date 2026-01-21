module test_base_essentials

using Test
using Jive

# julia/base/essentials.jl
Base._is_internal


function f()
    Base.@_terminates_locally_meta
end
@test f() === false

Base._is_internal(__module__::Module) = true
@test f() === false
Jive.delete(f)

function f()
    Base.@_terminates_locally_meta
end
@test f() === nothing
Jive.delete(Base._is_internal, Tuple{Module})
@test f() === nothing
Jive.delete(f)

function f()
    Base.@_terminates_locally_meta
end
@test f() === false

end # module test_base_essentials
