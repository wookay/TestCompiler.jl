using Jive
@If VERSION >= v"1.14.0-DEV.2734" module test_base_cancellation
# julia commit 7afe4ed42e

using Test
using Base.ScopedValues: AbstractScopedValue
using Base: CancellationToken,
            CancellationRequest,
            CancelTokenKey

# from julia/base/cancellation.jl
#      julia/test/cancellation.jl

Core.CancellationTokenSource

@test CancellationRequest <: Exception
Base.CANCEL_REQUEST_SAFE
Base.CANCEL_REQUEST_ABANDON_EXTERNAL
Base.CANCEL_REQUEST_ABANDON_ALL

src = Core._new_cancel_source() # Base.CancellationTokenSource()
@test src.child_head === nothing
@test src.nparents == 0x0000
st = @atomic :acquire src.state
@test st == 0x00

tok = CancellationToken(src)
@test tok.source == src

@test Base.cancel_severity(src) === nothing
@test Base.cancel_severity(tok) === nothing

@test Base.iscancelled(src) === false
@test Base.iscancelled(tok) === false

Base.CANCEL_TOKEN
@test CancelTokenKey <: AbstractScopedValue
@test Base.CANCEL_TOKEN isa CancelTokenKey
@test Base.CANCEL_TOKEN[] === nothing

@test Base.default_cancel_token() === nothing
@test Base.default_cancel_source() === nothing

Base.cancel!
Base.@cancel_check


#=
const CancellationTokenSource = Core.CancellationTokenSource

struct CancellationToken
    source::CancellationTokenSource
end

struct CancellationRequest <: Exception
    request::UInt8
end

const CANCEL_REQUEST_SAFE = CancellationRequest(0x1)
const CANCEL_REQUEST_ABANDON_EXTERNAL = CancellationRequest(0x3)
const CANCEL_REQUEST_ABANDON_ALL = CancellationRequest(0x4)

struct CancelTokenKey <: AbstractScopedValue{Union{Nothing, CancellationToken}} end

const CANCEL_TOKEN = CancelTokenKey()
=#

end # module test_base_cancellation
