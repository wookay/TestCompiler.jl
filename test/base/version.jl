module test_base_version_with_build_variant_tags

using Test

if VERSION >= v"1.15.0-DEV.84" # julia commit 7bf98f3bd1

ver = Base.version_with_build_variant()

if !isempty(Base.BUILD_VARIANT)
@test Base.BUILD_VARIANT in ver.build
end

if Base.isdebugbuild()
@test "debug" in ver.build
end

if ccall(:jl_is_assertsbuild, Int8, ()) != 0
@test "assert" in ver.build
end

end # if VERSION

end # module test_base_version_with_build_variant_tags
