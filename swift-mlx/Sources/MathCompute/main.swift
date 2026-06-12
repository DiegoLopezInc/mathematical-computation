// main.swift — MLX Swift numerical computing demos
// WWDC 2026 session 328: "Explore numerical computing in Swift with MLX"
//
// Run: swift run MathCompute
// Each example can be toggled on/off below.

import MLX
import MLXRandom
import Foundation

print("MLX Swift — Numerical Computing Demos")
print("======================================\n")

// Toggle demos
runPowerIteration()
runMandelbrot(width: 80, height: 40, maxIterations: 100)
runHeatDistribution(size: 50, iterations: 500)
runCurveFitting(numPoints: 100, steps: 200)
