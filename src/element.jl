include("node.jl")

struct Element
    id::Int64
    nodes::Vector{Node}
    young::Float64
    area::Float64
end

function len(el::Element)::Float64
    return distance(el.nodes[1], el.nodes[2])
end

num_dofs(el::Element) = sum(num_dofs.(el.nodes))

supports(el::Element) = vcat([node.supports for node in el.nodes]...)

free_local_dofs(el::Element)::Vector{Int64} = Vector(1:num_dofs(el))[.!(supports(el))] 

free_dofs(el::Element) = dofs(el)[.!(supports(el))]

volume(el::Element) = el.area * len(el)

dofs(el::Element) = vcat(dofs(el.nodes[1]), dofs(el.nodes[2]))

sin(el::Element) = (el.nodes[2].position[2] - el.nodes[1].position[2]) / len(el)

cos(el::Element) = (el.nodes[2].position[1] - el.nodes[1].position[1]) / len(el)

function rotation_matrix(el::Element)::Matrix{Float64}
    s = sin(el)
    c = cos(el)
    return [
        c s 0 0
        -s c 0 0
        0 0 c s
        0 0 -s c
    ]
end

function local_stiffness(el::Element)::Matrix{Float64}
    r = el.young * el.area / len(el)
    return r * [
        1 0 -1 0
        0 0 0 0
        -1 0 1 0
        0 0 0 0
    ]
end

function global_stiffness(el::Element)::Matrix{Float64}
    r = rotation_matrix(el)
    return r' * local_stiffness(el) * r
end

