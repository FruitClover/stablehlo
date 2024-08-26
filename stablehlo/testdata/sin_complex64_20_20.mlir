// RUN-DISABLED(inaccurate) stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xcomplex<f32>> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xcomplex<f32>>
    %1 = call @expected() : () -> tensor<20x20xcomplex<f32>>
    %2 = stablehlo.real %0 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %3 = stablehlo.imag %0 : (tensor<20x20xcomplex<f32>>) -> tensor<20x20xf32>
    %cst = stablehlo.constant dense<0.000000e+00> : tensor<f32>
    %4 = stablehlo.broadcast_in_dim %cst, dims = [] : (tensor<f32>) -> tensor<20x20xf32>
    %5 = stablehlo.compare  EQ, %2, %4,  FLOAT : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<20x20xi1>
    %6 = stablehlo.sine %2 : tensor<20x20xf32>
    %7 = stablehlo.cosine %2 : tensor<20x20xf32>
    %8 = stablehlo.exponential_minus_one %3 : tensor<20x20xf32>
    %9 = stablehlo.negate %3 : tensor<20x20xf32>
    %10 = stablehlo.exponential_minus_one %9 : tensor<20x20xf32>
    %11 = stablehlo.subtract %8, %10 : tensor<20x20xf32>
    %cst_0 = stablehlo.constant dense<2.000000e+00> : tensor<f32>
    %12 = stablehlo.broadcast_in_dim %cst_0, dims = [] : (tensor<f32>) -> tensor<20x20xf32>
    %13 = stablehlo.divide %11, %12 : tensor<20x20xf32>
    %14 = stablehlo.add %8, %10 : tensor<20x20xf32>
    %cst_1 = stablehlo.constant dense<2.000000e+00> : tensor<f32>
    %15 = stablehlo.broadcast_in_dim %cst_1, dims = [] : (tensor<f32>) -> tensor<20x20xf32>
    %16 = stablehlo.add %14, %15 : tensor<20x20xf32>
    %cst_2 = stablehlo.constant dense<2.000000e+00> : tensor<f32>
    %17 = stablehlo.broadcast_in_dim %cst_2, dims = [] : (tensor<f32>) -> tensor<20x20xf32>
    %18 = stablehlo.divide %16, %17 : tensor<20x20xf32>
    %19 = stablehlo.multiply %6, %18 : tensor<20x20xf32>
    %20 = stablehlo.multiply %7, %13 : tensor<20x20xf32>
    %cst_3 = stablehlo.constant dense<0.000000e+00> : tensor<f32>
    %21 = stablehlo.broadcast_in_dim %cst_3, dims = [] : (tensor<f32>) -> tensor<20x20xf32>
    %22 = stablehlo.complex %21, %20 : tensor<20x20xcomplex<f32>>
    %23 = stablehlo.complex %19, %20 : tensor<20x20xcomplex<f32>>
    %24 = stablehlo.select %5, %22, %23 : tensor<20x20xi1>, tensor<20x20xcomplex<f32>>
    stablehlo.custom_call @check.expect_almost_eq(%24, %1) {has_side_effect = true} : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> ()
    return %24 : tensor<20x20xcomplex<f32>>
  }
  func.func private @inputs() -> (tensor<20x20xcomplex<f32>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xBE090340E0451940EF6FE5C0A7FA3D400F618D408C961C403413DDBF9E8C20BF6387C53FBC99ADBF9650E93FE6F3C24049663D3F693A77BF74E045BD29225840088380C0BD21924035082A3E930A1F400C4E5F4055B899C051738B4045FFC13F4FCE42BCE3742BBFA1448A40FBEC2840FB8D8F40DAA5A13E8A7D9CBF011F43C07CA980404DEC404092710FBEB79A28402DC42B3F3656DA3F75A478BF09775ABD35C6CCC01E6A153FD25083C02D6A54BE955E0C40485BC73EF6074C3FF8B8C5BE87475CBF0BBD713F658D493F552A9A3F91A3EF3D401428C046DD9FBFC10C57C06E0D8F3F1A52DF3FE0C0BBBFCFD29C3E11D82B401DA02640CFAC5CC034C5DD3FC7D467400A10D13F81F4243F612291C0118E8E4099F621C0FCC66A4071D58DC0FE31483F930926BF48C5CB3F2888BDBF3B5816C09EAF04401DBA44C0CF1539C14C5412C080951E40FD54B1BF870AC4BB4DDE0F40ED6356C032F40CC095A543BF31AE0DC1B9968A40E956803F3770603F93E766C0024742402D0F1040552645BFEAE62EC058E237C0F1204A3FDD1E644051E62CC003924040FC8F5540F41E42BFD7F19E40B10E12C0FBB08240A09AFF40B66D3540136112C0364691C0D62685404B01A3C0F343E4BF90AEF23FE3BD4E40BC6A8D4061100F40A648DA3F82FF9EC081181EC0A1EF7640B305ADBF89EC973F3FF1A7C08FF514C0B277EDBFDAC4C73FB60D213FA6AC4340FB8F4CC04CECFBBF1027A9C0F75AD13FFAB165C07F5DBBBFA914973F0F4E76BF91615C401AE9913F1046A5C0A81067403C50033F1059BAC0087D96C0F017A3BF0A369ABFD630F73D75575FC0CF9CA83FC4A207C00348813F7C86A1403BE3983F9164EB3F680CA33E825B82BF9D4E0B3F319D3F408B7887BF5B7E1DC0B41174408F0911C1CCD97DBF56FF8AC0039E263EB2B7DAC0C673B7BCA5E6A840417034C075FB8B3F90BB98C01A34BDC0D7577B40A02A683F791213C09D0317C0CC19894083A65AC0F973464017C45DC01E1D333F51BE4A40CF84BFBFE5F00FC08B6EC63F22BBB940928A88BDDFD9B03F3B4055C007C7BAC04B75CBBFCE51BBBF59C522BF255411C0E58A13BEC3E0E23FDE91C5BE1D173DBFFAFD25405F4CD9BD4417843DDF20923FB5DF343F3F8D24408825543EA776853FD29ACABF64E488C0EBC394401EF9323FF3C32C3F5C6B753F01AC02BF47AB90BFA36BB140B4E4DEBE331A983EF3D0EC3F1CE08D402BEE86BE0878A33F3D638540F2C6B3BFD78C4EBFCBFD2AC03726ACC0FDBDB8BFCB080EC0AF6100410AD4FF3F531DA2BF455BA7C021F2DCBFE20831403DA12CC0F45CFA3FF75F4140AB9E0FC0BC153540CDFF24C0417A473E04CAA6C02C2109403802AF3F2A5997BF0E45F83F8B7B504010A40BC034B6AE40BA342E4050DD71C0A9018C3EFBB201C075C093C0DAC41440474D05C03A90DA40C0A11F40559CBE3EBDB458C05E4D5DC003A613C00AB2EBBE7F789FBF8ECB7ABDAAEC5BBFD366ABC0B3CED73F76E24A3E71C29CC083990E40C01A9BBF3BEC8E3F64C3DF3EF2381A40FF544BC0ADA97FC0A5D0693FBF2AE83FE26CCE3F7508864057882C407FF4B8BF12F0AABF3C4180BFFF911E40C1655CC0CBE179C019B298407C1CCC3FCF9A31C02AB33DC0F028A1BF8A54F8BEAD9BE1BE553372C0C4E30B3FA4693340CE244BC050B92E40D4C995BFCFB9D43FA759B840FCDE8CBE00780C3F8F1D7DBE69E8BCC0EF8709C0249247C0A4883A40C245A8C0E98E82C0C7C27A3EADCB67C0EB77A4BFDADE4240A2D9D13E8B252CBEE4002940D9A1214001382540B651BC3E1BE65BC0AD9CB03CE70C2641E9EF3D402DD62540DBB982C0C58AE7BE9490E2BDBFA5B3C07F5E213F32A138BFB745BA4077EA5440C228A43FA4DB85C000D7C5401DA647BF5B6ACCBF96D989C0F93DAC4021448040A55557C0F17FB440D40C0D409B3F41C0ECE18ABF703122C09D6E93401D137F406CF6373E51D42240726F6DC0A14FACC086B4FE3EDA2C9FBC742C3C40E2ABA43F738AF03F9B598EC0EA9A90C06289C9C06106B2BF5045AFC0A7E844C03F5AC63F3E271F40D31FF2BF24DABF3F032AFF3E154634407FB69EC0B1A57740A7A42CBFB76B28402EE3493F818B97C0E7529F40C47ADE3E81070640080A274035873A3F231433C0A7E19D4098886CC0DDECFC3FDD782DC0421091BDF4A04DBF30A38AC0138E6A40396504BF501012BEBE6DCDBF93C5E33F6424EB3F2E26E9BF4710134042B93FBF74A624BF3C868C3E85339F3FB67689407E1EC43F417E3AC0B7F91D409671BF3E2A22B9BEE67CB93F2AA36E3FD4BBAB3F5D6032BE6AA162401027D34092C40840C878CDBFA77F94402E6001413B6FC04003A5E63E25FB95BFA80B47C009B657C0C7C0BC407D6D0FBF6604FEBF8BDB23C0CD1A12BED7EBA9BF708121C093E22BC00C9D2F3F49AF3140D30F85BFD697753F072EC23E0CE588404D5F683FFDF175C0BC2DD1C0075C0640D460BEC0DDE16BC009C72C3F16E9BE3FE127C23FA4820A41302F07C1DCB86DC0486E1AC0941CCE3F8CF3C7BEB92294BF59153A40325EC7BFBC386740579DE53FD4D7BF3F710F8D40C28703416A34C1BEA86024408AFFCEBF0D0A103E62C84C4055F5FA3F1C9FF53FA5553BC004D90B402C858F3FC406A9BF105E7EBF46636C40E384E5BF23758ABF0A3196BF812AF03E2FD34F40193BE5BF0796E73D2FDA1F3F97C0BC405727D2C0AF71413E761FE33F0B335D3F82114E407C736DC0B970893FB8AF973E52F917C05FC368C03B9D723F0796264077DC73C0F5BBB6400C0F04BFDEC135C0A8848C40D85A8FBE2F3B893FF3ED09C05B4EC23FA76D10C035C1A43E9242B0C0248C0040FC42FC3FA833923F78AC7340778D043FA750EFBF9008B73F5157493F910CABBF43FA39C0D3EA04BF9C75E3BF7DE78B40EF61B3BF97E680BE4366E5C08F45B1BE1A55344000A1D1BF40A595C0F8BB37C0C0664240CFA78C40674178407530B84097ED5FBF6F62EA3F1122F03E439224402DABFEBFE24CA73E8118BCBF7924C3BF26F099BF891CF6BFBF4AA7BD9D4247C0A9B92240EF7416402706AB3DDD008BC02301C8BFC9B7C1BF650F03C1E5AFC1C0EF6D0640BD3C5A400A395CC0B8860BBFC6308B3E0410CAC098586CBE4843BC40028E2BBF97D9EB403AEF3240392215C184312CC09CBA6DC0A81BA83F7B1DCC402F860D40E8191F4048475FC04BB242C0F77E2DBF678ED240F64935C0578695C0435BC440827D71BFD00CC63E5F787B400B5825BFD961B73F157BF73F24982DC0A19472BF85C35E4001AC083FE91207C0E8C984C0259A05C14DEFF5BE2EFBB8BEC97389BECDAF42C0E1D9ED3FF3BAC7C0CB0FF03E1C769AC0BB6F073FDDA5D63FB145953E5C999340E8ADBF3FABE7AB3F6D16AFBFCEFDFD3FAEEEFCBEF92E10C06164234016CE00C03127453FC968683D4961BEBD40FB82BF0073E8BE7935A13F37A1963F5B4C7540B8D7894038F8F83F8290D0BFA63AE93F7ADC8D4011B07EBEB08E1E3F326346BEB1ED4140D87BAD3EEE280EBD8E672B40C9E4BEBFE896B4BF3F9F8D408CFDE13F16EE0240FE0959C01FC1ECBE59C7BF3F7D0503C0FACE29C0ED3DECBF23CE1040DD92E5BD43ACF43D22250240699EEFBFD9024E408A47D53F029A5C3F19B7503FA2092F4012025E3FEB40123FB6A2933F6A1FBFC0043EE7BF08989F40D01F46C0FE1E77408DE444C096400BBE3477B44071AD9BC0AD3A7B3E406CCD3FC19F383D124394BF959DA6C0C08A0FC07FA7F9C05281CD3F5DCD24C02C04C7BF20E7593FCF2DD73E3751FE3FCD97D040C0A280C0AF818E40782C70408EE0C4C0B3AA5940EE4F8DBF5AE55BBF3B602B40C08224C0792B233FE5FE0140EB056A40FD0E69C09623173F4F0D1640636E23409859C63F0B9F5AC0E989D5BF1CA3E73F95EB88BFD51A234035D289405325E6BF52F220408E849BC0C4CF5AC058F1A33F31530F3F984783BFF3511DC0C7179BBFB52710BE9A88744055A33DC0FA4A5AC09853BCBFFE91A0409EE054C06ABD683D540D23C0E46325BF5BDE203FC11BA0C0E59324BFE4481B400945D8BF72238D3FFD408ABE567D45C01515883FD94AFABF8362933FE58C80C05E57C23FCFD62EC07ABE9BC05F12B43F79F48F3FAE154340356226C0CE638940A759CEC0B449164060E23ABF50325040E0C5613E418D5A3E431BA04008C54CBE28A56CC0220C70C074EF5CC0535D8A3F90A9A6C07C082240F1758040F94F14403F6096405CD80FBF0C699440143C32C0D79CA5BF22EC5D3FB9619EBC5553063F22E539C044ECBDBFF1C0E53FBD638DC08344D1BF0E6391C0D28A5340EA4F1440461CC2BF0C82BC3FB502F03E5DD46EC0E23CAD40FA2C613FFF49B94075A078C071E79C3EAA4DE9BFCB8C5AC01B598340EEF800C08D6F053F09C83540123512BFC2830A3BD9DB40BEBE859B3F02ACA74069B37BBD83809440E1BD673F07D9863F85C9803F90F2C63F65869BC0DB75D540"> : tensor<20x20xcomplex<f32>>
    return %cst : tensor<20x20xcomplex<f32>>
  }
  func.func private @expected() -> (tensor<20x20xcomplex<f32>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x26359D40E9AE1FC079F5F1C0C841C440702EB2C08CCED4BF172198BF135FD53DD167044001D64CBD7E3A56439E9B5CC2D5C2813F355554BF033B35BF6CBC69413FA5134222DAF6C15EAB7F3FDF10BC40CF2CA6C19655654267330FC0148840BF622670BC6E8D38BFDD30D0C0F1252AC0380183BF3D8193BD0EF21EC109C265C0D8B4FBC00C76CFC038567ABFD7A5DB40F54CE23F1E6F05404EA753BFB8A8F6BCAD4B0BBE18FB1C3F518B563F8FB0F43D36F35F3F50636EBE45EE443FE6A38DBEE29E8FBF9520363F3ACDA43F2A15893F349F4F3F057CDAC0B5C85AC1468E91C022B52940AF819B3FD55385BFEA40043DDBA43F4040FAC0C09A34613F1D2427C074579DBF6CBF0BC0FE1DE041851C15C22D98C3C0F27ACB3FF234A9C10B6B1142FEB25B3FA579FCBED7EB1340C3A6343D280738C0CACB2FC0C1705FC591DC4D4787E690C0486778C0279E7BBFC08B90BA65E73141B6AC0E41F3F886BF6C31FE3E340AA4C112FAFFC18314983FCAD6083F290F9640CB6214C18E84823F499C083FB7C161C0A478014150C7484111CB46419F748AC0395212C1565581BE0B36513FEC4999C07A4D9CBFB5E094C4155158C4A546C03F10A694408ACAFC418E29B0C0ACB03540CBC489BF4F014041C70D81C089DB90C011EBAABF968B8E4237591A41CAEC6BC1E75994C16EC6DFBF2553A53E49638E40E2E525C034B718C0897F23BF54B8C840594B09411F3F4C3E053B6040FF2F0F40387EAB3F0B297C3F4D0DEC3F3282B13FADCCD9BE402603BFA981ABBF3E238541E63A014148EDA5420F4C13C3C4BBF63FE5F5813C15C970BFFD5E313D79B52E3F8E7BD0BF1DD5A9BF7FF01EBFD5D8D9BFA298FC3E2BBC813F7FC5AFBD6AFF7ABFED83993E1226733ED073A03FCC4264C1ACC78CC1CA400ABF2A3D8B3F4EF6713F714571BD863806BF603E9CBCDB42E3C0494A8FC0A71D5242A53ED9C16E2313414C35BD412A697D40644C42C03B91CCC1A6E2CDC127514140F4B62AC16E3FCC3E7D0538BF6C447CBD7AA90740466CF5BFA9B9B4BF0F8BECBE4E8472BD27405C41C23928C0660F8D3F139607C0A7DD99BFFE2095BD6BD745BFDBBFBE3DC1DB863FFC44A23DDAEB90C000629D409557D9BD6B70833D09AC923F645EA33E97390D3F1AD533BEA0400C400D6596BF838B3D424FE6AFC13FB54B3F74810E3FE8686D3FF3C69CBE1A60E7C25A2B5A427684E1BEF1F38B3E61F621421BC539C1FBDF00BF4D5DCC3FDE82ECBF439C7D3F6AECA7C0D9579FC021C2E03F8E5D9EBF771298C4F37C66C46A0ADF3FAF7E2D3FE6352140C544ACBFB0EA2E4028E7DB40BE811841682476C05E96D4C08860A8C01C570BBF0EB529BE46A5724006E3004094AFDF3FFAF298BE533142415AAA95C0F080C0C24EDA86C216C30E411FD69F41346C853FA9BA65C0B35DA440FC37F6BE6DA7C9C373AD62C38335253F9C959BBEE01D764096317641872852BF55EAA33E1F0F73BFCF3AA0BC437EA0C20B6C8AC2CDA7813F68C9BBBC17A49340B492593F46A2CABF414DF53EF8F91740910DA040419D763FE308D9419A7E1F40D084E93F3AC4034279B3B0BF8919773F7153E73F7A5CC0BFD3AB8CBE08791A419F0645410540234269C52AC2DAC7004143DD423E1112ACBEB4FCCB3F342103BF091CCEBEE9F0303F5C41EBBE194F7E40C81734416CE5343FFCD4AA3FA82A1E43913D67C13692A0BE60120E3F073C33C23C9131C33AC417C18E47C5409906AD419942BB4246B5543F12B715BE6815663F4F73BD3F6DAAD63D22C4D6BE47ED96BF6313DC404DCE75404D9CABC0F2E0B240C69E67C1BF43AD43EB1B7B46228D943F1A22D1C0D4D5643F2B918C3EFC3572C1F24608C3EADD3F3F0C6B22BF6CF1C6C0CD294741D87FFB413C1A15C1A1DA07BE00655BBF068814C2A804793FAEA4ACC190BC88411C28F941545409C3AA6804414A6CC1406080B3C0B12C3BC09E24D6C1D3A734C06983923F1A37C740C6B96A4283C4B742FA5FF43E06E48BBC2A83C73E5AAED1BFBBF022427D974F41C6568543B7FF5042D051EBC25A41ABC1AD6B23BE209D0FC0D125044041722440B0DA8F3F5BE6183D8EFEB541CE198742758952BFC5E20A3FB0E5253FB80843BFF7469142FE7ED93FAA11DE3FB016684004C5253F3C652FBF0821BBC1ECC882C242A6F73F468240C0757BD6BEE5E6833DFD2ADBC16469D3C1456F11BF79B6EF3E6A73BCBECB4B17C021864940EF3E22BFB2D39BC0386B9CBF709B53BFE61401BF8C55023F46ECC33FAFC10DC0A68E64BF17B3ABBF6DA8B6C08D5FC73E2E1FB0BEDD5EBA3F0561053E021A7D3F9AE022BD92C00EC30E0DA9C3FBE30B407C0BA43FC383CAC40312E9C2057296BE87E8E53EFD9D25C13C208BC0726925420D7F31C38C1DFCBFCC7E41C071020EBF560AF53D98EDC2C0010EBFBF2D480CBFCF562ABF3677113FB9E8933FC7DF603F8652643EAD51A7BFE098DFBE64A15E430ECF83435A942543CC64C14296DA233FBD4F1FBFEA631840C6FA2F3E11C3CA44F7FDD144B13C434063F394403DC7893F3969813CB88C06C181BF6A401B6194C12B007B3E43A9124029D9F0BEE6A2DDC46C300BC4A0B61AC0D2E4C040212181BF8764D6BB3F8557BEB76F5EC04BD40C4169424B40C987B13F8A5D4ABF5C6FBEBFD2C793BEF136CFBF942C1F40261FC8BF16D12FBFFF4FBA40CD413741BF6C7BBF62A6CABC6718D5421CDB1343501692BE93CB3A3EEF22AF3FED024ABE787BCCBF9FD8A24182F86A3F4CC8123EE5F952C10C955A41FF68B0402EC37A40863EBB42B3F3ECC2748A87C09B64EDC0D27D7CBF5E67B73DF0C27540924A02C07C489A403A2A7FBEF5091C42C705EAC23907544077EABEBFC4EBA3417EA61541AD57D23F2D0F30C0BAFDA73F2E29FA3D55AD0EC1DE8207C06B1FC1BF468F1FC079EC01C04A03233F30B221C3BF281DC4996A36C00305FB40DF4E56C2CBCC6540E9E132C08D6120C1DCF1B7C11E19F1C0E85035BF6B275BBFBA8A893F273400BE98AB0040884D41407B0C3C3F028CF9BFD606E8BF8D5D8FBD291C71BF15F0E63C075838BE7D0FCAC0C69C363F6DDB70BDD0AC14404554523F2A35E1C4E3F7CEC26D75723F4DB67A40669384C0E58D7041B2A709BF9FFD703E707C03BD60556EBE12D6F5BE091C2ABF88D5E84088CA7240F09C44BF597AE94071578A3F6386B9BF2349E13E59A28F4042DA1F414B724F4158E0FBBD31293A3F5C811F40688801C19AF36643ABEC12C1FAEE5EBFED646E3EE5985CBF3DDFF93EDFB35F401193EE3EDA0A1EBFB61A7F3FB828C3BE9B1907BFC7A4D9C1755182416E9B7BBFA942733E4F8BBBBEE82082BECD37A7BE9B3547C0C47A3D3D3BBDF83E4C60913F5AAD813D3BBA843F045000BDCD7615C084E558BE0B5B0240234DD4BEA6CE833FBEA3533E6183A0C0F4C780C036C197BF84C0B9BEFC49693DF558BEBDEE7E71BFF5677ABE7169D83F063BE63EEC62BDC17CD3E4C14DC41D40D887653FD2202342837927C1F8FD96BEADB1233FFBA7FFBF581F22412249AA3E9A1A06BD5E8B853F567CF13FF80725C294EBD440E2E7764069683CBF7A428C3EC5ADED3E4C597B40C04C8DBEF0DEC2BF517B2E403F63463F43C1923DC720ED3EAA9B6E403A4F3FC1F6FB6CC0F6B9B13F1ECCBDBD5139B4407E55A840ECF0633F67B3C73E586933432C1E9FC2587E8EC2CBEC88C16DA08BBF57D1BDC19E8D86BDB8620B3E3EA11BC29F6C4FC230FC203F934314405E6CA13D4086B7BF002C8640E9680DC03D9225C0D0C8FF3D37E1A9BFEF3DF43F39C8513F0009923ED1F19A43AAEC08C3DB4204425E62DBC10ECC06C34B674043A5DEDBBE7C11A63F1421B1C007609740C67527BF9DC212BFC8E18A415F9109C1B7BC103F4E7B0CBF06FE934055D98EC0D4C673413FF2A4BE3BC147C0431B94BECF8CB4C08D6243409F6836C0C33D943FEB5B1742E1F750429FE2073F5477CCBF77F3553F56CA83BFCBC993BF7BEB973F32084DC043ADB44174492CC046366E41585796C2831AF04078473C3E72E864BD96352EBF27CE123F89162F42B9ED70C24FCE5AC0C0CB8F40B083D4BFC6A622BE62333BC0036128C18B9349400F76D7BFE0FECA413EDF34C10D7CF6402782CDBEB7D60840664E973EBC741841343091402D1197C10ADFFAC15D6B5EBFA2AFA340EB380AC18CFC19417811653E46E2563E4D297ABFED856CBD6DC433414C7E9041138D003F48F29EBFF919B2405D3D3E40A73B7BC069B24EC01DBB94BFA4DDFE3B5DB801C192DF193F155BACBF2F23893E97ADB4BC648C0C3F1D530BBF921B0240A8CD21422D831341D2A43BC262B0404045D655BF17A89EC0EDAC12C0B0A9E53D79FC1641AFE694C15A208ABFCAC1243F7A4438C12563ABC1B234753FA9DF37C09CE80241B26BE9C1FC9F83BFE8FE6FBE2E61B13E7B56133F7FFA0C3B220042BEA7D0B042DB65034246A44BC019D24E423DEAA13FB118473FB29F05404FCF9A3F5213C3432E4C6842"> : tensor<20x20xcomplex<f32>>
    return %cst : tensor<20x20xcomplex<f32>>
  }
}
