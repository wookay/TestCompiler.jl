module test_base_set

using Test

@test Set{Bool}()  == Set{Bool}()
@test Set{Bool}() !== Set{Bool}()
@test_throws InexactError Set{Bool}(1:2)

if VERSION >= v"1.15-DEV"
@test_throws InexactError Set{Bool}(0:2)
else
@test                     Set{Bool}(0:2) == Set([true, false])
end

end # module test_base_set
