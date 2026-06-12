# Day 1 — Julia Basics, High-Performance Programming, Linear Algebra
# qnumerics 2026, Instructor: Raye Kimmerer
#
# Topics: Julia workflow, multiple dispatch, benchmarking, fast linear algebra, sparse arrays
# Run: julia --project=.. linear_algebra.jl

using LinearAlgebra
using BenchmarkTools
using SparseArrays

println("=== Day 1: Julia Basics & Linear Algebra ===\n")

# ── 1. Multiple dispatch ────────────────────────────────────────────────────
# Julia chooses the method based on all argument types (not just the first).

describe(x::Int)     = "integer: $x"
describe(x::Float64) = "float:   $x"
describe(x::AbstractMatrix) = "matrix $(size(x))"

println("Multiple dispatch examples:")
println(describe(42))
println(describe(3.14))
println(describe(rand(3, 3)))
println()

# ── 2. Type stability and @code_warntype ───────────────────────────────────
# Type-unstable functions prevent LLVM from compiling efficient code.

# Bad: return type depends on runtime value
function unstable_sum(x)
    s = 0          # Int, not inferred from x
    for xi in x
        s += xi
    end
    return s
end

# Good: initialise with zero(eltype(x))
function stable_sum(x)
    s = zero(eltype(x))
    for xi in x
        s += xi
    end
    return s
end

v = rand(Float64, 10_000)
println("Type-stability benchmark (10k floats):")
print("  unstable: ")
@btime unstable_sum($v)
print("  stable:   ")
@btime stable_sum($v)
println()

# ── 3. Fast linear algebra ──────────────────────────────────────────────────
# LAPACK/BLAS under the hood; use built-ins, don't reinvent.

n = 512
A = rand(n, n)
b = rand(n)

println("Dense linear solve (n=$n):")
@btime ($A \ $b)

# Eigendecomposition
println("Eigendecomposition (n=$n):")
@btime eigen($A)
println()

# ── 4. Sparse arrays ────────────────────────────────────────────────────────
# Tridiagonal Laplacian — common in PDE discretisations and quantum Hamiltonians.

function laplacian_1d(n)
    d = fill(2.0, n)
    od = fill(-1.0, n - 1)
    return spdiagm(0 => d, 1 => od, -1 => od)
end

L = laplacian_1d(1000)
println("1D Laplacian (n=1000), nnz = $(nnz(L))")
println("Dense equivalent would have $(1000^2) entries")
println()

# Sparse solve
b_sp = rand(1000)
println("Sparse vs dense solve (n=1000):")
print("  sparse: ")
@btime $L \ $b_sp
print("  dense:  ")
L_dense = Matrix(L)
@btime $L_dense \ $b_sp
println()

println("Day 1 complete.")
