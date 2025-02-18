struct Solver
    iterative::Bool
    structure::Structure
end

function calculate_displacements()
    f = free_forces(solver.structure)
    k = k(solver.structure)

    if solver.iterative
        return cg(k, f)
    else
        return k \ f
    end
end
