module test_base_build

using Test

# from julia/contrib/generate_precompile.jl
sysimg = Base.unsafe_string(Base.JLOptions().image_file)
if Sys.isapple()
@test endswith(sysimg, #= usr =# "/lib/julia/sys.dylib")
else
@test endswith(sysimg, #= /opt/hostedtoolcache/julia/1.11.8/x64 =# "/lib/julia/sys.so")
end

if VERSION >= v"1.12"
@test Base.__precompile_script.debug_output === devnull
end

end # module test_base_build
