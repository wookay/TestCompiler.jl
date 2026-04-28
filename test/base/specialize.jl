module test_base_specialize

using Test

# see also namedtuple.jl

function ntmap1(f,    a::Vector, b::Vector)
    map(f, vcat(a, b))
end

function ntmap2(f::F, a::Vector, b::Vector) where {F}
    map(f, vcat(a, b))
end

function bench(f, a, b, N)
    s = 0
    for _ in 1:N; s += length(f(sum, a, b)); end; s
end

a = collect(1:1000)
b = map(copy, a)

fs = (ntmap2, ntmap1)
table = Dict()
for f in fs
    bench(f, a, b, 1)
    t = @timed bench(f, a, b, 10_000)
    table[f] = t
end

@test !(table[ntmap2].time  <  table[ntmap1].time)

end # module test_base_specialize
