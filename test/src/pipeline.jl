# from julia/src/pipeline.cpp
#      julia/doc/src/devdocs/jit.md

#=
#include <llvm/Transforms/Scalar/SROA.h>
=#

#= google AI Overview
SROA (Scalar Replacement of Aggregates) type refinement refers to the mechanism
 by which a compiler (specifically LLVM) evaluates
 how an aggregated memory slot (like a struct or array) is actually accessed in code,
 and subsequently overrides or "refines" its structural type into simpler scalar types.
 This process strips away the high-level programmer-defined types
 and replaces them with types optimized for machine registers.
=#
