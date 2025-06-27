module test_jet_test_package

using Jive
using JET: JET, ReportConfig

using Test
report_config = ReportConfig(#=target_modules=#(Test,), #=ignored_modules=#(Base,))
@time_expr report = JET.test_package(Test, report_config = report_config)
show(report)

end # module test_jet_test_package
