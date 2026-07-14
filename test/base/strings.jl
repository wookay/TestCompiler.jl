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

# julia commit 5b6c2bacec
# @code_typed optimize=true string(5)
n  = 5
n1 = Core.Intrinsics.flipsign_int(n, n)::Int64
n2 = Core.Intrinsics.bitcast(UInt64, n1)::UInt64
n3 = Core.Intrinsics.slt_int(n, 0)::Bool
n4 = Base.dec(n2::Unsigned, 1::Int64, n3::Bool)::String
@test n1 == 5
@test n2 == 0x0000000000000005
@test n3 === false
@test n4 == "5"

end # module test_base_strings
