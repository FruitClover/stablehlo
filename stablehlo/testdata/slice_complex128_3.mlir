// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<1xcomplex<f64>> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<3xcomplex<f64>>
    %1 = call @expected() : () -> tensor<1xcomplex<f64>>
    %2 = stablehlo.slice %0 [1:2] : (tensor<3xcomplex<f64>>) -> tensor<1xcomplex<f64>>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<1xcomplex<f64>>, tensor<1xcomplex<f64>>) -> ()
    return %2 : tensor<1xcomplex<f64>>
  }
  func.func private @inputs() -> (tensor<3xcomplex<f64>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[(4.3319333664393156,1.7674270116019666), (-2.8423782718122377,0.71376902446208579), (-2.1525327045932272,-2.8886484621089434)]> : tensor<3xcomplex<f64>>
    return %cst : tensor<3xcomplex<f64>>
  }
  func.func private @expected() -> (tensor<1xcomplex<f64>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<(-2.8423782718122377,0.71376902446208579)> : tensor<1xcomplex<f64>>
    return %cst : tensor<1xcomplex<f64>>
  }
}
