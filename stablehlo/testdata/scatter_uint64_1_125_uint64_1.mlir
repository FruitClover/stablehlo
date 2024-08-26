// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<1x125xui64> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<0> : tensor<1xi64>
    %0:2 = call @inputs() : () -> (tensor<1x125xui64>, tensor<1xui64>)
    %1 = call @expected() : () -> tensor<1x125xui64>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<ui64>, %arg1: tensor<ui64>):
      stablehlo.return %arg1 : tensor<ui64>
    }) : (tensor<1x125xui64>, tensor<1xi64>, tensor<1xui64>) -> tensor<1x125xui64>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<1x125xui64>, tensor<1x125xui64>) -> ()
    return %2 : tensor<1x125xui64>
  }
  func.func private @inputs() -> (tensor<1x125xui64> {mhlo.layout_mode = "default"}, tensor<1xui64> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x01000000000000000000000000000000020000000000000002000000000000000000000000000000040000000000000001000000000000000000000000000000020000000000000002000000000000000200000000000000010000000000000002000000000000000000000000000000020000000000000001000000000000000500000000000000010000000000000003000000000000000000000000000000020000000000000001000000000000000200000000000000020000000000000002000000000000000300000000000000010000000000000001000000000000000300000000000000020000000000000000000000000000000100000000000000020000000000000001000000000000000100000000000000030000000000000004000000000000000000000000000000000000000000000005000000000000000300000000000000010000000000000007000000000000000000000000000000020000000000000002000000000000000000000000000000010000000000000004000000000000000100000000000000010000000000000004000000000000000200000000000000040000000000000003000000000000000200000000000000010000000000000000000000000000000100000000000000010000000000000000000000000000000000000000000000030000000000000002000000000000000100000000000000040000000000000001000000000000000000000000000000010000000000000005000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000010000000000000004000000000000000400000000000000010000000000000001000000000000000100000000000000030000000000000003000000000000000100000000000000040000000000000000000000000000000200000000000000000000000000000002000000000000000100000000000000000000000000000001000000000000000000000000000000010000000000000005000000000000000100000000000000010000000000000002000000000000000300000000000000000000000000000000000000000000000100000000000000000000000000000003000000000000000400000000000000010000000000000004000000000000000000000000000000020000000000000002000000000000000000000000000000000000000000000002000000000000000000000000000000030000000000000000000000000000000000000000000000060000000000000000000000000000000700000000000000010000000000000001000000000000000300000000000000"> : tensor<1x125xui64>
    %c_0 = stablehlo.constant dense<0> : tensor<1xui64>
    return %c, %c_0 : tensor<1x125xui64>, tensor<1xui64>
  }
  func.func private @expected() -> (tensor<1x125xui64> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x00000000000000000000000000000000020000000000000002000000000000000000000000000000040000000000000001000000000000000000000000000000020000000000000002000000000000000200000000000000010000000000000002000000000000000000000000000000020000000000000001000000000000000500000000000000010000000000000003000000000000000000000000000000020000000000000001000000000000000200000000000000020000000000000002000000000000000300000000000000010000000000000001000000000000000300000000000000020000000000000000000000000000000100000000000000020000000000000001000000000000000100000000000000030000000000000004000000000000000000000000000000000000000000000005000000000000000300000000000000010000000000000007000000000000000000000000000000020000000000000002000000000000000000000000000000010000000000000004000000000000000100000000000000010000000000000004000000000000000200000000000000040000000000000003000000000000000200000000000000010000000000000000000000000000000100000000000000010000000000000000000000000000000000000000000000030000000000000002000000000000000100000000000000040000000000000001000000000000000000000000000000010000000000000005000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000010000000000000004000000000000000400000000000000010000000000000001000000000000000100000000000000030000000000000003000000000000000100000000000000040000000000000000000000000000000200000000000000000000000000000002000000000000000100000000000000000000000000000001000000000000000000000000000000010000000000000005000000000000000100000000000000010000000000000002000000000000000300000000000000000000000000000000000000000000000100000000000000000000000000000003000000000000000400000000000000010000000000000004000000000000000000000000000000020000000000000002000000000000000000000000000000000000000000000002000000000000000000000000000000030000000000000000000000000000000000000000000000060000000000000000000000000000000700000000000000010000000000000001000000000000000300000000000000"> : tensor<1x125xui64>
    return %c : tensor<1x125xui64>
  }
}
