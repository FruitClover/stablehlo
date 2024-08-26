// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xf16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = stablehlo.exponential %0 : tensor<20x20xf16>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xf16>, tensor<20x20xf16>) -> ()
    return %2 : tensor<20x20xf16>
  }
  func.func private @inputs() -> (tensor<20x20xf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x7B2F2347ADC16CC5633E6F3F4EC040B1744519BB34427BB9C2BBB33AFEB726C1543CB9BE5939D9B91DC47FC86C40F3C1FEC1AE400F438EC1B1C58ABF1FAAFB388B43B7C13C3CD9BEE7C0BCBC233B42C3943E08346C416FBC6BA40C3902C4CFC048BB9C39964768BEFEB8ADBE69B5493A004392C07C40A134B04429BDDD38553DFC41C2C033C44044BEC27A3A2EC20A397B33423C833FFEBC49BC1E45C23090B575C4CABE563ECEBEA5BA2B3EFCC5BC475AC217402DB690B91BB4D3C13A3CB2B6E740DD41C0BE99BEB836953FBFB699BAFAC10F382CC2A8C7A4461A4618BCC3C117BF5AB9CB2A5641F44024B5BDB127C4A7C100C076C300BEA49E36C519BE40BFC636D3422FC4EDBE17C36CB65FAF2EB9094425C54E42392943353E375EBFCBBC9843FB4429C1CFB6973CA83DFCC2E24268B993BA1A432DBF5BC236C073B537BA26BEC1AD52C392BCC342E9B0023F1137224119BC1DC09EBD9545BA31DD4057B1B93ED2C7CBC471C1BCBDE7459341C4BEC4B9F6BC40BCB03DB542D1355C4448452F39643A463DEABC3B27F53C123DAF445F3899C101C42A3D1336B744A9BD004485B97BC07F4461BD064460A393BA83BEBCBFE43CB4C15E2BB03C8B3128401E3DE6BDCC3D29C11B3E4FBAD62FA8B03C45F4C32E44263C37C0F63C10414AC0B5BE66BF71B927B6FBBF5EAD71C4A2C0DA32C543B8C891BD73BE58AA1D3A23C55D3D754143BD92B8CFB6F6C18A454A3A19B908C4F9C591444237864073B61BC12845BF3E6EBCD9C4F4C405C54BC0A142C73DE8C0C73FE141683FAFC40A4295B3844026B805C1A13B1BBDA943D944063C863C4D3D05BCE2394EC33EC0A24314C27AC23B3FC4C50F3A1FC087413F42AD2F48BC0AB21C3241459EBCC43BE03C7E4266406CBBD23C2CB84641B74209C10C3CE4C305C13AC1EFBB7FBB12457C38DA4121C543B32E3EB7C02DB97B41A7BB7B3146389534BEB932B9A0C49CC6AB4397BC9BBCF3C316BFE6B245C5203EF1BF06C6AF3C02C2B8AD9BBD41C62AB9A1C68B3E072FF0416B3FF1428044EA3B972A574366C06940DE379E3522C308C188C1BC34B23C2E38FA40374370C4E5C0F8C6EE45493F8D3F79C2363A4AC50DB4D9BB0CC20AB9"> : tensor<20x20xf16>
    return %cst : tensor<20x20xf16>
  }
  func.func private @expected() -> (tensor<20x20xf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x7F3CE9647F2B861CF0446A46702FCA3A4C5B97368F4D083811369F40DB38E12CE741F631CE3FB437302413089048892A662A31494350F62BE91ADC30A03B743F6E51592BC441C731842DE634E140CC262E45253D864B4835DD3B843FA724C82D70360840B267733249380832B43963402450832EB548583DC9566734593F9643FB4CEE2DAF23625466287E40D329823F0E3DCC418A4698347B353759A43CA739F021DD31E044D731F936AD44281977685829BB477039FC37313AF52AC1414439CD49B14CEB312632163EA8463F390437732AA53ED929C00FFB61FA5EC0352E2B70311938383C354BF349CD39B03A0724952B553024262433F33B961DF83239311C3E954FCE23AA3164275B39213B30381253F91DD94D2B3C8F3D4A3E1331D43492518C58D92C3A394D421D44CB27CF4F123809375B5052315629CB2FB1395C37E132503B96261B35594FDD3AC445393E824ABE351830DB33265CC93CB049C53A5E45940E3E20372CA133B85D0F4CE531C837A13488352544274FC13DE354255AA53F72407943AF341D3CE8421B43C356E83ECB2BAC244643D93DF956C633D3520338D02E9B552B34FD52E33B09374832A130CB42642B3D3C7542C23CFD47304353334344D92C9A444637853CEB3ADD59CD241654A441C72FEA42494A7F2FFC3109310D3872395A305B3B0822502EF43C15523905F53362329D3B4B40051EA543A84B4B3485383A39802AF45B64403B388B24381903564C3ECD485939FC2C6C596745493504203B1FC41E7B2FE04E3D44812DFD46BA4C5F46BC201F4D503AC848C338342D31417734C251F757784132428743DB352C40A326AC2FAE51212A062919466B1A44401430EE4BAE4D823C7D35A03AD73CFA590B354841C4426C4E82485436AD42C038FC4A2E4F292D8041F424342DB12CEF354536FA58023FAA4C111E603AB0440F2E3038BF4B2636BF3CD33E543DCE372E3805218515C85114350F35CF247131733A451DA0446530F5187342592A513BE133E01732386A152245773CDE4C63460550A0556141363CE850192F89488A3EAF3D3C272C2D072C613D7842BF3E054A9C500E228A2DB513E05D2E469B46082959402B1D363A00363A2A4338"> : tensor<20x20xf16>
    return %cst : tensor<20x20xf16>
  }
}
