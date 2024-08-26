// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<1x1x1xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<0> : tensor<1xi64>
    %0:2 = call @inputs() : () -> (tensor<1x1x1xf32>, tensor<1x1xf32>)
    %1 = call @expected() : () -> tensor<1x1x1xf32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [0], scatter_dims_to_operand_dims = [0]>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %3 = stablehlo.add %arg0, %arg1 : tensor<f32>
      stablehlo.return %3 : tensor<f32>
    }) : (tensor<1x1x1xf32>, tensor<1xi64>, tensor<1x1xf32>) -> tensor<1x1x1xf32>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<1x1x1xf32>, tensor<1x1x1xf32>) -> ()
    return %2 : tensor<1x1x1xf32>
  }
  func.func private @inputs() -> (tensor<1x1x1xf32> {mhlo.layout_mode = "default"}, tensor<1x1xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<1.31754231> : tensor<1x1x1xf32>
    %cst_0 = stablehlo.constant dense<-3.90661335> : tensor<1x1xf32>
    return %cst, %cst_0 : tensor<1x1x1xf32>, tensor<1x1xf32>
  }
  func.func private @expected() -> (tensor<1x1x1xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<-2.58907104> : tensor<1x1x1xf32>
    return %cst : tensor<1x1x1xf32>
  }
}
