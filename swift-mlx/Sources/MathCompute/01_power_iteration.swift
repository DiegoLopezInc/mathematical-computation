// 01_power_iteration.swift
// Power iteration to find the dominant eigenvector of a symmetric matrix.
// Demonstrates: MLXRandom, matmul, norm, lazy eval, explicit eval().
//
// Source: WWDC 2026 session 328, chapter "MLX Swift" (3:04)

import MLX
import MLXRandom

func runPowerIteration(n: Int = 100, steps: Int = 10) {
    print("--- Power Iteration (n=\(n), steps=\(steps)) ---")

    // Random symmetric matrix A = Bᵀ + B
    let B = MLXRandom.normal([n, n])
    let A = B.T + B

    // Random initial vector
    var v = MLXRandom.normal([n])

    // v ← A v / ‖A v‖
    for _ in 0 ..< steps {
        let Av = matmul(A, v)
        v = Av / norm(Av)
        eval(v)   // force GPU evaluation inside the loop
    }

    // Recover eigenvalue: λ = vᵀ A v
    let lambda = matmul(matmul(v.T, A), v)
    eval(lambda)

    print("Dominant eigenvalue: \(lambda.item(Float.self))\n")
}
