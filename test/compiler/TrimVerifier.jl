using Jive
@If VERSION >= v"1.14.0-DEV.1589" module test_compiler_TrimVerifier

# code from julia/Compiler/src/verifytrim.jl

using Compiler: Compiler as C
using .C: TrimVerifier

# Print a value with optional stable coloring (light_black if stable)
# function print_value(io::IO, @nospecialize(x), stable::Bool)
TrimVerifier.print_value

end # module test_compiler_TrimVerifier
