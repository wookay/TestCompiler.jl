module test_base_intfuncs

using Test

# from julia/base/int.jl
#      julia/base/intfuncs.jl

(a, b) = (6, 8)
(d, u, v) = gcdx(a, b) # Bézout coefficients u v
@test (d, u, v) == (2, -1, 1)
@test gcd(a, b) == gcd(6, 8) ==
      gcd(b, a) == gcd(8, 6) ==
      u*a + v*b == -1*6 + 1*8 ==
      d         == 2
@test lcm(a, b) == lcm(6, 8) ==
      lcm(b, a) == lcm(8, 6) ==
      24

@test gcdx(6, 9) == (3, -1, 1)
@test gcd(6, 9) ==  3
@test lcm(6, 9) == 18

@test 2^3 == 8
@test 2^-2 == 0.25
@test ispow2(8)
@test ispow2(0.25)

@test powermod(2, 3, 5) == mod(2^3, 5) == 2^3 % 5 == 3

@test isodd(5)
@test isodd(-5)

@test digits(123) == [3, 2, 1]
@test digits(321) == [1, 2, 3]

end # module test_base_intfuncs
