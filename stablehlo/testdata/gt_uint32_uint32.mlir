// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<i1> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<ui32>, tensor<ui32>)
    %1 = call @expected() : () -> tensor<i1>
    %2 = stablehlo.compare  GT, %0#0, %0#1,  UNSIGNED : (tensor<ui32>, tensor<ui32>) -> tensor<i1>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<i1>, tensor<i1>) -> ()
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<ui32> {mhlo.layout_mode = "default"}, tensor<ui32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<2> : tensor<ui32>
    %c_0 = stablehlo.constant dense<1> : tensor<ui32>
    return %c, %c_0 : tensor<ui32>, tensor<ui32>
  }
  func.func private @expected() -> (tensor<i1> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<true> : tensor<i1>
    return %c : tensor<i1>
  }
}
