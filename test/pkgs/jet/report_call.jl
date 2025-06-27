module test_jet_report_call

using Jive
using JET: @report_call, ReportConfig

@time_expr @report_call 1+2
println()

function detect_not_defined_code()
    blah_blah
end

report_config = ReportConfig(#=target_modules=#(@__MODULE__,), #=ignored_modules=#())
@time_expr report = @report_call report_config=report_config detect_not_defined_code()
show(report)

end # module test_jet_report_call
