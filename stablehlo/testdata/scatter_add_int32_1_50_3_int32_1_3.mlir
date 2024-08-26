// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<1x50x3xi32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<32> : tensor<1xi64>
    %0:2 = call @inputs() : () -> (tensor<1x50x3xi32>, tensor<1x3xi32>)
    %1 = call @expected() : () -> tensor<1x50x3xi32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %3 = stablehlo.add %arg0, %arg1 : tensor<i32>
      stablehlo.return %3 : tensor<i32>
    }) : (tensor<1x50x3xi32>, tensor<1xi64>, tensor<1x3xi32>) -> tensor<1x50x3xi32>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<1x50x3xi32>, tensor<1x50x3xi32>) -> ()
    return %2 : tensor<1x50x3xi32>
  }
  func.func private @inputs() -> (tensor<1x50x3xi32> {mhlo.layout_mode = "default"}, tensor<1x3xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0xF9FFFFFF00000000FFFFFFFF0000000000000000020000000600000005000000FFFFFFFFFDFFFFFF0100000000000000040000000000000001000000060000000200000003000000FFFFFFFF040000000200000000000000FEFFFFFF00000000FEFFFFFF00000000020000000300000000000000000000000100000003000000FEFFFFFF030000000400000003000000FFFFFFFFFFFFFFFFFDFFFFFF020000000100000001000000FDFFFFFFFFFFFFFFFFFFFFFFF9FFFFFFFCFFFFFF05000000FDFFFFFF02000000FFFFFFFFFEFFFFFFFCFFFFFF00000000FFFFFFFF0000000003000000FDFFFFFFFFFFFFFF00000000FCFFFFFF0000000000000000FDFFFFFFFAFFFFFF00000000FFFFFFFF0000000000000000FBFFFFFFFEFFFFFF01000000FFFFFFFF00000000000000000200000000000000FDFFFFFF02000000FEFFFFFF000000000000000003000000FFFFFFFF03000000FFFFFFFFFBFFFFFFFDFFFFFF0000000001000000FFFFFFFF03000000FDFFFFFF0100000000000000FFFFFFFF05000000000000000100000002000000000000000000000000000000FDFFFFFFFDFFFFFF0400000000000000FDFFFFFF0100000000000000FCFFFFFF01000000FFFFFFFF00000000050000000000000004000000FAFFFFFF02000000FCFFFFFF0000000002000000FFFFFFFF0000000000000000FEFFFFFF0100000005000000FEFFFFFF0100000000000000FCFFFFFFFAFFFFFFFCFFFFFF01000000000000000200000000000000FFFFFFFFFEFFFFFF020000000100000001000000FDFFFFFF0000000002000000FCFFFFFF01000000FDFFFFFF00000000"> : tensor<1x50x3xi32>
    %c_0 = stablehlo.constant dense<[[1, 1, 0]]> : tensor<1x3xi32>
    return %c, %c_0 : tensor<1x50x3xi32>, tensor<1x3xi32>
  }
  func.func private @expected() -> (tensor<1x50x3xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0xF9FFFFFF00000000FFFFFFFF0000000000000000020000000600000005000000FFFFFFFFFDFFFFFF0100000000000000040000000000000001000000060000000200000003000000FFFFFFFF040000000200000000000000FEFFFFFF00000000FEFFFFFF00000000020000000300000000000000000000000100000003000000FEFFFFFF030000000400000003000000FFFFFFFFFFFFFFFFFDFFFFFF020000000100000001000000FDFFFFFFFFFFFFFFFFFFFFFFF9FFFFFFFCFFFFFF05000000FDFFFFFF02000000FFFFFFFFFEFFFFFFFCFFFFFF00000000FFFFFFFF0000000003000000FDFFFFFFFFFFFFFF00000000FCFFFFFF0000000000000000FDFFFFFFFAFFFFFF00000000FFFFFFFF0000000000000000FBFFFFFFFEFFFFFF01000000FFFFFFFF00000000000000000200000000000000FDFFFFFF02000000FEFFFFFF000000000000000003000000FFFFFFFF03000000FFFFFFFFFBFFFFFFFDFFFFFF0000000001000000FFFFFFFF03000000FDFFFFFF0100000000000000FFFFFFFF06000000010000000100000002000000000000000000000000000000FDFFFFFFFDFFFFFF0400000000000000FDFFFFFF0100000000000000FCFFFFFF01000000FFFFFFFF00000000050000000000000004000000FAFFFFFF02000000FCFFFFFF0000000002000000FFFFFFFF0000000000000000FEFFFFFF0100000005000000FEFFFFFF0100000000000000FCFFFFFFFAFFFFFFFCFFFFFF01000000000000000200000000000000FFFFFFFFFEFFFFFF020000000100000001000000FDFFFFFF0000000002000000FCFFFFFF01000000FDFFFFFF00000000"> : tensor<1x50x3xi32>
    return %c : tensor<1x50x3xi32>
  }
}
