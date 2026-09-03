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

@test_nowarn                             1e308
@test_nowarn                 Meta.parse("1e308")
@test_throws Meta.ParseError Meta.parse("1e309")

end # module test_base_meta
