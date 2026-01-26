module test_pkgs_reactant_compile

using Test
using Reactant

input1 = Reactant.to_rarray(ones(1))
input2 = Reactant.to_rarray(ones(1))

function sinsum_add(x, y)
   return sum(sin.(x) .+ y)
end

f = @compile sinsum_add(input1,input2)
@test f(input1, input2) == ConcretePJRTNumber{Float64, 1}(1.8414709848078965)

end # module test_pkgs_reactant_compile
