module test_core_kwcall

using Test

function g(f, args...; kwargs...)
    kwargs = merge((;), kwargs)
    Core.kwcall(kwargs, f, args...)
end

f(args...; kwargs...) = (args = args, kwargs = kwargs)

@test g(f)           == (args = (),    kwargs = pairs((;)))
@test g(f   ; b = 2) == (args = (),    kwargs = pairs((; b = 2)))
@test g(f, 1; b = 2) == (args = (1, ), kwargs = pairs((; b = 2)))

end # module test_core_kwcall
