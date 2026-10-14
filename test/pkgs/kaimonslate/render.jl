module test_pkgs_KaimonSlate_render

using Test
using KaimonSlate: ReportRender

io = IOBuffer()
ioc = IOContext(io, :color => true)
printstyled(ioc, :ok; color = :green)
text = String(take!(io))
@test ReportRender._ansi_html(text) == """<span class="ansi-fg-2">ok</span>"""

end # module test_pkgs_KaimonSlate_render
