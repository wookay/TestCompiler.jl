module test_compiler_essentials

using Test

# julia/base/essentials.jl
Base._is_internal


function f()
    Base.@_terminates_locally_meta
end
@test f() === false

Base._is_internal(__module__::Module) = true
@test f() === false
function f()
    Base.@_terminates_locally_meta
end
@test f() === nothing
method = only(methods(Base._is_internal, Tuple{Module}))
Base.delete_method(method)
@test f() === nothing

function f()
    Base.@_terminates_locally_meta
end
@test f() === false

end # module test_compiler_essentials
