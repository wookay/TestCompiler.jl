module test_core_intrinsics

using Test

@test Core.Intrinsics.not_int(false) === true
@test Core.Intrinsics.not_int(true) === false
@test Core.Intrinsics.not_int(0) === -1
@test Core.Intrinsics.not_int(-1) === 0

end # module test_core_intrinsics
