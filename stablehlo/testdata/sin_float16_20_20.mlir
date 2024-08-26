// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xf16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = stablehlo.sine %0 : tensor<20x20xf16>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xf16>, tensor<20x20xf16>) -> ()
    return %2 : tensor<20x20xf16>
  }
  func.func private @inputs() -> (tensor<20x20xf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x3D3DD738B4C16EC51B2C3F3E61C56C357C421731FDBA1E3782C53C34DFC5FB3457BFC638C93CD841BCC05CBCCC3E303A44315B411FC32D364BBEA0427D3E32C824C426C196C1D6C6AB3CD641614317B47FBA0442D1A861C6CB40203E653FC63452BFA841D1B92341903E593F874445C1ADC3224022C63E3D5F431BC348C097BC6A409FC423B4F5A93F3CAE45193A5BB51638EB3DDE3F5EBCAE446B3BFC310AC5CCC2F03ED03C6438C1C15DC3B5C19FB80338D5B0DEBE0543793EE130F0BB72C1CD417543353CC03C6FBCF044F1C0BAC0113245B8ACC599C1A2401A3C2C44FBBA21B82146594095BF433A983B4BC5C8BE2CB9D4C139C2953A4DC105C3D84457475430F73DC8481DBED533833EDDBE983F5946C13E97BC1FBAFF4213C2F521CB3EE93C89BCA4C5EDC388B40F4867BA15C30A4151440042A6BF9F4167BA7CC2944020C0A7C5E6B97C3399451F3CD9C0F83E99BF6B3047BFF043DF3AE3C15CC3753C79BD1D3A143F6842F2BD3CC904445F440FBE9BC029C8FEC591C23FB182B7BD3CF9BF58C117C1A4BCE9AB394264484EBF684426C1313E4A37F9C3C7415DC738C75CC442C50AA276427DC394BBB8C009BCD43DC4C7CBB8D6C4E2C43E418344CEBAECBE313377C04EB984C118C37CBE43BCB043AFC764C1523C8BBF59429A3B16C380C7753FC83C703995C14644C23095A0073E153D643B983691BF2F46173D63C4B2C25C40A645C5C1F1BA4DC50AB6943C4740F742B0BC463953429A411D385BBE2938DEC262445CB880467C3CB2C2EFB0E3B9FCB74FBD0D44DC411EC1A5A25A44B13A35C16330A13F69C0F73684C535C2C33D5834BAC1F53CD34449C3FDA97DB9E442DDB92FC255BC64C0A43AA2473E40A2B17D43F44144BDA145DAB95B46CFC18E3E2AC5ACBE7AB54A3F1A4177C020BD1C287CC46C40ADC13043B64014B6BABF5E3161C472C7003D2740D6B25BC167C1E3B873C3BAC038ADA7B2C63CC644D2BE0B3CD1B40C40E23E8BC1DD3A61BD49C092BED72C163AD6C4CDC16E3D343CDA41DF484441FABD3D3D9F409EBD82C73BB6A7C5A93E6C2F3C3D733F61C0B23C83BF194145B46144E73C3037514241BC843F844278C41CBC56407F448BAC1FC3FFBA"> : tensor<20x20xf16>
    return %cst : tensor<20x20xf16>
  }
  func.func private @expected() -> (tensor<20x20xf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xBB3B8D3893B4073A1A2C003C4A3A52356DAE123122BAE3369A392F346936E734B9BB7F38723BF93298B918BBEF3B97393E3129378236063600BC71B1FD3BE0BABA3A4DB877B533B85B3B19332BB80CB4CEB94530D1A81EAE6D39FE3BB13BB434BCBBEF3451B95738FB3BB83BDDBBC4B722390A3BCB30BB3B24B86536BCBA4BBB6F3AF73B17B4F4A9FC3A8AB8863942B5D237F73B623B1ABBFFBB663AF331943B1134E53B773B2C382FB41D388CB45EB8B137D0B0EABBC2B5FE3BDC30B3BA82B6A5336EB8F23A6B3B29BBCCBBF9B89EB9083212B8973861B5E139D73ADCBA21BAE5B7EBB0973A95BBA439813AB03AF0BBD2B838B3BFA7DD398CB7C235EEBBF73A5130FA3B65B0FEBBC133FD3BEBBB933B202CF23B4BBB8BB995B5ADAEF521EF3B893B40BBCB38DB3979B4B93BBEB93936A93862BB84308ABB3335BEB96D2E063A0DBBB83861B96B3311B9DC3A43B9E23B92BB6730C1BBE3B90F3A4DB21A382E3BD6BB8939D83BDFABF9BBEA3A23BA8ABBFDBBF3B925BB9734843039B13CB7693B4CBB3EB77FB856BBE8ABBF27CD38BEBBA1BB4DB8FF3B0A37FB3901340EBB71BA823BD73A0AA2AEAD89387FBAA4B9C5BAF33BF8BB83B8F03BE23BF537D7BB03BAE6BB223350BAEDB8FEB54F36FDBB00BB2BB9E2BBE8B60E3B9BBB20A8823A403681BBA83B713B07397FB53EBBBE3095A0FC3BA43B623A693698BB5DAEA63B943B8C32903ABEB810B41ABAA83AE6B5493BBF3A59B55FBBE63840A55935DE3700BCF3379B3492BB26B8E232343B8C32EAB05FB9A8B7C4BB50BABB3267B8A5A27CBBF0391AB85F308D3B72BABF368E39DFA8EF3B4A3465B4903BF3BBAF37FCA911B9C9B45AB95FAA11BB7DBAE739CE3BD23A9BB189B84231BEBBDEB858B99F2C86B3FB3B333BF6BB5FB5C03B753850BAABBB1C28CB3B6B3AC9B4FEB6A939EFB57CBB58318F3B57BB983B003BC9B229B7D2B697B868389EB937AD9BB2703BFCBBEEBBC73ABEB4323BE93BCAB50D3ACCBBBABAFBBBD62C8439F03BA5B3D23BF13ADA32FEB4CB37FABBBB3BE939E4BB87BB13B6B838F73B682FBA3BAA3B84BA613BA0BB783838B48FBB873BF33641A4FEBAA03B6CAFC43BD9BA9E3AD0BB8AAC823623BA"> : tensor<20x20xf16>
    return %cst : tensor<20x20xf16>
  }
}
