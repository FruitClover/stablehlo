// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xi32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<1x20xi32>, tensor<20x20xi32>)
    %1 = call @expected() : () -> tensor<20x20xi32>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [0, 1] : (tensor<1x20xi32>) -> tensor<20x20xi32>
    %3 = stablehlo.or %2, %0#1 : tensor<20x20xi32>
    stablehlo.custom_call @check.expect_eq(%3, %1) {has_side_effect = true} : (tensor<20x20xi32>, tensor<20x20xi32>) -> ()
    return %3 : tensor<20x20xi32>
  }
  func.func private @inputs() -> (tensor<1x20xi32> {mhlo.layout_mode = "default"}, tensor<20x20xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[-2, -2, -1, 3, 0, -2, 0, 0, 0, -2, 2, 0, 3, 1, 0, -1, -3, 3, -4, 0]]> : tensor<1x20xi32>
    %c_0 = stablehlo.constant dense<"0x02000000FCFFFFFF010000000200000003000000FCFFFFFF000000000100000000000000040000000000000000000000FAFFFFFF0000000000000000FEFFFFFF0200000003000000020000000000000003000000FDFFFFFF00000000FDFFFFFF000000000000000003000000FFFFFFFF0000000000000000FFFFFFFF0100000000000000FBFFFFFF03000000FBFFFFFF00000000FFFFFFFFFEFFFFFF0200000002000000FFFFFFFFFEFFFFFFFDFFFFFF00000000FFFFFFFFFFFFFFFF03000000FDFFFFFF02000000000000000000000000000000FFFFFFFF030000000000000000000000FDFFFFFFFEFFFFFFFEFFFFFF0000000001000000FAFFFFFF02000000FCFFFFFF080000000000000000000000FBFFFFFFFDFFFFFFFCFFFFFF00000000FCFFFFFF01000000FFFFFFFFFFFFFFFFFEFFFFFF0000000000000000FFFFFFFFFCFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFF0000000002000000FEFFFFFFFEFFFFFFFCFFFFFFFFFFFFFFFFFFFFFF02000000FDFFFFFF0200000001000000FFFFFFFF01000000FBFFFFFF01000000FCFFFFFFFEFFFFFFFDFFFFFF050000000000000003000000000000000200000001000000FFFFFFFF01000000030000000000000005000000070000000400000003000000FEFFFFFF00000000FBFFFFFFFFFFFFFFFFFFFFFF010000000000000000000000FDFFFFFF00000000FAFFFFFF0100000001000000FFFFFFFF02000000FFFFFFFF01000000FFFFFFFFFFFFFFFFFFFFFFFFFCFFFFFFFFFFFFFFFFFFFFFF02000000FFFFFFFFFDFFFFFF02000000FFFFFFFF00000000FDFFFFFF00000000000000000000000002000000020000000300000004000000FAFFFFFF00000000FDFFFFFF040000000000000002000000FDFFFFFF0000000000000000FCFFFFFF0000000002000000FEFFFFFF02000000000000000100000000000000FEFFFFFF04000000FFFFFFFF0100000001000000000000000000000002000000FDFFFFFF040000000000000006000000FEFFFFFF00000000FEFFFFFF000000000000000002000000010000000000000001000000FFFFFFFF0000000000000000000000000400000005000000FFFFFFFFFFFFFFFF0000000005000000020000000400000000000000000000000300000003000000020000000100000000000000FFFFFFFFFEFFFFFFFCFFFFFFFFFFFFFF0200000000000000FDFFFFFFFDFFFFFF01000000FFFFFFFF02000000FBFFFFFF01000000FFFFFFFFFFFFFFFF00000000FFFFFFFF00000000FEFFFFFFFBFFFFFFFCFFFFFFFCFFFFFF08000000FDFFFFFFFEFFFFFF0100000000000000000000000500000003000000FFFFFFFF03000000FDFFFFFFFEFFFFFFFFFFFFFF070000000000000003000000FEFFFFFF00000000000000000000000002000000FFFFFFFFFEFFFFFFFFFFFFFFFEFFFFFF040000000000000002000000030000000300000003000000020000000000000002000000000000000000000000000000FFFFFFFF01000000030000000000000000000000FEFFFFFFFBFFFFFF0100000002000000FDFFFFFF0100000000000000000000000000000001000000030000000000000001000000FBFFFFFF010000000300000006000000FEFFFFFFFCFFFFFFFFFFFFFF0100000002000000000000000000000004000000FFFFFFFFFBFFFFFF00000000FFFFFFFF0200000000000000FCFFFFFF00000000000000000200000001000000FDFFFFFFFEFFFFFF0000000003000000000000000000000000000000FCFFFFFF00000000FBFFFFFF01000000FAFFFFFFFAFFFFFF01000000010000000200000000000000FDFFFFFF000000000500000003000000000000000000000001000000FFFFFFFFFFFFFFFFFCFFFFFF00000000070000000200000001000000FBFFFFFFFCFFFFFF01000000050000000200000001000000FEFFFFFF04000000FAFFFFFF05000000FFFFFFFF0600000000000000FBFFFFFF00000000FFFFFFFFFFFFFFFF00000000FCFFFFFF0600000000000000FDFFFFFF020000000300000000000000FEFFFFFF000000000000000001000000FEFFFFFF03000000FFFFFFFF00000000FCFFFFFF02000000010000000100000000000000FFFFFFFF000000000200000000000000FDFFFFFF030000000000000000000000FFFFFFFF02000000FCFFFFFFFFFFFFFF03000000010000000100000004000000FFFFFFFFFEFFFFFF0000000000000000"> : tensor<20x20xi32>
    return %c, %c_0 : tensor<1x20xi32>, tensor<20x20xi32>
  }
  func.func private @expected() -> (tensor<20x20xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0xFEFFFFFFFEFFFFFFFFFFFFFF0300000003000000FEFFFFFF000000000100000000000000FEFFFFFF0200000000000000FBFFFFFF0100000000000000FFFFFFFFFFFFFFFF03000000FEFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FEFFFFFF03000000FFFFFFFF00000000FEFFFFFFFFFFFFFF0100000003000000FBFFFFFF03000000FFFFFFFFFDFFFFFFFFFFFFFFFEFFFFFF02000000FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF03000000FDFFFFFFFEFFFFFF020000000000000003000000FFFFFFFF03000000FFFFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF03000000FCFFFFFFFEFFFFFF0000000000000000FBFFFFFFFFFFFFFFFEFFFFFF00000000FFFFFFFF01000000FFFFFFFFFFFFFFFFFFFFFFFF03000000FCFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF03000000FFFFFFFFFEFFFFFF02000000FEFFFFFFFEFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF03000000FDFFFFFF02000000FFFFFFFFFFFFFFFF03000000FFFFFFFF01000000FEFFFFFFFEFFFFFFFFFFFFFF0700000000000000FFFFFFFF000000000200000001000000FFFFFFFF0300000003000000030000000500000007000000FFFFFFFFFFFFFFFFFFFFFFFFFCFFFFFFFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0300000000000000FFFFFFFF00000000FAFFFFFF01000000FFFFFFFFFFFFFFFF02000000FFFFFFFF01000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF03000000FFFFFFFFFEFFFFFFFDFFFFFF0000000000000000FEFFFFFF02000000020000000300000005000000FAFFFFFFFFFFFFFFFDFFFFFF07000000FCFFFFFF02000000FFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF00000000FEFFFFFFFEFFFFFF0200000000000000FFFFFFFF02000000FEFFFFFF07000000FFFFFFFF01000000FFFFFFFFFDFFFFFF03000000FEFFFFFFFDFFFFFFFEFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF00000000FEFFFFFF000000000000000002000000FFFFFFFF0200000001000000FFFFFFFF0100000000000000FFFFFFFFFDFFFFFF07000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF0700000000000000FEFFFFFF030000000300000002000000FFFFFFFF02000000FFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFDFFFFFF01000000FFFFFFFFFEFFFFFFFFFFFFFF03000000FFFFFFFFFFFFFFFF00000000FFFFFFFF00000000FEFFFFFFFBFFFFFFFCFFFFFFFFFFFFFF09000000FDFFFFFFFFFFFFFFFDFFFFFF03000000FCFFFFFF05000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF070000000000000003000000FEFFFFFF02000000000000000300000003000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFFFFFF00000000FEFFFFFFFFFFFFFFFFFFFFFF0300000002000000FEFFFFFF020000000000000000000000FEFFFFFFFFFFFFFF01000000030000000100000000000000FFFFFFFFFFFFFFFF03000000FEFFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0300000001000000FFFFFFFF0000000001000000FBFFFFFFFFFFFFFF0300000006000000FFFFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF03000000FCFFFFFF04000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF02000000FEFFFFFFFCFFFFFF0000000000000000FEFFFFFF03000000FDFFFFFFFFFFFFFF0100000003000000FFFFFFFFFDFFFFFF03000000FCFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFF01000000FFFFFFFF0200000000000000FDFFFFFFFEFFFFFF0700000003000000030000000100000001000000FFFFFFFFFFFFFFFFFFFFFFFFFCFFFFFF07000000FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01000000FFFFFFFF0200000001000000FEFFFFFFFEFFFFFFFAFFFFFF05000000FFFFFFFF0700000000000000FFFFFFFFFDFFFFFFFFFFFFFFFFFFFFFF00000000FEFFFFFFFEFFFFFFFFFFFFFFFFFFFFFF02000000FFFFFFFF00000000FEFFFFFF00000000FEFFFFFF03000000FEFFFFFF03000000FFFFFFFF00000000FFFFFFFFFFFFFFFF03000000FDFFFFFF00000000FFFFFFFFFEFFFFFFFFFFFFFF03000000FDFFFFFFFFFFFFFF0000000000000000FFFFFFFFFEFFFFFFFEFFFFFFFFFFFFFF030000000100000001000000FFFFFFFFFFFFFFFFFFFFFFFFFCFFFFFF00000000"> : tensor<20x20xi32>
    return %c : tensor<20x20xi32>
  }
}
