module test_base_scopedvalues

using Test
using Base.ScopedValues

const sval = ScopedValue(1)

@test sval[] == 1

@test with(sval => 2) do
          sval[]
      end == 2

@test sval[] == 1

end # module test_base_scopedvalues
