# Day 4 — Optimal Control of Quantum Systems
# qnumerics 2026, Instructor: Andy Goldschmidt
#
# Topics: Piccolo.jl for quantum optimal control (GRAPE-style)
# Run: julia --project=.. optimal_control.jl

using Piccolo

println("=== Day 4: Optimal Control (Piccolo.jl) ===\n")

# ── Goal: find a control pulse that implements an X gate on a qubit ─────────
#
# System: H(t) = (Ω(t)/2) σx — driven qubit
# Objective: U(T) ≈ X = σx
# Method: PICO (Piccolo's direct collocation approach)

# Pauli matrices
X_gate = [0 1; 1 0] .+ 0im
Z_op   = [1 0; 0 -1] .+ 0im

# Define the quantum system
H_drift = zeros(ComplexF64, 2, 2)               # no drift Hamiltonian
H_controls = [0.5 * [0 1; 1 0] .+ 0im]         # σx/2 control

system = QuantumSystem(H_drift, H_controls)

# Trajectory parameters
T  = 50       # number of time steps
dt = 0.05     # time step

# PICO problem: reach X gate
prob = UnitarySmoothPulseProblem(
    system,
    X_gate,
    T,
    dt;
    ipopt_options = IpoptOptions(print_level=0, max_iter=500),
)

println("Solving X gate pulse (T=$T steps, dt=$dt)...")
solve!(prob)

# Fidelity
fid = unitary_fidelity(prob)
println("Gate fidelity: $(round(fid, digits=6))")
println("(target: > 0.999)")
println()

# ── Inspect the pulse ───────────────────────────────────────────────────────
controls = get_controls(prob)
println("Control pulse summary:")
println("  Steps: $(length(controls[1]))")
println("  Max amplitude: $(round(maximum(abs.(controls[1])), digits=4))")
println("  Total time: $(T * dt)")
println()

println("Day 4 complete.")
