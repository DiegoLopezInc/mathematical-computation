# Research Motivation & Questions

## Why this project exists

Quantum algorithms for differential equations sit at an uncomfortable intersection: the people who understand the algorithms often don't understand numerical analysis, and vice versa. The Fields Institute's QADE program exists precisely because this gap is costing the field progress. This project is an attempt to build fluency on both sides simultaneously — implementing classical numerical methods from scratch to develop physical intuition, then studying the quantum algorithmic proposals that claim to beat them.

The code in this repo is not incidental. The heat distribution simulation (`swift-mlx/`) is not just a GPU demo — it's a worked example of how a PDE discretizes into a linear system, and understanding that structure is prerequisite to understanding why quantum linear solvers (like HHL and its successors) do or don't offer an advantage over classical methods for that problem class. The Lindblad master equation simulation (`julia/day2_state_vector/`) directly mirrors the open quantum system dynamics that quantum simulation algorithms are designed to solve efficiently on fault-tolerant hardware.

## The bridge problem

The hard constraint most popularizations don't say clearly: quantum algorithms offer provable speedup for differential equations in a narrow class of cases — essentially, linear PDEs where the quantum state can serve directly as the solution vector (Schrödinger, heat/diffusion, Poisson, linear Boltzmann). For nonlinear PDEs, the picture is much murkier and in many cases provably unfavorable. Part of what I want to understand is where exactly this boundary is and why.

The organizing framework the field has converged on for answering this kind of question is **Quantum Singular Value Transformation** (QSVT, Gilyén et al. 2018). QSVT unifies most quantum speedups for linear-algebraic problems — including all the quantum DE solvers — under a single framework, making it possible to compare them fairly and reason about their limitations. Working toward a real understanding of QSVT applied to the operators I'm building here (the 1D Laplacian, the Lindblad superoperator) is the theoretical target this project is aiming at.

## Open questions I'm currently thinking about

These are live questions, not things I know the answer to:

**On the numerical side:**
- The SOR iteration in `03_heat_distribution.swift` achieves O(N) convergence vs O(N²) for Jacobi by using a red-black update pattern with an optimally chosen relaxation parameter ω. Is there a quantum analogue — a quantum walk or quantum phase estimation scheme on the same operator that achieves a similar or better convergence exponent? The spectral gap of the iteration matrix is what governs both the classical SOR rate and the mixing time of related quantum walks.
- The DMRG calculation in `day3_clifford_tensor/` finds ground states variationally over matrix product states. DMRG works because 1D ground states have low entanglement (area law). Does this entanglement structure also bound the resources needed to prepare that state on a quantum computer, or is state preparation a separate hard problem even when the classical description is compact?

**On the quantum algorithmic side:**
- Fault-tolerant resource estimates for quantum PDE solvers are rarely computed end-to-end. Most complexity results are asymptotic (e.g., "polylog in precision") without concrete qubit and gate counts for problem sizes where quantum advantage would actually matter. Understanding what realistic resource estimates look like for even a simple quantum heat equation solver would clarify how far the theory is from practice.
- Di Fang's recent work on quantum simulation of Lindblad dynamics constructs explicit quantum circuits for open system evolution. The Lindblad operators I'm implementing in Day 2 are small and dense; the interesting question is how circuit depth scales when the jump operators are sparse (which is the physically motivated case for many-body open systems).

## Programs and context

**qnumerics 2026** (UMass Amherst, June 22–July 18) covers the computational side: Julia for high-performance numerics, state-vector simulation, Clifford circuits, tensor networks, optimal control, and quantum network simulation. The curriculum maps directly to the packages in `julia/`.

**Fields Institute QADE** (Toronto, July 1–December 31) is the algorithmic side: three workshops and a seminar series bringing numerical analysts and quantum algorithm theorists together. Workshop 1 (July 13–17) covers classical numerical analysis foundations; Workshop 2 (July 27–31) covers quantum algorithms for DEs; the August symposium covers recent advances. The organizing committee includes Di Fang (Duke), Nathan Wiebe (University of Toronto), David Gosset (University of Waterloo), and Dong An (Peking University), among others.

## On tools and reproducibility

All computational results in this project are in Pluto.jl notebooks (Julia, reactive) or Marimo notebooks (Python/MLX) — formats where cell execution order is explicit and environment is pinned. The goal is that every figure and number can be reproduced by cloning the repo and running `julia --project=. notebook.jl` or `marimo run notebook.py`. Quarto assembles selected notebooks into shareable documents when results are ready to communicate.

This is the standard the SciML (Scientific Machine Learning) Julia ecosystem sets for computational reproducibility, and it's the standard this project aims to meet.

## What I'm reading

- Gilyén, Su, Low, Wiebe — "Quantum singular value transformation and beyond" (2018)
- Di Fang, Jin, Ying — "Time-dependent unbounded Hamiltonian simulation with vector norm scaling" (2021)
- An, Fang, Lin — "Time-dependent Hamiltonian simulation of highly oscillatory dynamics and superconvergence for Schrödinger equation" (2022)
- Berry, Costa, Yu, Sanders, Babbush — "Qubitization of arbitrary basis quantum chemistry" (2019)
- Childs, Su, Tran, Wiebe, Zhu — "Theory of Trotter error with commutator scaling" (2021)
