include("src/element.jl")

node_1 =  Node(1, [1.0, -1.0], [0.0, 0.0], [true, true])
node_2 =  Node(5, [3.0, 1.0], [10.0, -5.0])

element = Element(1, [node_1, node_2], 0.0014, 100e6)

println("length: $(len(element))")
println("volume: $(volume(element))")
println("dofs: $(dofs(element))")
println("stiffness: $(global_stiffness(element))")
