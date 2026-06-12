# CLAUDE.md — Mathematical Computation Project

## Project Purpose

This repo is a learning and research workspace for Diluc (diegolopezuncc@gmail.com), focused on:

1. **Swift + MLX** numerical computing on Apple silicon (WWDC 2026, session 328)
2. **Julia** for quantum numerics — tracking the qnumerics.org 2026 summer school
3. Applying this learning toward the **Fields Institute QADE** thematic program (visitor)
4. Building toward research collaborations at **NC State, Duke, and UNC Chapel Hill**

## Key Programs

- **qnumerics 2026**: June 22–July 18, UMass Amherst. Five-day intensive.
  Curriculum: Julia basics → state-vector sim → Clifford/tensor networks → optimal control → quantum networks
- **Fields QADE**: July 1–Dec 31 2026, Toronto. Quantum Algorithms for Differential Equations.
  Three workshops (Jul 13–17, Jul 27–31, Aug 24–28) + seminar series.
  Di Fang (Duke) is on the organizing committee — key contact for NC Triangle connections.

## Directory Map

- `swift-mlx/` — Swift Package with MLX dependency. Build with `swift build` in that directory.
- `julia/` — Julia project. Activate with `julia --project=.` from `julia/`.
  Each `dayN_*/` subfolder corresponds to a qnumerics 2026 program day.
- `research/roadmap.md` — Fields QADE visitor strategy and NC Triangle faculty contacts.
- `resources/links.md` — curated links for all areas.

## Code Style

- Swift: follow Swift API design guidelines; use `eval()` calls explicitly after MLX operations in tight loops.
- Julia: use `@benchmark` to profile, `@code_warntype` to check type stability. Follow qnumerics idioms.

## Key Dependencies

### Swift
- `mlx-swift` — https://github.com/ml-explore/mlx-swift (via SPM)

### Julia
- `QuantumOptics.jl`, `QuantumClifford.jl`, `ITensors.jl`
- `Piccolo.jl`, `ConcurrentSim.jl`, `QuantumSavory.jl`
- `BenchmarkTools.jl`, `LinearAlgebra` (stdlib)

## GitHub

Intended to be pushed to GitHub and synced between local (Apple silicon Mac) and remote machines.
Use SSH for cloning on remote. On remote machines without MLX hardware, Swift MLX code will
still compile but GPU ops fall back to CPU.
