module test_corecompiler_constprop

using Test
using Core: Compiler as CC

# from julia/Compiler/test/inference.jl
f_constprop_simple(f, x) = f(x)
@test !CC.is_aggressive_constprop(only(methods(f_constprop_simple)))

Base.@constprop :aggressive f_constprop_aggressive(f, x) = f(x)
method = only(methods(f_constprop_aggressive))
@test CC.is_aggressive_constprop(method)
@test method.constprop == 0x01

Base.@constprop :none f_constprop_none(f, x) = f(x)
method = only(methods(f_constprop_none))
@test CC.is_no_constprop(method)
@test method.constprop == 0x02


#=
help?> Base.@constprop
  Base.@constprop setting [ex]

  Control the mode of interprocedural constant propagation for the annotated function.

  Two settings are supported:

    •  Base.@constprop :aggressive [ex]: apply constant propagation aggressively. For a method where the return type depends on the value of the
       arguments, this can yield improved inference results at the cost of additional compile time.

    •  Base.@constprop :none [ex]: disable constant propagation. This can reduce compile times for functions that Julia might otherwise deem worthy of
       constant-propagation. Common cases are for functions with Bool- or Symbol-valued arguments or keyword arguments.

  Base.@constprop can be applied immediately before a function definition or within a function body.

  # annotate long-form definition
  Base.@constprop :aggressive function longdef(x)
      ...
  end

  # annotate short-form definition
  Base.@constprop :aggressive shortdef(x) = ...

  # annotate anonymous function that a `do` block creates
  f() do
      Base.@constprop :aggressive
      ...
  end
=#

end # module test_corecompiler_constprop
