// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<i1> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<complex<f64>>, tensor<complex<f64>>)
    %1 = call @expected() : () -> tensor<i1>
    %2 = stablehlo.real %0#0 : (tensor<complex<f64>>) -> tensor<f64>
    %3 = stablehlo.real %0#1 : (tensor<complex<f64>>) -> tensor<f64>
    %4 = stablehlo.compare  EQ, %2, %3,  FLOAT : (tensor<f64>, tensor<f64>) -> tensor<i1>
    %5 = stablehlo.imag %0#0 : (tensor<complex<f64>>) -> tensor<f64>
    %6 = stablehlo.imag %0#1 : (tensor<complex<f64>>) -> tensor<f64>
    %7 = stablehlo.compare  LE, %5, %6,  FLOAT : (tensor<f64>, tensor<f64>) -> tensor<i1>
    %8 = stablehlo.real %0#0 : (tensor<complex<f64>>) -> tensor<f64>
    %9 = stablehlo.real %0#1 : (tensor<complex<f64>>) -> tensor<f64>
    %10 = stablehlo.compare  LE, %8, %9,  FLOAT : (tensor<f64>, tensor<f64>) -> tensor<i1>
    %11 = stablehlo.select %4, %7, %10 : tensor<i1>, tensor<i1>
    stablehlo.custom_call @check.expect_eq(%11, %1) {has_side_effect = true} : (tensor<i1>, tensor<i1>) -> ()
    return %11 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<complex<f64>> {mhlo.layout_mode = "default"}, tensor<complex<f64>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<(-0.11320697678920902,-5.8856752304734448)> : tensor<complex<f64>>
    %cst_0 = stablehlo.constant dense<(7.7701941531527954,5.6698682307202803)> : tensor<complex<f64>>
    return %cst, %cst_0 : tensor<complex<f64>>, tensor<complex<f64>>
  }
  func.func private @expected() -> (tensor<i1> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<true> : tensor<i1>
    return %c : tensor<i1>
  }
}
