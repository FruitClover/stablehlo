// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<3x2xi1> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<1x2xf32>, tensor<3x2xf32>)
    %1 = call @expected() : () -> tensor<3x2xi1>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [0, 1] : (tensor<1x2xf32>) -> tensor<3x2xf32>
    %3 = stablehlo.compare  EQ, %2, %0#1,  FLOAT : (tensor<3x2xf32>, tensor<3x2xf32>) -> tensor<3x2xi1>
    stablehlo.custom_call @check.expect_eq(%3, %1) {has_side_effect = true} : (tensor<3x2xi1>, tensor<3x2xi1>) -> ()
    return %3 : tensor<3x2xi1>
  }
  func.func private @inputs() -> (tensor<1x2xf32> {mhlo.layout_mode = "default"}, tensor<3x2xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[1.71692586, -2.081380e-01]]> : tensor<1x2xf32>
    %cst_0 = stablehlo.constant dense<[[3.46662855, 5.75379705], [5.34643126, -2.66210437], [-2.19924545, 2.91241693]]> : tensor<3x2xf32>
    return %cst, %cst_0 : tensor<1x2xf32>, tensor<3x2xf32>
  }
  func.func private @expected() -> (tensor<3x2xi1> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<false> : tensor<3x2xi1>
    return %c : tensor<3x2xi1>
  }
}
