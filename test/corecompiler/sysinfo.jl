module test_corecompiler_sysinfo

using Test

if VERSION >= v"1.13.0-DEV.877" # julia commit 3b2918785597f9b7b05f7b3e479ea89716ca22bd
@info Sys.sysimage_target()
# @test !haskey(ENV, "JULIA_CPU_TARGET") && Sys.sysimage_target() == "sysimage"
end

end # module test_corecompiler_sysinfo
