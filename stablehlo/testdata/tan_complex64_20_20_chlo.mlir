// RUN-DISABLED(inaccurate): stablehlo-opt --chlo-pre-serialization-pipeline -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s | stablehlo-translate --serialize --target=current | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xcomplex<f32>> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xcomplex<f32>>
    %1 = call @expected() : () -> tensor<20x20xcomplex<f32>>
    %2 = chlo.tan %0 : tensor<20x20xcomplex<f32>> -> tensor<20x20xcomplex<f32>>
    stablehlo.custom_call @check.expect_almost_eq(%2, %1) {has_side_effect = true} : (tensor<20x20xcomplex<f32>>, tensor<20x20xcomplex<f32>>) -> ()
    return %2 : tensor<20x20xcomplex<f32>>
  }
  func.func private @inputs() -> (tensor<20x20xcomplex<f32>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xE24D63BF94A921C03F299CBF9CC391BFB9A8F53F49F5FC3D6D1AE6BF8D284C4090B518BF7DBDE53F14B2F1BFD75B7A40D02A41406F693240EBD60CC0DF8CB6408F939F40D168BD3ED2DD5740DBA36FC0941C82C00C179E3DCA1590BF8D924FC0836F9ABF91006B40310979C058CEA73F349D9D4031EF343FB1FA17C0BB42C43EC2D75FBF1DF46FC0D520044119E7C7C0603078BFA66E594073D17640ED9027C0A0D139BF07229240626E9C3E2973A4C096E71C3FA201DD3D311E0C40640B1ABF7CFA7B400BB8223FC5E624407AEE1241DD55B2C066A83940049A41BF6DF453C0822F0AC06F9D39BF2379F13F5AC9FCBFC12B82C0C681743FC25266C04B9BAD3F112927C060B345BE85D1A8C0D3491AC0A8E7CD40BF1A6340B92537407CFD9BBFA42B194050C3BFBF64A990C0AC303FBE084BD93F5FDE51C07EBF48C016513F40747A5B3F5A5CE5BFC6C6F6BFF023843FEE2A32BF5EF00640BBA9733FF6D31E40911E22C021A8BFBE64F4F940DBCEAFBE147E583F2793F7C0C47118C05F2961C0E2F65DC004B776C0573CF43D4F7563408784F9C016697E3F92D65D40BD354B401AB13D4036437240069FB7BF172127BFACF225C082779CC08E851C402EB8C0C0182B66BE106BE7BFDB8B1ABFDE1922400D8EAB3FF42D043FB88B1B3FBF73793F6E5AD5407C1BCBBF891D004053F1A9BF6245D840303F86C0135B9BBF85A031C01C3BB03FA3A834BFD90C10BF49961CC0F6E387BF929933400CC347BF90162CC0A13123C06EDB19C0F7489DBF1CA4CF3EC82D9B3F8B5F8FBFE309293FC244403EEF1253400B0D15401993D84073F04FC094BE10C029B924BF1E4907405BA86640A193A03F73EC58C060905440211178C065AA0AC0D0ABCC40F7F2EF3F59FBAD40875890401E2F5C4086A134405E4F5D3FD5D16040FAA4343F495F2240F704AEBECE28B5400848F83F395D73BF959462C00C7940C0104766C0D6BA61C0E69EA73F007EA2BFD1C320408C4620C0AFE3F6C08A24B43FBBEAB2BFFC09F54071E0044075033D40204CC73FDFA68F40BD369DBFD1F6103F027E91BD1995B5C0AFC56CBEC37D034046745FC0E463DA40EFA08CC079E5423F1C525F40B75F16404B1069C0BA9EEE400F9812C0BD6BABC0A2BB9FBF7C52BB4015232F40D9BE8A3EA80B40C0ADD42040A885F13EB8A38ABF499FF1BF80C45EBFAE77FC3F025CC2BF2DE1E3BF131A6B40BA5A37BEA276A63F10E83BBFE66897C0D9CF0E3F015735C093B1B1C09140EE3DF64B39BFF32D14C08EF5BA3FDD2C9FC03EC7F73F6541A8C09C37B4C04B2272BFCEE874BF09EDB5BF1CE50640F71A3D40EE69E23E98F58BC0CD34AC3F3AB1CC3F051144C079C4E33FD69E3BC0B0F621C0DB3969C039EA2640E3832C40785F64406398623FE9A941C07DAEB840829014C094848FBE7A68FCBE14DB5241A3D7A8C03EC3A6C060B3C0BF158414BF5E38EBBE4AF9D93F52A5BBBE42867AC0BD6B42C0D1F4E940FADBADBF27AEA8C0AA2287C0762A3BC0EB383B40CBA604C05FEBA93FEC9F6F40A27E3B40962B1AC0F39E6E3EC0543640B30B9ABFBB06EEBD0005E93FD352C93FD7EB0FC0A94406BF388E62C0887E8B3F47F78EBEEFD0ABBF3C234B3EFC51D3BFBCDF55BF68275640D0089840F56C5940827360C0CFBB8E3FB78E623FC350DDBE47B65540A5E580BEE927BABF47E08CC0C0ED28404FCA45BFE4BF8BC072D24EC0C77B04C0A66B50C0A37E9340665A0E401C71E63FFA450E40879A1EBF9180903F34FF99400CB53AC040DBA9BF118DEA3F3711ABBF1A976F409F9A0EC0104C354062F3C03F4B4D3FC0C23042407929E93F38833CC05C7000400DDD1E3FC0025440B89861C0F64887C0E57C803FAE37C43E1DCD2240D2B6AABF645BA9BCE2D203BF3440D4BFEF33DFC0FB0100C0904B51C0A18E63BF1F5B5DBFEA5B30C1B8934F3FB41B36C0AC6AB0BF026F033FC2B0A73F56FF20C0A6349040E05301C0CC8A52C0D65358C0107AE23F53D4C440A8B151C094B403C07ED559BF561E34C00E56AE4028E78340117BF33FDE279D400E1CC8BF63A1D03F235D04C090D3EBC0DCC7F93F89FD2540941811C091D001C082A13B3F1B7621BF52B18440F3A581BF6DED1FC031909A407DEA833E82AA3BC0E3536440C7CFB4BEF1BCA4C00EBC47BF181C47BF3935923F053C1F3F6CC896BF740A263DB5EF67C046A0B33FAA53293FC63BA5BE909C0DC10B74E83F2E3C96C043A280C0BB689A3F8F0EA23F3392873DB8D12BBEA7D349C05644653F9B121F3F0118A13D211227BFCDD98C3ED758A83F90D115C0309E2940442C0D3F561A983FFBF19CBFA21DB8BFC35EA84087052EC0A1631CBF2B62EDBE7EB6643FE27249C0B02EDC3E04014AC0D7046DBF75411940DEFB39406E630A4062003FC0374D2240E9C8ED3E33C121C0EBF0FDBF4105DD3EB3262DC0E9DA8340D5C2CF3E44338D3F1FC504BFF01BB9BF520EA1C029344CC091D341C0D4149640A7E193BEDC6A9CBFB70031C0D5C0AF401A739AC0E48487BF19B53740DBC386406F1CBF40BA8B923E227E00BAEDBE803F04F9A540D866013FA3335B40AB98EEBFF9AF96C0362515BFDE1BDAC02E3A1F402E0D8EC017401FC07E2512400614443D1C06AFBFA87DCDC0BA2F314004EFF53ED7CE0BC0F78145BF13F92EBE9ECBE6BC504B7FBF80BE7040E4DD20BF7C59FCBD0A5B21C090848EBF60114E403A711440914BFBBE221FA03F750FC83F90F495C06A60B8BF775A0641003A5C40D52EF1BEEF3E03C1A4D0A64011EDBDBF731F8A40ED68193E08D3144166A8ABC0D69231BF45D089BF3FE9863EFCAD72BFF859673E5D9689C0727082C0F174A0C0408283BE1DA3C3C02F1C1F40633006C002E2EBC0BAECF0BF2D1012405710023F56556740BFFA50402D09AB4083512CC0C63FC1C0592EC13E4AF31D3FF3F8E93FF32496C053CF083F0B97F3BFE746BC3FBC6587BE177CF43D8CAC8D40AC29474101974D3ECA26053FF9961DC089A0683FCFAB53C083292640423C46407CEC0E408A23F1BF8D510CBF99071BBF8DCF5640D06F9FBF61E513C0B39E034011F015C0084E32403BDF6740A78A61C054C3C73F49A185C07480B43F68AA703FF9341A3DC532A84017CDDB3F3B4070409FF0123F50A2DF3FBEDF0EC0070647407FC9353FD54D24400EF79DC0A140283F9E7F0CBF3F236DC09F4A90C0EB3E43C02A6D26406E30FABEEEBCB1BF46DF44C0FD9E0EC08600ED3F60F02DBEEA0E1EBD130B8FBEC8B047BF6DC291BF0F5B63C024453A40F26BD23FC60E38C0E3C8573F4E6F4EC05ADF05C03AC28BC036C89D40B520E2C06F7A6DBF69DD8FBFC72F92BE6DF4FBBF60298040AB69B8C0E31525C0D73C87BFE45464BF558080C0FE14E9403346F0BF906A4AC04DC48D40D1839E409CABA140D3669CBE525391400F2C0ABF9DA8B73F2B6EC5BF0D505F404ECDC7BF4D9593C0A3DA1F40863AA0BE6C3FD23F12D2AFC086FA39404EA48BC0B5EFBCBFBF501140DA2C47BFCDE842409B8481BF0DF36CC07B2000C0069B3DBF1D4246C0F944863FB4AE77BF6E127D3E175C9C3F3EE41F3F5D62EBBFF7050CC02A99ADC035A66C4038D1A340738E0BBFB33A3EC08620AEC0D2D1C8BF6FADDD3F31FD7ABEC698814041B886BF703E30C09CC97F3F41B080C078600E40009301BD131009C1D0AF57C0DBB3294050E5763FAC258CC01217234065AE30C041DD65C04765B1BF8AAFC13F425E9F40F074E7BF6EF584C04F5C5DC0169C1740D90209C056295240F5A30EBEB22C4EBCD2CD76401733F8BE5D699A3D56416A40F9A6F63EA70B41403912293EECBC9EC0A1DC3AC0270601C050F27540E5330CC08DD521C0E028583F88385DBF635FA13FBD9524407391844016DC68406D04433E46FCA5BD4EB4003FF41F7C3EB45686BE48C848400688CBBF240CF8BF218840401CC637C053F4A0BFABC4B53F5FEE06C0A60797BF147B0BC0ACE039BF7EEA8A404A7C98C0979E66C055966B40026B67C0EBF123BF3AF412C06E0966C093DB673F300C97BF96D42840EFB695C0F3F827C00C5987BFA94F1F3FBBF2F4BF6D286AC00D6A743F6C0455C0E95156C01BB9E7C097630940C5BC88C059A7B43FE62837C05B0F12BF74290BC0BAD952C048292F3FE1BC5940CFD5D1BF9C58A8C0B03674C0FC45F13FE97F103E2904E4BE7F5A21BE74701B3FABD06D40545092BFADEE02C01A00A3C09053F93F189F9C3F84CBFBBFFEB6CEBF4E06C0C00246164078EF48C06CC4AE3E034842403AFC48BFC146083FB68731C09BC398C07A4675BFC76416401124C0BFC4485BC039757240A602E9BF81AD93C0D0F233C047FB5A400D163040694990BFAA929FC0A54E4FC02781FDBE767F7FC0524E153DD80229C0B17575BF2B1E1E3EDB2E853FD7CC2EBF6D9EBCC07B1A53C09B3287BF5048C5BFAD1E443F44FAF83D2C071F4062F57840FB84E4C0FECA20C1C9523C3EC389FDBC158F8F4049A741BFD51054407A5199BF7B7222BFABC621C0"> : tensor<20x20xcomplex<f32>>
    return %cst : tensor<20x20xcomplex<f32>>
  }
  func.func private @expected() -> (tensor<20x20xcomplex<f32>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xDCBF4DBCE15280BF87B91EBE175494BF0DB61BC0CE2E723F5565C33AF863803F74DC4DBD28837A3FD501F9391D15803F18DDF0BAEC1F7E3FAA23B1373900803FA61B9ABFA416EF3FD2C0023A6ABE7FBFA5E4A6BF5235573EF0841BBBCC3E80BF60E961BA9F1F803F782212BED0B77A3FCC1DA7BEA473C33F23223E3F0B94203FC8EE8EBA680680BF76E8B5B62B0080BF160709BB5A1A803FDC4E2C3C859A7FBF12E660B952FE7F3F687125384FFC7FBF38F1303FF294233E3D8322BF1E5B82BF8687063F10FF5C3FB409A4B20000803F2CA4C33B83C37F3FA3D32DBB9FF57FBFDC78FD3E3D418ABFA129C0BCFE0184BFB4FC9ABECA3D853F2566C6BD93D16A3F4FAA0E3F388081BED7F06F3C3CE080BF8121013A88987F3FE379A4BDAFCF5BBF9C1ECABD2DDB7CBF2E4227C0BBDC2AC0A0103BBA165A80BF49534F38F2B47E3FE1C7623DF0D380BFD4714E3E35C4983F3F70ECBCAE8D7E3FA970593C1D93803F596B123F831500BFEE44B03EACCA3EC0F919CB34000080BF2E32E63AF9F97FBFABC40EBA54D17FBFC870CA39D5977F3F98B929BDC940A83FA0FE093BCB497F3FACCDBBB9B3C07F3F996E87BE9C10D7BF8A56D3389EFC7FBF31F441B7DDFF7FBF1E7FB6BCC7D373BF7C6240BC25D67E3F7EDA253F4691E43FD547743E580A603F8158603DA9A470BF5138EFBD776F8BBF0DABC139B5EE7FBFB5B5A7BB7EC080BF6C539B3EDDFCC5BF123D5CBC1E547EBFAD81CCBB357D803FA94D17BC0EF77FBF2727763C8F657EBF0F538DBF2DF4C93FB755283E67BB94BF1A0E3C3F3B3A953E17F5BB3B676A7B3F0688223B35907FBF0ECB0E3F133073BF00E6ABBA9816803FD8A1B03A273C80BFEA699E3947CB7FBFB282AD361200803F247CB5B70501803F8BB9533AFB3D803F3A8724BE86543C3F62F56D3EBAB5293FDC3516BFE88DEBBEDA241EBDE46E7C3F85B4D0BADB1180BF001BD0395AA17FBF0B62BBBDD86F653F010EF7BB3564813F873DCC34FEFF7FBF7FE8343D9C998FBFF1374B3CA1C3833FB6BAF6BC38916B3F10DBB13D810295BF7498213F8F88CBBD6117253F979BA8BEB871C8BA782280BFEE1A8D39A4F67FBF14DEF33A01FA7F3FB211B4BA900080BF59E7723C57D681BF94BE283EBB4B84BF5E27CFBB1B987E3FE3A4263B70EA7EBF823B08BF71121C3F29871FBD433D83BF12401DBDB1BE803F1D33CEBBAB7187BFBC57103F979C71BEEA82B83EF732B8BFAC57633D8A80FC3F68B2913764FE7FBF31C8923D33DC1FBFEA34DD3DCD62803F06F0B03C2CAC843F1CFFBE37630080BFFD6C9ABEBED386BF4EA012BCADA8833FF42A1FBE9FF9DA3EF5B5C1BD58BE8D3FE85682B9248F80BF02C517BBA6AA80BFB84AA83A51E17FBF8D3302BC42DE7E3F42C2513E7767463F46469536C3FE7F3FFDF1693F1A780ABFF3C6D1AC0000803FD57C6138D60080BF17612FBE871BF2BFA0784FBD988F753F1E8F0BBA39D97FBF197B4534F1FF7F3F0B95B6B7930180BFFB4A9DBB396980BF576253BC6FB878BFD355093A6D20803F32C8D6BBD33F7CBF7252443B3F787E3FD87E16C02FA352BF1A4236BD22EE893F4907343FDBBC66BFB56E0DBEA3D6573FF93384BD3F6C63BF76FAD93CB5176FBF42CF21BB0608803F23F035B94149803F1EE3FABD78F8573FA12B513FE25450BF9B24403E3AFC82BE594591B8910980BFDA9290BEC7BC3FBF1F8502BBD74E80BFE7C2233B9B3480BFE1B5A03B86F6823F89DF2DBC57B6823F57A93BBEDEA66A3FD43599BA5CBC80BFF8BBCDBCE1E2853F47CD04BAC420803FBAF4DB3BCA38803F2DBC283A1BA580BF8EB92DBC7338733FFBDF5A3CC991773F8B57243B89C77F3FD8BB9AB9ECEB7FBF4A00833FF4F9733F10A7FABDD95271BFF95883BC37A8F2BE7C3BA3340F0080BFFB840F3BCF3D80BFC377B9BE0A5581BF3EDE063DFCDBBE3FF8E8823DEBD165BF2114EC3D0FA46B3FD19C7239FFFA7F3FB8CE0E3B8C3880BF65A7CFBCD708733FA7ED42BAD64B7FBF807ABA3EAF6295BF9C43BD3713FE7F3FF8942B3D1B13823F480117BDCAB48ABF94297FBB872084BFE56A0BBDFCE2823F22E39ABC1C747DBF2ECFF23EDD029D3F79D9F9B903F67F3F4AF547BC9FC080BF87D1B6BF05FE52407A83293AAAA07F3FE0CF37B8A2FC7FBFF40BCEBE552F69BF29131E3F6B4FA63FD6BF18C0E13B8C3E74A1BDBD2CD56D3F73DC293F1739F2BE985B413DAE367A3F5FE1BDB7201580BFFB4AF43D6F468F3F6800843DBAF32ABEA2E1BFBBE4D4363F3397353F0869F23DCC3F2EBF0EE3D03E56E5163C571482BFE23FBFBE00141A3F2E430A3EC2DA8FBF37496CB7B401803F22B7983EA2281EBF64465FBEAB724A3FC783A5BBAF8CCF3EB63AE2BB058E3ABFB960C3BBBCE07F3F2F749BBB103F80BFA70404BFD6AA163F9A11103DF99B7CBF5939DD3B12837EBF394C743FDA616E3FD12F4F3FA3C79EBFE2E9AFB7B30280BF4E87EFB94FCF7EBFDE94843E8C6462C046C0A7BB1CC780BF17AF06B90C0080BF306CB4BB1F6D803F1BA037373B00803FE9AE963E3B9F0BBAE1216D38E000803FBD0DEB3A32B67F3F5FA1BC38700480BFE93214B6F0FF7FBF171C8DB93EFB7FBF7E64A33C56907E3F2C64333CDAE860BF68FF0BBB36117E3F9597A73CFB417CBF7D7A6BBF4129A4BE34A242BC79BC42BF32BCD93EADDD39BFE7F14BBBD8CF7CBF953126BBCD3F803FBD4930BFF9C14ABFE271663D1F26893FE6BBD8BB9D2F8FBF1239EEBA491F803F184602B4FFFF7FBFBD46BBBD14C886BF5BDE04401213633FA56233B736FD7FBF6A685DBEFA306FBF694AF13D0E2943BF91A9283948EA7FBF4BE2B0B8DA0080BFC86BA1B672FF7FBFC91EEDBC22EA7DBFA84620BD775383BF27F632BFD22A593F16BF1A3B1D907F3F50AA0FBC585980BF41325C3E3B64C23E684E443D385E7B3FDBC484BD1FC60240D6EC903DB7C98A3FC48B88BE8773023E3B6C922D0000803F05511F3E7760FC3E7C86943E1BA7633F88A36ABB64527D3F15DA01BBD4347A3FD2D62F3F666DC7BF9DF614BBCCC77F3F4F3B46BCA80282BF73497CBC055381BF39BD73BA34B97F3FD7CA6ABD8DC76F3FDA84E2BD45BC863F4396AE3FBE06DD3DD4E070BDDCAC833F0B3FE83EC3F32E3FD31905BC5ACA82BF8D95A3BC21731C3F0342C5B83AFD7FBF030D013F0DAA31BFC68865B92FF97FBFA52F013B233D7D3F41CCC4BDE08E6DBFEFFB413BAA2D7ABF10E120C01B3ED1BF726412BD69A08BBE2F5B4FBEF0207ABF5AB68DBB4AF77E3FF04374BA9FCE80BFCEA44D3BB70B80BF36A99139520580BFEC4425B50B0080BF1B1E5ABE09F984BF0E3AA7BC4EAD77BFCF9CA3371A0080BF7F84473E396F61BF8C9F26BA800480BF8DB5313D2A6882BFD86349B76DED7F3F772C1FB86002803F7EA208B9CDF37F3F6DD6C1BDE979713F8408DEB8043D803FFC5882B6770680BF22E825BFD3AFE6BEF421A2B6190180BF56461AB915ED7FBFA36386BB35B5823F864D94BBF5FA7F3F337C8FBA6F1180BFCEE3E93EEB97A0BF62AB8B3CB930483FE2A49BBF04742B3FD4D1123FEFB0B63F053A573C97C982BFDF509F3AD105803F651040BF2052AEBFD5365137AEFD7FBF627C84B97946883F6BCD95B9E7DC7F3FCFB5E5BBCF8680BFFA58193ABB0880BFD296A6BFD8C3AEBD8562193B2E0B80BF2EEB50BE30D4533F40FAF9BBEE3B813FCE3A893A03B87FBFDE701DBD6A088C3F207FEBBC300186BF3D48E9BA8A1C80BF3529E2BC00B97FBFA9B70F3E819210BEF29DBCB770C57F3F57DB05BF0F90C43DDC5ADB3E149E0E3F5BDDFABDBA222A3E0E9A363B08A880BF004A3B3AEF12803FC7FA453C6E8580BF6975B63E047F7ABF877EE03B1B38813FCDB6A43AEE12803F2F12443E92BCABBD3B46023FA1279E3EEA9BF6BA892A7F3FBAAFDA3AD56A85BF44FBDBBADE6B7EBF166A9ABD2B5E8C3FB118393E96078ABFEAE1FB3E818887BFE3F4CD38820380BF25AD84BAD1CD7F3F3A01A5BE06A028BF928EC43AE50580BF15CF423E759B83BFD40F19B9F4F97FBF8A9C3A3EC6B05DBFEA84263D8D3D7CBFE93E5EBEA060553FB4956BBA90697FBF6F7AD4BC9B25813FBE13CABD537E893F9143533E11DC0BBF24A5283BF51F80BFFE530E3BA5E27F3FCD22F736C00180BFC14336BDE0277D3F913DEF3DDE99D9BEE811E4BD823E0D3FC8A42D3E7DA867BF786A8038700180BF2FAC09BE2C25903F46FF733D3F1787BF35B71D3CB8117C3F3118E73A4648A83E8E2777BDA8EA28BF4978DE3B62077FBF24B44A3D6AA6ABBF4737CBBDC90E7FBF3DA910BA79C77F3F0EF1C438A50580BF0A1DAB3A91917F3FBA5502BE6F3C5ABF0D8ED23AFD5580BF6B5515BA80E77FBF2035403AB26A7DBFAAFEA9BFAEDBE23E99C40B3F3BAB92BF287BFA3A94807FBFDC80A8BDF8C585BF07746F3F8D5C6B3E92E953BA0AF27F3F0DD97DB1000080BF7D493E3EEE1B03BD7A22973EF1B5BABF1549553DEE2B57BFEFAC46BC67037FBF"> : tensor<20x20xcomplex<f32>>
    return %cst : tensor<20x20xcomplex<f32>>
  }
}
