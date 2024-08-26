// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<8x9xui32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<8x9xui32>
    %1 = call @expected() : () -> tensor<8x9xui32>
    %2 = call @cummax(%0) : (tensor<8x9xui32>) -> tensor<8x9xui32>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<8x9xui32>, tensor<8x9xui32>) -> ()
    return %2 : tensor<8x9xui32>
  }
  func.func private @inputs() -> (tensor<8x9xui32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[2, 2, 5, 2, 2, 2, 0, 0, 1], [0, 0, 2, 1, 0, 0, 1, 4, 0], [2, 2, 2, 0, 4, 2, 0, 1, 0], [1, 4, 7, 1, 0, 3, 1, 0, 2], [6, 0, 0, 0, 3, 3, 0, 2, 6], [1, 2, 5, 1, 3, 3, 2, 0, 3], [1, 1, 1, 3, 5, 5, 0, 4, 0], [7, 2, 2, 4, 2, 0, 0, 1, 4]]> : tensor<8x9xui32>
    return %c : tensor<8x9xui32>
  }
  func.func private @expected() -> (tensor<8x9xui32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[2, 2, 5, 2, 2, 2, 0, 0, 1], [2, 2, 5, 2, 2, 2, 1, 4, 1], [2, 2, 5, 2, 4, 2, 1, 4, 1], [2, 4, 7, 2, 4, 3, 1, 4, 2], [6, 4, 7, 2, 4, 3, 1, 4, 6], [6, 4, 7, 2, 4, 3, 2, 4, 6], [6, 4, 7, 3, 5, 5, 2, 4, 6], [7, 4, 7, 4, 5, 5, 2, 4, 6]]> : tensor<8x9xui32>
    return %c : tensor<8x9xui32>
  }
  func.func private @cummax(%arg0: tensor<8x9xui32>) -> tensor<8x9xui32> {
    %c = stablehlo.constant dense<0> : tensor<ui32>
    %0 = stablehlo.broadcast_in_dim %c, dims = [] : (tensor<ui32>) -> tensor<ui32>
    %1 = "stablehlo.reduce_window"(%arg0, %0) <{padding = dense<[[7, 0], [0, 0]]> : tensor<2x2xi64>, window_dimensions = array<i64: 8, 1>}> ({
    ^bb0(%arg1: tensor<ui32>, %arg2: tensor<ui32>):
      %2 = stablehlo.maximum %arg1, %arg2 : tensor<ui32>
      stablehlo.return %2 : tensor<ui32>
    }) : (tensor<8x9xui32>, tensor<ui32>) -> tensor<8x9xui32>
    return %1 : tensor<8x9xui32>
  }
}
