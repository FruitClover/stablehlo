// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<2x3xi32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:3 = call @inputs() : () -> (tensor<2x3xi1>, tensor<2x3xi32>, tensor<2x3xi32>)
    %1 = call @expected() : () -> tensor<2x3xi32>
    %2 = stablehlo.select %0#0, %0#2, %0#1 : tensor<2x3xi1>, tensor<2x3xi32>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<2x3xi32>, tensor<2x3xi32>) -> ()
    return %2 : tensor<2x3xi32>
  }
  func.func private @inputs() -> (tensor<2x3xi1> {mhlo.layout_mode = "default"}, tensor<2x3xi32> {mhlo.layout_mode = "default"}, tensor<2x3xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<true> : tensor<2x3xi1>
    %c_0 = stablehlo.constant dense<[[0, -1, 0], [0, -7, 0]]> : tensor<2x3xi32>
    %c_1 = stablehlo.constant dense<[[-1, 1, 3], [-4, -2, 1]]> : tensor<2x3xi32>
    return %c, %c_0, %c_1 : tensor<2x3xi1>, tensor<2x3xi32>, tensor<2x3xi32>
  }
  func.func private @expected() -> (tensor<2x3xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[-1, 1, 3], [-4, -2, 1]]> : tensor<2x3xi32>
    return %c : tensor<2x3xi32>
  }
}
