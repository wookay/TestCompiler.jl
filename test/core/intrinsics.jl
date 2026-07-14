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

end # module test_core_intrinsics
