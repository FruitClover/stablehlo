// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x30xf64> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x30xf64>
    %1 = call @expected() : () -> tensor<20x30xf64>
    %2 = call @integer_pow(%0) : (tensor<20x30xf64>) -> tensor<20x30xf64>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x30xf64>, tensor<20x30xf64>) -> ()
    return %2 : tensor<20x30xf64>
  }
  func.func private @inputs() -> (tensor<20x30xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x6C2D7E520B3F16408EC588B5E08F1B40109D3FA35AB50AC0F8C4D31AC6EEFBBF568BC9927FF7F23F209E343EC899FBBF368380E6D6D400C0DAD62B6535820C4064E24244A2F21040104C2F3C63B914C0C145452965381AC045A30B4212411140D8A2CF24676AD83F8FF9A7B53CE410404735D6696D90FE3F92A77030ADCE034054636A209A93E5BF90FDCBDBB1A411C03A6EA8E96C46EB3F96DC5E2ABEDA04C0C94560D8AB6505C00EFCD4176067EBBFBC89E575648E0640323A388E0571ECBF5B0EEE930A131EC0C308B6C3C12C06403BE86F3DB8461BC0F60C85C17970F43FEC842716A3CC01409079C3FE9FC815C002DB36B96C11DDBF214B078F0FCC0EC0460B1356967DF03F7E549C04DB940C405A2F678710830D40305A1512ED9808401785E2802C5EF2BF6A234D729168DBBFD01A3263C8FDF0BFDCC46BF7CE8EB2BFD77C806F923006403063E199A30A0C40E231B0F9B583F5BF7E38C0769489014038480F4964291440A79852BB48C902C09EE7336DF1560F4074915DE82E431140719691931A9B0AC06D2B36F7CF7AFFBFA2DBC97562F608405E3DA471E3AEFF3F702773DD0C6CEB3FF03A2F5ACEF1AABF0F1D3BFF265000C02A56700D76400B40AF21FFFB784CDDBF6F5F93F7179BE73FB44593D2E4580540EC5DA1FE89CACF3F2C56B9887DB4983F5B332308E3C00640001114141F8310404A20DBA4D57CF53F4878BD25000900C0D9C13BA50847E93F2C66129934351240740D6154D8CEFFBF9E41B0169E51F43F06D07D804B53D63F199E9F0CEFBE0EC0F07F8EA76332D4BFBE417B3A403AE0BFD60084F00F7BE6BF326E8C09BF0707C04C7037BD709C024078AA8CCD7F6F983FE8A944917519E3BF7874D668A408DF3F94EF7FFC97230E403851C0751D5D0440C8DDC022BD100440D63FDEE7296AECBF0C2BDCFC2EFE08C0AE2899C1C8591440F915AD51B17BF1BF9EC4F43ABC611140BB14F33D88EB1840C7BE1BED2BFDF63F3E0D92CB607602402C0BF09637F1A1BF103947ADD3E3EABF66EC9FAB59BA10C01C768724F3FE0A40130D5FBF8D0803403421AF96558002C0E248E39B5BC2E23FCFC26E95415C00C08A4115289EE2FCBFADC7AACEE0630840C330AEAF9BFBFFBFAAED5F4A5C1CF5BFCE052BBA817614C05EF4E945BFADC2BFE1C1747000E7C03FB6309F425E5B02C0D0DA549D4BF718C0B507B7614A54E63F4D963733A05F02C0BCA51A153BEBFABFBFE406843E93E23FF8D7C3E81A18F2BFB0A00A06E32506404ABA9BB4C3D6EFBFC95401D77C9B17400A821DEC25F111C07C24C164DA2B863F52F21CFA7A3607C0A4235FACCC340F40E8AF9B33D153F83F850BCAB40F5717C00285888EA272E33FB1E18F7BCD32F23FD3FA14AE1551A33F9CC5C954AD5008C0F607CE5B328DF03FEE2AC110DB0BFA3FAFDC35EC77EB17C072EA62D8E53606C0D2A3880C45D80140B0B8C608174AE83F7AFF2799F332E63FD03049D5EE3C0AC026B1CB6A162400C00AAB876C77260140E254656DF069EEBFAE009886FA5AF5BF46051CF7726D04C0368BF12B1E79F0BF6F1BE4EF197FCDBFA8055A4DD1391340471A9F3C5DA8F73FBA1F4859FB81E43FF1D8DBCB28C013C071226140ABFDFB3F49813BD49286D2BFE3C1345F198113408C6DCCA9888B03C0D03E3D3B3B6604401FB003C8974B0B409C98B65C14550F4021E97A27E8C304C090263A0B4D82F23F32594DDE027EDBBF174AD81E64380740660697A79AFDECBFF24C874403DEFABF3CD60766417005C0F5C2DD01E28CD6BF02E10D07B8490CC0845FF3A12A5BEFBF8A1A41D37D53E0BF3A417DD6300DEA3F007481FCDF9F17C019282E0375FD0A403A89C8DB141CD2BFEDDE8AB25E1EE73F5EB6D517516A1040E5887DB978BDF03FD112B92CBC4C0EC094123C9EFE2214C064E57D2C679ABA3FCA2244397E4402404824A2409EC9134092DB3719AE170640D0D053DC4F07FCBFE70572D52B1B1040C88A5BF61A730FC02402D1797E2D0D4030BE973A16ED10C05E756F1CBD28EE3FB35174EF800AC83FCC9D0ECD03A0DD3F73CE72FD4BB31240AA201BDA565C1CC0B7241BDA760BF7BF2A9BE29C16CB01C06B75D1A0B109DFBF647FD69ED372E23F73537CCDD3A60AC0A386A4CDFC3904C02C4F3E29F494F03F02D539BB1E880E40A7552448FAE4873F98F9CDF2CCF5DA3FA4148CF60DAF10C0883C2FE4720E0EC0C5644A56843D0C40C7F321FA985313409190FE30654B11406AA9834002F315C09E88E49B4184F2BF4E44DA8A7A3BFCBF22B3122DBA59F03F2A2F16233F1BF5BF5618E372CCCE0940EC624C25AADEA7BFF60EB824828904C01D7A85EFE9D80EC0A39F92E94B5B0840C4F8D147048415C02E5863287850F93FBA387C01E8D5F1BFEDFC376912BAFD3F8243CFB057BDE03F34C795A71FA6E2BFEECFEAB0FF5D1AC0AC3036BC2E160BC05ED1DFBC00A3D23F62804AD9AF8E014037D1516DE521F53F324EF843502C0940EE5E28E4656CFDBFA6849F8812B7F43F6D36B404111718C002D08BA0C5C8F8BF6BB359188823F03F13CEE5D9728D663FE48C8C3BA05801402A1816123334074013E26C7E44E71040348C17DB6FEF02C0288D318A7485FEBF1D81500FD62500C073B00E2029560F40B534DAC0EE3BF3BFFEB14DD05B66F93F429AC37F58F206C004AE4E6A17C10840A0C534DE3CAF1AC07939CE522D38E1BFF800470F120B08408C920333A9870B40DAFE6CAFE4E0E5BF82D8BEAF1C5004C0242FEDE81255F0BF3FFB4A956F0ADA3F86C74578183503C090DA72C11083F6BFE82E9230C13EFEBF7A391A1CE512DEBF2BFF32611D08D23FB1C81E209738B63F998091EF0C990FC036DCE2B78E86E2BF24F425825F8EFBBF3CAEF1C2C493F93F88FEA5A9EE09EEBF95594CDDD461C4BFD31BEEEDE52D0BC0BA14C7694E0E0040D6D25EF1314A10C04C9A111477150A40B8400EDBCA18FF3FDFC774300649F13FA433F224125ACEBF80636B7DDF71EDBF84602D34B866F1BFAE59BE348A3306C0BCB197F22901C23F14876C7C5A7508C01948FC9748EB963F1B95E9B2748212C0C8EE9A90B88F04C0A2CE44C7911A0240480796E26A2F0F408DD6F752F512F0BFEA22238CA5110AC056D86FF1B2AD13C0317AF4BA2D43ECBFD832C7EB0D5A0C40A75B2169541410409F67B3ED1FA501C0338D7A2F1AD906400A46745EADFAF33F4B2F008B820EF63F37624FB2528F0F400EEF5DE0C28A1140FC274841FEA50CC01DE5736197B7E1BF7CF02B345EC2FB3F50496D9B1F6106403030C7A58188F7BF424547A926DE0D403C1BC9CEA44E20407226CDA4DBD51840B8569E3376EC0940432C5607B49203C0629E5E1B7CC61140D26219A1EC84ACBFD3E69412221611C0B546565911A400C006101A212FDEDDBF94FAAB12E3FDDFBF4645FC70B3D4FA3F22DB879DB707F93F73470D47A3E5E4BFFB0817CD4A9B19400F47FDEAC6C20FC04561254C43B6FEBF6AA5FE9CFBE7E53FA71B818B0A7F0C409D530D4017F904C0004F9CC866250D404B09F777D37F57BF0E514AA524C6EDBFA30CE1DADE9D0A405E030CCEF9A10F40AA9ACD354B9BD1BF4782A5A2410E01C022BAC95998AEFA3FF4EA142B5FD90340C69AB2593986044054C40E86DE2CF63F68C134A01434CDBFF7948B3E30B1DCBFEEB8F3B94BA2FDBF8DA0A66E0C3EFB3FEE7D311588A913C072DCFA016B5706C07381CD3B7AAC12C09382291AC643F8BF66D47D4E4CD3EE3FCC0F29378CAF1340AE3140CD7FB1933F58CEB8074B2D1440F7CAFB40736502400A2F2AE6E953FABFA649C3EAA69506C05C8FDEAEFF7D1240186EACD79806F83F0B654A0D9F3600C0C304DCFFBDCE1AC059DD90405F4A01C00AD8D7D513BFE63F9252F9C2F0BFD93F4E251B96A673D7BFFCCBB43B21C6E8BF340754D2A2401040E3C7162EDD90F43FEB75D93092CAA53F9DFA9478144DCABF0911EA0B24F003C040E3F7DB144E05C0A69423C0B19513C01A9C5B64A9811AC06B4B98667A74F53F4D92947CEB50C23F4D7058B1A8F204C01B3E444A352E15C01243DA7F650510C04062186423E81240F49CA050829101C0525926DA03E9074018CCFEA303E709C086CFBE04648606C03B0E102A61ECD23FE22DDB78797911C0E6FDD337943410C05ABC02F85A49D43FC4E75B0FADDFE43F311A8B1B0BF0104088C43EFB5EC8CABF3B8993543BDA1040CC385FF3C14315C080382E701ABA1240B660B750430913C0EF7FCD8F341AF7BFED48420FB8B2BFBF8C19F81864B9E3BF06E134F4923BCCBFFCB3BCA6A4EC1940BAD2B59E0344F5BF7D4C2562325801C0A0337D29C7FF05C0708CBA96A006CF3FAE96D193205105C03FC0E77C152803C06C04199B6C04DFBF38DDC190A398F2BF5920914A6868EC3FC0833E2F05A204C0A867248F4BBC01C097B94C70645E0D40A04E7E5C439F7B3FEA2066150FE3F03FB47967044DBF12C0F331CAAFDE7AE9BF04505A28FADC0A40B45F0972EDC8E43FBA50FF693BC111C05D1D98BFE0AADDBF1F71B6344C761040547E730CC4C9FEBFB06EE5D23D730B404AD58373801210C06C2DBC5C94A5CE3FA25E479165CED1BFCCD2AF366655FB3FF2F464CBD5C8FEBF674E82C6D14CA63FE6B4BE459E3C15404ACD903C9D67E83F1EE9C09F77D7F4BF778E1D610C49F7BF435AE93094C6164095EC115527E6F83F1E88EA2946CC06C093C2CE66A8A09F3FD0436C4D72D81040F21B20F9409D0BC0A088630B9A06FABFD3E4F92C305AF7BF942AA713B49C124080B6C1FFE36B0AC0E8A7305221BC17406D56CF0E661F1B402E7926453D9BEE3FF63F12EAADE9084000E81FACA7CA10C0340E5253CC39FBBF08ABFEF07779E6BF7EEEA622B7B91540C0EED78EDD6D104093B9A34E2A7617402B571CF4402DE23F0B21D78F4E4910405A97BE0C6F26B0BF75FC3A2579A31040FCEBAE718EF11BC02A39791918C4F8BF67711206C34B02409CA7DF177ABAE83F9EFBE96D8E8F0E40F813C95F0622F3BF3E4B48553E961440DE3FAB6C5935E33F11CD788C73D10FC02E0B6F322AFBEC3FC6E1B69ECBF818C0A82FC1CC5588F23F86F98186AE98E23F8CB734E56E2203C0C01BAA38B707CABF0E4846C59E96FABF2A4CF07F3901F93F12907452E4770D40B2C311A97335F63FB47A7198E98FD23FA8162AC9A18B094046082E4C02A8F53F686CD62B6D5013404E817992ED160840E8D0D51AB2D508C026CAEBC49F720140ECE983485A3EF13F1A68A5AC31EF1540DE044A852A53FFBF0513D847F3ABFC3FE0ED60F84FB0EF3F8881D5ABBEAD10C0AA2333998F610540A261366AB2C20CC08CE8AF300695EE3F18E59FFA000C08C02E32A23877DF04C0B0A7DAB185A5FE3F1E3099A9B67D014064F513B3E6B7F93F907BEF8E6CD2164084F16F0F4D29FC3F1E740A612983E83F077EB35C3E17F4BFCE090835EF1DDCBF6E5B9070D5CD09409D19BFAC7E29FDBFB3C5A7B2911922C09A62997E298B0B407A9E1B62AA80FC3F3E39171FECD005409E192B17CAA00BC0521DA46D0CE211C0D83D9A09B642DCBFAEF837AE2626D3BF08EE6ACB72F50740737FBE0F3E90FFBF98B6CBD5365808C0D089A1CEA49A1DC0B9756AED741306C0E66471C622F4064054405D451BF506C0A6817D4AF240F2BFE5B59664E326ED3F261DB257C374EA3F069F82B113E9F03FBFC70AA5CC5D0DC0FD1E79536C3EEBBFDD711B24BB820240DD6B241AA749A7BFCE9188A6BFA8C9BF0C2F9B0C544CDE3FE001D115ABFD12C0A05AB050C3EA02C07AEA31379787E7BFC3EEDF58EB6400C01E5679BF4D40F7BFC3AA960435F102C0DAB2166EC36214C0042289905FE91740F1AD23A7C35501C0F414A494BBA505C070CF0C23654106C01D0F6BC35519124032BE7F646D901140145972E2F1A6C8BFE035A230AA43E23FC931F408BD5EECBF55231147343DFEBF640BACDCE85CE53FD07C201AE429E63F4B123182B1A803406F86B616A07A00404E2CF639A1AC18C0000182B2AE1F0340ABB527AE162D0C406889EF978C2B0640325914DD5DA011C09D8A507EFA65124088B610220094ECBF12A7728069B1FC3F3246F70F0331E1BF424239D01D4FFC3F46315CC1CA76D33F62600DA348361DC0D4CC657248FCEC3FA817FE92D8D207407F3CBAEB10CDBA3FCAB5135FC013D23F5622F8CE238F12403BEE40A5A96E1A402A0404E29C51D83F9C5A1E7D2E0BC03FC65A5E9BBDB5F43FD4CA7AEE18D3D03F5739B01ABC9908409AD8D8F0DBE20440ECB9BF8404CBF63F7AD4BFE7D1071B408C8BBE1783BB18C0D222943BE796FD3F2F64CB4477FEF3BFE2FCE375F1C5FB3F8AA796E7878D0440D72BB9DB17C4F7BF50E453901D8FF83FB2A758EA37DAF8BF42C44AFF3A53E0BF85113E519C8ECB3FBA83E650C14CDEBF2D3B76ACB0780BC056A4B5CB4871E0BF734F5BCB01EF17C0BEB365011DF70640FD2F8ED5A451F4BF0C86965F700A0140E3EE643D7FBF09C0FBF947B56CF213406842D6CCBDF9E7BF1BC4CFF605D4EFBFE47624F922D703C0F46E84F82106FBBF307F4980EEE4F83FD67680C5BDE50B4088DEAFD8C66BEC3FCC2712E9B2A80A40006359173BCC0740FE373B20BE63FC3F361D1F993689F53FF8B636990467DFBFF84DCD04B7E600402E691415229BFBBF7ABF4D2952DAD1BF7642B300A94CF63F9F468AB98EE802C0ABBF5BC2C29303C072DD3213453B05406C8A8A26BB65FB3FD355780F45E50BC0E2D6D1E0FE03F7BFEE0B0FD6B23E0140"> : tensor<20x30xf64>
    return %cst : tensor<20x30xf64>
  }
  func.func private @expected() -> (tensor<20x30xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xE56ECA5DD3E58D401C6A4D16869CA1404621995BD40E5F402CAAA2630194224051D9BFF14398FF3F5641D74EE4B521400B3B6F780B983340AADA628E8A286440DCA801823A24744007CB4DCF7584864036C744E155D99C40B556715256A375403B9D83F28BB0953F9777B83021E0734077F5AB6ABDA12A404BBFA4B018CA4240CD300579FA74CA3F13C0929A3DA87740E41568CDB2E3E03F90733175CC164740B81A86587E964940C2217C49E435E13F83FD99C561994F40BABB2EFE19F8E33F8F485CF61DF7A8409D12184EFD834D40C7497C646DE4A0409084FA760C4E05404A6761A453813840E46127C1CF7C8B407EB34E2CB1C9A53FB23480D5F8736B40265261BAED0DF23FEC13F30B7C5D64402E59BB344A2667408C7A488BB757564028F1DF4604CAFB3FEBDA4F92E338A13FDA2288C26E59F43F9BFED593EFF4FC3EA0766F8052984D40B02731AA92DE6240D6A770215F270A40EED33AD91D183740AE490863A82B84408629693FB3683E404B0B26286B706D4020F1F753F0AD7540A0673A2A6E955E40955BD2021AF82D40C33A5B1CEBB2574049512F3B57C02E4062FBE6BEA541E13F52EE1C41E215E03E945E1EB8244A3140D29A86C2F1D460401B8EA1D1D87CA63FC67E6341BDF3D23F2CE16D59965949402A95318A3D2C6F3FA9F61BE886BC963E3218F18C085C5040E5CC405136267240C1AA5C75FF050A409ACB5A031F243040B7F1AA6008EBD83F2D33B9774FD57A4078415E8C243D2F40190FE2F185CE0440B599915F45538E3FC6A0294A48456B40F9DEF509C24F843F08C93E7505EEB03FC0871E0C9B2DCF3FD11B5F2A922B5140977C429B624A3D407DBDE198ADC2953E63DCEB19783EC03F28AC08CB7C4EAC3F6AAE9C9B412E69403B5D632DC6FD4440D2FBAD13B5C9434079678C4BDEE4E33FBED8C0DF96D0574014F7879D0DF08440C6022D254ECFF63F4906C90D04497640D1F24397CF899740E495C0B71E0C11407D3BCFCBA05D3C4027E99F18364DB93EB9E12B1535E9DF3F5238178FD41D7340ACA73C295C356040A214051941054040BF841745029B3C403BEE0C8AF33BBE3FF969513BAE7D31401470C2C3AC3E254036CC11DC6599554038533B5C72EE2F4085011E8BCB3E0840544FC9023D678540175E6273EEB73D3F5DACA66527ED333F54E8C5950DB93B40A4B304B660B697406C9AC994AE58CE3F909586B5CED23B40BD3E1D7434062040DE0D2AF0A810BD3F481E91FE5D2BFA3F4CC515797A5F4D40065894924C5CEF3F0D76923B01F592401EA06D71D24C79404D9559BE2D7F4D3E3254387A9BB851403418886BF1F06C406DD6947BB96015408F24799FEB1C92404A66DAAB3E76C13FDBC48C3D28C7FA3FC55A27C5F5FEC03EB4E6C2FFB15555403C8250EBAA52F23F3D47DA5942171C40F217F3750DFB9340251B7A5520BA4D40B6428020A2C13840D5AA5FFB9C3ED53F433DF35D06A5CD3F111FBC9953ED5C40C5EC21E9449230402B12E294141F3540B1D08CC0941CEA3F0B0591E67E630940C3080FDE704145404D38040263FAF13F5BD44346DD19673FA3D1983FA6AD8040C088C7547F1E13408641AFEC6797C53F33BB5C7F3F938240684B2AAEC1BB22401AA8A9FFABC17C3F330B538E6BAA814021ADD7DA57D04140DC1F8C397623454077C72E0F83F06040B337573E6B696D40C0A38B6850B24640471DECD82DA7FC3F5E565826086FA13F742DA4E271BE5140BEC83FD9808EE53F2D3676B3A4CD1F401DD69BE044C94940B391FE14ED908F3FE20683A49C8A6340BEF6F4EC4C80ED3F7B3000115158B13FBBF5FA31051DDC3FFEB3ACC51C0393403CC186BAC63160403EBCC49466427A3F329AD9B66D6FD13F8F85AEEA1CBA7140EB3943291D2CF33FE08C8F0ADAB86940263FFD031B12844070FB526435921E3F33C63F90DF2F3B40496FC979EEB682401CAA968365144D40589C92AE9FD52240565B2F6AC56D70401986BE79CBDA6D408977F997531E664087F905E5E8097440A4D795C2773FE93FA67698748A63543FFF5B7632A681A73F30B39ED94FDB7D4089F28C4E43BEA340EB750A5AAB36114021C3E561CD7838402C29D83A5352AC3FFCEB82A6D347BC3FAEA01F9779CB5E401E8C3718646E4440FEF23D661C75F23FF800E9F4D4846A40197E264766E5533EAA1BDB456E1FA03F42743E4D66EA7240F2A0029EE1E76840BA54ECFEFA6863403863C587CF07814052E84C9E4ED775406BB4E27130558C4036494A634BB3FC3F46D7BF0B6163234031428327E072F13F219927FAAD390840E96EF4A074135B40F0FD72CC67D0D33E2698CFD62BB7454068528BECE9A16B40E26CB4DC0F7B55404F70C2ECDB288A40390C1CE951101940CCFF083087B4F83F986E1B23C7D42740455F8ED5852BB33FBC38D1BD8787BD3FB41A73B639809D400FD6592D706D60400D440F8FC8737D3F88927F241033374097156EC2435808409E8841785282584095C28A527DDF26409A20928B677A0640CE7039F3498E94408AD41A808C07174005FB768FFC8FF03F99072E371894CF3D6E50354A711A3640CED2E470A5B15140255B175968EE7340670FA73AAF623F409374AD0C947B2A4020D6D364749930409B64DFA57A6D6D409E348C48FEB400408029815973671940C280FCD118EC504029757BC20DEB5640D81D89176BF29E405395A4FDDA76B53F5D6897D576655440D99B061E8F87614032C74EBD1AF8CB3FE5FACE005CC844408A5A6E800B5FF13F30D557CB22119C3F096CE2A8499D4040B09F79A9185A0F406A4A40C3818929404158DA8DA1F6A83F1DDCAD9D56CF793FF727769B30C30D3F308CF461E66B6E40EECDAA7992C1BC3F945964DEAD982140BEAB8768081F1A4030E808A1ECD8E83FE2C954653F11453F97733D1F44A760400F403F958639304031B1B227F1307140E727A5C6CD405C40A6FFAD5697892C407AD0CBC656CBF53F90F448BA40E6693FEEE8635788F0E63F1ACA66C59E62F63F602FC4FA2AA84D4054703F8CA1A7393FCCB9FD8D8FD7554028D542654DD7903E7F01B86923A87C4076D09E797ED1454047F13C96A2393A4037E51673FFDC6C40B1AA7F7E5C4CF03F4A59061846305C403057293A2E4E824001E841759078E33FD71CB248E7B7634010F69024ED51704003F9480A8CAA3740FFB5698B1CA25040A4EA62843D7303400E17DF7B3BE40C40D127158D81466E40688AAB68571E7740D64C2636808E6440F4C040943A0EB83F5A796B9CF61E22408E91EBDAAD9E4E4091F8339D52B8124027EA062F4C496840FD06A860C043B140F0FC596356389740F1373986C7905B4056390A7089EA4140D9B2C8CF835F78404BB3B60B3A30E43E1867F80F11CF7440765936FDC3B83240F737F1B96749A83F945FF5208DF7AF3F36E4AB77A4A11F407E8B470402F51740B2917E333247C73F8CCB62FFD13D9A40A3395EF9D60D6F4005DE60E191262B40618C42176D1CCC3FBE9E50A6961F64407E58DE2A599E47408A6FCCECD30566406FB46429C39C923D62BCF52694FBE73F520EA0D728A25E40F48DEF2C548E6E401546D8F6F975773F0A5F61A3CCA834405996BE0370EF1E40826317B5CEF242401A5BF9064BA945404A4C906D96840D40558A5E2C5332663F732EE504B5AEA43FCE959554E48827407E0BA7AEFCCE20409BEC107BB13E82400D515F7EB2694E404AB02AADDAAF7D40661633A38C2815400D30FD34D08DEB3FB0C6E730105582407A489B39565C823E725157A7493B8440593DCA3E27F63B405427F40B31531D40D4831F8523C24F405682373C938C7C400F54B6074D561440330F97FEE4DE304062702D5594859F40172482E023D23540D2748909D556D03F1A3618FF4FD59A3FAECBEF574E76923F2B161E0EBCFDD63FBF289083BA08714090B21BE458D6054087761CA5A386CB3E3E67018ECA345D3F94FE2A57564A43401F618A706126494015578C8E7FF581402755F1AB19219E405F3108CC9BDD0940FD798777257A3B3F3C1EA0776D814740433DB55931918840C2A094EDA0157040FD52312B67327F40021CC044FE413740C927CE29DCF253406E6A9C48A3795B407677C7E8A26C4F40CE8EBDDA6E4E7F3F84382CEFBCC37640CDFA7D7A66D670400D03DCECC2AC843FC27FFE13AD2CC73FDC4F3ED1EC17744087B1E7A7A7675F3F3E1E848A33B173407ABB2B54C5F5884099ED2E73DF067E407C0B9289A4078040B0E907F0E0621140B9BE6D0739CF2E3F803AD841D679C23F2D20BF1AA463633FC1D03F198D919B404FAFF6ACF9F60840F7DDD278411836402E202F8158974C409FEEBF8A23476C3F83F2D142C634494020CFEB2072704040A769B9461C3FAC3F6E65E0857B32FD3F98204398F3DFE33F0DFCB05F921F4640ED604AAFD027384071AF316E0FB4664012696ED9F9C3213E036C0C2296DAF33F75BBE02543287E40518EC0F9E5B9D93FF68447B8BDC85F4096B4CBB14BC8C63FF69B9154C1427840D8D6DE8333A4A73FAEB3817916EE71404CB902E3CA6B2B40D781DFDBC6536140FF86648F824A7040C322FF23C3EB6A3F68C071DE058B783F81E2C01AE80821404822CB3E7A682B40F0B0AAB12530CE3ED9DCCC0751D488400D9E9AD8A4A6D53F0164A44D4E0807407DD8A00493F11140DE2D546D6D6C9040CD60CEE7837517402A6E51F7E07C50406302F4D13C89AE3E65497CB5DCA87340A6E03B12CFBE61405F97C3CD9E001C40B276A860A2261240E5633A8D0A4C7D40B9CBAECA96BE5D404FD6A6F7B45E93405F6F851ED783A0404E1C946980C7EA3F08147A42D0825740F4B804D9C9687340294179B081C420404A043F9AC424CF3F9636A5CDDB318B40040A401F76C97140DA8D43AA3A7E924001B424438EA6BA3F07E0939C312D71408FA11D9BE99BF03E736B823017B6724067B6039D699BA2405CEFAF752EF616409C5014E43E5B3B40E41FACAC98D2D63F8AFBC55DB49E6A40215085A0AF5B00405607CC063BED8540D80B976B2A9EC03FA19DB1ED62476F40A053F3714087E53FEE51BE1E14BC97403C7433A49DCCFC3FE8B7E25AC032BD3F56B39A1F155D404017446A746A055C3F2482C6B7D5801E40F7F4FD3F30DC1740B394F2C24F03674036CFC89563B20D402A342632D4FB7C3F0EC56D24DBFD594058240F19A0D90A40ED7EC6D5A4FC8040B38483F8D08D54404B13940BBB375740479B2A7C1FA03640BCA7AC53B695F53FCEB8203183418C40E80F11A33C622D40EF4ECBAB9E9F2440C06E3CD3DEC5EE3F9E1B7B6C76E47240CFB7E9ACDA824940CACE28045FE1644049FB6F86C6B1EA3F6D61F4BCA16854401468F8FFBD2B47402D3F999A8FEB2A40C94265D3DBD93640C5F86309DDB31A408A6EC2ABB28E90403062B44FA231234039728D690C09D63FA7B1C35C6AE303408BAA66FEB712A33F1F627E44680F5B40A3F6A5AC35122640EC17163CD733BA4080FFC1A97B906140B120D4A92D24244075B5DCF0C8A64B40D080A662E7C76140452C45B512F878409493E6A54677A33FFD0579A7D069803F4332CBE37A1C5440DAC85ED9084A2E40DF99754C327055405CBB32CB9E70A7405C4E58702FFE4C403034B34761F15040228BC7273FF450401350B2B8C81AFB3FEB20F59E520AE63F26EA17FB9EE6DD3F27663968F2F6F33FAB0F7E1C3AB26640F1A5035EE9CFE03F05FD57B0D7A93C40DDADCE0170F3D13E8CE6DF9226755A3F90D3FA7D78B7A93F6DDC279874C17F4027AEFC92BD433F40F7F431D968B5D23F078680C6D7A2314061A510D8ADD6114023EC8E5C6D6E3F4056DFDE001A158540CF923E420EF4934041DC90F4DE0B36403D9FACFF57CE4A40F7F6D99778F24D40D4D28C337C327A407B482364443C7740EDF6F087D28A563F9D56A6A5F12ABB3FCA5EB466F2C4E33F989AFEA645842940A6F5F7F0AE6CC93F92E55820BE74CD3F1A2A9E40953B42403C2B4F9BF8003240CA609BDFA49F9640B35EA543AE53404084B18BD8F73B6340A9BF2FC18F7D4D40583A6A7D0F91774036A9B29D5DF97B40C145984E0C5BE43FA5F2D81E5AAF24404513E2883753B53F89E8C3168B992340145148933185813FAD0760AD0639A64046A84E30938AE53F9AE868E946A95340D8D6FCEFB27D1F3F4D56A44C37127A3FD194A02A01F77C4003916C5A14CB9D409768C4F1FA58953F8BF707EDE82C303F73356055A0740640FBD38B11F08F733F65778EE9A75A5640866BEF1CD33A4740D57EE1CA3E791040DB7CA82AB44AA040F99650386BD69640F21EC848C8642740AC5734950282034024D1A64B4E2822409F1FBF3934C84540B4D374A1C0781340A28EF1B027341640F0E6BB5BA9481740966B68193557B13FFC2ED6324999613F3509E67FEBB8A93FDBEC86D18C616140043E000949D8B13F9C1ABBDAE2069440383D7C812DFA504094C14593A1CE0440A09A56DB53963440C0A2A6D976D35A40A8DB7D892E538340416B11D5E82AD43FE6B8162D8151EF3F04046A3847EA424000492C35A34620409AE7B949E970174081704245057C62402C505F2163E9E33FC8EF50DA20D45E40A5A0209679935340892FF2F0E8D22340BA8664E42A420A4097B9B72C00ADAD3FD2BAC734CDEB33400D1547385CB92140EEA7C61306CD783FEBEE84EC482F0E4071CFDDAD2B353F40FD8F8B0069EE41406A35B44103CE4840BD3FC831C33121402BBF4E60C57A6240063410836520114091105FC471973540"> : tensor<20x30xf64>
    return %cst : tensor<20x30xf64>
  }
  func.func private @integer_pow(%arg0: tensor<20x30xf64>) -> tensor<20x30xf64> {
    %0 = stablehlo.multiply %arg0, %arg0 : tensor<20x30xf64>
    %1 = stablehlo.multiply %0, %0 : tensor<20x30xf64>
    return %1 : tensor<20x30xf64>
  }
}
