module test_base_meta

using Test

@test Meta.parse("1+2") == :(1+2)

@test Meta.isexpr(:(1+2), :call)
@test Meta.isexpr(quote end, :block)
@test Meta.isexpr(:(), :tuple)
@test Meta.isexpr(:(function () end), :function)

if VERSION >= v"1.13.0-DEV.980"
Meta.reescape
end

end # module test_base_meta
