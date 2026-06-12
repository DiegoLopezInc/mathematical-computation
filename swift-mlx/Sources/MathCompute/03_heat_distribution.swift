// 03_heat_distribution.swift
// Steady-state heat distribution via Jacobi iteration, then SOR.
// Demonstrates: conv2d as a stencil operator, `which` for boundary conditions,
//               red-black SOR for O(N) vs O(N²) convergence.
//
// Source: WWDC 2026 session 328, chapters "Heat distribution" (6:34) and
//         "Faster convergence with SOR" (8:12)

import MLX
import MLXRandom
import Foundation

// Returns a checkerboard mask (0/1) with given phase (0=red, 1=black)
private func checkerboard(rows M: Int, cols N: Int, phase: Int) -> MLXArray {
    let r = MLXArray(0 ..< M).reshaped(M, 1)
    let c = MLXArray(0 ..< N)
    return ((r + c + phase) % 2) .== 0
}

func runHeatDistribution(size: Int = 100, iterations: Int = 1000) {
    let M = size, N = size
    print("--- Heat Distribution \(M)x\(N) ---")

    // Convolution kernel: average four neighbors
    let kernel = MLXArray([Float]([ 0, 0.25, 0,
                                    0.25, 0, 0.25,
                                    0, 0.25, 0])).reshaped(1, 3, 3, 1)

    // Heat sources at the walls (simple hot top, cold bottom)
    var heatSources = MLXArray.zeros([M, N], dtype: .float32)
    heatSources[0, 0...] = 1.0   // top wall: hot
    heatSources[-1, 0...] = 0.0  // bottom wall: cold

    let heatMask = (heatSources .!= 0) .|| MLXArray(heatSources[0, 0...] .== 0)

    // ── Jacobi ──────────────────────────────────────────────────────────────
    var temperature = heatSources
    let jacobiStart = Date()
    for _ in 0 ..< iterations {
        let next = conv2d(temperature.reshaped(1, M, N, 1), kernel, padding: 1)
                       .reshaped(M, N)
        temperature = which(heatMask, heatSources, next)
    }
    eval(temperature)
    let jacobiTime = Date().timeIntervalSince(jacobiStart)

    // ── SOR ─────────────────────────────────────────────────────────────────
    let omega = Float(2.0 / (1.0 + Double.pi / Double(max(M, N))))
    let redMask   = checkerboard(rows: M, cols: N, phase: 0)
    let blackMask = checkerboard(rows: M, cols: N, phase: 1)

    temperature = heatSources
    let sorStart = Date()
    for _ in 0 ..< iterations {
        // Update red cells using black neighbors
        let sorRed = omega * conv2d(temperature.reshaped(1, M, N, 1), kernel, padding: 1)
                                .reshaped(M, N)
                    + (1 - omega) * temperature
        temperature = which(redMask, sorRed, temperature)
        temperature = which(heatMask, heatSources, temperature)

        // Update black cells using updated red neighbors
        let sorBlack = omega * conv2d(temperature.reshaped(1, M, N, 1), kernel, padding: 1)
                                   .reshaped(M, N)
                       + (1 - omega) * temperature
        temperature = which(blackMask, sorBlack, temperature)
        temperature = which(heatMask, heatSources, temperature)
    }
    eval(temperature)
    let sorTime = Date().timeIntervalSince(sorStart)

    print("Jacobi \(iterations) iters: \(String(format: "%.3f", jacobiTime))s")
    print("SOR    \(iterations) iters: \(String(format: "%.3f", sorTime))s  (ω=\(String(format: "%.4f", omega)))")
    print("Speedup: \(String(format: "%.1fx", jacobiTime / sorTime))\n")
}
