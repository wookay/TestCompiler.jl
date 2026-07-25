using Jive
@If VERSION >= v"1.14.0-DEV.2734" module test_base_cancellation
# julia commit 7afe4ed42e

using Test

Core.CancellationTokenSource
Base.CancellationToken
Base.iscancelled
Base.cancel!
Base.@cancel_check
Base.CancellationRequest

end # module test_base_cancellation
