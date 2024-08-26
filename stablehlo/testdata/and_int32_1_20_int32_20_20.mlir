// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xi32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<1x20xi32>, tensor<20x20xi32>)
    %1 = call @expected() : () -> tensor<20x20xi32>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [0, 1] : (tensor<1x20xi32>) -> tensor<20x20xi32>
    %3 = stablehlo.and %2, %0#1 : tensor<20x20xi32>
    stablehlo.custom_call @check.expect_eq(%3, %1) {has_side_effect = true} : (tensor<20x20xi32>, tensor<20x20xi32>) -> ()
    return %3 : tensor<20x20xi32>
  }
  func.func private @inputs() -> (tensor<1x20xi32> {mhlo.layout_mode = "default"}, tensor<20x20xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[2, -2, 0, -2, 0, 5, -1, 3, 0, -1, 0, 4, -2, -1, -4, 4, 6, 1, 0, -1]]> : tensor<1x20xi32>
    %c_0 = stablehlo.constant dense<"0xFCFFFFFF0000000000000000FCFFFFFF010000000300000001000000010000000100000000000000040000000100000000000000000000000000000000000000FEFFFFFF000000000000000000000000030000000100000000000000FFFFFFFFFDFFFFFF0000000000000000FDFFFFFF00000000FEFFFFFF020000000200000003000000FDFFFFFFFFFFFFFF00000000FDFFFFFFFDFFFFFF0200000003000000FEFFFFFFFFFFFFFF0300000002000000FFFFFFFFFEFFFFFFFFFFFFFF050000000400000000000000FEFFFFFF01000000FEFFFFFF00000000010000000000000002000000FDFFFFFF000000000500000005000000010000000100000003000000020000000600000000000000FEFFFFFF0500000002000000FCFFFFFF000000000500000000000000F8FFFFFF00000000FEFFFFFF000000000100000002000000000000000100000003000000FDFFFFFF06000000FFFFFFFF06000000F8FFFFFF00000000FCFFFFFF000000000000000001000000FDFFFFFF010000000100000002000000FEFFFFFF0100000000000000FFFFFFFF0500000000000000FDFFFFFFFFFFFFFF0200000000000000FEFFFFFFFFFFFFFF03000000060000000000000003000000FFFFFFFFFAFFFFFF000000000100000000000000000000000000000004000000FEFFFFFF0200000000000000FCFFFFFF000000000600000000000000060000000000000000000000FEFFFFFF07000000FCFFFFFF08000000FEFFFFFFFFFFFFFFFDFFFFFF030000000000000002000000FEFFFFFF01000000FEFFFFFFFDFFFFFF00000000FBFFFFFFFEFFFFFFFDFFFFFF0500000003000000FEFFFFFF02000000FFFFFFFFFFFFFFFFFFFFFFFFFCFFFFFFFEFFFFFFFCFFFFFFFEFFFFFFFFFFFFFF02000000FDFFFFFFFBFFFFFF00000000FFFFFFFF0300000000000000FEFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFEFFFFFF040000000300000000000000FFFFFFFF00000000FCFFFFFF01000000FDFFFFFF0200000001000000040000000700000000000000FDFFFFFF00000000FFFFFFFFF9FFFFFF01000000FFFFFFFF0200000001000000020000000100000001000000FDFFFFFF0000000001000000FBFFFFFFFEFFFFFF02000000FEFFFFFFFFFFFFFF0000000000000000030000000200000007000000FFFFFFFF02000000FEFFFFFFFDFFFFFFFFFFFFFFF6FFFFFF0000000001000000FEFFFFFFFEFFFFFF010000000000000000000000FDFFFFFFFEFFFFFF0000000000000000FCFFFFFFFEFFFFFFFFFFFFFFFEFFFFFFFDFFFFFFFBFFFFFF03000000FEFFFFFFFEFFFFFFFFFFFFFF04000000000000000000000001000000FDFFFFFF0100000000000000000000000300000003000000FDFFFFFF00000000FBFFFFFF0100000004000000000000000000000003000000FFFFFFFF0000000000000000FCFFFFFF0000000004000000FFFFFFFF000000000000000000000000FEFFFFFF0000000000000000FEFFFFFF00000000000000000200000006000000FEFFFFFFFEFFFFFF0300000001000000FCFFFFFF01000000050000000500000002000000FEFFFFFFFCFFFFFFFDFFFFFF03000000FBFFFFFF02000000FAFFFFFF0500000001000000FBFFFFFF040000000000000001000000030000000300000004000000FEFFFFFF0100000004000000FDFFFFFFFFFFFFFF00000000FFFFFFFF01000000FCFFFFFF05000000FFFFFFFFFCFFFFFFFEFFFFFFFFFFFFFF00000000000000000400000001000000FEFFFFFFFCFFFFFF0700000000000000FEFFFFFFFFFFFFFFFDFFFFFF05000000040000000100000005000000FCFFFFFFFEFFFFFFFEFFFFFF060000000300000003000000000000000100000002000000FEFFFFFF0200000004000000000000000100000000000000FDFFFFFFFFFFFFFF02000000FDFFFFFF0400000001000000020000000000000000000000FBFFFFFFFEFFFFFFFBFFFFFF00000000030000000300000000000000020000000000000000000000FEFFFFFF010000000400000000000000FFFFFFFFFDFFFFFF0100000008000000050000000000000002000000FCFFFFFFFEFFFFFF0000000003000000020000000400000000000000FFFFFFFFFEFFFFFF03000000FFFFFFFFFEFFFFFFFFFFFFFFF8FFFFFF040000000000000002000000030000000000000002000000FBFFFFFF000000000200000000000000FDFFFFFF010000000400000001000000"> : tensor<20x20xi32>
    return %c, %c_0 : tensor<1x20xi32>, tensor<20x20xi32>
  }
  func.func private @expected() -> (tensor<20x20xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x000000000000000000000000FCFFFFFF00000000010000000100000001000000000000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000020000000000000000000000FEFFFFFF0000000000000000000000000100000000000000FEFFFFFF000000000000000002000000FDFFFFFFFCFFFFFF000000000400000001000000000000000300000002000000FEFFFFFF00000000020000000000000004000000FFFFFFFF0100000000000000000000000000000000000000FEFFFFFF000000000000000000000000020000000100000000000000050000000000000000000000000000000200000000000000040000000000000002000000000000000200000000000000000000000400000000000000F8FFFFFF0000000006000000000000000000000002000000000000000000000000000000FCFFFFFF0000000005000000060000000000000000000000FCFFFFFF000000000000000000000000FDFFFFFF000000000000000002000000000000000000000000000000020000000400000000000000FCFFFFFF000000000000000000000000020000000000000003000000000000000000000002000000FFFFFFFFF8FFFFFF000000000000000000000000000000000000000000000000FEFFFFFF0000000000000000000000000000000006000000000000000000000000000000000000000400000006000000FCFFFFFF08000000040000000600000001000000000000000000000002000000FEFFFFFF00000000FEFFFFFF0000000000000000FBFFFFFF020000000000000005000000000000000400000002000000FFFFFFFFFCFFFFFF04000000040000000000000000000000FEFFFFFF020000000200000000000000FAFFFFFF0000000005000000030000000000000000000000FFFFFFFF0000000004000000FEFFFFFF04000000000000000000000006000000000000000000000001000000000000000200000000000000040000000000000000000000FDFFFFFF0000000000000000F9FFFFFF0000000004000000020000000100000000000000000000000000000001000000000000000100000002000000FEFFFFFF00000000FEFFFFFF0000000000000000000000000300000000000000070000000000000000000000FEFFFFFFFDFFFFFFFCFFFFFF04000000000000000100000000000000FEFFFFFF000000000000000000000000FCFFFFFF0000000000000000000000000000000000000000FFFFFFFF0000000004000000FAFFFFFF03000000FCFFFFFF040000000600000000000000000000000000000000000000FCFFFFFF00000000000000000000000001000000030000000100000000000000FBFFFFFF0000000004000000000000000000000000000000040000000000000000000000000000000000000000000000FEFFFFFF0000000000000000000000000400000000000000000000000000000000000000000000000000000006000000FEFFFFFFFCFFFFFF0000000000000000000000000000000005000000000000000200000000000000FCFFFFFF0000000001000000FBFFFFFF0200000000000000050000000000000000000000040000000000000000000000000000000200000000000000000000000100000000000000FCFFFFFF00000000000000000000000001000000FCFFFFFF0100000000000000FCFFFFFF0000000004000000000000000000000004000000000000000600000000000000000000000000000002000000FEFFFFFF00000000040000000000000001000000050000000000000000000000FEFFFFFF00000000000000000200000000000000000000000000000006000000000000000000000000000000000000000000000000000000FEFFFFFF0000000005000000040000000100000000000000000000000000000000000000FEFFFFFFFBFFFFFF00000000000000000200000000000000000000000000000000000000FEFFFFFF00000000040000000000000005000000FDFFFFFF0100000000000000050000000000000000000000FCFFFFFFFEFFFFFF0000000000000000020000000000000000000000FFFFFFFF020000000200000000000000FEFFFFFF0000000000000000040000000000000000000000030000000000000000000000FAFFFFFF00000000000000000000000004000000010000000000000001000000"> : tensor<20x20xi32>
    return %c : tensor<20x20xi32>
  }
}
