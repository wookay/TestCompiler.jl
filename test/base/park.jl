using Jive
@If VERSION >= v"1.14-DEV" module test_base_park

using Test

# from julia/base/park.jl
#      julia/base/cancellation.jl

Base.WAKE_VALUE       # 0x00  # normal wake consumed (lazy settle)
Base.WAKE_FIRED       # 0x01  # fired; self-claim won; no suspend
Base.WAKE_INTERRUPTED # 0x03  # exceptional wake (cleanup path)
Base.WAKE_WITHDRAWN   # 0x04  # withdraw! - the caller is done waiting

Base.WAIT_AUX_WATCHER_BIT # UInt64(0x100)

end # module test_base_park
