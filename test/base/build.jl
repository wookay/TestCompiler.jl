module test_base_build

using Test

# from julia/contrib/generate_precompile.jl
sysimg = Base.unsafe_string(Base.JLOptions().image_file)
@test endswith(sysimg, #= usr =# "/lib/julia/sys.dylib")

if VERSION >= v"1.12"
@test Base.__precompile_script.debug_output === devnull
end

end # module test_base_build
