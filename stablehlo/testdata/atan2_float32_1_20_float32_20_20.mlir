// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<1x20xf32>, tensor<20x20xf32>)
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.broadcast_in_dim %0#0, dims = [0, 1] : (tensor<1x20xf32>) -> tensor<20x20xf32>
    %3 = stablehlo.atan2 %2, %0#1 : tensor<20x20xf32>
    stablehlo.custom_call @check.expect_close(%3, %1) {has_side_effect = true} : (tensor<20x20xf32>, tensor<20x20xf32>) -> ()
    return %3 : tensor<20x20xf32>
  }
  func.func private @inputs() -> (tensor<1x20xf32> {mhlo.layout_mode = "default"}, tensor<20x20xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[3.21661901, -2.18642902, -1.70161474, 0.360160381, -0.697152435, 0.0582824722, 5.63289165, -2.39707184, 1.16670322, -7.44891357, -2.09084773, 0.626925707, -0.445298761, -0.0596289672, -0.549545944, 3.60934186, 0.775961399, -1.93357456, -3.91368222, 2.46272278]]> : tensor<1x20xf32>
    %cst_0 = stablehlo.constant dense<"0xF56EBB40D9D62841038304BFA6E46840A60A404097C4FE3FD5AC69402C1240C0B749B83E7E248A4056A035C0EDBFEE3F467C6CC02ED2D2BD73C9C43E40ED1FBF2D278B3F399A65C0D8ACF7BF913F68BEEEF88E3F298781BF33F80BBEB4CABB3EB2A4943F7E86EA3FB69A14BFCB5D0C400CC98DC03BC65CBEEA81E840B0D4DFC073D227BFB231BBBD08A4A23F5A2AACBF7FB51CC0DCF45C3F9CF2C53F55503ABFE5ECEA3F7DF1444060BB304048D3843F23B5B4BF05505CC0DE6124C0F56C9E3EDCCC0440683665BF48012ABF30E8A0BE63BCC93F84DD79402C38263E545A92C09E467FC026B8A24045CD973F23F3133FA01385C0FB5C1DC0C744E63E189111C04428883F06150AC006462C3F7824B8BFB1E5FB3FE0BEA6BE7AC0883F9AF211BF8A7D493FC7995E408988DBBF74FF9840B270794003549940A7B648C0B11CC7BF7B238A3F80C1403F32552C402D6E3DC087D1713E1EF889BFF0BCD33E0D6E9D40765B81C061CC19400B92C6BF197F9D3F717C44C0D663A3C047B775409FD9D7BFFCE3D6407487063F063A223FFE4FAB3FC87BB63ED1DA1B3F8D8402BE3630A0C095C6CE40A01B3E3F9E644EBCF0810EBE59EAAFC0AB9C463E417A234093A084402F7251BF16375ABF7912F2BE251E123E4BAB20C0E1502AC0F5F62040C78F91C05D82CB3F9A3CFA3F603D6140B0B705C0C91688BF28780D3F588E72BD5AE6D33E68DC06C0B9701D3D81D881C009E4D7BC4BE0BEBFFD6027404FF937BFF7EE373F513CFFBF38290540B207C5BF7D107E40AEAA1C40D766ACBFE702A73F33194140CFFA0D3FB95A5940083F453D9BEA334048E98440B0B5ACBF6724A73FDD6E613E974D3F3F1D375FBE1A9AB5C06A905BC0892BE0BFE20B843F3E1DD1C0595D1D40E018A0BFE8BD24C05C9088BFBE300AC0A467D34073C6D0BFEA7D9940421B8EC0A02B0A40E5F5D340D15554C039CA72C0D95B764014F3EF3F707CF340CBFF75BE2BDB83BF949D22C083CB33C038A5E63F2D5D644047D70FBF4B6C713D93D4B9BFD9355A40C184CDC0439C47BF2C270C41D49808C0D20009C0A264CAC075E624C0FC65233FC0C6C2BEFAFD36C0484F8C40C7B089BF582826BF0D9086BEFEFF14BF1ACB113EBA720AC0E3798D3F7BE3DB3F1CAD99C09854AEBF53C1A6C07C06343E910428409A571DBF3BC9663EF54AEE3F44EE0040090D3E407AAE83406751CF3F2E3135BDB0BC843FC021B3409309194021A23840C209AFBF96C3EDC0C5C63240A69FAB3ECDCBCFBFC9C572402DD38A4081C80DBFC8E74B40B444E43F005F5E40B4AA90C02E059D3E06C8904073C5543AFF9445BF64437D3F878476403B2F6C40C93283BFDE99994030138A3F343DEBBFD652E33F590186BFE6491D3F3CE3333FCBDFECBFE8227E3F32E29AC0CA2DF0BF4B2C003FC21817408B41643F20EF533ECC8FEB3E0FDEE0BE44B8A4409BE3A3BE6341CCC08AE59540738A55C04FC6D6BE7B61F03E730FF3BFF6DAE1C0F6D31440F7202CBF20DC8ABF8823953F9DAAD73F5DAD2E40C2F5603F1B0E95C0F66A7F40E331ECC0D5E39A3F7C2E41401477A4C0AC68AF40B37E463FCB289FBE3BA68B3E81DE68C0D40FEB3FE4F2FF3FE8581FBFB03435C0CB2D7040EA21C2C0A7B78CBF2B9C7C3E2AC98BC0B3CF62BFDF779CBFA022ECBFEB8A55409B0C82C067B74FBF341C04C0F39187C02F620B4060B1EFBFEC22A3BF9D00F33F627905C017A43E3E53E49640177BB13E212D6F3F729A473F963B8640EBDF524016E3A5C0CC9C9C3F524414C084E31A40404C70C08276BABCCD91D2BF02B29C3F33A408C0ABFFB740F887913FFAF2FBBD3032A4C08164F8BE792D1A40038F6EC00CF056C0D795173F2FF1B1C05AF108BF158C724050818E3F1EC839BF217CD7BFE4AB3C3E2342EC40FE6F2840B80EC2C0561E53405D4F8240371E39C0B7C238C0D0C3073FE46E9DBF9821EF3E000B943F7A6D07BF36E5E9C047A94CBDA228BC4097BAA840F51535C0334836C05A052240BB0961BE67E10F3DB316A2C0A0E311C0E6782DC02FF7A63F3F4B32400C3F63BE9C85B13FE7A5C2BF3F568B3F12EFDCC08CE2E5BF4D4C6E40EC836340B1DF83BF1EE0BD3FB09D29C0E2F5A0C09241AD3FD9C7853E9CE4CB3F00CD3FC011C92CBF99E9C4BC6BEFF2C0BFDCF53F540388BF3496D8BF70A5A9BD9E146B3E725297BF636717C05DC77DBF8DDCCF3D21FE7CBF41AB24C0E27B72408452FF3F2C6CECBF999D7DC023DFA440"> : tensor<20x20xf32>
    return %cst, %cst_0 : tensor<1x20xf32>, tensor<20x20xf32>
  }
  func.func private @expected() -> (tensor<20x20xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x4990003F6E3551BE4DDCEEBF340ACA3D3BC369BE9BCFEF3CECE57E3F9CED1DC03AC2A23FC5D485BF7E6C20C0ED03A63EE06241C0C47527C0CFE175BFC8FFDE3F39B21E3FAA6C29C0E4EA01C024D1D43F08489E3FE24500C06F52D3BF03BB463FFA680ABF893F023DD034D63F496C54BF6C95384005C4CCBF76758FBE4B574340E5DF22C03D1124C03700D1BEA8B8F63FC06B3540865293BFD6E498BF85D7ED3F52B1863FCF241EBF4F600DBFF20AAB3EC4B42BC07CFA474075D2FF3F46A1B8BF4920033FC55FD8BF396DF0BF3A4502402EFC8CBEA7377ABC884CA4BF8D4D1E40D2C33C404A0BBABE7966A3BFD68EAB3F50ED1E40768B1AC0C2FCA7BFD6023F40D58414BF5F554740A2D7B93F042007C071FF083F98A7CEBF93988CBFCDC2134057CE03BFEF6D8CBC823735C0C289253F213D493E7C61C4BE28C40FC00E96084095A09F3F2C9C9EBF3B4610BFF84F4140A7419FBFD09A45406EAEBF3F8722E8BE48143740F71DA1BF74620DC0EB44F13EE9D73FC0865048C0409511BEF7800040619AEB3D3F18A7BFC283B4BFCE57893FCAEFBA3F124DA6BFC0A1D2BF18774440171BDCBDB967A03D2259C93F247CD0BF85AD3B40D3BAC5BF5A9A2FBF67BA193E722929C0989744C0390012C01101C43F4FE035400BD920C0CAE67FBFD64D29404B4D8E3FB95A57BFA495E6BE10233E40E1EA23C04A33D73D5368CA3F862DB3BF21B32840C466C8BF619C2AC08070CE3F787D36C0FCBEBABCBC471FC018E9AF3F8F4F3140EEAF3FBFEC06F9BFC6250E3F5E976B3FD0DD07C0C6A86ABFCC51F33DC01666BF45928C3CBAF7C73FDDBF34BFEA348C3EC6FFDFBFBC9A81BFEDD59D3FBE9209BF12F937C03DE242C0362C15407A5E2E4003548ABFEB8626C0CA43493FE887F83F26FF1BC0835F08C0EC7B3E406E52D7BDA7C64640858B5D3F606229C0F4ABFD3E240E58BF9C1225C080943E40F5DDEBBDB53E02BD65A893BDA491D13F84BE1F401A6E1FC050600CC0886A703F03CF3B3F5E42E9BF47A1C4BFC47F394022884EBE2D7B484018ABDA3FFAC288BEA20B2940A5E1ECBFEDA034C051C939407FF11BBF7D1C3FC0CDE83CC05E4F303F4E112140FE83F2BF0BA5D1BF96C4E63F6666C33F987416C02AA77EBFE49E533EECD53FC028534640EF4E1440E1B0BFBFDC1DD63E7799D3BF4E51BBBFCF4FA63EE2C35EBE8079A4BC38F207BE0212933FE359D03FEB0C8ABF98321CBF55D54C3F5FF7563F3A4D08C045A73AC0B04D033EC8B18FBFE6C34640C2667A3FFE3901BF73E500400A5495BFAC565DBF1ECC363E3CC742C088A544BECA8AF7BD7C08C93FE49F164021878CBFC3194BBFABA5163F2A8CF03FE5D6DABE03BE80BF37AD3C409985BFBEB0804540C027BB3FE88FA4BFAD0F25406E1AB8BFF0F62EC0D36C3440C4173ABF92DCCEBCC0660DBFEDBAC13F8E8E843FA2A6E5BFB86A26BF2D9BD93FEF2F2B409F97DFBE0EE12AC01EA81B40CC657ABF2519474003F41D40E1F14CBFBBFD0540CB92DBBF97FC87BFA061B63E0D9C25BEF0C18ABDC58B41C074383C3FBC5B4240427C81BF9EF069BFB7762C40AAD9073FC4709DBFC230E0BFBE316C3F44F23CC07CF3013D5B669D3FE494E9BFE90B304079538DBF0AD233C085E42740914E88BF383048C0A38725C05FDCF23F7E942F40527406BFA50018C0E5CCF13FB80B0940FB912AC094CA29BFB5E63C40100729C0346AFB3C2773F63FF823BFBF1E60783E101CC3BFE24593BFBC5D2D3F7498D8BD903C94BC784D42C0293A9F3F83603440F3912CBF2A7815C0B33ECA3F74C90240A9BA87BFE7FE1DC0FF1C803DF2CF0CBF08BF2C40B4D013405C9FE2BF2DEBE63EA63902C0666C25C0F25D503F9FF243C00AF541C07D7513BECDC3A23FD3A71440D46012C0550AC3BF9FD7A43E0D93623F6CEA32C09BD5F3BEC2A9B43DD6EC39C021C54740D80BBD3F2EDF02C06B52983F4E58B5BF35C8E8BF009643405F5DD7BF302526BC6CAED4BD0F150F40E9093840C4FA26BFEF3DD0BF803CC73F14DA24405A2118C0FD2E25C046EE893EF3187BBEFB9F38404C29AA3F3AB608C06FED513F625E14C04EF311C023D02A3E4C35FFBDA65C45C0AFA6B5BEEA100D4020443F40C6C575BF6587C0BF8E257F3FBC8814401E63EFBFB5DECABF290746408B42B2BE1C8E4540236AEE3FC27BCDBF7731B03F6335DDBF07BD1AC0B7F82440A460ACBF7A3445C044983BC05ADA423F4EF3BD3EFE5415C0F23117C0234BE43E"> : tensor<20x20xf32>
    return %cst : tensor<20x20xf32>
  }
}
