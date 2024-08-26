// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<8x9xi8> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<8x9xi8>
    %1 = call @expected() : () -> tensor<8x9xi8>
    %2 = call @cummax(%0) : (tensor<8x9xi8>) -> tensor<8x9xi8>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<8x9xi8>, tensor<8x9xi8>) -> ()
    return %2 : tensor<8x9xi8>
  }
  func.func private @inputs() -> (tensor<8x9xi8> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[5, 0, 2, 4, 0, 4, 0, -2, 1], [0, 3, 0, 1, 4, -6, -2, -1, 4], [3, 0, -3, 1, 0, 0, 2, 7, -1], [0, -3, 1, -1, -4, -2, 1, 1, -9], [4, -1, 6, -1, 0, -1, -3, 0, -2], [5, -4, 3, 1, 0, 2, 0, 2, 2], [-1, 2, 0, 0, -1, -2, 1, -1, -5], [0, 0, -1, -4, 2, -2, 0, -4, 0]]> : tensor<8x9xi8>
    return %c : tensor<8x9xi8>
  }
  func.func private @expected() -> (tensor<8x9xi8> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[5, 0, 2, 4, 0, 4, 0, -2, 1], [5, 3, 2, 4, 4, 4, 0, -1, 4], [5, 3, 2, 4, 4, 4, 2, 7, 4], [5, 3, 2, 4, 4, 4, 2, 7, 4], [5, 3, 6, 4, 4, 4, 2, 7, 4], [5, 3, 6, 4, 4, 4, 2, 7, 4], [5, 3, 6, 4, 4, 4, 2, 7, 4], [5, 3, 6, 4, 4, 4, 2, 7, 4]]> : tensor<8x9xi8>
    return %c : tensor<8x9xi8>
  }
  func.func private @cummax(%arg0: tensor<8x9xi8>) -> tensor<8x9xi8> {
    %c = stablehlo.constant dense<-128> : tensor<i8>
    %0 = stablehlo.broadcast_in_dim %c, dims = [] : (tensor<i8>) -> tensor<i8>
    %1 = "stablehlo.reduce_window"(%arg0, %0) <{padding = dense<[[7, 0], [0, 0]]> : tensor<2x2xi64>, window_dimensions = array<i64: 8, 1>}> ({
    ^bb0(%arg1: tensor<i8>, %arg2: tensor<i8>):
      %2 = stablehlo.maximum %arg1, %arg2 : tensor<i8>
      stablehlo.return %2 : tensor<i8>
    }) : (tensor<8x9xi8>, tensor<i8>) -> tensor<8x9xi8>
    return %1 : tensor<8x9xi8>
  }
}
