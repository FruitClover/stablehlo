// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<5x6x7xi32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi64>
    %0:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<5x2x2xi32>)
    %1 = call @expected() : () -> tensor<5x6x7xi32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %3 = stablehlo.add %arg0, %arg1 : tensor<i32>
      stablehlo.return %3 : tensor<i32>
    }) : (tensor<5x6x7xi32>, tensor<2x2x2xi64>, tensor<5x2x2xi32>) -> tensor<5x6x7xi32>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> ()
    return %2 : tensor<5x6x7xi32>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32> {mhlo.layout_mode = "default"}, tensor<5x2x2xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x00000000FFFFFFFF01000000FEFFFFFFFDFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF00000000FDFFFFFFFEFFFFFF02000000000000000000000001000000FDFFFFFF000000000300000000000000020000000400000000000000FFFFFFFF01000000FEFFFFFF000000000000000006000000FDFFFFFF0100000001000000FFFFFFFF0000000003000000030000000200000000000000FDFFFFFFFFFFFFFF05000000FDFFFFFF0000000001000000FFFFFFFFFDFFFFFF00000000010000000100000000000000FDFFFFFF020000000000000000000000FFFFFFFF0000000000000000FDFFFFFFFAFFFFFF00000000FFFFFFFFFEFFFFFF01000000FAFFFFFFFEFFFFFFFFFFFFFF040000000300000000000000000000000100000003000000FDFFFFFFFEFFFFFF01000000FDFFFFFF0000000001000000FCFFFFFFFFFFFFFFFFFFFFFF0600000001000000FFFFFFFFFFFFFFFF0300000009000000020000000000000000000000FDFFFFFF00000000000000000200000004000000FDFFFFFF00000000FDFFFFFFFFFFFFFF0000000001000000FFFFFFFF00000000FCFFFFFFFDFFFFFFFCFFFFFFFEFFFFFF01000000FFFFFFFFFFFFFFFF01000000FDFFFFFFFEFFFFFF00000000FDFFFFFF0100000000000000FDFFFFFF0000000000000000FFFFFFFF02000000FDFFFFFFFEFFFFFF0000000005000000FEFFFFFFFCFFFFFF0300000001000000FEFFFFFF02000000FFFFFFFF0000000001000000FEFFFFFF0000000000000000040000000000000002000000FFFFFFFF03000000FBFFFFFF00000000FEFFFFFFFEFFFFFF050000000100000000000000000000000100000000000000000000000000000001000000FFFFFFFF05000000FFFFFFFF04000000FFFFFFFFFDFFFFFF01000000FDFFFFFF010000000000000001000000FDFFFFFF000000000000000004000000FDFFFFFF000000000300000000000000FAFFFFFF0000000002000000FFFFFFFF06000000000000000300000001000000010000000000000002000000FFFFFFFFFFFFFFFF000000000000000004000000FAFFFFFFFFFFFFFF0500000000000000F9FFFFFFFCFFFFFFFFFFFFFF010000000000000002000000020000000300000000000000FDFFFFFF000000000200000002000000FEFFFFFF"> : tensor<5x6x7xi32>
    %c_0 = stablehlo.constant dense<[[[1, -1], [-2, 2]], [[4, -1], [-4, -4]], [[4, -1], [0, 2]], [[-4, 0], [5, 0]], [[-1, -2], [-1, 0]]]> : tensor<5x2x2xi32>
    return %c, %c_0 : tensor<5x6x7xi32>, tensor<5x2x2xi32>
  }
  func.func private @expected() -> (tensor<5x6x7xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x000000000000000001000000FEFFFFFFFDFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF0100000000000000FDFFFFFFFEFFFFFF02000000000000000000000001000000FCFFFFFF000000000300000000000000020000000400000000000000FFFFFFFF01000000FEFFFFFF00000000FEFFFFFF06000000FDFFFFFF0100000001000000FFFFFFFF0000000003000000030000000200000000000000FDFFFFFFFFFFFFFF05000000FDFFFFFF0400000001000000FFFFFFFFFDFFFFFF00000000010000000100000000000000F9FFFFFF020000000000000000000000FFFFFFFF0000000000000000FDFFFFFFF9FFFFFF00000000FFFFFFFFFEFFFFFF01000000FAFFFFFFFEFFFFFFFFFFFFFF040000000300000000000000FCFFFFFF0100000003000000FDFFFFFFFEFFFFFF01000000FDFFFFFF0000000001000000FCFFFFFFFFFFFFFFFFFFFFFF0600000001000000FFFFFFFF030000000300000009000000020000000000000000000000FDFFFFFF00000000020000000200000004000000FDFFFFFF00000000FDFFFFFFFFFFFFFF0000000000000000FFFFFFFF00000000FCFFFFFFFDFFFFFFFCFFFFFFFEFFFFFF01000000FFFFFFFFFFFFFFFF01000000FDFFFFFFFEFFFFFF00000000FDFFFFFF0100000000000000FDFFFFFF0000000000000000FFFFFFFF02000000FDFFFFFFFEFFFFFF0000000005000000FAFFFFFFFCFFFFFF0300000001000000FEFFFFFF02000000FFFFFFFF0000000001000000FEFFFFFF0000000000000000040000000000000002000000FFFFFFFF03000000FBFFFFFF00000000FEFFFFFFFEFFFFFF050000000100000000000000000000000100000000000000050000000000000001000000FFFFFFFF05000000FFFFFFFF04000000FFFFFFFFFDFFFFFF01000000FDFFFFFF010000000000000001000000FDFFFFFFFFFFFFFF0000000004000000FDFFFFFF000000000300000000000000FAFFFFFF0000000002000000FFFFFFFF0600000000000000030000000100000001000000FEFFFFFF02000000FFFFFFFFFFFFFFFF000000000000000004000000FAFFFFFFFFFFFFFF0500000000000000F8FFFFFFFCFFFFFFFFFFFFFF010000000000000002000000020000000300000000000000FDFFFFFF000000000200000002000000FEFFFFFF"> : tensor<5x6x7xi32>
    return %c : tensor<5x6x7xi32>
  }
}
