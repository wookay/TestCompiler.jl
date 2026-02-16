module test_base_macro_var

using Test

var"#self#" = 42

@test (@__MODULE__).var"#self#" == var"#self#" == 42

end # module test_base_macro_var
