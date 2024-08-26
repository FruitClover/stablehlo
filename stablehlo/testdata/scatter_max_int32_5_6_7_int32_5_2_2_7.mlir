// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<5x6x7xi32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi64>
    %0:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<5x2x2x7xi32>)
    %1 = call @expected() : () -> tensor<5x6x7xi32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %3 = stablehlo.maximum %arg0, %arg1 : tensor<i32>
      stablehlo.return %3 : tensor<i32>
    }) : (tensor<5x6x7xi32>, tensor<2x2x1xi64>, tensor<5x2x2x7xi32>) -> tensor<5x6x7xi32>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> ()
    return %2 : tensor<5x6x7xi32>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32> {mhlo.layout_mode = "default"}, tensor<5x2x2x7xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x000000000200000000000000FFFFFFFF040000000200000000000000FEFFFFFF00000000FEFFFFFFFDFFFFFF01000000FDFFFFFF04000000FDFFFFFF00000000FEFFFFFF03000000FEFFFFFF0000000003000000FDFFFFFFFDFFFFFF00000000FDFFFFFF03000000FFFFFFFF00000000FAFFFFFF020000000100000000000000FEFFFFFF0200000000000000000000000100000003000000FDFFFFFF010000000300000000000000FFFFFFFFFDFFFFFF0000000002000000FFFFFFFFFFFFFFFF05000000FFFFFFFF0000000000000000FEFFFFFFFFFFFFFF000000000000000003000000FFFFFFFF00000000FEFFFFFF00000000FEFFFFFF00000000FCFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0100000001000000FFFFFFFF0300000002000000FFFFFFFF03000000FEFFFFFF000000000000000000000000FEFFFFFF01000000010000000600000001000000FDFFFFFFFDFFFFFF000000000200000003000000FFFFFFFF01000000FAFFFFFFFEFFFFFF000000000000000006000000000000000000000000000000FFFFFFFFFDFFFFFFFCFFFFFF030000000100000002000000FEFFFFFF030000000200000002000000010000000000000000000000FFFFFFFFFCFFFFFFFCFFFFFFFFFFFFFF02000000FFFFFFFFFFFFFFFF01000000000000000300000000000000FEFFFFFF01000000000000000300000004000000FFFFFFFF00000000FBFFFFFF0100000000000000070000000000000004000000FEFFFFFFFBFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFCFFFFFF0300000003000000020000000600000000000000010000000600000008000000FFFFFFFFFCFFFFFF000000000400000002000000FDFFFFFFFDFFFFFFFFFFFFFF000000000400000001000000FFFFFFFF04000000FFFFFFFF0000000002000000000000000200000003000000FDFFFFFF0000000000000000FEFFFFFFFDFFFFFF0300000002000000F9FFFFFFFBFFFFFFFEFFFFFF000000000000000003000000FFFFFFFF000000000400000000000000000000000200000003000000FCFFFFFF01000000020000000100000000000000FDFFFFFF00000000FCFFFFFF0000000000000000050000000400000000000000030000000400000004000000FBFFFFFF020000000000000002000000FAFFFFFF03000000"> : tensor<5x6x7xi32>
    %c_0 = stablehlo.constant dense<"0x03000000FCFFFFFF02000000FEFFFFFF010000000300000003000000FBFFFFFFFEFFFFFF020000000000000000000000FDFFFFFFFEFFFFFFFDFFFFFFFDFFFFFF0000000000000000FEFFFFFF0200000000000000000000000200000001000000FBFFFFFF0000000000000000FBFFFFFFFEFFFFFF0100000001000000FCFFFFFFFFFFFFFFFEFFFFFF00000000FEFFFFFF00000000FEFFFFFF010000000100000002000000FBFFFFFF02000000FFFFFFFF0400000002000000FAFFFFFFFDFFFFFF0000000003000000040000000000000001000000FDFFFFFFFAFFFFFF0300000006000000020000000600000000000000FFFFFFFF0100000005000000FFFFFFFFFFFFFFFF00000000FFFFFFFFFEFFFFFF00000000000000000000000004000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFEFFFFFF01000000FEFFFFFF0000000001000000FCFFFFFF02000000FAFFFFFFFEFFFFFF0000000000000000FFFFFFFF00000000FCFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFFFFFFFF01000000FDFFFFFFFDFFFFFF05000000FFFFFFFFFDFFFFFF01000000FCFFFFFFFFFFFFFFFEFFFFFF00000000050000000000000001000000FDFFFFFF00000000FCFFFFFFFEFFFFFF03000000FDFFFFFFF9FFFFFFFEFFFFFF01000000FDFFFFFF05000000010000000000000002000000FEFFFFFFFCFFFFFF020000000000000002000000FDFFFFFFFCFFFFFFFDFFFFFF020000000000000004000000FDFFFFFFFFFFFFFF01000000FFFFFFFFFEFFFFFF0100000002000000"> : tensor<5x2x2x7xi32>
    return %c, %c_0 : tensor<5x6x7xi32>, tensor<5x2x2x7xi32>
  }
  func.func private @expected() -> (tensor<5x6x7xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x030000000200000002000000FFFFFFFF040000000300000003000000FEFFFFFF00000000020000000000000001000000FDFFFFFF04000000FDFFFFFF000000000000000003000000FEFFFFFF0200000003000000000000000200000001000000FDFFFFFF030000000000000000000000FAFFFFFF020000000100000000000000FEFFFFFF0200000000000000000000000100000003000000FDFFFFFF010000000300000000000000FFFFFFFF010000000100000002000000FFFFFFFFFFFFFFFF05000000FFFFFFFF00000000000000000100000001000000020000000000000003000000FFFFFFFF040000000200000000000000FEFFFFFF00000000030000000400000000000000010000000100000001000000030000000300000002000000FFFFFFFF03000000FEFFFFFF000000000000000000000000FEFFFFFF01000000010000000600000001000000FDFFFFFF06000000020000000600000003000000FFFFFFFF0100000005000000FFFFFFFF0000000000000000060000000000000000000000000000000000000004000000FFFFFFFF030000000100000002000000FEFFFFFF030000000200000002000000010000000000000002000000FFFFFFFFFCFFFFFFFCFFFFFFFFFFFFFF02000000FFFFFFFFFFFFFFFF01000000000000000300000000000000FEFFFFFF010000000000000003000000040000000000000000000000FFFFFFFF0100000000000000070000000000000004000000FFFFFFFF01000000FFFFFFFFFFFFFFFF05000000FFFFFFFF030000000300000002000000060000000000000001000000060000000800000001000000FDFFFFFF000000000400000002000000FDFFFFFFFDFFFFFFFFFFFFFF000000000400000001000000FFFFFFFF04000000FFFFFFFF0000000002000000000000000200000003000000030000000000000000000000FEFFFFFF010000000300000005000000010000000000000002000000000000000000000003000000000000000200000004000000000000000000000002000000030000000400000001000000020000000100000000000000FEFFFFFF01000000020000000000000000000000050000000400000000000000030000000400000004000000FBFFFFFF020000000000000002000000FAFFFFFF03000000"> : tensor<5x6x7xi32>
    return %c : tensor<5x6x7xi32>
  }
}
