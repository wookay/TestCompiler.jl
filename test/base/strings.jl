module test_base_strings

using Test

if VERSION >= v"1.14.0-DEV.2418" # julia commit feca5b8b97
Base.raw_substring
Base.unannotate

s = "가"
io = IOBuffer()
@test_throws BoundsError show(io, Base.raw_substring(s, 1, 2))
@test                             Base.raw_substring(s, 1, 3)[1] == '가'
@test_throws StringIndexError     Base.raw_substring(s, 1, 3)[2]
@test_throws BoundsError          Base.raw_substring(s, 1, 4)

annostr = Base.AnnotatedString(SubString(s))
@test Base.unannotate(annostr) == s
end # if

end # module test_base_strings
