// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<3x2xf64> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<2x3xf64>
    %1 = call @expected() : () -> tensor<3x2xf64>
    %2 = stablehlo.transpose %0, dims = [1, 0] : (tensor<2x3xf64>) -> tensor<3x2xf64>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<3x2xf64>, tensor<3x2xf64>) -> ()
    return %2 : tensor<3x2xf64>
  }
  func.func private @inputs() -> (tensor<2x3xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[-2.3456966792229577, 5.3498934080825755, 1.5772425443498772], [0.34120593540777594, -1.8904489264669952, 2.6353488633822506]]> : tensor<2x3xf64>
    return %cst : tensor<2x3xf64>
  }
  func.func private @expected() -> (tensor<3x2xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[-2.3456966792229577, 0.34120593540777594], [5.3498934080825755, -1.8904489264669952], [1.5772425443498772, 2.6353488633822506]]> : tensor<3x2xf64>
    return %cst : tensor<3x2xf64>
  }
}
