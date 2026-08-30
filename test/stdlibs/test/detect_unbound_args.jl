using Jive
@If VERSION >= v"1.14.0-DEV.3072" module test_stdlibs_Test_detect_unbound_args
# julia commit 801aaa0648

# from julia/test/ambiguous.jl
#      julia/stdlib/Test/src/Test.jl

using Test # detect_unbound_args

module UnboundDetect
    unbound1(x::Type{<:T}) where {T} = T                       # f(Union{})
    unbound2(x::Vector{<:T}) where {T} = T                     # f(Vector{Union{}}())
    unbound3(x::T) where {T>:Int} = T                          # f(2.0)
end

@test_throws UndefVarError UnboundDetect.unbound1(Union{})
@test_throws UndefVarError UnboundDetect.unbound2(Vector{Union{}}())
@test_throws UndefVarError UnboundDetect.unbound3(2.0)

ambiguous_bottom = false
meths::Vector{Method} = detect_unbound_args(UnboundDetect; ambiguous_bottom)
@test !isempty(meths)
using .Test: unbound_sparams
m = meths[1]
@test m.name === :unbound3
inhabited_params = !ambiguous_bottom
@test unbound_sparams(m.sig, inhabited_params) == [1]

end # module test_stdlibs_Test_detect_unbound_args
