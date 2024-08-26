// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<4x2x3x5xf64> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[0, 4]> : tensor<2xi64>
    %0:2 = call @inputs() : () -> (tensor<4x2x3x5xf64>, tensor<4x3xf64>)
    %1 = call @expected() : () -> tensor<4x2x3x5xf64>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1, 3], scatter_dims_to_operand_dims = [1, 3]>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<f64>, %arg1: tensor<f64>):
      %3 = stablehlo.add %arg0, %arg1 : tensor<f64>
      stablehlo.return %3 : tensor<f64>
    }) : (tensor<4x2x3x5xf64>, tensor<2xi64>, tensor<4x3xf64>) -> tensor<4x2x3x5xf64>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<4x2x3x5xf64>, tensor<4x2x3x5xf64>) -> ()
    return %2 : tensor<4x2x3x5xf64>
  }
  func.func private @inputs() -> (tensor<4x2x3x5xf64> {mhlo.layout_mode = "default"}, tensor<4x3xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x3393EBE9868F0D405C233E2CF19420C029DFC250B7AAE33F5447A73BEC0202402071A6FAA7FFDBBF49C829F3B01A0040C1774C74D899F53F121A7BBF10BE1640625780548FB3F2BF5FF80988153DEBBFD8C32ADB1ED901C0650D422956E41040D499DCD33E9C08C0F04553F7B83801C0F8B6763B524E0FC0E867CC01F21F1440F8714027718EA4BFFAD884F32769BA3F7296F9FB57000BC0C74A30508F2E01C0C82733AE21AEF3BF60398373C94006C01AC86F625050F0BF7EE58012BC171BC07609C2CF0D30BE3F6A08FAA6835C04406EF0B0A7D98E02C0310843D05D4BF13F626900E72317D83F696070B05F2804C0564FFAC604CCF0BFF0E26FD96D5DF03F02F56177DD6005409141E42A934102C052BFE4740D0CE6BF185A20F1E1B80AC00A1BC127B420FA3FAB593794C347F8BF15D9F163DD01E3BFE06ED5DDBCA7034034AF945F03B2FD3FEA86F40C7BEAF23F8E571230A649E1BF4229A169930300C0602766DF6C41F1BFCE55D686532105C01399F28BC03510405DFFB7DB68CEF13FCC869C63679BEC3FD1BE57475772C4BFF06DC0F55B930640D11A574611060040B75DF3C22046014060BEECC5BF451BC04EF76FA94FA8DF3FCD74009F284B174018846FCC01460A406D13370A7B78F1BFB0B26665E94CE3BFD64F89BCE289F93F4E001605D2CAE1BFA0B6478EF1081140D2EFCF46AF9FF5BF9E969D42382F044073DCF305137F0E401E0EF7E739FFFD3F06A82F325261D43F3884E054ED750CC01DB43BF9C1B1E93F8B74201A0504C5BF629B41ECB27EF8BF8620865276BFE23FB88EF5FE0AAB11C067DBF425D97704C0F410B13346820BC0A2DF3C5D76A81C408CE7D5FF44A702402F3DC4394124E5BFBD7B6AE9C25FE4BFE31E922575F907C0424DBA67E7E50EC086ED1CD7E803F13FB8B3903C464908C0FF911B1A41A100C0E301BBD059AF0140B39E5B7C2BED11C0C4EA2CABF9C3F4BF62D5C49B48F2FCBF76C32A251D7FF9BF9D489B9305080440097B9BB35DFDD33FAE7D1AF1A6CB1840A1BA9037010BFB3FA07090F7E6EB0CC082A1855BDA49EABF89A0C5001617FFBFE58A2C09D7F501C0F8D1740F1ADEF1BF4958AAE95FB2EE3F7BF15C88352315C09EF55B6CD701EABF208B9807E047FD3FF695F55B07950440CA4C96265268F8BF27ED36DD5FDD0540B1EDC1E0706704C0050BE917C50711C01B68C0EFF979DCBF21B75B10DA7DFBBF67BD2EF6C4BBEA3F70C9B01C2A47EA3F446BADAE4D090DC03025B76F8C0A0340593838A9D76402C0D4AC12982E350B40D2FA5920B6201A4047662C4FA72FC1BFC34FB4526CD80F40244DA924E58009404432C1249D1B1040"> : tensor<4x2x3x5xf64>
    %cst_0 = stablehlo.constant dense<[[-0.8610660852659282, -3.7156571730132755, 2.6084720846056428], [-1.6718185192922048, -2.5080623898248837, -0.83309610862231942], [-0.73976570329324853, 2.9103196499807318, 0.97003633068516648], [-3.1645145985901451, 5.9193658789130001, 3.265285344365215]]> : tensor<4x3xf64>
    return %cst, %cst_0 : tensor<4x2x3x5xf64>, tensor<4x3xf64>
  }
  func.func private @expected() -> (tensor<4x2x3x5xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x3393EBE9868F0D405C233E2CF19420C029DFC250B7AAE33F5447A73BEC0202407633E839D7C6F4BF49C829F3B01A0040C1774C74D899F53F121A7BBF10BE1640625780548FB3F2BFA234E6EC774412C0D8C32ADB1ED901C0650D422956E41040D499DCD33E9C08C0F04553F7B83801C0D6DD6E3D57E0F4BFE867CC01F21F1440F8714027718EA4BFFAD884F32769BA3F7296F9FB57000BC0C74A30508F2E01C0C82733AE21AEF3BF60398373C94006C01AC86F625050F0BF7EE58012BC171BC07609C2CF0D30BE3F6A08FAA6835C04406EF0B0A7D98E02C0310843D05D4BF13F626900E72317D83F696070B05F2804C0564FFAC604CCF0BFF0E26FD96D5DF03F02F56177DD6005409141E42A934102C01AD882C0E5E202C0185A20F1E1B80AC00A1BC127B420FA3FAB593794C347F8BF15D9F163DD01E3BFC086E4738931AABF34AF945F03B2FD3FEA86F40C7BEAF23F8E571230A649E1BF4229A169930300C0387A3575C995FEBFCE55D686532105C01399F28BC03510405DFFB7DB68CEF13FCC869C63679BEC3FD1BE57475772C4BFF06DC0F55B930640D11A574611060040B75DF3C22046014060BEECC5BF451BC04EF76FA94FA8DF3FCD74009F284B174018846FCC01460A406D13370A7B78F1BFB0B26665E94CE3BFD64F89BCE289F93F4E001605D2CAE1BFA0B6478EF1081140D2EFCF46AF9FF5BF9E969D42382F0440EA1501BE089408401E0EF7E739FFFD3F06A82F325261D43F3884E054ED750CC01DB43BF9C1B1E93F0F8F8A5915F80540629B41ECB27EF8BF8620865276BFE23FB88EF5FE0AAB11C067DBF425D97704C0E8444FCBA3BF03C0A2DF3C5D76A81C408CE7D5FF44A702402F3DC4394124E5BFBD7B6AE9C25FE4BFE31E922575F907C0424DBA67E7E50EC086ED1CD7E803F13FB8B3903C464908C0FF911B1A41A100C0E301BBD059AF0140B39E5B7C2BED11C0C4EA2CABF9C3F4BF62D5C49B48F2FCBF76C32A251D7FF9BF9D489B9305080440097B9BB35DFDD33FAE7D1AF1A6CB1840A1BA9037010BFB3FA07090F7E6EB0CC080AE869E63E30FC089A0C5001617FFBFE58A2C09D7F501C0F8D1740F1ADEF1BF4958AAE95FB2EE3F381FF8BAC551E43F9EF55B6CD701EABF208B9807E047FD3FF695F55B07950440CA4C96265268F8BF0817B4E456FE1740B1EDC1E0706704C0050BE917C50711C01B68C0EFF979DCBF21B75B10DA7DFBBF67BD2EF6C4BBEA3F70C9B01C2A47EA3F446BADAE4D090DC03025B76F8C0A0340593838A9D76402C0D4AC12982E350B40D2FA5920B6201A4047662C4FA72FC1BFC34FB4526CD80F40244DA924E58009404432C1249D1B1040"> : tensor<4x2x3x5xf64>
    return %cst : tensor<4x2x3x5xf64>
  }
}
