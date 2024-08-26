// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xi64> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xi64>
    %1 = call @expected() : () -> tensor<20x20xi64>
    %2 = stablehlo.sign %0 : tensor<20x20xi64>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<20x20xi64>, tensor<20x20xi64>) -> ()
    return %2 : tensor<20x20xi64>
  }
  func.func private @inputs() -> (tensor<20x20xi64> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x020000000000000004000000000000000300000000000000060000000000000000000000000000000900000000000000FFFFFFFFFFFFFFFF0200000000000000FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF000000000000000009000000000000000400000000000000FEFFFFFFFFFFFFFF00000000000000000000000000000000FCFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0300000000000000060000000000000000000000000000000300000000000000FDFFFFFFFFFFFFFF00000000000000000500000000000000FEFFFFFFFFFFFFFF0000000000000000FAFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000000000000000000004000000000000000100000000000000010000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF0300000000000000030000000000000003000000000000000500000000000000F9FFFFFFFFFFFFFFFDFFFFFFFFFFFFFF00000000000000000000000000000000000000000000000001000000000000000300000000000000FCFFFFFFFFFFFFFF010000000000000000000000000000000000000000000000050000000000000000000000000000000100000000000000FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000004000000000000000400000000000000FEFFFFFFFFFFFFFF000000000000000001000000000000000100000000000000000000000000000000000000000000000000000000000000FAFFFFFFFFFFFFFF000000000000000002000000000000000000000000000000FFFFFFFFFFFFFFFF00000000000000000600000000000000FDFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF040000000000000002000000000000000500000000000000F9FFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF01000000000000000500000000000000FBFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF02000000000000000000000000000000FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0500000000000000050000000000000000000000000000000400000000000000000000000000000005000000000000000200000000000000000000000000000002000000000000000000000000000000FEFFFFFFFFFFFFFF02000000000000000200000000000000FCFFFFFFFFFFFFFF0100000000000000FDFFFFFFFFFFFFFF0500000000000000FCFFFFFFFFFFFFFF04000000000000000000000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF000000000000000003000000000000000100000000000000FBFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFBFFFFFFFFFFFFFF020000000000000003000000000000000000000000000000FDFFFFFFFFFFFFFF0100000000000000FCFFFFFFFFFFFFFFFAFFFFFFFFFFFFFF02000000000000000300000000000000FEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF03000000000000000000000000000000030000000000000000000000000000000200000000000000F9FFFFFFFFFFFFFF00000000000000000200000000000000030000000000000003000000000000000200000000000000FDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF050000000000000004000000000000000100000000000000FAFFFFFFFFFFFFFF0000000000000000FDFFFFFFFFFFFFFF00000000000000000000000000000000FFFFFFFFFFFFFFFF01000000000000000100000000000000FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF02000000000000000000000000000000000000000000000000000000000000000100000000000000FEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF010000000000000000000000000000000300000000000000FEFFFFFFFFFFFFFF010000000000000000000000000000000400000000000000010000000000000000000000000000000000000000000000FCFFFFFFFFFFFFFF000000000000000002000000000000000200000000000000FCFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF02000000000000000300000000000000FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0400000000000000FCFFFFFFFFFFFFFF0000000000000000FBFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000000000000020000000000000000000000000000000100000000000000FFFFFFFFFFFFFFFF010000000000000000000000000000000200000000000000FEFFFFFFFFFFFFFF0000000000000000FDFFFFFFFFFFFFFF03000000000000000100000000000000FFFFFFFFFFFFFFFF00000000000000000200000000000000020000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF0400000000000000FCFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000000000000000000000000000004000000000000000100000000000000000000000000000005000000000000000000000000000000F7FFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0700000000000000FEFFFFFFFFFFFFFF0000000000000000040000000000000000000000000000000000000000000000000000000000000003000000000000000500000000000000040000000000000003000000000000000000000000000000FFFFFFFFFFFFFFFF00000000000000000000000000000000FDFFFFFFFFFFFFFF0000000000000000010000000000000001000000000000000200000000000000FDFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF02000000000000000100000000000000000000000000000002000000000000000000000000000000040000000000000000000000000000000200000000000000FAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000FEFFFFFFFFFFFFFF00000000000000000300000000000000FFFFFFFFFFFFFFFF00000000000000000100000000000000FFFFFFFFFFFFFFFF01000000000000000500000000000000FFFFFFFFFFFFFFFF0100000000000000FEFFFFFFFFFFFFFF01000000000000000500000000000000FCFFFFFFFFFFFFFF0100000000000000FCFFFFFFFFFFFFFF0200000000000000000000000000000001000000000000000100000000000000020000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000FEFFFFFFFFFFFFFF010000000000000000000000000000000000000000000000FEFFFFFFFFFFFFFF00000000000000000200000000000000020000000000000002000000000000000000000000000000FEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0800000000000000FEFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0200000000000000FDFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF03000000000000000000000000000000FDFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFAFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF0000000000000000FEFFFFFFFFFFFFFF00000000000000000300000000000000030000000000000006000000000000000000000000000000FFFFFFFFFFFFFFFFFCFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000FEFFFFFFFFFFFFFF00000000000000000600000000000000FAFFFFFFFFFFFFFF000000000000000001000000000000000000000000000000FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0500000000000000010000000000000003000000000000000000000000000000FEFFFFFFFFFFFFFF00000000000000000100000000000000FAFFFFFFFFFFFFFF0300000000000000F9FFFFFFFFFFFFFFFEFFFFFFFFFFFFFF05000000000000000200000000000000FEFFFFFFFFFFFFFFF8FFFFFFFFFFFFFF0100000000000000FEFFFFFFFFFFFFFFFAFFFFFFFFFFFFFF00000000000000000000000000000000FDFFFFFFFFFFFFFF0200000000000000FEFFFFFFFFFFFFFF0000000000000000000000000000000002000000000000000000000000000000020000000000000000000000000000000000000000000000FBFFFFFFFFFFFFFF000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000FEFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000020000000000000002000000000000000000000000000000FEFFFFFFFFFFFFFFFBFFFFFFFFFFFFFF040000000000000001000000000000000500000000000000FDFFFFFFFFFFFFFF040000000000000006000000000000000200000000000000"> : tensor<20x20xi64>
    return %c : tensor<20x20xi64>
  }
  func.func private @expected() -> (tensor<20x20xi64> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x010000000000000001000000000000000100000000000000010000000000000000000000000000000100000000000000FFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000001000000000000000100000000000000FFFFFFFFFFFFFFFF00000000000000000000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0100000000000000010000000000000000000000000000000100000000000000FFFFFFFFFFFFFFFF00000000000000000100000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000000000000000000001000000000000000100000000000000010000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF0100000000000000010000000000000001000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000000000000000000001000000000000000100000000000000FFFFFFFFFFFFFFFF010000000000000000000000000000000000000000000000010000000000000000000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000001000000000000000100000000000000FFFFFFFFFFFFFFFF000000000000000001000000000000000100000000000000000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF000000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFF00000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF010000000000000001000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF01000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0100000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000100000000000000000000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFF01000000000000000100000000000000FFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFF01000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000001000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF010000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01000000000000000000000000000000010000000000000000000000000000000100000000000000FFFFFFFFFFFFFFFF00000000000000000100000000000000010000000000000001000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF010000000000000001000000000000000100000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF00000000000000000000000000000000FFFFFFFFFFFFFFFF01000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01000000000000000000000000000000000000000000000000000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF010000000000000000000000000000000100000000000000FFFFFFFFFFFFFFFF010000000000000000000000000000000100000000000000010000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF000000000000000001000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000010000000000000000000000000000000100000000000000FFFFFFFFFFFFFFFF010000000000000000000000000000000100000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF01000000000000000100000000000000FFFFFFFFFFFFFFFF00000000000000000100000000000000010000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000001000000000000000100000000000000000000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFF0000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000100000000000000010000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFF00000000000000000000000000000000FFFFFFFFFFFFFFFF0000000000000000010000000000000001000000000000000100000000000000FFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01000000000000000100000000000000000000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF00000000000000000100000000000000FFFFFFFFFFFFFFFF00000000000000000100000000000000FFFFFFFFFFFFFFFF01000000000000000100000000000000FFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFF01000000000000000100000000000000FFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFF0100000000000000000000000000000001000000000000000100000000000000010000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF010000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF00000000000000000100000000000000010000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01000000000000000000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF00000000000000000100000000000000010000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF00000000000000000100000000000000FFFFFFFFFFFFFFFF000000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0100000000000000010000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFF00000000000000000100000000000000FFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01000000000000000100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000FFFFFFFFFFFFFFFF0100000000000000FFFFFFFFFFFFFFFF0000000000000000000000000000000001000000000000000000000000000000010000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000010000000000000001000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF010000000000000001000000000000000100000000000000FFFFFFFFFFFFFFFF010000000000000001000000000000000100000000000000"> : tensor<20x20xi64>
    return %c : tensor<20x20xi64>
  }
}
