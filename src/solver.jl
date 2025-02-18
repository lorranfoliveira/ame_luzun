include("structure.jl")


using IterativeSolvers

struct Solver
    structure::Structure
    iterative::Bool
end

function calculate_displacements(solver::Solver)
    f = free_forces(solver.structure)
    k = global_stiffness(solver.structure)

    u = zeros(length(f))
    if solver.iterative
        u = cg(k, f)
    else
        u = k \ f
    end

    return u
end
