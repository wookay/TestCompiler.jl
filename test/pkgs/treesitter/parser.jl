using Jive
@useinside module test_treesitter_parser

using Test
using TreeSitter

p = Parser(:julia)
tree = parse(p, "1 + 2")
@test tree isa Tree

out = String[]
traverse(tree) do node, enter
    enter && push!(out, TreeSitter.node_type(node))
end

@test out == ["source_file", "binary_expression", "number", "+", "number"]

end # module test_treesitter_parser
