module test_base_sysinfo

using Test

if VERSION >= v"1.13.0-DEV.877" # julia commit 3b2918785597f9b7b05f7b3e479ea89716ca22bd
    # Sys.sysimage_target() == "sysimage"
    if haskey(ENV, "CI")
        @test Sys.sysimage_target() == "native" # github actions
    end
    if haskey(ENV, "JULIA_CPU_TARGET")
        @test ENV["JULIA_CPU_TARGET"] == Sys.sysimage_target()
    end
end

end # module test_base_sysinfo
