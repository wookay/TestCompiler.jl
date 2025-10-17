module test_corecompiler_callable

using Test

# https://docs.julialang.org/en/v1/manual/methods/#Function-like-objects

struct Polynomial{R}
    coeffs::Vector{R}
end

function (p::Polynomial)(x)
    v = p.coeffs[end]
    for i = (length(p.coeffs)-1):-1:1
        v = v*x + p.coeffs[i]
    end
    return v
end

(p::Polynomial)() = p(5)

p = Polynomial([1,10,100])

@test p(3) == 931
@test p() == 2551

end # module test_corecompiler_callable
