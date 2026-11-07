module test_base_show

using Test

# from julia/base/show.jl

Base.show_function
Base.show_typeparams
Base.show_typealias
Base.show_wheres
Base.show_unionaliases
Base.show_type_name
Base.show_datatype
Base.show_at_namedtuple
Base.show_supertypes
Base.show_pairtyped
Base.show_mi
Base.show_delim_array
Base.show_linenumber
Base.show_block
Base.show_list
Base.show_enclosed_list
Base.show_call
Base.show_sym
Base.show_globalref

Base.show_unquoted
@test sprint(Base.show_unquoted, Meta.parse("+(1, 2)")) == "1 + 2"

Base.show_unquoted_quote_expr
Base.show_unquoted_expr_fallback
Base.show_generator
Base.show_import_path
Base.show_signature_function
Base.show_tuple_as_call

if VERSION >= v"1.15-DEV"
Base.show_typealias_name
Base.show_typeegal
Base.show_typeeq
Base.show_callee
Base.show_quoted_sym
elseif VERSION >= v"1.12.0-DEV.1571" # julia commit cd7250da83
Base.show_unquoted_phinode
Base.show_unquoted_gotoifnot
end

Base.show_default
@test sprint(Base.show_default, ()) == "Tuple{}()"
@test sprint(Base.show_default, 0) == "Int64(0x0000000000000000)"
@test sprint(Base.show_default, pi) == "Irrational{:π}()"

Base.emphasize

Base.summary

Base.ioproperties
@test Base.ioproperties(stdout) ==
      Base.ioproperties(IOContext(stdout)) ==
      Base.ImmutableDict(:color => true)

end # module test_base_show
