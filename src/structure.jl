include("element.jl")

using SparseArrays

struct Structure
    id::Int64
    nodes::Vector{Node}
    elements::Vector{Element}
    tikhonov::Float64

    function Structure(id::Int64, nodes::Vector{Node}, elements::Vector{Element})
        new(id, nodes, elements, 1e-10)
    end
end

num_elements(structure::Structure)::Int64 = length(structure.elements)

num_dofs(structure::Structure)::Int64 = sum(num_dofs.(structure.nodes))

free_local_dofs(structure::Structure)::Vector{Int64} = vcat([free_dofs(node) for node in structure.nodes]...)

function free_dofs(structure::Structure)::Vector{Int64}
    return vcat([free_dofs(node) for node in structure.nodes]...)
end

function forces(structure::Structure)::Vector{Float64}
    return vcat([node.forces for node in structure.nodes]...)
end

function free_forces(structure::Structure)::Vector{Float64}
    return forces(structure)[free_dofs(structure)]
end

function get_auxiliar_free_dofs(structure::Structure)
	fdofs = free_dofs(structure)
	aux = zeros(Int64, num_dofs(structure))
	for (i, fdof) in enumerate(fdofs)
		aux[fdof] = i
	end
	return aux
end

function global_stiffness(structure::Structure)
    max_terms = num_elements(structure) * (num_dofs(structure.elements[1])^2)
	aux_free_dofs = get_auxiliar_free_dofs(structure)
	v_i = ones(Int64, max_terms)
	v_j = ones(Int64, max_terms)
	data = zeros(Float64, max_terms)
	c = 1
	num_diag = 0
	sum_diag = 0.0
	for el in structure.elements
		el_free_local_dofs = free_local_dofs(el)
		el_free_global_dofs = free_dofs(el)
		kel = global_stiffness(el)

		for i=eachindex(el_free_local_dofs)
			for j=eachindex(el_free_local_dofs)
				aux_1 = aux_free_dofs[el_free_global_dofs[i]]
				aux_2 = aux_free_dofs[el_free_global_dofs[j]]
				aux_3 = el_free_local_dofs[i]
				aux_4 = el_free_local_dofs[j]
				v_i[c] = aux_1
				v_j[c] = aux_2
				data[c] = kel[aux_3, aux_4]
				c += 1
				if aux_1 == aux_2
					sum_diag += data[c]
					num_diag += 1
				end
			end
		end
	end

	if structure.tikhonov > 0.0
		tikhonov_factor = structure.tikhonov * sum_diag / num_diag
		for i in eachindex(v_i)
			if v_i[i] == v_j[i]
				data[i] += tikhonov_factor
			end
		end
	end

	return sparse(v_i, v_j, data)
    
end
