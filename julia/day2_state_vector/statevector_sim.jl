# Day 2 — State-Vector Simulation & Quantum Dynamics
# qnumerics 2026, Instructors: Katharine Hyatt, Stefan Krastanov
#
# Topics: state-vector simulation, QuantumOptics.jl, master equations
# Run: julia --project=.. statevector_sim.jl

using QuantumOptics
using LinearAlgebra

println("=== Day 2: State-Vector Simulation ===\n")

# ── 1. Single qubit in QuantumOptics.jl ─────────────────────────────────────
b = SpinBasis(1//2)

# Pauli operators
sx = sigmax(b)
sy = sigmay(b)
sz = sigmaz(b)
sm = sigmam(b)   # lowering
sp = sigmap(b)   # raising

# |0⟩ and |1⟩
ket0 = spinup(b)
ket1 = spindown(b)
plus = normalize(ket0 + ket1)    # |+⟩

println("Single qubit:")
println("  ⟨0|Z|0⟩ = ", expect(sz, ket0))
println("  ⟨1|Z|1⟩ = ", expect(sz, ket1))
println("  ⟨+|X|+⟩ = ", expect(sx, plus))
println()

# ── 2. Two-qubit Bell state ──────────────────────────────────────────────────
b2 = b ⊗ b

# |00⟩ initial state
psi0 = ket0 ⊗ ket0

# Hadamard on qubit 1 ⊗ identity
H = (1/√2) * (sx + sz)
Had_1 = H ⊗ one(b)

# CNOT
CNOT = (ket0 ⊗ dagger(ket0)) ⊗ one(b) + (ket1 ⊗ dagger(ket1)) ⊗ sx

bell = normalize(CNOT * (Had_1 * psi0))
println("Bell state |Φ+⟩:")
println("  ⟨ZZ⟩ = ", expect(sz ⊗ sz, bell))   # should be 1
println("  ⟨XX⟩ = ", expect(sx ⊗ sx, bell))   # should be 1
println()

# ── 3. Rabi oscillations — Schrödinger equation ────────────────────────────
omega_0 = 1.0   # qubit frequency
omega_d = 1.0   # drive frequency (resonant)
Omega   = 0.1   # Rabi frequency

H_rabi = (omega_0 / 2) * sz + (Omega / 2) * sx

tspan = range(0, 20π / Omega; length=300)
_, states = timeevolution.schroedinger(tspan, ket0, H_rabi)

prob_excited = [abs2(ket1' * s)[1] for s in states]
println("Rabi oscillations: P(|1⟩) at t=π/Ω = ", round(prob_excited[end÷2], digits=4))
println("  (should be ≈ 1.0 at half-period)")
println()

# ── 4. Open system dynamics — Lindblad master equation ─────────────────────
# Qubit with T₁ decay (amplitude damping)

gamma = 0.05   # decay rate
J = [sqrt(gamma) * sm]   # jump operators

rho0 = dm(ket0)   # |0⟩⟨0|
_, rhos = timeevolution.master(tspan, rho0, H_rabi, J)

# Extract ⟨Z⟩ trajectory
z_traj = [real(expect(sz, rho)) for rho in rhos]
println("Open system (T1 decay, γ=$gamma):")
println("  ⟨Z⟩ at t=0:    ", round(z_traj[1], digits=4))
println("  ⟨Z⟩ at t=final:", round(z_traj[end], digits=4))
println("  (decays from 1 toward steady state)")
println()

println("Day 2 complete.")
