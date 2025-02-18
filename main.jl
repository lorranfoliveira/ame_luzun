include("src/solver.jl")

area = 0.0014
young = 100e6

nodes = [
    Node(1, [1.0, -1.0], supports=[true, true]),
    Node(2, [3.0, -1.0]),
    Node(3, [5.0, -1.0]),
    Node(4, [7.0, -1.0], supports = [true, true]),
    Node(5, [3.0, 1.0], forces = [10.0, -5.0]),
    Node(6, [5.0, 1.0]),
]

elements = [
    Element(1, [nodes[1], nodes[2]], young, area),
    Element(2, [nodes[1], nodes[5]], young, area),
    Element(3, [nodes[2], nodes[3]], young, area),
    Element(4, [nodes[2], nodes[6]], young, area),
    Element(5, [nodes[4], nodes[3]], young, area),
    Element(6, [nodes[5], nodes[2]], young, area),
    Element(7, [nodes[5], nodes[6]], young, area),
    Element(8, [nodes[6], nodes[3]], young, area),
    Element(9, [nodes[6], nodes[4]], young, area),
]

structure = Structure(1, nodes, elements)
solver = Solver(structure, false)
println(calculate_displacements(solver))

