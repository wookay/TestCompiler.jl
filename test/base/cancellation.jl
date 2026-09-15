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
Base.CANCEL_REQUEST_SAFE             # 0x1
Base.CANCEL_REQUEST_ABANDON_EXTERNAL # 0x3
Base.CANCEL_REQUEST_ABANDON_ALL      # 0x4

Base.STATUS_PREEMPT_BIT # 0x40
Base.SEVERITY_MASK      # 0x3f

@test Base.severity(Base.CANCEL_REQUEST_ABANDON_ALL) == Base.CANCEL_REQUEST_ABANDON_ALL.request

src = Core._new_cancel_source() # Base.CancellationTokenSource()
                                # Base.CancellationTokenSource(nothing)
@test src.child_head === nothing
@test src.nparents == 0x0000
st = @atomic :acquire src.state
@test st == 0x00

tok = Base.CancellationToken(src)
@test tok.source == src

@test Base.cancel_source(tok) === src

@test Base.cancel_severity(src) === nothing
@test Base.cancel_severity(tok) === nothing

@test Base.iscancelled(src) === false
@test Base.iscancelled(tok) === false

Base.CANCEL_TOKEN
@test Base.CancelTokenKey <: Base.ScopedValues.AbstractScopedValue
@test Base.CANCEL_TOKEN isa Base.CancelTokenKey
@test Base.CANCEL_TOKEN[] isa Base.CancellationToken

d_tok = Base.default_cancel_token()
d_src = Base.default_cancel_source()

@test d_tok isa Base.CancellationToken
@test d_src isa Base.CancellationTokenSource

@test Base.cancel_severity(d_tok) === nothing
@test Base.cancel_source(d_tok) === d_src

# @inline function default_cancel_token()
ct = current_task()
@test getfield(ct, :bound_cancel_default) == Base.severity(Base.CANCEL_REQUEST_SAFE)
s = @atomic :monotonic ct.bound_cancel_token
@test s !== nothing
@test Base.cancel_severity(s) === nothing

# @noinline function _default_cancel_token_slow(ct::Task)
scope = Core.current_scope()
v = Core.OptimizedGenerics.KeyValue.get(scope.values, Base.CANCEL_TOKEN)
@test something(v) === d_tok

Base.cancel!
Base.redeliver!
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
