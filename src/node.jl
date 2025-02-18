using LinearAlgebra

struct Node
    id::Int64
    position::Vector{Float64}
    forces::Vector{Float64}
    supports::Vector{Bool}
    displacements::Vector{Float64}

    function Node(
        id::Int64,
        position::Vector{Float64},
        forces::Vector{Float64}=[0.0, 0.0],
        supports::Vector{Bool}=[false, false]
    )
        new(id, position, forces, supports, [0.0, 0.0])
    end
end

function distance(no_1::Node, no_2::Node)::Float64
    return norm(no_1.position - no_2.position)
end

function dofs(node::Node)::Vector{Int64}
    return [2 * node.id - 1, 2 * node.id]
end

function free_dofs(node::Node)::Vector{Int64}
    return dofs(node)[node.supports .== false]
end
