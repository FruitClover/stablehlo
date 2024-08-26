// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<5x6x7xi64> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi64>
    %0:2 = call @inputs() : () -> (tensor<5x6x7xi64>, tensor<5x2x2xi64>)
    %1 = call @expected() : () -> tensor<5x6x7xi64>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<i64>, %arg1: tensor<i64>):
      %3 = stablehlo.multiply %arg0, %arg1 : tensor<i64>
      stablehlo.return %3 : tensor<i64>
    }) : (tensor<5x6x7xi64>, tensor<2x2x2xi64>, tensor<5x2x2xi64>) -> tensor<5x6x7xi64>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<5x6x7xi64>, tensor<5x6x7xi64>) -> ()
    return %2 : tensor<5x6x7xi64>
  }
  func.func private @inputs() -> (tensor<5x6x7xi64> {mhlo.layout_mode = "default"}, tensor<5x2x2xi64> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x0000000000000000FCFFFFFFFFFFFFFF00000000000000000200000000000000FBFFFFFFFFFFFFFF0100000000000000FDFFFFFFFFFFFFFF01000000000000000300000000000000000000000000000000000000000000000300000000000000FDFFFFFFFFFFFFFF0100000000000000FBFFFFFFFFFFFFFF010000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF0100000000000000020000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFF0000000000000000FEFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF030000000000000004000000000000000300000000000000FBFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000FBFFFFFFFFFFFFFF000000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000000000000FDFFFFFFFFFFFFFF0000000000000000040000000000000002000000000000000400000000000000FAFFFFFFFFFFFFFF0000000000000000FEFFFFFFFFFFFFFF01000000000000000000000000000000040000000000000002000000000000000100000000000000000000000000000000000000000000000200000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF0000000000000000FCFFFFFFFFFFFFFFFBFFFFFFFFFFFFFF0100000000000000FEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF02000000000000000000000000000000FDFFFFFFFFFFFFFFF9FFFFFFFFFFFFFFFCFFFFFFFFFFFFFF00000000000000000200000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0300000000000000FFFFFFFFFFFFFFFF04000000000000000000000000000000FCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0100000000000000FEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF00000000000000000100000000000000060000000000000000000000000000000100000000000000010000000000000002000000000000000300000000000000000000000000000001000000000000000200000000000000FEFFFFFFFFFFFFFF000000000000000000000000000000000100000000000000020000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF02000000000000000300000000000000030000000000000002000000000000000100000000000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF000000000000000001000000000000000400000000000000FFFFFFFFFFFFFFFF0300000000000000040000000000000004000000000000000100000000000000FFFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF0100000000000000F9FFFFFFFFFFFFFF05000000000000000100000000000000030000000000000001000000000000000000000000000000FDFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF0400000000000000FDFFFFFFFFFFFFFF0600000000000000FEFFFFFFFFFFFFFF030000000000000003000000000000000200000000000000FDFFFFFFFFFFFFFF0100000000000000010000000000000001000000000000000000000000000000040000000000000005000000000000000100000000000000FFFFFFFFFFFFFFFF0000000000000000FEFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF0400000000000000FDFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF00000000000000000300000000000000FDFFFFFFFFFFFFFF0700000000000000080000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF030000000000000000000000000000000000000000000000FEFFFFFFFFFFFFFF03000000000000000000000000000000020000000000000006000000000000000100000000000000FEFFFFFFFFFFFFFF00000000000000000000000000000000FFFFFFFFFFFFFFFF000000000000000003000000000000000200000000000000FAFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF0000000000000000FEFFFFFFFFFFFFFF04000000000000000000000000000000FFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000000000000FEFFFFFFFFFFFFFF010000000000000000000000000000000000000000000000020000000000000003000000000000000100000000000000FEFFFFFFFFFFFFFF0200000000000000"> : tensor<5x6x7xi64>
    %c_0 = stablehlo.constant dense<[[[0, -3], [1, -3]], [[3, 0], [1, -1]], [[1, 2], [0, -1]], [[0, 0], [-5, -2]], [[-1, 1], [-6, -4]]]> : tensor<5x2x2xi64>
    return %c, %c_0 : tensor<5x6x7xi64>, tensor<5x2x2xi64>
  }
  func.func private @expected() -> (tensor<5x6x7xi64> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x0000000000000000000000000000000000000000000000000200000000000000FBFFFFFFFFFFFFFF0100000000000000FDFFFFFFFFFFFFFF01000000000000000300000000000000000000000000000000000000000000000300000000000000FDFFFFFFFFFFFFFF0100000000000000FBFFFFFFFFFFFFFF010000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF0100000000000000020000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFF0000000000000000FEFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF030000000000000004000000000000000300000000000000FBFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000FBFFFFFFFFFFFFFF000000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000000000000FDFFFFFFFFFFFFFF00000000000000000C0000000000000002000000000000000400000000000000FAFFFFFFFFFFFFFF0000000000000000FEFFFFFFFFFFFFFF01000000000000000000000000000000FCFFFFFFFFFFFFFF02000000000000000100000000000000000000000000000000000000000000000200000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF00000000000000000000000000000000FCFFFFFFFFFFFFFFFBFFFFFFFFFFFFFF0100000000000000FEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF02000000000000000000000000000000FDFFFFFFFFFFFFFFF9FFFFFFFFFFFFFFFCFFFFFFFFFFFFFF00000000000000000200000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0300000000000000FFFFFFFFFFFFFFFF04000000000000000000000000000000FCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0100000000000000FEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF00000000000000000100000000000000060000000000000000000000000000000100000000000000010000000000000002000000000000000300000000000000000000000000000001000000000000000200000000000000FCFFFFFFFFFFFFFF000000000000000000000000000000000100000000000000020000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF02000000000000000300000000000000030000000000000000000000000000000100000000000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF000000000000000001000000000000000400000000000000FFFFFFFFFFFFFFFF0300000000000000040000000000000004000000000000000100000000000000FFFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF0000000000000000F9FFFFFFFFFFFFFF05000000000000000100000000000000030000000000000001000000000000000000000000000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF0400000000000000FDFFFFFFFFFFFFFF0600000000000000FEFFFFFFFFFFFFFF030000000000000000000000000000000200000000000000FDFFFFFFFFFFFFFF0100000000000000010000000000000001000000000000000000000000000000040000000000000005000000000000000100000000000000FFFFFFFFFFFFFFFF0000000000000000FEFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF0400000000000000FDFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF00000000000000000300000000000000FDFFFFFFFFFFFFFF0700000000000000F8FFFFFFFFFFFFFF00000000000000000000000000000000FFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF030000000000000000000000000000000000000000000000080000000000000003000000000000000000000000000000020000000000000006000000000000000100000000000000FEFFFFFFFFFFFFFF00000000000000000000000000000000FFFFFFFFFFFFFFFF000000000000000003000000000000000200000000000000FAFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF0000000000000000FEFFFFFFFFFFFFFF0400000000000000000000000000000006000000000000000100000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000000000000FEFFFFFFFFFFFFFF010000000000000000000000000000000000000000000000020000000000000003000000000000000100000000000000FEFFFFFFFFFFFFFF0200000000000000"> : tensor<5x6x7xi64>
    return %c : tensor<5x6x7xi64>
  }
}
