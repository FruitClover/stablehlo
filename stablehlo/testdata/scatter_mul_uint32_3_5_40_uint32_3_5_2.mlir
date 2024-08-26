// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<3x5x40xui32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<1> : tensor<2x1xi64>
    %0:2 = call @inputs() : () -> (tensor<3x5x40xui32>, tensor<3x5x2xui32>)
    %1 = call @expected() : () -> tensor<3x5x40xui32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>}> ({
    ^bb0(%arg0: tensor<ui32>, %arg1: tensor<ui32>):
      %3 = stablehlo.multiply %arg0, %arg1 : tensor<ui32>
      stablehlo.return %3 : tensor<ui32>
    }) : (tensor<3x5x40xui32>, tensor<2x1xi64>, tensor<3x5x2xui32>) -> tensor<3x5x40xui32>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<3x5x40xui32>, tensor<3x5x40xui32>) -> ()
    return %2 : tensor<3x5x40xui32>
  }
  func.func private @inputs() -> (tensor<3x5x40xui32> {mhlo.layout_mode = "default"}, tensor<3x5x2xui32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x0200000003000000020000000100000003000000010000000000000002000000030000000200000000000000000000000600000005000000010000000200000002000000010000000200000007000000020000000200000001000000020000000000000002000000000000000000000002000000010000000000000002000000010000000000000000000000020000000300000004000000000000000300000005000000020000000000000000000000000000000100000002000000000000000000000000000000010000000300000001000000030000000300000004000000030000000300000002000000010000000200000002000000010000000200000000000000060000000100000001000000010000000300000000000000040000000200000001000000020000000000000005000000020000000000000001000000070000000300000002000000020000000000000003000000040000000300000003000000050000000000000007000000010000000200000004000000010000000000000004000000010000000400000000000000010000000200000001000000010000000100000002000000070000000400000006000000020000000400000001000000010000000100000002000000010000000000000000000000030000000500000001000000030000000200000004000000010000000200000001000000000000000000000005000000010000000200000002000000020000000200000004000000000000000200000001000000040000000500000000000000000000000400000002000000030000000100000002000000050000000200000002000000030000000300000001000000010000000300000001000000000000000100000000000000010000000100000003000000010000000300000003000000000000000200000002000000010000000000000003000000040000000000000000000000010000000000000002000000000000000000000001000000010000000100000008000000030000000700000001000000000000000000000006000000020000000200000000000000010000000500000000000000030000000100000004000000000000000300000005000000010000000200000001000000010000000000000000000000010000000400000004000000010000000100000000000000050000000400000000000000000000000400000003000000010000000000000000000000000000000200000000000000080000000500000001000000020000000200000000000000020000000700000006000000030000000400000005000000020000000100000001000000010000000100000000000000030000000000000002000000040000000100000004000000020000000200000006000000000000000100000002000000020000000100000000000000010000000100000003000000040000000100000000000000000000000600000000000000010000000100000001000000060000000200000004000000000000000000000000000000000000000100000001000000030000000200000000000000030000000000000001000000020000000100000000000000010000000300000000000000020000000100000002000000020000000100000002000000050000000200000006000000030000000100000001000000010000000400000001000000020000000200000000000000000000000200000002000000000000000000000002000000030000000300000003000000030000000300000003000000040000000300000007000000050000000100000001000000010000000100000002000000000000000100000000000000000000000000000000000000050000000B0000000000000004000000020000000100000003000000010000000300000003000000030000000200000001000000000000000300000002000000060000000000000002000000020000000100000003000000020000000300000000000000030000000000000000000000000000000100000004000000010000000000000006000000010000000500000002000000000000000400000003000000020000000200000000000000000000000200000000000000020000000300000005000000000000000300000005000000030000000000000001000000000000000500000002000000000000000000000000000000010000000400000002000000000000000300000001000000020000000200000000000000010000000000000002000000010000000000000000000000060000000200000001000000010000000200000000000000000000000600000001000000050000000100000007000000020000000500000000000000040000000000000003000000040000000300000000000000000000000300000000000000020000000100000006000000020000000100000005000000040000000400000002000000030000000300000003000000000000000100000004000000030000000400000000000000040000000500000001000000000000000000000000000000040000000100000004000000000000000000000000000000020000000200000000000000020000000200000000000000020000000000000001000000000000000000000002000000020000000300000002000000000000000400000002000000010000000200000003000000000000000100000003000000010000000000000002000000000000000600000004000000040000000300000004000000010000000300000001000000010000000500000003000000030000000000000002000000010000000300000000000000000000000100000006000000040000000300000001000000000000000100000003000000010000000200000002000000020000000500000002000000010000000000000000000000050000000300000000000000030000000000000000000000020000000200000000000000020000000100000004000000000000000000000004000000000000000300000007000000010000000300000005000000000000000000000003000000030000000200000003000000020000000300000004000000010000000100000000000000040000000200000003000000000000000300000002000000000000000100000000000000020000000200000003000000020000000100000002000000000000000000000000000000020000000400000000000000040000000000000001000000020000000300000000000000020000000400000000000000010000000500000003000000020000000100000004000000"> : tensor<3x5x40xui32>
    %c_0 = stablehlo.constant dense<[[[1, 5], [0, 2], [3, 2], [1, 1], [2, 5]], [[3, 0], [3, 4], [0, 2], [4, 0], [0, 0]], [[2, 2], [0, 1], [1, 0], [1, 6], [2, 4]]]> : tensor<3x5x2xui32>
    return %c, %c_0 : tensor<3x5x40xui32>, tensor<3x5x2xui32>
  }
  func.func private @expected() -> (tensor<3x5x40xui32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x020000000F0000000200000001000000030000000100000000000000020000000300000002000000000000000000000006000000050000000100000002000000020000000100000002000000070000000200000002000000010000000200000000000000020000000000000000000000020000000100000000000000020000000100000000000000000000000200000003000000040000000000000003000000050000000000000000000000000000000000000001000000020000000000000000000000000000000100000003000000010000000300000003000000040000000300000003000000020000000100000002000000020000000100000002000000000000000600000001000000010000000100000003000000000000000400000002000000010000000200000000000000050000000200000000000000010000000700000012000000020000000200000000000000030000000400000003000000030000000500000000000000070000000100000002000000040000000100000000000000040000000100000004000000000000000100000002000000010000000100000001000000020000000700000004000000060000000200000004000000010000000100000001000000020000000100000000000000000000000300000005000000010000000300000002000000040000000100000002000000010000000000000000000000050000000100000002000000020000000200000002000000040000000000000002000000010000000400000005000000000000000000000004000000020000000300000001000000020000000500000002000000020000000300000003000000010000000100000003000000010000000000000001000000000000000A000000010000000300000001000000030000000300000000000000020000000200000001000000000000000300000004000000000000000000000001000000000000000200000000000000000000000100000001000000010000000800000003000000070000000100000000000000000000000600000002000000020000000000000001000000050000000000000003000000010000000400000000000000000000000500000001000000020000000100000001000000000000000000000001000000040000000400000001000000010000000000000005000000040000000000000000000000040000000300000001000000000000000000000000000000020000000000000008000000050000000100000002000000020000000000000002000000070000000600000003000000040000000500000002000000010000000C000000010000000100000000000000030000000000000002000000040000000100000004000000020000000200000006000000000000000100000002000000020000000100000000000000010000000100000003000000040000000100000000000000000000000600000000000000010000000100000001000000060000000200000004000000000000000000000000000000000000000100000001000000000000000200000000000000030000000000000001000000020000000100000000000000010000000300000000000000020000000100000002000000020000000100000002000000050000000200000006000000030000000100000001000000010000000400000001000000020000000200000000000000000000000200000002000000000000000000000002000000030000000300000003000000030000000000000003000000040000000300000007000000050000000100000001000000010000000100000002000000000000000100000000000000000000000000000000000000050000000B0000000000000004000000020000000100000003000000010000000300000003000000030000000200000001000000000000000300000002000000060000000000000002000000020000000100000003000000020000000000000000000000030000000000000000000000000000000100000004000000010000000000000006000000010000000500000002000000000000000400000003000000020000000200000000000000000000000200000000000000020000000300000005000000000000000300000005000000030000000000000001000000000000000500000002000000000000000000000000000000010000000400000008000000000000000300000001000000020000000200000000000000010000000000000002000000010000000000000000000000060000000200000001000000010000000200000000000000000000000600000001000000050000000100000007000000020000000500000000000000040000000000000003000000040000000300000000000000000000000300000000000000020000000100000006000000000000000100000005000000040000000400000002000000030000000300000003000000000000000100000004000000030000000400000000000000040000000500000001000000000000000000000000000000040000000100000004000000000000000000000000000000020000000200000000000000020000000200000000000000020000000000000001000000000000000000000002000000020000000000000002000000000000000400000002000000010000000200000003000000000000000100000003000000010000000000000002000000000000000600000004000000040000000300000004000000010000000300000001000000010000000500000003000000030000000000000002000000010000000300000000000000000000000100000006000000040000000300000001000000000000000100000012000000010000000200000002000000020000000500000002000000010000000000000000000000050000000300000000000000030000000000000000000000020000000200000000000000020000000100000004000000000000000000000004000000000000000300000007000000010000000300000005000000000000000000000003000000030000000200000003000000020000000300000004000000080000000100000000000000040000000200000003000000000000000300000002000000000000000100000000000000020000000200000003000000020000000100000002000000000000000000000000000000020000000400000000000000040000000000000001000000020000000300000000000000020000000400000000000000010000000500000003000000020000000100000004000000"> : tensor<3x5x40xui32>
    return %c : tensor<3x5x40xui32>
  }
}
