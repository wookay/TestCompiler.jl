module test_stdlibs_Test_detect_unbound_args

# from julia/test/ambiguous.jl
#      julia/stdlib/Test/src/Test.jl

using Test # detect_unbound_args

module UnboundDetect
    f(::Type{<:T}) where T = T
end

meths::Vector{Method} = detect_unbound_args(UnboundDetect)
if VERSION >= v"1.14.0-DEV.2923" # julia commit be2a0c825c
@test !isempty(meths)
using Test: unbound_sparams
m = meths[1]
@test unbound_sparams(m.sig) == [1]
else
@test isempty(meths)
end

end # module test_stdlibs_Test_detect_unbound_args
