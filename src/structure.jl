using SparseArrays

struct 
    id::Int64
    nodes::Vector{Node}
    elements::Vector{Element}
end


function free_dofs(structure::Structure)::Vector{Int64}
    return vcat([free_dofs(node) for node in structure.nodes]...)
end

function forces(structure::Structure)::Vector{Float64}
    return vcat([node.forces for node in structure.nodes]...)
end

function free_forces(structure::Structure)::Vector{Float64}
    return forces(structure)[free_dofs(structure)]
end

function k(structure::Structure)
    # Triplet
    
end

v1 = [1, 2, 3, 1]
v2 = [1, 2, 3, 1]
t = [59.6494, 5.4, 12.4, 58.9]

# Sparse matrix
A = sparse(v1, v2, t)
