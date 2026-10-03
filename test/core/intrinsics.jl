module test_core_intrinsics

using Test

@test Core.Intrinsics.not_int(false) === true
@test Core.Intrinsics.not_int(true) === false
@test Core.Intrinsics.not_int(0) === -1
@test Core.Intrinsics.not_int(-1) === 0

function count_intrinsics()::Int
    cnt = 0
    for sym in names(Core.Intrinsics)
        sym === :Intrinsics && continue
        f = getglobal(Core.Intrinsics, sym)
        cnt += 1
        @test f isa Core.IntrinsicFunction
    end
    cnt
end # function

if VERSION >= v"1.12"
    @test count_intrinsics() == 92
end # if

if VERSION >= v"1.14-DEV"
primitive type U3 3 end

U3(n::UInt8)      = Core.Intrinsics.trunc_int(U3, n)
Base.UInt8(x::U3) = Core.Intrinsics.zext_int(UInt8, x)

@test UInt8(U3(0b111)) == 0b111
@test Core.bitsizeof(U3) == 3
end # if

@test Core.Intrinsics.bitcast(UInt8, Int8(0b111)) == 0b111
@test Core.Intrinsics.trunc_int(UInt8, UInt16(0b111)) == 0b111
@test Core.Intrinsics.zext_int(UInt16, 0b111) == UInt16(0b111)

end # module test_core_intrinsics
