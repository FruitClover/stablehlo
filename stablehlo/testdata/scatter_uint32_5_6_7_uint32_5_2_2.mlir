// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<5x6x7xui32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi64>
    %0:2 = call @inputs() : () -> (tensor<5x6x7xui32>, tensor<5x2x2xui32>)
    %1 = call @expected() : () -> tensor<5x6x7xui32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<ui32>, %arg1: tensor<ui32>):
      stablehlo.return %arg1 : tensor<ui32>
    }) : (tensor<5x6x7xui32>, tensor<2x2x2xi64>, tensor<5x2x2xui32>) -> tensor<5x6x7xui32>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<5x6x7xui32>, tensor<5x6x7xui32>) -> ()
    return %2 : tensor<5x6x7xui32>
  }
  func.func private @inputs() -> (tensor<5x6x7xui32> {mhlo.layout_mode = "default"}, tensor<5x2x2xui32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x010000000000000002000000020000000100000004000000020000000000000000000000020000000300000003000000030000000500000002000000000000000300000001000000030000000200000002000000000000000000000005000000030000000000000000000000020000000300000000000000000000000200000008000000010000000100000002000000020000000100000001000000000000000600000002000000000000000000000006000000020000000400000002000000040000000000000001000000020000000300000004000000040000000000000006000000050000000100000002000000010000000000000001000000040000000200000003000000010000000100000003000000020000000100000000000000010000000000000000000000040000000000000000000000060000000200000000000000020000000300000002000000000000000300000002000000030000000200000002000000040000000100000000000000010000000000000001000000040000000300000001000000000000000100000001000000040000000000000005000000020000000300000003000000050000000400000004000000040000000000000006000000010000000600000000000000020000000100000002000000020000000100000000000000010000000000000007000000040000000100000002000000040000000000000002000000000000000800000002000000020000000000000003000000030000000100000000000000010000000200000004000000000000000800000001000000000000000100000002000000000000000200000001000000020000000500000002000000010000000100000001000000000000000100000002000000020000000600000000000000000000000200000000000000000000000400000002000000050000000000000002000000030000000000000001000000000000000100000001000000010000000000000000000000040000000000000002000000030000000200000004000000010000000400000003000000040000000300000003000000000000000300000003000000060000000100000000000000000000000000000004000000010000000300000000000000000000000000000003000000"> : tensor<5x6x7xui32>
    %c_0 = stablehlo.constant dense<[[[2, 1], [3, 1]], [[2, 2], [0, 3]], [[0, 2], [5, 7]], [[0, 6], [0, 1]], [[1, 0], [0, 2]]]> : tensor<5x2x2xui32>
    return %c, %c_0 : tensor<5x6x7xui32>, tensor<5x2x2xui32>
  }
  func.func private @expected() -> (tensor<5x6x7xui32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x010000000200000002000000020000000100000004000000020000000000000000000000010000000300000003000000030000000500000002000000000000000300000001000000030000000200000002000000000000000000000005000000030000000000000000000000020000000300000000000000000000000200000008000000010000000100000002000000020000000100000001000000000000000600000002000000000000000200000006000000020000000400000002000000040000000000000001000000030000000300000004000000040000000000000006000000050000000100000002000000010000000000000001000000040000000200000003000000010000000100000003000000020000000000000000000000010000000000000000000000040000000000000000000000060000000200000000000000020000000300000002000000000000000000000002000000030000000200000002000000040000000100000000000000070000000000000001000000040000000300000001000000000000000100000002000000040000000000000005000000020000000300000003000000050000000400000004000000040000000500000006000000010000000600000000000000020000000100000002000000020000000100000000000000010000000000000007000000040000000000000002000000040000000000000002000000000000000800000002000000010000000000000003000000030000000100000000000000010000000200000006000000000000000800000001000000000000000100000002000000000000000200000001000000020000000000000002000000010000000100000001000000000000000100000002000000020000000600000000000000000000000200000000000000000000000100000002000000050000000000000002000000030000000000000001000000020000000100000001000000010000000000000000000000040000000000000000000000030000000200000004000000010000000400000003000000040000000300000003000000000000000000000003000000060000000100000000000000000000000000000004000000010000000300000000000000000000000000000003000000"> : tensor<5x6x7xui32>
    return %c : tensor<5x6x7xui32>
  }
}
