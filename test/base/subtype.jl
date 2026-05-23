module test_base_subtype

using Test

# from julia/test/subtype.jl

const issub = (<:)

@test issub(Tuple{Tuple{String}, Int},
            Tuple{Tup,           I}
                where Tup <: Tuple{S}
                where {S <: AbstractString, I <: Integer}
)

end # module test_base_subtype
