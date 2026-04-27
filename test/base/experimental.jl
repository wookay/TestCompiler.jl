using Jive

# see also  opaque_closure.jl
@If VERSION >= v"1.14.0-DEV.16" module test_base_experimental_reexport

using Test

module M1
export f1
function f1 end
end

module M2
using Base.Experimental: @reexport
@reexport using ..M1
end

using .M2
@test f1 isa Function

end # module test_base_experimental_reexport


@If VERSION >= v"1.12.0-DEV.91" module test_base_experimental_hint_handlers

using Test
using REPL

function get_hint_handlers(T::Type{<: Exception})
    if VERSION >= v"1.13.0-DEV.1358"
        [f for (Err, f) in Base.Experimental._hint_handlers[Core.typename(T)]]
    else
        Base.Experimental._hint_handlers[T]
    end
end

@test get_hint_handlers(UndefVarError) == [
        Base.UndefVarError_hint,
        REPL.UndefVarError_REPL_hint
    ]

@test get_hint_handlers(MethodError) == [
        Base.noncallable_number_hint_handler,
        Base.nonsetable_type_hint_handler,
        Base.string_concatenation_hint_handler,
        Base.methods_on_iterable
    ]

@test get_hint_handlers(FieldError) == [
        Base.fielderror_dict_hint_handler,
        Base.fielderror_listfields_hint_handler
    ]

end # module test_base_experimental_hint_handlers
