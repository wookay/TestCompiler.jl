module test_stdlibs_LinearAlgebra_symmetric

using Test
using LinearAlgebra

A = [1 2;
     3 4]
@test A' ==
      adjoint(A) ==
      [1 3;
       2 4]
@test transpose(A) ==
      [1 3;
       2 4]
@test A + A' ==
      [2 5;
       5 8]
@test ishermitian(A + A')
@test issymmetric(A + A')

@test Symmetric(A) ==
      Hermitian(A) ==
      LinearAlgebra.hermitian(A) ==
      [1 2;
       2 4]
@test Symmetric(A, :L) ==
      Hermitian(A, :L) ==
      LinearAlgebra.hermitian(A, :L) ==
      [1 3;
       3 4]
@test hermitianpart(A) ==
      [1.0 2.5;
       2.5 4.0]

@test LinearAlgebra.uplo(Symmetric(A)) ===
      LinearAlgebra.uplo(Hermitian(A)) ===
      :U
@test LinearAlgebra.uplo(Symmetric(A, :L)) ===
      LinearAlgebra.uplo(Hermitian(A, :L)) ===
      :L

@test LinearAlgebra.HermOrSym ===
      Union{Hermitian{T, S}, Symmetric{T, S}} where {T, S}
@test diag(A) == [1, 4]

@test triu(A) ==
      UpperTriangular(A) ==
      LinearAlgebra.uppertriangular(A) ==
      [1 2;
       0 4]
@test tril(A) ==
      LowerTriangular(A) ==
      LinearAlgebra.lowertriangular(A) ==
      [1 0;
       3 4]

@test real(A) == A
@test imag(A) ==
      [0 0;
       0 0]
@test conj(A) == A
@test det(A) == -2.0
@test logdet(Hermitian(A)) == -Inf
@test inv(A) ≈
      [-2.0   1.0;
        1.5  -0.5]
@test isapprox(exp(A),
      [ 51.968956  74.736564;
       112.104846 164.073803],
      atol=1e-5)
@test isapprox(norm(A), 5.47722, atol=1e-5)

F = svd(A)
u, s, v = F
@test u == F.U && s == F.S && v == F.V

end # module test_stdlibs_LinearAlgebra_symmetric
