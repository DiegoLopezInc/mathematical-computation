// 04_curve_fitting.swift
// Polynomial curve fitting using automatic differentiation (grad).
// Demonstrates: MLX autodiff, gradient descent, parameter updates.
//
// Source: WWDC 2026 session 328, chapter "Curve fitting" (10:17)

import MLX
import MLXRandom
import Foundation

func runCurveFitting(numPoints: Int = 100, steps: Int = 500, learningRate: Float = 0.01) {
    print("--- Curve Fitting (quadratic, \(numPoints) pts, \(steps) steps) ---")

    // Ground truth: y = 2 - 3x + 1.5x²  + noise
    let trueTheta: [Float] = [2.0, -3.0, 1.5]
    let x = MLXRandom.uniform(low: -2.0, high: 2.0, [numPoints])
    let noise = MLXRandom.normal([numPoints]) * 0.1
    let y = trueTheta[0] + trueTheta[1] * x + trueTheta[2] * (x ** 2) + noise
    eval(x, y)

    // Model: f(θ) = θ₀ + θ₁x + θ₂x²
    func f(_ theta: MLXArray) -> MLXArray {
        theta[0] + theta[1] * x + theta[2] * (x ** 2)
    }

    func loss(_ theta: MLXArray) -> MLXArray {
        mean((f(theta) - y) ** 2)
    }

    var theta = MLXArray.zeros([3])
    let gradLoss = grad(loss)

    for step in 0 ..< steps {
        let g = gradLoss(theta)
        theta = theta - learningRate * g
        eval(theta)
        if step % 100 == 0 {
            let l = loss(theta).item(Float.self)
            print("  step \(step):  loss=\(String(format: "%.6f", l))")
        }
    }

    let fitted = theta.asArray(Float.self)
    print("True  θ: \(trueTheta)")
    print("Fitted θ: \(fitted.map { String(format: "%.4f", $0) })\n")
}
