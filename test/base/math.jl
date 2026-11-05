module test_base_math

using Test

@test isinf(/(Inf, 0))
@test isnan(/(Inf, Inf))
@test /(0, Inf) == 0.0

@test √(2 ^ 2) == 2 ^ 1 ==  2
@test √(2 ^ 4) == 2 ^ 2 ==  4
@test √(2 ^ 6) == 2 ^ 3 ==  8
@test √(2 ^ 8) == 2 ^ 4 == 16

@test √(3 ^ 2) == 3 ^ 1 ==  3
@test √(3 ^ 4) == 3 ^ 2 ==  9
@test √(3 ^ 6) == 3 ^ 3 == 27
@test √(3 ^ 8) == 3 ^ 4 == 81

# from julia/base/special/pi_remainders.jl
Base.Math.paynehanek # Payne-Hanek

const prec = precision(BigFloat) # 256
setprecision(BigFloat, 4096)
let I = 0.5/big(pi)
    inv2pi = ntuple(19) do i
        I *= 0x1p64
        k = trunc(UInt64, I)
        I -= k
        k
    end
    if VERSION >= v"1.15.0-DEV.482" # julia commit 06c1d18d3c
        @test Base.Math.INV_2PI == (UInt64(0), inv2pi...)
    else
        @test Base.Math.INV_2PI == inv2pi
    end
end # let
setprecision(BigFloat, prec)

if VERSION >= v"1.15.0-DEV.482" # julia commit 06c1d18d3c
@test collect(Base.Math.SINPI16_TABLE) ≈
      collect((0x0p+0, ntuple(j -> sin(π*j/16), 31)...))
end

end # module test_base_math
