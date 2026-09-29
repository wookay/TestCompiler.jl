module test_corecompiler_poset

# see also lattice.jl
#          typelattice.jl

using Test
using Core: Compiler as CC

# poset: partially ordered set
CC.SimpleInferenceLattice

# lattice 𝕃
#  - least upper bound (join)
#  - greatest lower bound (meet)
CC.tmerge
CC.tmeet

end # module test_corecompiler_poset
