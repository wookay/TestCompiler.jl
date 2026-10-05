module test_pkgs_resolver_picosat

# from Resolver.jl/src/PicoSAT.jl

using Resolver: PicoSAT

PicoSAT.UNKNOWN
PicoSAT.SATISFIABLE
PicoSAT.UNSATISFIABLE

PicoSAT.var_count
PicoSAT.clause_count

end # module test_pkgs_resolver_picosat
