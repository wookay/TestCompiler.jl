module test_stdlibs_Markdown_space

using Test
using Markdown

using Base.Unicode: UTF8PROC_CATEGORY_ZS,
                    UTF8PROC_CATEGORY_ZP,
                    category_code

Base.isspace
# from julia/base/strings/unicode.jl
@inline isspace(c::AbstractChar) =
    c == ' ' || '\t' <= c <= '\r' || c == '\u85' ||
    '\ua0' <= c && UTF8PROC_CATEGORY_ZS <= category_code(c) <= UTF8PROC_CATEGORY_ZP

@test '\t':'\r' == ['\t', '\n', '\v', '\f', '\r']
@test UTF8PROC_CATEGORY_ZS:UTF8PROC_CATEGORY_ZP == 23:25
@test Base.isspace(' ') ==
      Base.isspace('\n') ==
      Base.isspace('\u85')

Markdown.whitespace
# from julia/stdlib/Markdown/src/parse/util.jl
const whitespace = " \t\r"

@test in(Markdown.whitespace)(' ')

end # module test_stdlibs_Markdown_space
