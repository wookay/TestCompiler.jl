using Jive
@useinside module test_treesitter_parser

using Test
using TreeSitter
using tree_sitter_julia_jll

p = Parser(Language(tree_sitter_julia_jll))
tree = parse(p, "1 + 2")
@test tree isa Tree

out = String[]
traverse(tree) do node, enter
    enter && push!(out, TreeSitter.node_type(node))
end

@test out == ["source_file", "binary_expression", "integer_literal", "operator", "integer_literal"]

end # module test_treesitter_parser
