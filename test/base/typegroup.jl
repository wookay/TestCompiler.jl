module test_base_typegroup

using Test

if VERSION >= v"1.14.0-DEV.1858" # julia commit 741f560dc4
ta = Core.TypeApp(Vector, Int)
@test ta.head === Vector
@test ta.param === Int
end

end # module test_base_typegroup
