// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x30xcomplex<f64>> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x30xcomplex<f64>>
    %1 = call @expected() : () -> tensor<20x30xcomplex<f64>>
    %2 = call @integer_pow(%0) : (tensor<20x30xcomplex<f64>>) -> tensor<20x30xcomplex<f64>>
    stablehlo.custom_call @check.expect_almost_eq(%2, %1) {has_side_effect = true} : (tensor<20x30xcomplex<f64>>, tensor<20x30xcomplex<f64>>) -> ()
    return %2 : tensor<20x30xcomplex<f64>>
  }
  func.func private @inputs() -> (tensor<20x30xcomplex<f64>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xB13795A7219E024017CAE89B5AC11AC09F641A33F99A07C03AC860AE458DE83FBEE586CE6217F53F536C4D02E7D5FE3F80D79893F652F8BF13DB8DF3335AF23F42C98B7539D5F93F531FECAAA3AAFA3FB44F4610FB18E23F4CE5D7EB97A41140420E9F0B81D6F83F04D533152C9910C00CF67A0AB9BEFF3F188FB6830E3F15C0D106581474D1F8BF2476EE26220BEB3F985DD7DE4A41ED3F5474E23AC45EFFBF528799D90B08FCBFE142282DAF0D08C0349F19806661FEBFAEA2964AA380E03FDE795659976CD8BF5071ED3B3303EBBFD13FFA301540AABF9F03D6C135C5C13F51616A2697F202C0241765010753DE3F5232F5BBEE7DEBBF47841DDF3571D8BFE7606097311A12C07B0B8595171711C09C6F19EE98B808C0D1E0E3BB323C15C05AAC9B9170E8EABF928B2623187F22C036CAB115D686FA3FB9F4150CA247F5BF0E61340B8D3112C0999E2EC8A5FC01C04E166F26326C0B40F6AC3A80E635E63FE06A8615BB1AFEBF10C549CFDECEF13F4C68E35B3CE8D93FE4436ABD095AE73F65790BAC599EEABF824914DAA225EF3FC92C3E13D6D5104029687F108DC2FFBF581EDC2291B910C01A06FA6E6DF6F13F1D9C809B9AC713C0EA9EF125BC660D4057C779E9E2B0B33F95C31813A994E1BFB922F444DB5D18400EED717CBEE4FBBF9C17C39561A700C0488667277C200C401EEF77C6BC5FDB3F02B9CEC08A9D06C07A96BA0D775B104006E2808F90931DC07A81F2275B5006C0AEC68ADD0F4A0440583F92EE2157FABF662A3801C21DDA3F7CDB772A4EC31040BA4E4C7DE86FF73F4C4AE0F232A208C05E9420ABC6440BC02AB9439F367DF33F49D4B13889880F4000C642A8ECE8BEBF98A93F6AF1DBFABF8A07750FC79CEEBF7CE20F6AB92EF4BFE793F8E695B4F43F59A9E1797F89F6BF4992BC96F42C9F3F87764115710C1740E0A794C82ECDF2BF65F33ED8C61614C0353518B543AB04C08B57AA5F8CBE0940C78BD9E5A77014C03F58BE76A13303C05416A2D57641ECBF2E33DC1D6B1010C05068431A4A7708C0CC8320904915E7BF2E29A833514F0A40647B2B75D7BDE1BFC40B429D0D0BFE3F5E5DE0DF9F1312C006EDCE1E683508C058B7609EDC6410C02743619670550AC02234F9375ABEFD3F3E337B2DBF4412402CA478FF5BA618C090790AED5804C6BF0B2F9677ABB2F7BF08E6766D113012405AFF83233E20F53F7A3C3E8F4C240AC0BBDC1EE9698AD7BFABFD6262CDD503C0F09693BC3C1D03C0A4C2899BEB20E5BFFE4E722FE5560AC047DC99F782B30340A03F755D5E06024087E78E0E03DD0F40684416A5A903ED3F29338792097706C0731AF27E7DC206400C4F38614B1F0BC0F3A05AA3B28F03406AC65B9D26ADCD3F844F47B1DE59F73F8A30A365AC181DC0AA452BFDBE9A00C097B506BCC8EE14C0F4BF02FA8AC30BC070DB7C799AD7EEBF2BC69265D425E13F170B37E4D6920F4024CA4791E2CCF1BFE82FC6FC0C9812C052C0FD42513B06C0668C279195D4D7BF5878DE888E8BD23F00EFC9395C96F9BFD0F3E603E3B410402618CBE624BCC13F6646F0567BAEE3BFF0D9A3F2E392F4BF5088C0EFFD660040EE2D837444E006C01121FD10425D13C0B4A86620FDDC1140BE5A05F7575710C022AFA955841E1040E03D79CF343FD93F823351F3E22BF83F6683543C923906C0FEBF2FA71ABA1240ED64B21A0ECDE23FB1CA050656771A400AE72F524B7FB83F0D1A9FD07E15E13F32C8968AE77A12C0B5E38927587006C06EA449CFF33D054066DBFF7D43CF0140F6C04A35EDE0EABF13BB770ADE54F23FB0B04F350F5C14408E0513AA4844FABF10E8145643D706407DE26D734E5AD23F4A62C55E9F2206C0D32A630257CF0240C1660045BF7E07C0F2FDB6BEE5330B403C7A50FF9A43F53F3F945A806E8A90BF4A6A42C6C47CDFBFFD607B469CD60E405E87ECE3FBBBEBBF3EF3D7BFEBDA0340901C360D83681840705B9347084C08400AF72FDF73BDF63FF69E0BC91C8F0E40AB3E5CEA935301C05AA0C77E1C80DCBF50C38F7EE2A3FA3F9E76C5B58FE2F8BFB2AAD822D5B10BC014A7504A17940440747A9FAFD57CCC3F020663C0A5DB02406F9F41247AE4D73F33875FFB8F45FE3F8D74C640BF3AEB3FCA76ADF818AE06C0AA332210A37303402D5963AC8F51F3BF96AE363C8BD816C0F8F388C110601040F3A9BD6B4D2802C0C209DCA1FB6DF6BF1FB3DEB562F6E5BF5F5D8EBDDECCD0BF74D6834A8EF71D407AEC14DA1282EABFB943C98CB32002C0BC4989AF8871F6BF198130D77073FCBFFB5D294BC4840940B2733C44CE6507404671B7FB38439BBF0C85DB18EB120B4049E2C1329B7A12C07BE6F5E533DC11C00470F856B4699DBFFAE0DDCA9C05FE3F1CC84B279D3B02C06240A5DA67B009C0DDE76005930216C0D6F0D26A086F0E404CB46CA4EC000240FD088F4DA321E43F62F0AE3A687BF9BF5CE2FC69408EE23F27E14A1CE6F50DC0510EF1B80EB6D5BFBCA871BDDBC511C0DC49971692D4F63F4E4F2C668A00E03F3636D1CC788610C0FEAD989709A6EEBFE6BBF32D1800F6BF89975F145F620040DEEBE3926E11054002B8D32EC2D11440845F9DC55A01F3BF448C94D99D77EDBF12C8D322BBD812402F0D89E367AB02C0B89F7695DC6EFDBF1AFFF6324A9DB53F2A073BDAE3031040BEAFBCEA89ACF83F6E6177E2C83A09400A1E35C4BFFE0840388E5585E19CF93FE57A6C7B1A3810402FD7CD884DCC11C04C747F5176AC74BFC8A0DA4D4D16F8BF52BBA1D7E23C01C068E9889CB56C0D407229A3D7FF4A0640667C4D2460A0F93FDA9BE8FB5D8501C0D83AF2ACFDFEC53F2CBECA2A1AFA06401D3971B524D7B13FB4D3D718B0F1F03FDCA32876A1FAF3BF6F1DA7E6FC2FFF3FD2026C6AD09202C0C61A86A34452FCBFE90FF7CF7E30FE3FAB56A8FF3C5304C020C451BD589FFA3F3E32ED258F51C2BFCC574E7AFE01F2BFFE6E6CAAEC17FBBFE29F67536E29E23F5246B370C9BAFBBF70DD1AA8B810B13F86571F401D3D13C06815A60B7ED4E5BF9C74FB4487D5F0BFBC1462BB8130FEBF4C8924628FCF18403AA60BC56222EBBFCCEF28A588E20EC0FA6A55E42298BC3FF2B0ABB11DC4E03F0C5587BEA4ECF3BFE2CBBA049B6300402813FD0B457801409856C45B1CD212407DF7D9B5CB2C08C05E79E64AE903C4BF615233DDF6CA02C06C03743A303900C0AC538B3A04D217C0C816486EAFBF06405E766EA68DDCF63FAD0099D08A460DC0E7672CCF7D0B17C0415A06F87B97F73F4D164999A29812C0F2D458BFCC3DD43FE2B6C4917817FDBF666A658EE8020B4021C0250627701940AA6B0BB98030F23F59FAA74ACDC70E40CED5052AE8B5B43F81A3E9B225A5E7BF40E7262C4246E83F22619CE78155F8BFEC7B96DECF15E33FC0AF690353F00040EC0042F2D4C910C0CE1BEF85E24E07C0C8FB489C4834E83F47A9D6CEC8840FC0DC0FFC5EE156FD3F6246541236B103C044D171255C04E5BF7D0975D16D0ADEBF8164A612DD890140204BC1A22D1901C0FE973AB6785801406C10203C8D6B044020BB00F2285802C018EC6A2CE86A08C022D494924D1D0540CA48A964EBECB63FA0AB1EF606F6E33F3A7A344B22E00B40EF11E6A70B4B15404ECDDF2DEAF3DFBFEC5D531E6526F2BF56336069C9C502C08AF3E4A35CCBE9BF3EAFD808B42501C0A2273D5A124E03402A8859E9A0AD1140145B19CB220F02C0301E5F9ADC5804401EFFDF6FB232F4BF5419E4719093E3BFB057F446048A08C036AC71C9CFC9104066F08CA3291D01400E7FF8FB0DED0740B79061CD55A8FEBF419205278AB9EF3FA0C7DA2EDAC106C0D03F3CD12957E8BF02B38063E3D1EFBF496A3EAA71F2CDBFECDB4531F7210240983879D8FABCFBBF7A37106A5094F73FF16C1C7D2CF7F03F0A77E57C6460B83FD4C1DDCECFB501C06B29BFAC87781A40FD6BD9EBF0BC06C0F6C4FA76669CF8BFBAE129052FDAE53FB15F611CF8F5F13F2F5A1FE80ABC174094E383573D2C1340AAE7707B4DC6D43FAEE9C5DFA48BE4BFC831E685D6DBED3F16BF3079A5450C405D9FC8B5143B13C028EC35FA050511C024499D842436FE3FDCD8EF04C4250940F8FC4CB3E550F73F85F1FAA511B8F5BF3499D5C4B6FCF3BFFA2438E82E0AF53FFB9CCF935DC315405E5A59285862AF3F24A6D89D01DBFDBF9936BD13376A0840E101F4D84C25F43F6086FF06B37D00404B9A79144B6CEABF0CAABF69CD3901403E68A7A8D6A6CCBF7F6043B8EADF7DBFFA8C3A6C4E7EEC3FB2F946303117FB3FE6CBDD4230AAEB3F42F8AE782D0D0EC0241A97E146C0FA3FBB6C65522C62E73FC1787BF873B4E43F1A5667657F90F9BFAFBCEA3AC00900C03A506D68BDA011C0A822F5349414B23FD2859F4A145022C096536A33DF76C7BF52E7BD1EDBFE00405A9D96167B381540A0800B433267FEBF6061435287AF1A409EEB5BFFA8C503403EF5A41FC471EDBF78DCCB7F98F41AC00698D116EF170340F6A812D15A9116C0BEA861206AF8F33F08726EB805F11440DCA479B841B21140CAC737A64609D33F869C749675E7FFBF320B28C8608DE5BFA86AAC460E3EF2BF1267F6C4D3B50EC0F556299E46FFFEBF5DCE3A0AE4FDE33FE945AACDC2DD13C0BACCC4D3D2EDE9BF70F82E2300DB11401F34364CD21709407E3AEF2874B714C09B1E987B5C5813C04C61EAEE87C21040B4C061E68776E83F25E2A8861AD3174091A9FAE1EC29FABF9AB3B3196752E1BFA8B8B6304F51FBBF38A1B126B95AFCBF045180E15D9300C04B040C72A18E004047D8D6F3845DE73FBE04BDEECC2DD8BF6541F181541FF63FEB102849E39E1F40EBED9EBA1D6312C0F07D9411CE0C19409A616D6CD13DED3F8A11D0EAE229E6BF5F709725B28006C0DB14E41B2EE5D1BF7AD679D1F20701C0AF76374ACC00064043A7BDBE9BD0ED3F057B82A3B08902C0C2E990C42DAEECBFEE0C753F3C15FF3F0CFE72BDEF1C1C40E25E3454EE100AC02281480AA0A7DA3FD0CC19539AEAD6BFB4E611AD5CAC164018D6308615B2D2BF4D8A3145ABD101404B3BDB0AAB560C404E3CD8AA3162114058582874E63D0CC0923639E00EE6FA3F0B3B636F65751240FC6AD4566267883F5E3372E08027C7BF557D1257B00C02C0B380283388521340CFDECB1588411140A435749A31D200C0EAF66BA75CFDF6BFB766E9F9F9ADD0BFF94920460A33FFBF62CBFB605E04054075C11D4996A3E23F1429DEE95DA9F4BF82AF5D291ECE1640EF3E2BE70A9CE1BF82AF72C9E2710940C02225EBD244FBBF4EC833C159DE04C083556A3A92B6234043969171B009DB3F6A87183AB7E5FD3FE215D5DC3677F53F861733A9A83AF1BF44AE5A4AE4F901C0D2F0CF5DA75AD43F5123FF6744740AC06D49429EB18C05C02EBF9972179DFFBF448656D46411F2BFF77608FB8C5C04407A4B5C60ABE6EF3FAF02C71F58DDF53F9FB1D3BBF0C4A7BF0B1D8FE1B6DE0C404C7EED86A8E3DFBF2D7631EEAD1F02C0BF4627FC6662144060CC454EAC2C19C0D2A3501D8A66F13F8E5B9C38F30409402A0ED49FB91A13C059DCA4161ED4DC3FE1D051D73A7500C04C1CE6DCB7BE09409D96001B19A6AE3FF301A662DAB10840FC98A9C81EF6F43F6C469514F32019C04F64B8CCA64AD3BF8A610D40F4A001406CF5955060EA01C0304E7F89D9191240F78C2E5E4455F63F4DB7CB8D172A05400C924D414AA3F73FB06B589E2A55F8BFB6E9A483350913404AC803FF37BEDF3FB59B12DFECF0F2BF6D407E43D838F3BF741996D2679C1C4046CCB6DC184700C0EB37A692280401C04C5F3F010D7E0140483B8BE1578AFDBF92F75A6E4E881340EA0AD56242621040B54EAAF0CC6FE83F146B2528308DF03F3C576402CB71E9BFD2913BA63230024080EFB132320017C082FFE178D34C10C0C68D52FC3ABCF53FA4163F121B4C0A40ADB805864A0A02C0670CD2518A5BFCBF831A5B368AFC0440C9E5A5AEA339034006F702AC517705405CAB8C4B7CA3C63F3FFB2A3F4AB2F5BF56A03485593103C0A11932A4A76DC03F6B4A8860F733D7BF8DC60D3471030DC058DE559D4118E9BF9F3A3AF80A22F43F36AFBE22D8CDF8BF1D1AC739402D0040D0DA8DEA74E6C4BF2BF243B3460E0340FE067BCF116F04403BA30B1B558A15C0987893242BFE0EC01F8E42640BFA16404D13897067AF004026333E871934F23F0E6A6D0ABF73B7BF2CA5BC1C28510440A591DD9783DB03C0B493321C7AA31640A4866900568AF6BF6B4960EA16D2064050D65EDA1EC6E4BF963A2D3F7BD40B40AACF6D71B276963F3A7B4F6595F1BE3F73BFF12052E901C0953382917C0CD1BF96234A7D828ADCBF5E937A55EB78F2BF6456569E8759E43FB2031F13E3450D409FDA2901552E1040FA0653E5EEAED5BF6A24ED5316BE0FC0065D6D117CF70F404FFB993977A8DCBFC4EA6099C1FCF73FDB60560E39B8E6BF33453352924B01C07F49E8C96DB4F23FBA90AFF69DFF0240EA30D6E18F4511C05D440145E7C20240AE58DC4136D00FC0B5A18E9DC1EE154025E60AFED92E10C05673CE61C4A70D401860728BD88509405E2281D635450740ACA205DC79B906C011738BD1E9E102C081D0DA7F8CA115C02E7122DD845CEF3FC6E48868AA40E73F4CAE53D13125EA3FC7624E3F7EFA0540720290074C64F8BFC6DB6100570916C0467589517830D7BFD0DAB54DAD001240028D7F25A470F2BF5C21DA233AA107402C879C8596FC0EC0BDB34EC80B6D0A400ABFBC86940CFC3F10B0EBC84CEE0EC06F547C565A051340A2B57510B399E0BF8E5E31DA326B1CC00E7D4D675189ED3F162F6882082DF6BF5EC4DA2696C616C0342242F5C1EAFCBFBC8AEDDF2398F93FA9D81ACA8BB211C09C12ADF478C9C9BF1F7A9BD62EA40EC0E2475AC29AC81DC02631CC747A07E93F89F8DB5B7E1DE13F79F21AB93139F53FF830543765D405C04C96CC348A0AE33F433EB1EE95B8B33F8ECB2BF1A8DF16C09486591A9C0309C054DDDDDBD3E20540F13937865B62D13F72397510A060E53F942A2B2F2C12F03FB4B604E650BD15C04CD8E29979BF0DC095E3621453DD0240AD54BC8A8E7410C005E1D82B298E07C0825912EA1FD8004074A2240FF99207C0D908DDCE238009C04CE00E46BE5ADDBF7563B51F1262BDBF78F2A5B50A4EB8BFDD244A48D730144090C833357D98F43F7AAB4036E393FB3F7D9D33EB12B8FF3FE6A67B60119C00C0308156AE0E5E12C03A74E3FB3AF516C01ED869ADEB28F4BF2C5619D5B21908C08BA387E4F34DD1BF317B63A1617309C011EF13506BBF1CC03C8A5405DC75FBBF28FC9658BFB2EE3F8F0C0FED31A5F0BF4AE2514A5D5806C03C3CD2F1F6E7FEBF74E20F4DD4870AC0AF1193E590DB11C00F51DF5D3264E2BF751A3959FD4DC63F533A9732487E0840E7E327DC7BDAF1BFFAFC7CA398D2EC3FF0E328E592B6F7BFA9897F1902FF1640ADBFCDF224B4F63FAC106736F5EAEEBF9C4578A50FDFFBBFADE6ABED6D7BD4BFA060B80076DADDBFA7BB9F4EA0240DC05A89AD47210007C080EBE203E288F1BF6236A0FED28306401AD42BA1FEDF0DC0494B33D885D700C0C7A82AC5B53E17C06B87E80C57A311C024BCD8CDA6B60A40968408DFC331FFBF80ECA7B887180A408EE66B0D8E7C1B406AAF02E9E5BF01C0485822523AE212C09B0806CC2004F13FE1D031D2F4DBDEBFFE0252B89F7A01C06A01DB44E3D0FC3FA8B872F8B8FBDB3F2EF5AC5D2A00FEBF1E91B63EB5AE0340B242A2F03B1A04C0D939DDE32B54EE3F18CB6B7B80FF0B4026C7791AE7C4FF3F9BA81670527A12C031C742299A23E33FD99DC2F0829A1E4014F498D7CAAA0E40718BE51FDC67F4BF778CE6C0C8DB05C0CC342BF791760AC0C2B04E83E28CF63F1849AA908729D6BF4D2C49FEE1D80DC058EBFD04A0DEEF3F5BF21878643D0F40158CF68515DAF4BFC0593FF559E0FC3F27A0E53934F10DC050EB854BC51DF73F03B9A3E509CAD9BF2725F9FAAC7D0540765C609A9CAD1BC09C62B0F92FBB01C0655D3E0C1DFCE03FC88F5AC861E301401E9AA3A42CD4D43F9BC9F668FC2B03C08D431AA557C916C0CCC25589BF2104C0475F564809F40DC0CF61DAF3144BE5BF511D18A08353943F2C85CD22FD7307408BEA4940C74C1440A2174F8623FAF8BF7F9FAEA4E54AD8BF184ED0B3664C09C063BC544FDE29E43F7E3D3A20F3C4EFBFF0F30B8CB34606406D7EF18D1284164012087567F8B217C0A6C81C4B5F04FABF4BCD59E3C29D04C07482503CD75E0540D0222A3A80EAE83FC635A92A950E02C0900188C23955F8BFAF3F348D421C1B4042D293542C7ECEBFCC75420C82F8E0BF3D9192F5ACB2D5BF465D23042C1F0F405A5827F8541ABD3F68FF09A6DCD919C06CC91833ECAEFF3F78377036F24BF0BF4F961B0BFD28EF3F96C73F58884BECBF6FE0D7687EF0014074F8C2D4907CF73F19231FAFE4BBF4BFECF986796D870B404E26FCAFDE70C93F33E8B2AF558EFFBFCCF72445E352EB3F13928876285910C062B0F1B40C4BF3BFA8A0A92B46F6FB3FB9C49C3A16ADBD3F800F1F45FAC5D3BF58CBD8ECD7FA733F981E5DED31F5F93F3C4E723E99C61840D66346CE76FAF3BF4CCD910A04ADF9BF9C243A542C9C114005FB089C1FC6EDBF80CD8F8E865810C0E915ED51AFB6F73F6A87285DAD3EF53F22A2B00929B60640946DC8FB849008409C1F8FC531C90AC015BEF64D663BE33FA82C76DF5F6115C020EC5E997BE5F03F165F72077663EEBF8FDDDABE1E6DE93FA29F9909C202F53F6E796C37E80BFD3F90A6E3318ABC11C0E8803925158AF93FDEC0304BA02009C0420F5D1747F9F63FB094A0BB9E4D01400A9DA4321ADD03C040621B3DB37D03C082880384DF23F4BF665B25F29DAEF83FADD4021BEA6106409A7F25255B6219C0BC704065C7330240DED5449688850C4008BCC9F1616C07406E4F3D76D1C1FBBFB59FF88CFE9BF73FBC9BD72422D6ACBF723474FDD198CD3FD2CA91128921D3BF50D284FEF12104C014726BF038840140D0053DC2E4E710C05818087FFDA40DC0C237DD37860CE8BF2104C858239512407AF90E2DC9B311C090B7EA48DC480E4094F8CF0AFB2C0F400A35BD0A6B261540B1733EED99C114408FE26281CAE4F33FC6D914A5BE24E63F50A2DAB896340A402F1983B3F7600040207C915D42200A40FDD1AC3865BCF6BF3A3D0E073C67DA3F2C2698DDC3ECF03F15863BC9A0AC06C077C2D84191B30E400A8DF5A32B3100C0EF8FF364C1021240CB8080793FA611C0C6A67314FA0E13C064C1098A03581C401837E5C39B10ECBFA8397B948266144004161696134B00409603A6AF3726ED3F3948DBA426CAB03F4C486F525DC9F03F1DD2DC302116E2BF84C0D2F71FEDFC3FD91CD5756D4715C092F638DFC58007C0D4C2B52E3E4BD1BF85DF2E6BB9B50CC0416AAD7E3EC60DC0D073F45F5344733F2490BEF8C88E01C0DE9797F44B7D07408C2E7AB624370C4081079E1998A807C088A70F4ABC0903408A6F5303469DF6BF1433091DC0B408402950113CBB9BE0BFD8E0F5F50C790340B9226907FD1F03C0626AAC8FC570F0BF63DB4FDC9FEAF0BF622BEB3DCDDB16400DA96CC9FC9D12406E2B0B2C5041EA3FF96E4472A94A02400670C98BE959FCBFAA905FF79C8FA0BFA85A406DF052F7BF6E0313BB8EE4FDBF3E5E9EB700B6E43FAC7F00935901C03F770E45603B8FD03F5B00772D4316F23F552261FF1282F13FA93538741636ECBF0CD67B13C4E9FF3FF9B846834B2003C028DD3AA5DEE30A408B10CD56F76D11C09AA68112669516C02AAC479A6A20F3BF9C9F7C1BDC5511C0CA88670AEDE910C032DD15150D8404406ACB58F99078FB3F7F457BC2BDAA0CC0D66F7632E753C83F6006391EB51DF33F2025BECCD897D53F685041444DF60DC09E5E33B06AD7E53F28F7CE8DC9330440CAE0570027F9F43F453D7CA71DAD13409DA1DDAFD46D084081CAC1FD932CEFBFEFA20342FCE4E6BF846E542AF98ED5BFE192760CF89311C0729082174D48F43FD6BDFCFCDCD512C0D9A26BA16258D9BF13BEC7C77447C5BF0AB64D4DDAD60DC08294F7817894CA3F5C474655F40BDD3F10060A7D0E310DC0DD65D3BEFA681440870812BF1A4B0240EC10F449187A0240A390B387EA9A0AC00A2C92ACC7D3FFBFAE87CE614E34E53FC40CB6E24AF90D40306B7246B4D9DF3F44B3A9F88F6EF9BF466EC9B199EADF3F52DF2F1AD19BEDBFCFA1E915E25518C0D87CCB9E7D1F124075BE6162E473F3BF74A2704667EFB3BFCDD04E682BD811C004394809F88B09400A8EB5F10DDE14C0A4C1BFB1B19C0BC08A5B5B2288DFECBFA17BB1A7B2A4DABF5C32C10E30CF00C0B4FE1C457809FFBF0E55F21C8107BEBFB6F08096D268FEBFD4A9905C26F970BF3EF7D9A67506F43F31E0F9E6042507C08C50E7FDB5EC09C03AA099D31D5AF9BF38C53B4B4CB7B93FDE8F92E11E72C53FFCF04C9125CDF5BF421E072CB831EC3FA8BBC5EB69D40140B4628E425450D63F642BE9633B99FEBF0B522AB60462B4BFBFF132C56C7EC43FBC4D7C03060EBC3F745C03EE317BF9BF20407ECD9561E2BFFEB5672A351A10C084F43A7E3010F53F6B3402A4293BEFBF86F74CEC6868D8BF1AC7DA52FFB4D3BFAEFE2C674E76D03FF6BB4CBFF77208C0C6526E12865BF93FA137F79E192DFDBF708AECA2F4441140F064F30514C614C0C99FB4BFEB2D1040827A5EAFC97BD23FA73196921DCC0040406776CE1462D63FCDB2E5DB16EB134017C0B098CF471640BCD6D6F9E2BF02C03649E3B1C8A9F6BFDA7972672BC0E73F2DE21C05CE0811C0ED617F303D4CD03FEA5903E358CFF33F4C01A6BAFBCEF0BF146AAAAD90820DC0265749D565C2FC3F964B48D2AECFF13FA869404A97AA95BF98198860421CE93FE432BB874234F5BF2FE41D1F4499044034F4221DC213FFBF96E0C754160D5B3F2D3336B7CD6CE63F28DEED94FF4C11C0D44C24341E1215C0E8A973592513F7BF4834908D88480DC0B9264E94DBC4F8BFEC631F9A738BDE3FD9BAF9236E0106C0C6AB426A0624CFBF253C2D101D5EFC3F29A60F6FFF1C0440F28E1A6AED24C83F1D5994CEE5F110C0FF07CE876C000B40510D50CA3329FB3FB011BB603E9205C0E43C2342A0980540350FB514DCE0E23FC313BBDADD6E16402310D26CB057FFBFB1A2438EA638E3BF84AC96325095EB3F555136344278F4BFF6A8DF6585E50D4062BD2470D9B4F4BF25AFC5A69FE10640F00BC82A6BFE1BC0E495E3BF192F044087BA771FDD951440CCAEB7B9526708C0CC749D3AC050F43F5221C504B0161240F87162789C4CF6BFF823E861D78500C01441D8ED791BF73F709E1E07F95CD8BFD055860B21DEFA3FEE3C931D0DC3ED3F16B44746FA6713C0EDEA6A8F5F0F07C05FE4117F80A9F7BFA8DCEE4FEF4914403EE85AA40D16F3BFF60660F68005C13FEFC487CF557D1EC0684D56F569F40B40F3D0E3796DFC0640FF5F6C3AEA861440E78D8BCF7DE900C0A1D41F06263DC1BF9EA8704EEE2EC7BF04C128C6356FDEBF6A17F6CC754908C0A867C774B4CB074084C956C384DEFD3F475DD4F75FDA0140EE00AA785511E6BF2E5BF6CAB890FCBF2D3A696F59B70E40663C548737E1F9BF8EA04CC59FD9D33FFB7369126C62E1BFE3BBD30ECEC003C050B57F1C194CC9BF2A13158E22B407407EFCC46869D210408559C22BAD92F03FEE7C4367767CF6BF95DD12E0BB6203C03DBF674D7FEBF0BF4442827F0DF40540363AB2D52A9BF53FC243E9076492FC3F7862085BB516EEBFE6458294D587D6BFD506EFCF5FDBF5BFFEDF268CF2B8EABF22CCF4FA55AEE83F7D6E5724F32D97BFF4CE96FFA30FEB3FA8C34DE181070E40C654659C5E8FD73FF374ADAFD448F4BFEC02BC117B4C03C0FF0596BEAE69F2BF96E468689B8C014077E0626D37F9F1BF38AF1C59D040EBBF36903AF63559034007D13F48064617C064E58F39506E0E4044E742DB092E00C0518AAEA6C5981140442ED25232800CC006785F8E20620140A29DA9DB1768FABFBB46E35A3DDC13C00A7AC3B3DE011840B39C60631B20F03FF441BA5A2AB6F13F264F54AAA5AA2040F1E4D0A03737F03F9D471D4B3749DDBF21823E38282301C0C9E4444D360814C09282071D77C80DC067C60015C83DF73F53D8293B72B90FC0B0D7C87285C70240408EC87C29F512C03AD7BDF225B303C0DA7B35F09F1908401E66350A6612F63F25312F83347A16C066C8030BD97FEE3F3C3A1D84DD3EEF3F242F94FC63F0E13F0C8067D415D903C0CE03A6DD524EC83F9E787B6D5660FEBF4C0112EEA57D11406E174FA6560317C0CA7E00E842B5C1BFD8308845685C12405AC2BE54BDFEF1BF2718175D1CDCEDBF6C167C25935ED03F044062706FB9F4BF7C2B4278D0A9EC3FD861163F663508C0D83AD33437FA01C0D8847F4F78610AC0535A26A0742D0A40EF684AE2ECE2CABFDF72BA24BD8B0FC03C92D1739956F2BF333D49FA5F41F03F82CC2EC82E1FF0BF9EC2BCB9A2A30440508FF7B446AE06C08C7FBB1E6ED509C0BE4BB380E156F6BFC99CDA0523370AC07557D00E6157F1BF83D3B2E10AF202403AB8E362015FEE3F0047EBD0AA7CEA3F4688877F2679E1BF4692CF7C7EBBC33F9EE37121FF3711C0CCAD8033731FA53FA556501DDF53E3BFDE7461CF57C0E3BF7C85F0854B81F43FCF5D4B27DFFAEF3F5D71D811DB4D08C002F764A8C47006C039625B88A938F43F7FE51C4E492B00C0F6FA5BA010E889BF8709C7B2F0DCF1BFED9F5B4266AC2140D845C39B1B1AF53F00868E302AC9F7BFF05D30BE1BA51040722B4CE8D943EE3FC65248E2E6100840147FA8CBF42602C0216CD46EC8D11940193F8248CA760D40C867BC905854074092941303CCDDF8BF9A4BEAE530A409C0F09D6BE0D10CF3BF4EC2167850FE0840E1ECC8875EDA1340E958C4AB57BDE0BF60532B16FF81F83F589BB4B28DA1F53F11F3D722FFF800C09AEF070871F31CC0A5CEB748D0EC01C0E6A0252479F7134040592285842C00C004BC621D1E1D0E404C8BA3941EDEF4BF35AF9655A99910402582928DF83DD63FC485A7A728F006C09FBDC638CF2DC73FA6E3F4CF0F97154026055B44A501E5BFAA44D5D3BEE416C0C489EB23AAC516402421571BDE98FB3F44647ACB351F0BC0D1E832AE58B603C07C72A99B6CF903407EEE68312B3CF1BF7E1205231F04CEBF52BF00087DD3F6BF6BF8936775F80340647AA8F7C4721EC0CA1BFA0E8B330F40F4F5BA850075F23F02F4F0E06EF701C04299CF661F63EBBF476484009437FC3F1D91BC5BF4D5074018814A59426312C02BBDDE3E4ED005407AD719740D1000C0A04BE95BC3AD06C012EBAC7FA3FB06C0CC7A2B74965013C072B1F99789A315408DA22B85230F1A40A89F7FB029750240461B73AEDA44F3BF1E01443C0C5D10409F6578641CE5F4BFE44E116ABF5A05C0E87A6E797DB4F43F648BB88A51A817403C7D0B1E6A35E4BFA09D808EE8AEF83FC88B8FF692C4F63F"> : tensor<20x30xcomplex<f64>>
    return %cst : tensor<20x30xcomplex<f64>>
  }
  func.func private @expected() -> (tensor<20x30xcomplex<f64>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x105A535D5C0982404F263B011721A34016F94205EBB246406F553280B56052C0F09246BDDCE835C0ED88A97FCC1534C03021B7F2F95726C03ABB25376DC61BC04A05306856EF3CC0AEC9BA1F5F71FDBFC1D402F8F9537540622406CA9EDD67C0D34E66E355AA4A4015F5AF2959D977400DF117E53C2362401C8AE6C4C5FA8F40357CA5E0A70B10C095A298CEFABD21C04E83C204E8690EC08A931008A591354026754A9ECAD552C0D19BE8DC98735FC064A784EDE5431D40641D320FE8282AC060902840E5FCB7BFFD61054AA060E7BFE7489E8FB081133F0236F44D0C0F3F3F29DF8C7521F637406F932D7D3B2C38C0075120BB9872B4BF078E9CAD62DFE83F79DC82E7204A97C0A67DB443C085654020F57DFFF0C986C02F0BE6C7161B93C029C8856EFD28BB4072C17B5B0E9DA4C018077A96FF7C32C0A6303E90C34821C02C6CCA6B03BE65C0B0C38B39BDFB8340CFC156C43C155A407B0FAB0C30CF5A40BDF1E2F6BC7D28C0A66B2FCF0D4733C02FD69DADEA47CBBFB16000E7F7E0DBBF2BE1A557917404C02465EC538479EA3FF8476828FB5D56C062FD13BDCAC47CC0CBB379F6B2E0654098BED865830973C09234493027C592C00F2A6A2453DD88C08D489D2ECC96B43F5C0292FD4B9CA93FE85234BD942C86407C89BC57EF9C96C02EF3356A9BBA62C0BDF0C242AB606D404FEA22C815904B407F43E56212E2424090AD0F97B451A1C0BF835523FDEDB140C595154A1CCB68C079E446BC3F1143C0864EB10627A912407A076FB958571BC0BACFFCB9DEBB5540AAB89BAAC0A87740A4188B7628417BC09815AFAAD06D56C088107228FF515A404BA4F05D33DE70C00EEA3548A7C71E4080C0D151E92E02C0246BC326747815C0D25627DB6E1A0AC0066C147FC3632AC0BC641C7B220C02403953911BDA389140D5E9D055424C37C0C000405610D27A40B071D9DE9B9681C0C33C129E506F70C013D67E1D149A5E40EEE62FA9DF7167C07882EAE987338F402743A3D7312967405B39BA8DE6366BC045DE70C6FB454D40C935F202307C5340636420B521485840E2246CA3102953C0CBB32597F71704C03721B2543DEC8140E858DF0F2E6781C083D4042FB1B077C0361B9E697ED457C0DE8CB4D12A9466C0D0F58FB40977A6C090CAB7EE271C9E40815625AF04B21140B5720B129AA401C06BEAC63FFEC66A408FA4AF230B6A7C40C4F892E9B4575A405E616D8DF257494052DC0675C88561C022E626ED30CB2440F354F312F25556403951397A0F9E56C06CE19AB60A8B5EC07C58FF047AEE35402ECEEB049BC26540B44551ABE2286B40E917ABFE21E86FC01025A0A34B9F1A402916C309E78E6EC085006EDB1CDC66C04B3B3DB454D20E40AC74805C0E7B06C06E44BF237DAA9640DA32DF9F93EEA6408EA20CF407F090C0904B1E3B306A91408DC4022EA3F6E4BFD21D5CAAD836F5BFA7CC2C95760F604064056BB5A87A6FC099435225E6AA7DC016DEE9060B6C86404723355E8A4FA6BF6902D738322A98BFB186860648954540118E0906D1DB7840A7CFBFC0C992B93FFFE312CAC555BF3F9C126D23664C35C0F9E67619CCE43A40FC1C76186FAD80C0069880D07F678AC0E3F9FCFC3CA394C023A2EBB274AE6DC0A46251AB72126F405FFF22966A9159408D0FA0D7937444C0602B974A22D056409DC4A6686E327B4060206211BAAB6D40DDF25F87A3E89D40C1D25E5C74B65B40483B9FA1C0327A40AC2184D4CBF869405956D9EA60A66BC07E2F6F31A95538C0C7095770F1511040673702B4BBCA3FC0D317B47AB04D7D40FB2B2C7398ED81C073A3A08B3B0D4DC0B5AC6BDC629359401CAFDCF18B6B4B4060F13A3163093840CC0C168D93A466C022ED6626BC625540887DC43DB58C2C40BDB88A8171226640598B62DBE4CDAD3F2AB536C8A67B7FBFC9C6A3DEA44C634021F6CA373F9167C028821E6CD61D484006A3399C056A9DC04ACF94A723A136C0EBE997ACD2185F40FF2A9F9320F865C01060F714407A74C07E4DC39C65B41140C54BC9FD28891E40C5592220147738C0D9617E3338C069C07747E371ABE84440071D6CEEDC132E4011330638C03F3A4089523110A611334069E9B10712B501C016333F63896332408AE05CCD923167C05FB38915BD4C4DC0FFE6CC1A4767884042CACDE4E7DC8AC0280E207A11536AC0D9E9BEBFCBF67AC0E8380E785286F7BF5BB1D3013B001740837C972EF06DA840F35D6BEE968F7B4038BD15083BC716409B4A17E231B340C0AB50E000A57537C09FA5820AF3D427C0DBF1C27D459875C03A34955F3B3F4E407F9AB166F76360405571158584821040BCB6311EDE8F9AC0006AFD35FBFC5C40D2F3C564B8C1284082640BB47048E83FFE7B6D70E38167C029FCC31B83B962C0CB862D2D9C7B97C0F7CB321DADAD94C05C8D1BB52C8F2B40B92FDE6689703A405D0975A340DFF63FD9B66984624120C034015F1C6B6167405F9813FC38AC514059A35C17361763402F030A107B107CC082C108B0399C7040B3C799E6455F61402183229AC7F517C02C17087E958214C0209A1FAD3B365BC00C0BEDA411914DC0E0D215A9ABA87F40F6FF83B865D883C019584D8D8AC97740C3FAB4A9E928774064CA70F1DA5D51C056BF58F191B4414017564ADF9C047040C825BE359AAA35C0850CE77498AB42C054204559026762C08EA00040AF1D48C0B873C3FCEB006240DB5129C50D2B94C08F076A8F34486E408367BE42538B144029F714CE44A2B1BFCABC4FBA3E8965C04955BA68D69A7140DA1762F410524AC08D7001815E3557406EDAEE849C2836404737EA28CFB41CC0D65A5BF3A3F35040CCF6C64AE9661A40B99339D54D361BC0B6867720E0850240F01845DEE2D853C099773A94D4CB3C40BE8A567DE03746C01C0FAE49E5D0164071707C9A79F24CC02261A0E5B22A4FC0C6C45A867830F73F36502413B2B1E9BFE4696FC9534506407A640109CC9123C0888588D334E221407F9909D7102DF6BF77CB41B2286C7D40E40A191802987240CC83202FF37D23C07F97AD66FA7A33C01B1C89D8F98A944087150CA54AD288C06C72C4D6BFA06B40D02F8120BBAF39C03769BE0338F7B2BFB8E6DAFF15A50A4092A0D52890EE53C079266878657624C0E1854CCECFFB83C0D97AC84F191E87C0F5130D587CA43D40980C54BAF12420C0768AD003FDF77840ADA3AD06B1A997C07AA216DFA57F3DC0805A3AD1158F5840C7C096EB9DA795C0CD393B761A179AC09954541601BE674094E3D9C740A88040D2C404FA16E92140150053D1567F1D4073898BB0F5458FC080A76EBA0B7DA3C0B9566846A3815A4071F8FEFFB68C6DC0B9A1044686B5D13F84561BECAB82C03F506404E7257002C02EE4B7B19F0920404E6BBA756650254060390C6847D934C068927430991680C0F2FB12A0F7E67B40646189DC8E7F674042311811A5466640FE04F7FB4A8E52C04B66EB0DFE574840EE7FAEDBCD7AD5BFDB566F3AC8A7D03F52903610DEF055C06A72C7BB13DC11C0ADC2848A68CE5DC0E4C05A7BD71444C052E498CCFF6E66C0316E6AEE7C665CC06327DFF13A18484069CEF13118501A406A23A7A6EECD5D407F1E9645398B59C08351AD1C82C58740BCEA48E09DA972C0FA47AFB33D1325C0055D14E7DD7646C09C45824823F20C40586E9B1993423BC0FCB7096A44B070C03ECBE359B24682C041AF02250F3F60C0606CD68E45883F4003ABE2E357C3ECBFEEAC2CE425220E40C1FF809FF69C82C0A6331F53C4697A404F52696AE11462C033057A039AF25BC09115F44DC6D21CC0517E3A97CD6D34C00FF2440ACFDC42409B78E2B0E2415040CFE5805260FDE43F515BE7966DD0EB3F11952835C29B4CC07407CD7E1FC140C04CA6905E1E5721C0E74337A686301A401AAF836856C0374020070E4DA77F10401F1AC0BF597161C0EE9C0B4642FEA4C0248A8C422CBFE9BFE793906F41ED1FC0A087DAA3F5778E40EFC9E74ADB438CC05FF5CD959E0A80408A656D3089CA6140999D1FDF759BF3BFB4861274A093F13F63BEE3A1414790C009858B9B9A9086408C4B32E9466847C096EA3A07B5337DC049A45AFCD1C037C01115479C9CC461405CCEAE7D1FD826C00202FD99B09EFE3F76692E9236E181402286FAF066ED88C0508175C3E41628401AFB0993D975F93FDF64B0269458E53F81942760A0B25D400EE582A80735F23F957F6CD1F94938C06B2F760DC91A3440658AD92117AF21C0B5F241A3701BE43F85C01F70C916953FEA7B4005AD5010C0FB33931D92D12840291D71770FBE3DC08D4D830E48C471C08DE8CCA82930ECBF3E1BF396FEEACB3FA0A20682177243C0F27BC33C1BC932C0B32FD6CDC1897740FB30C103622C38C0776729483364BB40E60FFBC86A958140D57140D7A22C4940FC4ED19268A590C0EABAB380F9169040898D56D49B33A040582B04D609FF1B40190C88C485EE47C0FF601EC21AF580402B22480A32F6A3C0130C59521C7186407844A206FCA58AC0127ED9D3E348A0C0E58FC66955B0864070588B70A7692B40685D9FB5257222408D587C2D5047FABFD3705BA5F4CB04C0DCE1BBCDD32659C07B5F13C58B6B744013EEA0FAAF368140FC4F248CD5D472401B8C5FA2C4EF73403FBAED32A86C7140F5CEAEB1EEF887C02E111E7DD03E9140E21D2A54E32199C04B0455EFDA8D7DC0D28095CEE9B99140888509C0DDDB83C0BB4CD4B8A34704403061F9FF4BDC2040D22055BCB84842C08845B3987AD405C03A006058846352C0B46084273B07C5BF9A63DFC15C73C3BFCA8ABDF90292DBBFF4144A061EF0A8402DB5187923B1A4C07A69262F5957A7C041D22477C345A04003107985DC9DF7BF26C49535D2C8ECBF939DF0829B724D4060E30BAB46A53840852B670F26FC5FC0CC133CF78FC15140A827EE9FCCE3F93F4389A721F56F434038711AEED8680AC0871F15E5A6B034406C96A03ADC8D82C0686D45957FC0ABC066071C12CA3FB6BFD7BEC703CAA29BBF158384FB15BF8F40A4326326B5876AC00D379E6485EE67C0CA9C170626EE6DC058D7D438DE218CC0576F0B05EEA378C0C308C9CE0F1659406E9FC95FF0E881C0067ADA1D3416513FE2C42307DE68323F4178EBC5F7C861C0F4173557E1DA884070D885D371F15FC0EE40820DB31680C011614549AF670B40858ADF0A03ED0740DDEBF2BC69D757C00D4A3DB58EC14F401A2CEA4F90E9DFBF2B9B9167C7F80F40D0F1AC13AF2C8F40E03A67B6F04179C0D7759D30E06150C0DB3B807BCC8B63C0EF97A586598EB5400D2E181AF625C240D7FB3FC2DBF72040B0003EF563EC24C084DFE438B9C01FC0A8A576E67D9A0DC0E6FBEBCE7A70364043DA5A6894492CC0C154A5FF64FD72C0F73AE20A4F6260407CF553937A012AC0403357D833763740321BCEDFEB4B114032475C0688D44B40821CE4E886B40B40C8C2D1252A4BDEBFF5688B4262C86240C4F4C41C82F856C0E6892279EDBB58C0FB5D402E5D128E401F485C8CF9249440630C12D03C7090C006B85CE12D9586C0BC33D2A240548840D58019A1EE9929407225DF6905DF2D40877BFE3AF8C15A402488EFFEDDE81F4031A50857A38A11C0232CED9DD3975F402508515A270098409A65290FF9A37240290DCBC3955858C092C81FF9462709402ACB0F8629F86640CE36AFBD91427D406DD646DD10F442C080F162120DD35240A62AEB9AF27F69405AC97E84986582404993B0870D87A6BFD3B6C43E98B50540FFACF5D01801A14083ECA7B1CBB39A404A9B9CFF9EB152C01142EE179B9A1AC0DB9A236317A74FC0DFEAB026BB2836C01A5CEC6FD33898C0CB000DD5B2AB81409D202B73941202C0372587DDCA9EF8BF37CB2DC5AE091E40AA9FBBDB19674040CD96152E7E159EC0E618C99EAC1A98409FF8D9A467AAE03FCBA081B65C0164C0F0353003C30E4EC08D56B0E6B2133F400E5C1F40E5B763C0C7B5D47D02E83B4032F3B0C8793E49402BCBC61D5A372B40C3E185711AFE3AC0BBBFD8CD247C49C0BA7A1E0C18AA723F74469D9D79E9953F8507D719E1355F40BE2E20934DD46140A9A53CB0EA182DC0027C2F9169971940C6DC6CB4C2103040917A85F7B17515C06269FC8AF56A62C0F91936DC9DB134C05F275DBBE72498C0D9D17E5E023E92401F85F9F9D7CE6E40C8370DD5F77295408CD07A4B1CC4F93FE2AD18111C28E1BFC67C6671D3DB63C0BC2E873456181DC082345A61454484403B4FBC9735F28DC09529D8DC70E84640EA0FE6CAB6934CC0F4947CC9524D624011F21B723F8D0D408D7CF93758B03840384C8ECA6EA41540E05896727F86A4BFA3DD9FB9DC1EAFBF6361CCCF50B4F4BFA58118088FD005C03B85B6216F1C8BC00CB6F27B4A0466C0F13AD93EF6A06D404C5C385F840255C0E3C74C2798786D4096A5A386C4355CC0FA5F094252DFF7BF210B4FD29AB11DC038346B7DFB392DC089424DB879B740C0AF2C5BF13D6F6FC03E394ED05AAB80400F591BDB6D306EC02FF26CC50E0C7840EFEA7E724FD39BC07E91213C89FD92C0EF91B385121681C0931FD52F66116540B611B22CDF0E71C0C71152D60AEE29C0A0AD447496D156C03F7931E38EE292C0F720EEFF0177FDBF9B733C7301B6F33FC195B6A9BD2E3B40EEEB70CD26E34EC013035D6D4F757F4047A14119366C8DC06E80BC94D6A578409F9E552FB7686040EAE5029798B3204006EC38EC912D594016FF056086F083C0ABE905AD522C6AC0E7C8A5398A5E45C0F025F3DD7A1F7440D74CD04FF3AD7D4033B32606ED8E6BC01D4440F92CE5A140E3FDD2C1C85694C00BA79BD5FC488540F7764C9853168EC007A56BD8547740C08F89792F2B5D20C0783A7D37A1A677407A85AE676569514088C9CD4D31DC98C03AD0C5C3082BB2C0A9BE20DC9601E3BF602F7CE5F070E13FFB56D889CC1134C0EE01E233F89454403CFB3669F9DFBC3F0DCDAC3C4F57B03F97C57A1C6C8A87C085B3BDC80C9E9940245C0D8E995A4A40A760902B0707364018C76CC171C0F7BF9DEBFFFB3629F8BF04A2F94784AB95C03AA04E431BD893407CB081ED64E96EC0240A204DB08E7B40CE749CC452F960C0100C4E5167435AC08F7F17EBB8EB75C0E14DAE850DC04BC0FDB8A8F8FC779C3F7FC3839BD442A53FD0E4AE51823E8440A9F930758D6948408673D16FBEF631C0554E3A10F75127C0E66F4363A4E750C089FF712FD30F1940CD935151799BA4C0AC1513C6A48793C00F813E13A104F9BF08E6A3411D6C5CC0C75E6091EC7F584022EE7A7F2C4941C0A03F1073EB8E9B4013FB3FF93FC6A24066F47AE1AEA90FC02A06273EA6B1E43FDD9C205CA9F758C09BA8BED625F655402635165B0EE888C0659D0F69408880C02137DB520686A93F463D70F5CFC2BEBF41DF5CF5DD633340D232B1C32AC55BC079D7783E0AD614C03E9AD8E062961D405A6DBC8637C98540A65E2D5762A68F4055932A99C4AA1BC0DBC6EF7798492CC04E87EA5CC86CB3BF418B43AFB49AB1BFB79B0377B8DB79C0490527153D356A406F0CFC85BC671C40695B34B6B7B95440A83F6D980D9763C0EE68249FBCB2724069AE0A6681EAA2C0CAEDF7C6E4F196401A889AA596E15CC0230F1DD205EC67C04AE03517E4FD84C058CC132D5C9FA9C081E94590372A61C00A5BEB5734BC86C0890772A5CD49CFBF6895C2365E7DFDBF8458743813CC4DC0AF151DA6501538C0BBE8BECF92BA20404D5B93EC1CCE25408998F8920E1A63C0AFD036F2D3D319400D3C4E62103455401B7ECB52EBD262C056660DD368EF40C0D381611F32F283406AF9B4D8EFC9A9401B14CE048FA390C07B8A05DC3ACB52401CBBD5D5FEF16FC0F2754AE9BAAA73C06361B677256C5FC0B9B37F08723F0440DEB3A45F6E260DC01A2B6726A8F95B404A05DD288F0468C0500FB2950901544005493E8B6D3D71C0435BD74E35BB50C0EEA588A9D8277240A65FDA0F71CC024022900B6D51EE11C0481F87B977F6704001F0CE8FF69EA74069185880BAD02F40E99ACD6E5BCA35C0662FA52BFAD43540DDFB561EAB7D2C40A178E124431340C097B49E48E6C996C0E8C5AC95728072C0F139F5DECC1A72C03606ACD7EEF5C83F2BB76BC501EF97BFEFEAED4B5D7782C0757F25903DEA8FC0B43F672691D20E409893C579D9BC15401ED0343DA7155340B86CD4C49E2253C0EC432DD5E2782E40F5D68283A8B55240059370E95255B1C0BB367919967E7C40EA339288A1214BC0CCE59F07C7BF50C00313D5CED354394078E42A4DA1294B40F0B7EBC472B243C05437F1E2F118434074BFA29BEC5CA0400CA51881E08472C0F7074AB2D705BABFF286CC89F49EBE3F9D4DFF687D7B6C40A26364B2BDBF3A4008DCBA4EA74988405A4A030466459EC02DB58B06086A0FC03645B227F1A7D6BF591B2314B3760240B55113082AD740405FB4166EDC7E2CC0981CF26B68F10CC023637939332D614047637ECDC9244040370139635DAAF5BF145047FD744A35C07988F1B642ED6040B9CBF2F109CA724080E0C756002A2240DC1678CE76B60340D1ED2B8407A2823FFCAAC1ACDCD942BF4FB709FB63478B404811363C2C7196C018C4750D370E2EC0A3ABC8A8A14920C026F4875BD83B7140A83F9EB443F672C0BF80E15C27CC4F40F78998066AF575C01C2016CF113131C070C2045737BC57C056D727E1E4397AC012D5271EFA52524077E0BE7DAB9387405868B97D8FA776405A2C82E773D10FC0716C4BE2B063EBBFB851DC05A24709C01A82F5C39D3F12C0DA6F6926C74921406F3785F7AB7780402B2428C2B57F47C06F4C73C2F65762401E6A3A68D3BB3FC0739C379A5A4040C0488D785A8D4A62C0F005E7082E2E1640CC9F02CB5DE62CC0BC41D3F404B51840D5F0A652020A6AC044F86DF97100A24028B987646ACE69C0F7FF10526A8E6EC07ABF0A53371052C0CE7B04E2E5415CC070D2193935CC12401F11570BCF20E7BF880739D9CC3F92BF4C5620192552843F1D106CCB28C55DC0E8D58ADBC4F540C0FA6365905F208EC071008728642D70404CCC62C5708F78400484635F32587240A851C4AD531C91C017D8A93B970276C023BF3136C8FC97C0E46E9C94917290C031566C9C93DA7D408896F1CA0878844099C23727452255407B33B74E963C57C060153F08271D61C0EBA8E44B2EA465C002CFF28C955A004053AE489CE75711C0122E5C0E32B42740C4A35239D4BA5440A0B7EBB00E0A60C088215E4CF7A474C09F350C8FDBA898C054F023AE360050C014D7116B6FB5ADC08B9C64B70F06AD4052DFC5ED01698140B372FCBAF2397C40290682021B0E06C032E0F547C49F384054A12AB08AEEF23FC2C64B155650D3BF593B33A6B71412401ACA3C24651B284098ED22C66F7182C090A7DFA55A369340F37EBFB969076440513F94533FD648C0C90FEE5FD8FB6740FE3BF98A340AEFBF214319E939F462C0812DED4E0184584036C8E5F54D587AC0C7BB801B074363C05CF7BC973DD13FC041A7AD7E88A848C09838B76E99E7524092270736C6B54DC0630B706DCDEC60C0044A0ADBE08813C072394CB657DE12C0CC565A62CA3FD1BFDF3EF12AB029A5C0D1B204F1FD469240DDA7C52C40AC1A40F53F0D75CA1641C03C7C93CD6AAD2340EFC91EA7E706E73FCB8F170132CE3BC0F342CEFF7FC02DC0881EB46E1876C13F5FA3284D86B5C03FC89D5E0B91FCF13FABED942305ABF6BF6144C3E7455E0CC0660E08E71DF1F9BF88C88FA306FC55C0C91C7F87039240400CA670488DF788C04C608D8928277C40F8E5671B944687402A9E4CE4C9AF8940EE223612E2F994C0FF9EAB66E9895040A1E64DB34E1850C009B2F2B058F44F408A29676C204364405A58E16BEA7041C0F3E445B09635F13F02535812C7F1004031D5FFA87EB863407F169B4D515561C0CD315B5E2E2036C0CBD7E053E2D74E40E5C682A09F4A85C06CE52A34C7EC8B40DE8148825E08FCBFB24E2BD15280F33F55A18FC5DF7C7640952F1D0C3F6B5CC06F963785318771400114D3CAE8B07E40372FF2770B2B45BFD9F5C84B636BA13F1EE8658978BE6740CD6403B2F97B45C09F0F4BECE71B6440BECD694DA4B55540CCD56618FEE75BC0458BC84FA1588E40B96094E79A6669C0A86BE7E42AFD6540B1B2E834BEB31540FCF3630A388C32C04459B72F7908664053B7D6CDA2B659406054C436766605402E36C3A17BE31CC0C82E19C16772924037F90C9B367189C0EEBE5FFB6C306E401A06A357C33B7AC02B8BB8187EB57840F628ACF268A53BC0DE8ECF1301A489C03FB6CDCD1EB89140D0A05E1CE9185540E94052C840486140F5A43F9C70DC2D408F95B91D80AE2DC0E8BCEC3D8CB22B40A488832D7D4C0B4096EFEA8E8E182A40235AFB46C521BD3F007ED7A8D1A018C0FB10274F77A25840588C6BF0F6CD44C030D5D67CD7836440527B8C74B7884ABF5CD34FD421D553BF7562D9054A6412C0D24C5EDA81C014C0BBD8F9D9991035405701836F4E1F2E40D873E32F46792A406A2FC4F220CA0140C003F1ED802251BFEF8820BEA3554F3FF20192774F54F83FBADF9F829A25204077EB8CDF0C475840F9CF7EE98F2C73C0275336FBFFE2B83F3ED74574C539F33FE99F9F63C7DA98BF846D6F6E6E9782BF9DDAC0174A9B47C01169FA724A8960C0D957032833C92AC01A054CB121247E4025C3BAE116D299C03001EBFDD9DC8BC0F338A21D843C3140392AF0A76FFB24C0D615B6A55AA582406C19CAFB3B7C65C00E16113E37BE3DC03F04891C4AD594C0C20D6F19AC6B02C05986A1F9677B18C0C6745988991D744012EC2FD6E09853C0C153DAD4D2541AC0EDBB4F2D92DE01C0F38AEEB9E80B51C0C9F17FA7033371C00CB9E8C27B84F83F3C4A4FC2CCE0BDBF6025E872173308C0EBDD0BC743FA12409F10111288F856C09AF80DDA0B944CC08BFA8D0B89DECE3FF725C81F849E62BFE4E42BFAA32A9FC03F9AC599D6BF89C0D9FFE8622EA53040B34DC2AC2DE06DC06B4124C2A32804408799A8A010A319C0F9F8642372484B40662C0B026D183440F191E089735851C01B7CBEE800544CC0445E950F74E373400C53B5F4659F4C4047CA4AC4B7714DC0301C6A78626168408164AF69F57D6AC05B0307A2C255DF3FF762B44BB0DD8C4053248B4166BA79C06E08A3E85D311A40626EE257D25C30405D11F031414310C0861B9D612D8A0F403E4BE41899C04C400D3FAF33AEB86DC07C1225DAD5E34E40EBC390F41E85A9405F61C60222D970C0222CB74EC35390C092869B460B59EABF9AE32718FDCB5DC07849E3186FF466403C5B74A93B297DC0D1D0B9C510D63EC0804D7CBE62023AC0A807A8BF151516400984AB89C65B1B40A14FE32394097B40627118FF65937940F24C3734449B41C07875E488A9185A40F835EEF82AC47B402FD54F5ABB6182C042CDF4721C53AA405A711BDBFD6F6D4025BE972F3B3978C00AFD457681DA6340CAB4A26495651D40A4FD0C7BD3A68DC01B47EF7046BC61BF03859C60027257BF207487305B1F5240C888ACCA4FF549C0CCDFAC0414A557C0A622E0BEC2C65D4036EA281CAAA225404EB8B784CCBA3BC0EE5D10A33E394BC089ABCA0B16CD7340ED813D083D601540221414855F3A14C0982207FDDA753A40184E8271EE203FC0D2D57A7C14C15240D2BADAB1DC78344078B615920E036940355ABCDA90177240397FED94A5343FC0FE1CDD3AAD8A4AC0DC668DDD05B91D40A26DCFB9919B524090ECE8B5586535C06B5C1300DB562AC07EE03BC31CDEC13F45E41B05B41AF03FC42D556201B70EC073E2C8221E5515400E42A392F187D63F5520151A7D40A5BFC54FFCDF9D5261403E3314A2623A65C095B9DFA189B7F43F6A4DC1F0D7FA05408485522B773E25C0412125112EF548407CDDD9CB095F27C0285FD45C447F41C0C6AB5F87229222403CFE6149F51B45401C08450C75BE98C06627CEBF48D09AC0655BB94E03ED54C0A5A4A61D6BF98040BF83DF8FA20566C03126A3CDCED96EC07608A298F1876A404D451FC6087686C0EAFDADEC4EDC90401E4C79BFEE778A400A46C8795ED9B0409B86DDB860AAA3C0FC9AEFC7DE85C8BF115C3FB28145F8BF637440D06A3B44C0606BFC2D9E7A8BC0851FCF37061535404C520AEC3BC56FC0BD225D7F86486EC085CB15ABD9C577C030AE8330AA3E71C0815B375823EC8740D90F4BBCC0A331C0DDB6F0644FCE5D40CB0540D893CE8940522642B92E8884C0F56974F9A047E9BFCDE90678F063F63F479D31D26B474240B5CCEFA6311027C0B9B79F91AF7541C0F6E72BDCEA198040DD623EFC3C0F91400071972B7E545A408A7E5B364ADA714012A74961D68F79C0721552A6E7EBDA3FEA9157F8DE99E8BFD57F21A2E37812C050DCE0351A4010C0DD73658F150365C02F22084828EE5B408CF2FA20341B7DC0343D9507A5CE1CC078D4B0A61AB56D40A6E1F63F4EAF49C067325B24AF6015C0F779DF11D9F9F4BFBF9116D6CA24134089357A4C71534D40093A456CDA9874C0A825C75E9AE155C041FC21AC12F519C0A2B3690F0A1B64C0496B3D36F5C71AC028A0B64576C246402EFB1795626003C0BF7ECB48BFAFE53F9FFA638CA609A83F2CD0A04BE6A6B7BF63493898ED7275409252674404532AC0B847357CEEC7E1BFFB4ECD121DB198BFE2A7911DA79618C0B800AF1D54610A4050A95E62210A72C0A9D1AD7CFC324740CDB9F9F322E933C0123995EE136B39402838657EB0D6F83F2FA138ACEA05B2BF811386A2BAA5B4401EDFE01668CEAB400AAFA0284EC75240269F8B77A05C77400FD9D69B181041401D37FE0BD43357C09DCAAF0CE6B67D407230881AACB6A04070779668F63C7BC02770C41BCF2C6B40CFD415F544C142C0497A91B9299263C06795886707842C40D1B16ECE88085F40E8A8CE2AA6B38140D69C8439AC9F6FC048E852B265E230C0BE1D1150BA2D1140B27C8707C5169540DD3F412A34FAA6C0B5115B926D205AC0EFBD169EFDD08B4091F96E049D4060C04AE52534762E7340A10C5728BEEF5E4041275CFDF000754086D1672995D24E40119DE6FCC4244040FAA8C2A91D588A40FC6FC40872715CC0491F1D9027E48E405FA58FF2045D7EC01F74B556470C7E40AC16E42AAB10924000AF891B82376FC0920217F0D8A5664099261200F78909C0394880E9884A4BC03531756A7ACA0B40107D4605323305C07D7AB8A64437934000E957F124B5AE40BFBBB11B05ED5B403F20DE209E396F40B09D1699C5780E408D94B65BB192404011A22EF6854B53C0120B41D7944D5EC0A5415D15A48D7BC02EE1560FDC7585C02291E12152635CC0105EE690B4CB56C01E6BADDDE5F680C0FA318CC59C1E8AC034B2C33AA5BAB2C0312F0048A6069DC0F806E1B24CC42FC04A1F436DAB8545C0A75B21738DEE5B40EA16E0F7DF1274C0D2683195BB0432C012CDD08DEDD352C0025DD70D2CD09140D4C612412C2580C0E83C10A5862633C028DC3A7E97F00840"> : tensor<20x30xcomplex<f64>>
    return %cst : tensor<20x30xcomplex<f64>>
  }
  func.func private @integer_pow(%arg0: tensor<20x30xcomplex<f64>>) -> tensor<20x30xcomplex<f64>> {
    %0 = stablehlo.multiply %arg0, %arg0 : tensor<20x30xcomplex<f64>>
    %1 = stablehlo.multiply %0, %0 : tensor<20x30xcomplex<f64>>
    return %1 : tensor<20x30xcomplex<f64>>
  }
}
