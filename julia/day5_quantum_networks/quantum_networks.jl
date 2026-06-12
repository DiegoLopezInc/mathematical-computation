# Day 5 — Discrete-Event Simulation & Quantum Networks
# qnumerics 2026, Instructor: Stefan Krastanov
#
# Topics: ConcurrentSim.jl for discrete-event simulation,
#         QuantumSavory.jl for quantum network simulation
# Run: julia --project=.. quantum_networks.jl

using ConcurrentSim
using QuantumSavory

println("=== Day 5: Discrete-Event Simulation & Quantum Networks ===\n")

# ── 1. ConcurrentSim.jl — basic DES ─────────────────────────────────────────
# Model a simple entanglement distribution attempt with probabilistic success.

println("--- ConcurrentSim: Entanglement Attempts ---")

function entanglement_node(env, node_id, success_prob, log)
    attempt = 0
    while true
        attempt += 1
        delay = rand(Exponential(1.0))   # random wait between attempts
        @yield timeout(env, delay)
        if rand() < success_prob
            push!(log, (now(env), node_id, attempt))
            break
        end
    end
end

sim = Simulation()
log = Tuple{Float64,Int,Int}[]

for id in 1:3
    @process entanglement_node(sim, id, 0.3, log)
end

run!(sim)
println("First successful entanglement per node:")
for (t, id, attempt) in log
    println("  Node $id: success at t=$(round(t,digits=2)) after $attempt attempt(s)")
end
println()

# ── 2. QuantumSavory.jl — two-node entanglement purification ────────────────
println("--- QuantumSavory: Entanglement Purification ---")

# Two registers with 2 qubits each
reg_A = Register(2)
reg_B = Register(2)

# Prepare two noisy Bell pairs (fidelity ~0.85)
noise = Depolarize(0.05)
initialize!(reg_A[1], reg_B[1])
initialize!(reg_A[2], reg_B[2])
apply!(noise, reg_A[1])
apply!(noise, reg_B[1])

# BBPSSW purification: use pair (2,2) to improve (1,1)
fidelity_before = fidelity(reg_A[1], reg_B[1], X_basis_bell_state)
purify!(reg_A, reg_B, BBPSSW())
fidelity_after = fidelity(reg_A[1], reg_B[1], X_basis_bell_state)

println("Fidelity before purification: $(round(fidelity_before, digits=4))")
println("Fidelity after  purification: $(round(fidelity_after,  digits=4))")
println()

# ── 3. Simple quantum repeater chain ────────────────────────────────────────
println("--- Quantum Repeater: 3-node chain ---")

# A ── repeater ── B
# Each link: probabilistic Bell pair generation, swap at repeater

function repeater_chain_sim(p_link=0.5, trials=1000)
    successes = 0
    latencies = Float64[]
    for _ in 1:trials
        # Two independent link generation attempts (geometric waiting time)
        t_left  = rand(Geometric(p_link)) + 1
        t_right = rand(Geometric(p_link)) + 1
        # Entanglement swap succeeds with probability 1 (ideal BSM)
        push!(latencies, max(t_left, t_right))
        successes += 1
    end
    return mean(latencies), std(latencies)
end

μ, σ = repeater_chain_sim()
direct_μ, _ = repeater_chain_sim(0.5^2)   # direct link probability = p²

println("Repeater chain (p_link=0.5):")
println("  Mean latency:  $(round(μ, digits=2)) ± $(round(σ, digits=2)) time steps")
println("  Direct link:   $(round(direct_μ, digits=2)) time steps mean")
println("  Speedup:       $(round(direct_μ/μ, digits=2))x")
println()

println("Day 5 complete.")
