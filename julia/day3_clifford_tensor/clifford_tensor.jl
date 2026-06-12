# Day 3 — Clifford Circuits, Tensor Networks & GPU Acceleration
# qnumerics 2026, Instructors: Stefan Krastanov, Katharine Hyatt
#
# Topics: QuantumClifford.jl (stabilizer sim), ITensors.jl (MPS/DMRG)
# Run: julia --project=.. clifford_tensor.jl

using QuantumClifford
using ITensors

println("=== Day 3: Clifford Circuits & Tensor Networks ===\n")

# ── 1. Stabilizer simulation with QuantumClifford.jl ───────────────────────
# Clifford circuits act on stabilizer states in O(n²) rather than O(2^n).

n = 10   # qubits
println("Clifford simulation ($n qubits):")

# Start from |0...0⟩ as a stabilizer state
state = zero_state(n)

# Build GHZ state: H on qubit 1, then CNOT chain
apply!(state, sHadamard(1))
for i in 1:n-1
    apply!(state, sCNOT(i, i+1))
end

println("  GHZ state prepared via Clifford ops")
println("  Measuring qubit 1: ", measure!(state, sMZ(1)))
println("  Measuring qubit 2 (should match q1): ", measure!(state, sMZ(2)))
println()

# Random Clifford circuit on 20 qubits — scales to thousands
n_large = 20
big_state = random_stabilizer(n_large)
for _ in 1:50
    i, j = rand(1:n_large, 2)
    i == j && continue
    apply!(big_state, sCNOT(i, j))
end
println("Random Clifford on $n_large qubits: ✓")
println()

# ── 2. Tensor networks with ITensors.jl ────────────────────────────────────
# MPS (matrix product state) and DMRG for 1D quantum systems.

println("Tensor Networks — 1D Heisenberg chain:")
N = 20   # sites

sites = siteinds("S=1/2", N)

# Build Heisenberg Hamiltonian H = J Σᵢ Sᵢ · Sᵢ₊₁
ampo = OpSum()
for j in 1:N-1
    ampo += "Sz", j, "Sz", j+1
    ampo += 0.5, "S+", j, "S-", j+1
    ampo += 0.5, "S-", j, "S+", j+1
end
H = MPO(ampo, sites)

# Initial state: Néel state |↑↓↑↓...⟩
psi0 = MPS(sites, n -> isodd(n) ? "Up" : "Dn")

# DMRG
sweeps = Sweeps(5)
setmaxdim!(sweeps, 10, 20, 40, 80, 100)
setcutoff!(sweeps, 1e-10)

energy, psi = dmrg(H, psi0, sweeps; outputlevel=0)

println("  N=$N Heisenberg ground state energy: $(round(energy, digits=6))")
println("  (exact: ≈ $(round(-N * log(2) + 0.25, digits=4)) per standard result)")
println()

println("Day 3 complete.")
