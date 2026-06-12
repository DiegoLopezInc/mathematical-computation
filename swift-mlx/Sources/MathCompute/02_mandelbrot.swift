// 02_mandelbrot.swift
// Mandelbrot set computed over a complex grid — entire grid at once on the GPU.
// Demonstrates: linspace, complex arithmetic, elementwise comparison, GPU speedup.
//
// Source: WWDC 2026 session 328, chapter "Mandelbrot" (4:28)

import MLX
import Foundation

func runMandelbrot(width w: Int = 800, height h: Int = 600, maxIterations: Int = 256) {
    print("--- Mandelbrot Set (\(w)x\(h), \(maxIterations) iters) ---")

    let start = Date()

    // Grid of complex numbers c = x + iy
    let x = MLX.linspace(-2.0 as Float, 0.5, count: w)
    let y = MLX.linspace(-1.25 as Float, 1.25, count: h).reshaped(h, 1)
    let c = x + y.asImaginary()

    var z = MLXArray.zeros(like: c)
    var counts = MLXArray.zeros(c.shape, dtype: .int16)

    // z ← z² + c, count bounded iterations
    for _ in 0 ..< maxIterations {
        z = z * z + c
        counts = counts + (MLX.abs(z) .< 2)
    }
    eval(counts)

    let elapsed = Date().timeIntervalSince(start)
    print("Computed \(w * h) points in \(String(format: "%.3f", elapsed))s")
    print("Max iteration count: \(counts.max().item(Int16.self))\n")
}
