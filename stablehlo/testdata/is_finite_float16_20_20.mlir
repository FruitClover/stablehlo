// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xi1> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xi1>
    %2 = stablehlo.is_finite %0 : (tensor<20x20xf16>) -> tensor<20x20xi1>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<20x20xi1>, tensor<20x20xi1>) -> ()
    return %2 : tensor<20x20xi1>
  }
  func.func private @inputs() -> (tensor<20x20xf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xC9B0A4C4AC38A744DB45CDB6713BD94336C5E341571D10C4B04458C089429AC1EB3BA145CE3E19C53C3D7F46BD41E9C2F83EF6BC50B620BF0244994329C2E1A6203DAE38FF43BBBA08B794C24F3EAC43F638F93596C3AAC47A39F044214421BC77C76FC4A03C9FC90D410E4024C23441E8C5B846023BF9BFAF416A242C43F2ACA434214484C17F447C4142BF67BDBDC17040BA39493FB93C5A3446C1C2C2EA41A5C5C2A9AD3D8BC503C3A64153C4F73CE7C058BB543ABBC460438CC03A34E543B8B468B15CC17AB93A432AC33AB83241A33B8FBE7E393DC2A03CF241FA35BDC3123528C4F3B9ED44A84012C0CC3C04456CC0BB3D2BC4384167BD773B3F3509C341C269C5D9C2CA38D3BE0CBBC1C5B23F0C3E3FC20ABF8742EEBE4244673D4AB7DB3E40C59E3E264067BCE3406C35D5C057457D3F614117C0EB40BBC51444BDBBCB396FBE354840B8EEC3BA43CFC5CA41284004C1AE432DB5954148337AC445C1F9C7E1B8E6B22743EABA6C3B893D2FC5853829C029C13941DA32B0B91AC494406B3A27C13F40EDC0293E6EBE093EFA39ED38AB46C0C3EBBBD839A0C21AC13542B1BE05BDA3C2DA3F8C447A40263A0745214399485F44E5BB13C442C2D8BE9BBE26C345C4AFC477BDB9427A41E23813C0D6C670C149BE2DC11543A640DB305FC459432B44604141C069477FC74BB9A8C26DC343BEFBB95643C33E50379F4625C1BC41D83C2EC216467E429C38BA2C26423FC2314135BF913C6FBAD3C060B98CBCFF4126445740593DFC3D2D32ECB76E44013F5C432AC2B2BD3E2EA24062B4AAB8C3C592BD62C3A5BACAC46C4158C43BC4D7C21AB82445313EFA3C96C100B72C41F346C445F94410C303C238C2D0C6B54031C16238EFC0D64356371B3D884011C32D3B964007321EC54343ADC44F43CB413D4533C46BB4D5BE883416437DBC4CC47AC390C1392A73BBC845ECC27EB139BD68381442E33DE23CF13EB62C17C01C40CAAD36C395B973C599BF9A418B3FAC381A45E846B2C5FFC14B3D98C2DA4459395E44BCBD56BB553A1AB1CEBE623E903BD040993EC1BDE8BA713A28C018C539C02D42AF3CB9BE78C1B940EFC2F6452F409E443342343F663DD54221BDD440E13D"> : tensor<20x20xf16>
    return %cst : tensor<20x20xf16>
  }
  func.func private @expected() -> (tensor<20x20xi1> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<true> : tensor<20x20xi1>
    return %c : tensor<20x20xi1>
  }
}
