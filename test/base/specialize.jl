module test_base_specialize

using Test

# see also namedtuple.jl

function ntmap1(f,    a::Vector, b::Vector)
    map(f, vcat(a, b))
end

function ntmap2(f::F, a::Vector, b::Vector) where {F}
    map(f, vcat(a, b))
end

function bench21(f, a, b, N)
    s = 0
    for _ in 1:N; s += length(f(sum, a, b)); end; s
end

a = rand(1000)
b = map(copy, a)

fs = (ntmap2, ntmap1)
elapsed = Dict()
for f in fs
    bench21(f, a, b, 1)
    t = @timed bench21(f, a, b, 10_000)
    elapsed[f] = t
end

if VERSION >= v"1.12"
    @test elapsed[ntmap2].bytes < elapsed[ntmap1].bytes
else
    @test elapsed[ntmap2].bytes == elapsed[ntmap1].bytes
end

end # module test_base_specialize
