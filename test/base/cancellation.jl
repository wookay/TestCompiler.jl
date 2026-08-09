using Jive
@If VERSION >= v"1.14.0-DEV.2892" module test_base_cancellation
# v"1.14.0-DEV.2892"  julia commit cbbb1702f7
# v"1.14.0-DEV.2875"  julia commit 35b7e12113
# v"1.14.0-DEV.2734"  julia commit 7afe4ed42e

# from julia/base/cancellation.jl
#      julia/test/cancellation.jl

# see also https://github.com/wookay/TestCancellation.jl

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
@test Base.CANCEL_TOKEN[] isa Base.CancellationToken

@test Base.default_cancel_token() isa Base.CancellationToken
@test Base.default_cancel_source() isa Base.CancellationTokenSource

Base.cancel!
Base.@cancel_check

Core.WaitEntryN
Base.WaitEntry

@test Base.DEFAULT_CANCEL isa Base.UseDefaultToken


# from julia/test/cancellation.jl
# @testset "structured cancellation of @sync" begin
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
@test t.result isa CompositeException
@test first(t.result.exceptions) isa TaskFailedException



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
