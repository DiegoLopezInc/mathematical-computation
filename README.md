# Mathematical Computation — MLX, Swift & Julia

A learning and research workspace for numerical methods in quantum information science,
accelerated by Apple MLX hardware.

## Goals

1. **Swift + MLX** — NumPy-style numerical computing natively in Swift on Apple silicon GPU
   (WWDC 2026 session 328)
2. **Julia for quantum numerics** — hands-on work tracking the
   [qnumerics.org 2026 summer school](https://qnumerics.org/2026/program) (UMass Amherst, June 22–July 18 2026)
3. **Fields Institute QADE** — visitor participation in the
   [Thematic Program on Quantum Algorithms for Differential Equations](https://www.fields.utoronto.ca/activities/26-27/quantum-algorithms-QADE)
   (Toronto, July 1–December 31 2026)
4. **NC Triangle research** — collaborative research with groups at NC State, Duke, and UNC Chapel Hill

## Repository Structure

```
mathematical-computation/
├── swift-mlx/          # Swift + MLX numerical computing explorations
│   ├── Package.swift
│   └── Sources/
│       ├── 01_power_iteration.swift
│       ├── 02_mandelbrot.swift
│       ├── 03_heat_distribution.swift
│       └── 04_curve_fitting.swift
├── julia/              # Julia quantum numerics (qnumerics 2026)
│   ├── Project.toml
│   ├── day1_julia_basics/
│   ├── day2_state_vector/
│   ├── day3_clifford_tensor/
│   ├── day4_optimal_control/
│   └── day5_quantum_networks/
├── research/           # Roadmap, program notes, collaboration contacts
│   └── roadmap.md
└── resources/          # Curated links and references
    └── links.md
```

## Quick Start

### Swift + MLX

Requires Xcode 16+ and macOS 15+.

```bash
cd swift-mlx
swift build
swift run MathCompute
```

### Julia

Install Julia 1.10+ from [julialang.org](https://julialang.org). Then:

```bash
cd julia
julia --project=. -e "using Pkg; Pkg.instantiate()"
```

Run any day's notebook:

```bash
julia --project=. day1_julia_basics/linear_algebra.jl
```

## Programs & Timeline

| Dates | Event |
|-------|-------|
| June 22–July 18, 2026 | qnumerics Summer School — UMass Amherst |
| July 1–Dec 31, 2026 | Fields Institute QADE Thematic Program — Toronto |
| July 13–17, 2026 | QADE Workshop 1: Classical Numerical Analysis |
| July 27–31, 2026 | QADE Workshop 2: Quantum Algorithms for DEs |
| Aug 24–28, 2026 | QADE Symposium: Theory & Applications |

## qnumerics 2026 Curriculum

| Day | Topics | Key Packages |
|-----|--------|-------------|
| 1 | Julia basics, high-performance programming, linear algebra | LinearAlgebra, BenchmarkTools |
| 2 | State-vector simulation, quantum dynamics | QuantumOptics.jl |
| 3 | Clifford circuits, tensor networks, GPU acceleration | QuantumClifford.jl, ITensors.jl |
| 4 | Optimal control of quantum systems | Piccolo.jl |
| 5 | Discrete-event simulation, quantum networks | ConcurrentSim.jl, QuantumSavory.jl |

## Fields QADE — Visitor Application

- [Thematic Program Registration](https://portal.fields.utoronto.ca/personal-portal/participation/3240)
- [Visitor Funding Application](https://survey.alchemer.com/s3/8618599/Visitor-Funding-Application-Form-for-the-Thematic-Program-on-Quantum-Algorithms-for-Differential-Equations-July-December-2026)
- Contact: Linh Nguyen, inquiries@fields.utoronto.ca

Organizing committee includes **Di Fang (Duke University)** — relevant for NC Triangle connections.

## NC Triangle Research Connections

See [`research/roadmap.md`](research/roadmap.md) for detailed faculty, groups, and outreach strategy.

- **Duke** — Di Fang (quantum algorithms for DEs, QADE co-organizer)
- **NC State** — quantum computing and scientific computing groups
- **UNC Chapel Hill** — applied mathematics and quantum information

## MLX Swift Resources

- [mlx-swift](https://github.com/ml-explore/mlx-swift) — core Swift package
- [mlx-swift-examples](https://github.com/ml-explore/mlx-swift-examples) — LLM, stable diffusion, training examples
- [MLX Framework docs](https://mlx-framework.org)
- [WWDC 2026 session 328](https://developer.apple.com/videos/play/wwdc2026/328/)
