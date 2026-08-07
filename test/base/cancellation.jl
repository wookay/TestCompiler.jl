using Jive
@If VERSION >= v"1.14.0-DEV.2875" module test_base_cancellation
# v"1.14.0-DEV.2875"  julia commit 35b7e12113
# v"1.14.0-DEV.2734"  julia commit 7afe4ed42e

# from julia/base/cancellation.jl
#      julia/test/cancellation.jl

using Test

Core.CancellationTokenSource

@test Base.CancellationRequest <: Exception
Base.CANCEL_REQUEST_SAFE
Base.CANCEL_REQUEST_ABANDON_EXTERNAL
Base.CANCEL_REQUEST_ABANDON_ALL

@test Base.severity(Base.CANCEL_REQUEST_ABANDON_ALL) == Base.CANCEL_REQUEST_ABANDON_ALL.request

src = Core._new_cancel_source() # Base.CancellationTokenSource()
@test src.child_head === nothing
@test src.nparents == 0x0000
st = @atomic :acquire src.state
@test st == 0x00

tok = Base.CancellationToken(src)
@test tok.source == src

@test Base.cancel_severity(src) === nothing
@test Base.cancel_severity(tok) === nothing

@test Base.iscancelled(src) === false
@test Base.iscancelled(tok) === false

Base.CANCEL_TOKEN
@test Base.CancelTokenKey <: Base.ScopedValues.AbstractScopedValue
@test Base.CANCEL_TOKEN isa Base.CancelTokenKey
@test Base.CANCEL_TOKEN[] === nothing

@test Base.default_cancel_token() === nothing
@test Base.default_cancel_source() === nothing

Base.cancel!
Base.@cancel_check

Core.WaitEntryN
Base.WaitEntry


function cancellable(f)
    src = Base.CancellationTokenSource()
    g() = @async f()
    t = Base.ScopedValues.with(g, Base.CANCEL_TOKEN => Base.CancellationToken(src))
    return t, src
end

t, src = cancellable() do
    @sync begin
        @async sleep(1000)
    end
end

@test t isa Task
@test Base.cancel!(src)
@test_throws TaskFailedException wait(t)
@test t.result isa Base.CancellationRequest


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

const WaitEntryN = Core.WaitEntryN
const WaitEntry = Union{WaitEntry1, WaitEntry2, WaitEntryN}

=#

end # module test_base_cancellation
