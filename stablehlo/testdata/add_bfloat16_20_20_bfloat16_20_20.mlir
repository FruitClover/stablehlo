// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xbf16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<20x20xbf16>, tensor<20x20xbf16>)
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.add %0#0, %0#1 : tensor<20x20xbf16>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> ()
    return %2 : tensor<20x20xbf16>
  }
  func.func private @inputs() -> (tensor<20x20xbf16> {mhlo.layout_mode = "default"}, tensor<20x20xbf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x4640233F884089C06EBF12C06CC09A3DCF3F72C0974045C0653F7E408DC094404C3F78BF0F408C40C33F47BF33C00C40733FBC404BC0163FC240ECBFA0C0A53F71C0E64001C056C0963F0241AEBF0EC02F40344098BF933D35408EBE5D40C33F07BED33FA0C07F3F8ABECCBE5A40723F81BF3040ECBF423E81C06EC08D400240D840AABF603FA03F4F3F94BFA4C046BFA0C015C0E13F44BF5B3FACBFB93F6340373F66C0DEBE923F67C050BF27C07C3F3D3EDEBE4E409FBF45BE8CC03F4077BE50BFB540F93FC240A43E53C048405740ABBE8CBF4DC0763F8640B83F873EEE3F44BF85408BBE3EBEC43F2140DD3F7BBF8E406F3F7D3F1D40A0BE0D4082BE054088401BC0853F993F5ABFBBBFC9BF7F3F9A3B913F3DC0ADBF3BBF5C3FBFC01EBFAD4038BFE5BFC740BDC0E93F0E4024C080C04F40D7BE8CBE70C09CC064C0E8BF0DBEE53FDABFA3C06FC058C0C4BFB53F08C0053F12C0E0BF4E40D63FB8C0713E543F66C09BBE873E513D2FBFD5BF4340954035BF3340D0BF714068BE7F408CBF4CBF2740943F0C3F8ABEBBBF47401AC0BDBF9DC0BE40E13F25BF29C001C113C09CC0594025C0D13F69C0993D0E4080BF344042BDB5BF9BBF67BF38C08BBE1140ED3CAD3FCD3F28404940A43FC9BDAC4028C0214088C09ABFB3402D40DA3F023F81C065C007405140723FC3BFCDBE20C041C067C08B4088BF85BFF5BEBF3F883F29BF5D40424006C0CABF66BF7FC0823F7B40423F35BFE3BC83C091BF3140AF3EAC3EADBE35C051BD4ABF13405E400840A4C0813F9840973F18C02B401AC0C84026C0F13EA6BFD93FFD3E173F8C409DBFF93EA3C0C8BF5ABF13C0A4BF31C09440EEC07DC0D340E43DD1BF0441E93CE740CABF1C40FDBF46BE06C059BF8ABE1FC0C73F4540DE4069BE5D3EA7BF15C186C0DEBC19BFCDBFBA3FB440FA3D31C03140C8BF39BF05C09B3F3D3F7E3F8FC02EC054BFB6C0D740904083C0383D3CC0AC408A3C6B40144037401740C0BF094090BFC0C03840233F333F28C01ABF19C0B44018408D3E704040C017C0A640F140ACC0CBBEB64000C08AC0293FC8C0FC3F3AC020C0994099BF863FE8BEA0BF03C056BF2FC0AC3F83C096404C403440B43E8D3F"> : tensor<20x20xbf16>
    %cst_0 = stablehlo.constant dense<"0x9ABF103E2EC012C0EC3FCB4061407FC050C01240F93E76C02DBF1F408FC074BF07401440044036C053BF4440953F003F1B40A6BF11C08AC00A40A7BFCFBE40C08340DEBFBFBF82C0654042BFA1BFBBBF413F933F51406040A9400E3E8EBF40BF033E053FFDBDA93FD2C0B1C0863E993F413F21C06AC066C08AC08C40ECBF763E0F40D2BEC63F49BF7B40E9BF9C40F7BF85402EBFA33F40BFB240313F5440D3C0DDBD1DBF01C0553FF9BF2040A1C040C002405FBF703D85C00E418DBF2DC0B9C009C0903F753F12C0A23EC13E1640FBBE53C07540A040EE3FEEC06FC0BCBE0AC047C0B0405A40FF3F79C097BF40C0E7BF59BF00408B40A040CD3ED43EF4BD314091BF3E3D1CC07240AD40F240F6BF6DC088BF834029C09540ADBFAD4018BFB340FE3F8240E7BF4CBE03BFE33FE63F103D01C1D44003C0C3C00EC046BF753D763D15402D40423FA540CC3F16C025C008BF974006C0F63FB3BFEF3F4840543F16C0004062BFE73E07BD05BF903F90C00740FB3F143F1A402BC00FC08C3E713F813EA1C0BE3F12C08440003E0540894020C0A8C08EBF2640B2BF5540963E2340F33E22C051C0844097C09A3FDDBE51BE623FF03F0C401940EEBEE2BF20BE884037406840834049BF4140C03E603FAD3E534080C0D7C004C0C03F96BFB63F493FB9C0C2BED4BEF33F7BC0B1404BBEB4C04B40BC3FD04035C033401EBFB1C0DABED13E9C3EC53EA9BF593E9C3EB13F5FC00D4023405CC0B53F823FA140AABF3F3F8D40123F71C05FC02FC006C076C084403FC0D7402F40A14002409CC000C0863FB83F69C06540E9BF3A40A03FA8C0E33F4BC066C0AE3D4EBF3B3E17404E40BCBE1540AA3FE5C0E9BBEC3FDE3F0E40504005C0B23E2140863E04C0A4BF66C08DC076BF274004BF743F3D40D8C093400A40363F293F3640C340BCBF8E3F193F01BF74C051402940163F0E3FD43F4BBFCEBFBF3F6BC0DBBFE9BE8E4007418540D93F1EC0243F5EC0B640BE3F53407BC0FCC0D14089402FC082BF1E3F91BFA5C01AC018C083401AC0993F5D4065BE06BF17C06FBFDFC09F403DBE9E407A3FE83E99C038BF88C01ABF9B3F663F2140E5C0723FCE3E3340C13F824058BFF3BF8A3F063FE23D"> : tensor<20x20xbf16>
    return %cst, %cst_0 : tensor<20x20xbf16>, tensor<20x20xbf16>
  }
  func.func private @expected() -> (tensor<20x20xbf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xF23F473FC43FD2C06A3F824030BE7AC0D1BFC0BFA740DEC0603ECE400EC16B403A40AC3F8A40C43F333F1240D1BF2C4058409240AEC06EC004414AC0ADC0DBBFA83EAE4060C0EDC09840EC4028C06CC05F407E400540654002410EBE1640463F80BB0B40A4C01440DBC0BEC06B40094082BE703EB0C05AC006C1283F244011401041DEBF1B40EE3E97403EC080BE2DC058BF40C04240C2BFCD4027BF984043C01B3F87C01DC0FC3FB2C0D83FF4C001C00E40A7BF5240ADC00B41AFC0903EC1C03DC0D9403A407240233F3BC0AF40384068C02F40E63F344050C013C0D4BD98BE78C01A414940E73F17C0AB3FA3BF32C066403C40AB40EE40B43D2840BFBE9B40484018C0B3BF9F409240C34060C02DC087BFA740B3C0544005C0C840D2C09F40EC40564066C0C140CDC06640804022C041C11E411EC0CCC0BFC0B5C060C0E0BF0C40904072BF803D09C0B7C084C0623F2640CABFB8BE4AC0A3409A409EC007C035408FC0183E6C3EF0BEE23EC5C0A540D44004BEA6408AC0C43F403D9E4058BFBAC0834090BF964014BE1E3FEC409DC0D7C0C0C00841BC3E2C4016C0B0C0E9BFEDC0003EC63F46C01CC0B7BE0140F0BD964009407A3FD6BF2BC042C07F40A4406A40AE40513FB44061400A40763E0B41D4C086C0CAC0983E8E4084401F40A9C08DC080C0804028BFCF40DCBFC1C02C3FC6BF3940C23FDE3FD4BFC0C0883FBC3FB6BE7640DB3FF1BFA3BFF83EEFC04E40CF402CC0353F7D3F703F1EC061409840683F83C0CAC032C038C0C6BFF3405CBFCC3F70401C414E40E8C02C3FAEBFF640C8C0824048C09340DF3F95C0C5408DC047C0A0C018C02BBF803DF83F48C0DE40C4C032C1D340FA3FD03D28415240A4409EBF9E40DCBF10C058C08EC096C05CC085402440FC402E40D1C05240E5C05EC0223F1040904080BCD840383F51C086BFDA3FF63FBFBFE23F19404C3EC2C09DBF90C0EDC0C8400F418B4086409FBF3A40283F503E00418B40B540AEC0B8C0AD40DCBF103EC2BEA83F70C0B8C09AC05040CF4008C09E40E83E25C09540A640CAC0ECC02A410CC0203FD23FBAC034C068C0D8C08640803CF93F044006C18DBFDEBE803D364000BD7640A53F7940603F9B3F"> : tensor<20x20xbf16>
    return %cst : tensor<20x20xbf16>
  }
}
