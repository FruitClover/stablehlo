// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xi16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<20x20xi16>, tensor<20x20xi16>)
    %1 = call @expected() : () -> tensor<20x20xi16>
    %2 = stablehlo.shift_right_arithmetic %0#0, %0#1 : tensor<20x20xi16>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<20x20xi16>, tensor<20x20xi16>) -> ()
    return %2 : tensor<20x20xi16>
  }
  func.func private @inputs() -> (tensor<20x20xi16> {mhlo.layout_mode = "default"}, tensor<20x20xi16> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x0000FFFF03000000FDFF0000FFFF000002000000010004000200FBFF0000FDFF010003000000FEFFFDFFFFFF0600FEFFFEFFFFFFFFFF0300010000000000FEFFFEFF0000FFFFFDFFFEFF0000FFFF0200000000000B000000FFFFFEFFFCFF0400FAFF000001000000FFFF04000200FFFFFFFFFEFFFFFFFEFF020000000200FCFF000003000400FFFFFFFF0000FCFF0000FFFF0000040000000100FFFF0400FEFFFCFFFDFF00000100010003000300FFFFFFFFFDFF00000500FCFF0100FFFFFFFFFEFF02000000010002000400FDFF0000FFFF040002000100010000000000FFFFFFFFFDFFF9FF04000300020002000300FDFF01000300000002000300FDFFFFFF010002000200000000000000FEFFFBFFFBFFFDFF0500FCFF0000000005000000FFFFFEFF030005000300000000000000FFFFFFFF0500FFFF0000FDFFFEFF0000FDFF0400FFFFFEFFFFFF000000000500FDFFF7FF0000000000000000020001000000FCFFFFFF0100FEFF0000FEFF000000000100FFFF0000FEFFFEFFFAFFFAFF0200FEFF0000FFFF00000700050004000000FDFFFCFF0000000001000100FFFF0000FDFF0000030002000300060000000000FCFF0000000000000400FDFF01000200FFFF0000FFFF0000000002000000FEFFFFFF0600FEFFFEFFFEFFFAFFFFFF04000000000002000100000002000200050000000000FBFF0400FFFF010000000000010001000400FEFF0000010007000000FFFFFAFFF9FFFFFF0100F6FF01000000FEFF0000FCFFFDFF000000000000000003000200FFFF030004000400FDFF0300FFFFFBFF00000000FFFFFFFFFDFF00000300000000000000FCFFFFFFFFFF020000000100000000000100FDFF05000000FAFF0100FEFF030004000000000003000000040001000000000005000000FFFFFEFF04000000060000000300FDFFFFFFFFFF01000000FEFFFEFF00000600FDFFFFFFFDFF0200000000000000040000000100FDFFFEFFFAFF04000100FFFF0200020002000100FEFF00000200FBFF00000500FFFFFBFFFBFF01000200FEFF02000100FEFF0000FEFF00000500FEFFFFFF0300FDFFFDFF0600FBFF000002000500FDFFFDFF03000000000002000000"> : tensor<20x20xi16>
    %c_0 = stablehlo.constant dense<"0x0200000002000500FFFF030000000000030000000000000003000300FEFF01000000000000000000FFFF000000000100FCFF0000FAFF000001000700000000000000FEFFFEFF0100020000000000FBFF0000FCFF0200020000000400020000000100FFFF050000000000FCFF00000300020000000000FAFFFCFFFDFFFFFFFEFF010003000000FEFFFBFF0000FEFF04000000FDFFFDFFFFFF03000100000005000000FEFFFFFFFFFFFEFF00000000FDFF020002000100FDFF0100FBFF0200030000000000000000000100FDFFFEFFFFFF0300FFFF000008000200FDFF010001000100FFFF040001000200FFFF000000000300FDFF0400FFFF01000000FFFF0000FFFF0100030000000100FEFF0200010001000000000000000000FDFFFFFF0100FCFFFFFF03000800FFFFFCFF00000600FDFF0200FFFF01000000030000000300000001000100FFFF0200FFFFFFFF030001000000030002000000FFFF0000FBFF00000400FAFF01000000000005000000FDFF010002000300010002000000FDFFFDFFFDFF02000000FCFFFCFFFFFF00000100F8FFFEFF00000000010002000200FDFF00000200FDFF050006000300FFFF060000000200FEFF0100FFFFFEFFFBFF010001000000FBFFFFFF0000000000000000000002000200FFFF0000FEFFFEFFFFFF0400F9FFFFFFFDFF0000FEFF020002000200FFFF050000000400FFFFFDFFFFFF000003000100060004000100FAFF010000000100FDFF0000FEFFFEFF050000000000000000000100FDFF010001000000000003000000FDFFFAFF000003000100FBFFFDFF0100FEFF03000100FCFF0500020000000000FEFFFDFF020004000500FEFF050000000000FDFF0100FEFFFEFFFEFF0A00070000000400FDFF000000000000000001000200030003000400FBFFFDFFFDFF0100000001000000060003000000FEFFFEFF0200060000000400FBFFFCFF01000000000000000000FFFF0000FEFF0300FFFFFFFF000000000100020002000000FEFF0000FCFF0100FFFF00000000FEFFFFFF00000200FDFF0100000000000200010004000000FEFF0000FDFF00000000FCFFFEFF0000FFFFFEFF05000100F9FF0200FEFF000003000000"> : tensor<20x20xi16>
    return %c, %c_0 : tensor<20x20xi16>, tensor<20x20xi16>
  }
  func.func private @expected() -> (tensor<20x20xi16> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x0000FFFF00000000FFFF0000FFFF000000000000010004000000FFFF0000FEFF010003000000FEFFFFFFFFFF0600FFFFFFFFFFFFFFFF0300000000000000FEFFFEFF0000FFFFFEFFFFFF0000FFFF00000000000002000000FFFFFFFFFFFF0400FDFF000000000000FFFF00000200FFFFFFFFFEFFFFFFFFFF000000000000FFFF000000000400FFFFFFFF0000FFFF0000FFFF0000000000000000FFFF0400FFFFFCFFFFFF00000000000003000300FFFFFFFFFFFF00000000FEFF0000FFFFFFFFFEFF02000000010001000000FFFF0000FFFF000002000000000000000000FFFFFFFFFFFFFFFF02000000000002000300FFFF00000000000001000300FFFFFFFF000001000000000000000000FFFFFDFFFDFFFDFF0500FCFF0000000000000000FFFFFFFF000000000000000000000000FFFFFFFF0000FFFF0000FFFFFEFF0000FDFF0200FFFFFFFFFFFF000000000000FEFFF7FF0000000000000000020000000000FFFFFFFF0000FEFF0000FFFF000000000000FFFF0000FFFFFFFFFAFFFFFF0000FFFF0000FFFF00000000000004000000FFFFFFFF0000000000000000FFFF0000FDFF0000000000000000000000000000FCFF0000000000000000FFFF00000100FFFF0000FFFF0000000002000000FEFFFFFF0100FFFFFFFFFEFFFFFFFFFF00000000000000000000000000000000010000000000FFFF0400FFFF000000000000010000000200FFFF0000000000000000FFFFFDFFFFFFFFFF0000FFFF00000000FEFF0000FCFFFEFF000000000000000003000000FFFF000000000400FFFF0100FFFFFFFF00000000FFFFFFFFFFFF00000000000000000000FFFFFFFFFFFF000000000000000000000000FEFF00000000FFFF0000FFFF030000000000000003000000040000000000000000000000FFFFFFFF00000000060000000300FFFFFFFFFFFF00000000FFFFFFFF00000000FFFFFFFFFEFF0200000000000000000000000000FFFFFFFFFFFF04000100FFFF0000000002000000FEFF00000100FFFF00000500FFFFFFFFFBFF00000000FFFF02000100FFFF0000FFFF00000000FEFFFFFF0300FDFFFFFF0000FBFF000000000000FEFFFFFF00000000000000000000"> : tensor<20x20xi16>
    return %c : tensor<20x20xi16>
  }
}
