module test_base_reinterpretarray

using Test

# from julia/test/core.jl

@test  Base.ispacked(Int64)
@test !Base.datatype_haspadding(Int64)

if VERSION >= v"1.14-DEV"
primitive type Byte63 63 end
primitive type Byte64 64 end

@test !Base.ispacked(Byte63)
@test  Base.ispacked(Byte64)
end

end # module test_base_reinterpretarray
