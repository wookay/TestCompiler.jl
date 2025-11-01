using Jive
@If VERSION >= v"1.14.0-DEV.16" module test_corecompiler_experimental_reexport

using Test

module M1
export f1
function f1 end
end

module M2
using Base.Experimental: @reexport
@reexport using ..M1
end

using .M2
@test f1 isa Function

end # module test_corecompiler_experimental_reexport
