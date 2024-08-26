// RUN: stablehlo-opt --chlo-pre-serialization-pipeline -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s | stablehlo-translate --serialize --target=current | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xf64> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xf64>
    %1 = call @expected() : () -> tensor<20x20xf64>
    %2 = chlo.erfc %0 : tensor<20x20xf64> -> tensor<20x20xf64>
    stablehlo.custom_call @check.expect_almost_eq(%2, %1) {has_side_effect = true} : (tensor<20x20xf64>, tensor<20x20xf64>) -> ()
    return %2 : tensor<20x20xf64>
  }
  func.func private @inputs() -> (tensor<20x20xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xDA9CFC9A1D82F1BF2C275FE8AF23EE3F540DA2CC637406406ECD00BD4FEACEBF506902FF81420640EEDC50A8B0C2064061C881412ADF0EC04CD7FAD2458717C08A524E074EF8E8BF100404785546FABF6E2D927E91DDE2BF75D3D682DDE303C009A3B9F72BD9FB3FD4508B3D1FBE0640BB1C8AF3373FF53F1248E962C14B024023039F243A6400C01C239E0F0A0205C0CAF7208533A61040840A3AE8B7B4F8BFD85879EE280806402C2204AD4696EA3F9D2A3B63FF2AF83F0F1EBB8BDC3505C035670A36B3BB16C0B9D41E523E83CB3F3F297884411906402EC7E1230CA3EEBFC91161A7F99CFF3F983A31E9710216C095BD81D49EA302C0A8BF837DCFFABC3F9C2AECB732C600C0DF328FA2CB1915C0739A0BFFFFD1054016FAE2C4EC220C40151B4A0A39F313C03C08869355E9FB3FBC92CCCCB508034053936F84D4B20FC013116E79C457F5BF60CA40B3AAA821400CCDDC36B2FCF6BFA8E085366D25F8BFAC3CE54D17E81CC08CA880884E0FF93F68A08BC2C64F893F2B212C9AA8D8BABF5403929C0F4BEABF1A958268F8C0164096F0D101A4C8F53FAE37C74A56A7FDBFFAAD934AD3EA01C0DEDE42B3001F0B4086F90E224919F03FBFCE12C5D9D413408C63DE56B4F0E33F9051114B2AC8FABFD47C38A707AAFD3FF9B25D830E7FD7BFC6B36F008FE30BC0175961775E5515C09E9D3A6342A011C0A5E658EC255FA03FBCFA41C28AFC10408BCA3C1F8218F73FE80514230FD70A40B48AF8CD4D27E53F24A1674265A10BC09EE2ED96CB9816C098AC3B41720D0A40D56FC83F073BC93FA46D8582009DF73F321C5EAAA4BE09401D548919B9B4F23FB9C77AC1608813402AAC981FEC2AFFBF96063CB1F637F2BF87782F569032F13F87F1BA266EF60040065D0F223CFC0E4061F07D12CEE6044082FC2D0760C4FDBF1A03EA22040F11C0C0FF3479323D14C014FB45DC1F0FC43FA3DEBE999A21F83F3150E9178E55F23FB06D9AFA1DD3F23FB4F01361BE2B13C0D33954E6F06CE1BFB2C4C5498E39034071B0F7A99E7D13C0247F6A5F4EE00A403B77D7B2F75302C0A261EC0E910505C0D733DBB1A5F30FC055312C6064831A40405338166640E43FAAECE455A3A4F53F70791089A1C9F3BF02EC5BA996E0F13F50E364FF6DD611C0EC529BC0D1A3F3BF74121EE13361D0BFD38E8B950B97F3BFFDB70372B380F73FDCFB756CBC9CF0BF2512A37C375DEDBFAE9945E6DDC2E0BFC8F4C1C30B5E13C0C4B1D9DC2C6119C03E80DA0E652FCB3F55ECBE85C036004064B3F4496BA401C0ECE3B4395184EF3F653815C0E2D6EE3F1260CB9D8A64F6BF3671DCD5046A03C0844B342256BFCABFDE27BC4AA7EB02C0C1ED1798307A1040669A3A6EB8071DC068D50073771E01405073EC113C661040D78BB040F12BF1BF0E4B8307765E0240D9445FC4FE7203C0709E56440AE71CC0E1C5D971236A0540F8ACB468AA90EBBFA67A8E208B52E23FAC2AFB364C1106C0B189D9F6A565A53F80528D3263460140E414702B0D1FF5BFAECD83C8E63E08C02E77EC4A81F908C0CA8DA9C164C906C002CE6844586903C09CEACF23ADD50F40B1EC53C528371440BAE6C8FB3960F7BF14F6476F6BA9C1BFFABA785C9DB00E4083AF58BC4CBEC73F5EEDEE8C38361DC0BAD87605ED54F4BF5D10E829B9F2F43FFC738DAB00FFF0BFAEA1094DB9A501C0426ACD37AF6C044089B11D0173E4F1BFC53A6A78362EA7BFC8A373BC4F7302C0F28D274D35A4BBBFF5476A23DB4E07C072CCC988A610C13FDDC5644CDD361640B8694960B9630D40C2B9889E91990C4092C1AFDAD85F19C0EA2B3B91DAA3F63F3082406EAE1EE03F1F7E1A53B7F204C06F6FC79CD5C00AC0294B0096CFD8E2BFF30456DF4DF5F0BF8D372A1FAA66F13FF6210C0ADC44F23FCAD0F2FDAEF6F8BF3AF7111DAE7D07C0D84CC44DBC310EC06692DE46503401403ECA606DBAA202C09D7127A585BB0CC019D536279BA3114040D6B09931C6EABFA80BF1B7DCF80F402A694C6C2B0BF6BF50CFD7491A25FC3FF383E12831AC893FD932637B2E9D05408796F7C47148FDBF4C7274A83CB50BC06D4D99B943140CC096FFA61CCC0DE2BFC624F4673807BCBF426A89AE0BA101408D44FE340301B4BF3AB0C8B23CF4E5BF467381F5B813F13FB5E85E5C504805404479B5C2F660E9BF883E699FFFA912C00B7FA55AD4B911C09E8CFD49ACB7E03FBDB19A36B88AFC3F72251AC0E80DF13F9B32C291521DF33F3AAFC87882ECEDBFE12F03A60B26F33FA398618CE1E1F03F50C5D58CD31B01C0DF8E9166E44C13C07E8E4B1C2312FFBFC470A9E7DF9006C022E3CB62D9190B405BBFA0C49D0510C08F2F9134B6120FC0208881CC187E0F40F68AE1D4765802405C89E049C36703C0BA9F95A53D4F00C04F13777B865EFA3F1EBEC319BE80F43F0270F75EF74108406E060EA7D42823C0ADAE3131C182D53F2909014AEE030240AD387E6A8CA60C408DAA4A2EB4C00FC0B233B4FFFAFDF3BF61FA18E1C51A12C07584738EE42AF1BFE48E96E190C0FF3F0A03D5A4490F0B40B507DEC15EA5E4BF87FE08FEA13BF63F358D9D25C195D1BF1938982DE2CBFF3F0EECFB78C1FDFE3F355666BADCD6F13F0CDCBEE6573FF1BF9F8EB89A473CECBF6B1FD0C37BBB02C062E5FDA1EF0FFEBFDCA2876FEC0A1040FD305F004A69A5BF4CBCA7C4F793FABF6FA4A6801ADC1040E1527801FEE4F33FBFB5BE95C72E09C0E4A49340453BFBBF5C4CDD96C3A41040C31EE1471D3B08406BD289451D3A0540D39E8B6220E4FF3FDEB59DA74B10FDBF0C8938ABC07A0440F01FE14EC3A4F73FFD5B5B4B3E6A0BC083D9E5A6A60D03C0F3ACCF91E37D0BC0CBA34942F878F0BF3BEA8CB6C308E7BF88C992CD60F300C018ED21C47508D83F0816F0583C94F8BFD004DEFF7E30C7BF46640043DC7112C0A7689FF245A011403679B45EE3EDF03F74E0089536CBFABFF0149F1A5EE2E7BF9570568AE35FEE3F0A45828F25010BC07C2F69D139390340E8ACA647E10D01C0BE6264D3EB55FA3FAC0ACE527FFF03C0F0A3D639873A0940DE11DB2DCAFB03C0E2F9437F47C408C099F10A7F2E1A0EC074053BE3617C1D40F7D2CAEB2659EDBF702A00E3492EFD3F74E12D683A8915C080F667C834F50B400BD0C447588E1940C6EFDD89C69700C0102ACC7909BFFF3FECDA0F5BB2E0C23F08EE8157C24EFEBFDAD3BA64ECCF0740B8C5D8DB84EAFA3F0CA6E0488197EEBF84A4FDE72B34FF3F3542B38836DC0E40A3153AA7D64C05C09FCAED0B9BACF7BF998B27F5E3140DC022319877B5F3FB3FFE358A937DCAEB3F6C698273D854F23FB661F5297247FE3F9D2F61C62D0EF73F5CC4FF0540A909C0A048AB84C422184048E65387DA1210C0C2843159B0AFDFBF167349D594F9F13FA8734ACC9ABC0A40409F01CBFD02DD3F9A3660EDB697FF3FEC196A08460FF33FB12D162B2B71E6BFA7442497F7A00240AF470F3E95CB0440C65DDAA09A2FAFBF1CCE3EA2B92DF03F69ED135B9C69F23F4C7970A5C1FB02C0F8B34E859FF707409206C8CFBF830B40E180BCBBCBFA04404C16319E8116F9BF2A98FB962228CF3FDE5F0D1CAC5E11C0047C5E19C3CB03C013FA07325703FFBF2E6E0386D44105C0D2A2666BBFA9D8BF513D25E3E644DCBF3EA052B3AF0210C03864E3C0D56B13C027D97E3F581F16409A7D5DD7DB8EFFBFE53207A7DCEDF13F9676736B169EF53F261ECB8DF11AED3F27643582D3CC03405CBF6C7ECAFB0240CCFE288488CA0AC024D69C9683C0F93F08564466A75FEA3F0F25EDB51D8908405E9B7AFEE8FBF9BF5B09376DF251F2BFFA95F81DD5AAE63F7423521A54A40340C3709F0861730540E692C0C235A2FDBFB5A1A0C1DD64F23FC7B6EE2820D7D4BF61E025FCF2B0D23FF86E125EE731104009C610A88B2707401CC5C304D17B09C01D6BFA14938FD53F1AC813D0E42C094000810B49EA5610C01D88578729A4E73FF7F1D943B8F901C0E2B12BAAFC2E12C07735E8FA076DF93F5CF9357CE445B6BF623A1C88162400C030296C741BE0C4BF7C6AAE5687D3E53FBEDE93D82EBFF9BF7C3C65343225EDBF60F8ABE908F50D401AC27F63EDC0D1BF70494334C396DE3FDE956FF279FC17C071E2FB0985B5ED3F0E26FC405DEAE8BFAE656DD119B4E63F84314CE76234FCBFCCC351AA08FF014062234E6F641CE0BF073CED176FD1BCBF703282FDF1DE13C07637CD1E7FC50F40BEC6D94D819802C0350490B89DADF5BF35F69E2868AF0940D8465FA959210040D21B34E6C498FF3FDDB6C05515980340AB213E99891FF63FDC8402BCC9BCD63FA2630A71A381E43F01ED7CA17A6FF3BFDE3660F1E3F2E63F31A6BB9E090D134056619FAB6C880FC0E1E83F7CDFD8064015440B5B3F70C43F2703B6836820CF3F28C8D6BA1658FD3F388DDD67D9ADDF3F4A89FB7F5D47FCBF944ADF50DEA500C08FE697149F7F1340960C3D67536A12404A2F36718F0F0B40BB87375584880040"> : tensor<20x20xf64>
    return %cst : tensor<20x20xf64>
  }
  func.func private @expected() -> (tensor<20x20xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x18FF38355E0DFE3F4405FC001D68C73F3851F1FD43E2123F176B9624F646F43F36474BDDEDCE153F3A553CCA170F0E3FC8D707F3FFFFFF3F0000000000000040C3981E66E7AEFB3FBDAC42BB35ADFF3F85F0C41D7A87F93FF39412CD34FEFF3F4623D92E91568C3F201F561FDD760E3FAD67F2A697EAAE3F4F424E6ABAFA533FC676CB8299F0FF3FF537E4D729FFFF3FA52D2BF807F4303E7950AD064989FF3FDCDEAA7091C5193FD454791D43B8CE3F3525ED3E95B9A03F3A7E503546FFFF3FFCFFFFFFFFFFFF3FE3788DF0505BE83F074261378A8B183F38E9E5E72530FD3F9C68E165EF4E753FE0FFFFFFFFFFFF3FE51154D9F7FBFF3F98D4087B0CEEEB3FE3AE64209DF3FF3F7BFEFFFFFFFFFF3F073CCF6D130D1E3FB4CBBCC9AE05A63E4AE1FFFFFFFFFF3FFC43892A7CE68B3FF725FA2A421A493F34FC5CFAFFFFFF3FF47E8F7E610DFF3F830D0AAC7E75A738C98311874053FF3F11B8C0A88E79FF3F00000000000000403F97AFF21A679B3FE52E06E9C28DEF3FEE765415EAE2F13FFA6951C58613FC3F0C51EDBF9027CF3C0C10F771E7BCAB3F80B44BEC17DCFF3F834B8CF8B2F9FF3F9839A7DE7F60BB3E52346D72EDCEC33F065BB29623BE843D748306763434D83F6B25F37E96B6FF3F72114AF184E7813F7989024D9157F63FF2626323FFFFFF3F30FFFFFFFFFFFF3FDB4CE0FFFFFFFF3F8C8C598386D8EE3FE6922B9C135F203EB418F1DCB219A53FA0CF14674984C13E920CA7FE1664D63FB4AA8AE9FEFFFF3FFAFFFFFFFFFFFF3F2BD6EA96A142D13EE6C74E6944F9E83F0E6D4A0A59E1A23F2BA2BB3C2863D63EEBE582E20927B93F95ACBF8132F2953D4C793D05F3E7FF3F71121ABD6048FE3FBE5CB4DC8D72C03F86B6971F0B38663FCF4115D18C29673E7AA63B1DB7D42C3FC26F6EBA22DDFF3FBD1F90FFFFFFFF3F58F1FFFFFFFFFF3F02C1B0002E63EA3F15D8936057DCA03F39A16FD50CE9BA3F0B2EAA925E9CB83F8829FFFFFFFFFF3F74924E96B2F0F83FA074D539CB33463F8A9EFFFFFFFFFF3F37CBA8BFF5F8C03ECCEA3D7A1AFBFF3F15F571E52BFFFF3F839CA6FBFFFFFF3F182D90034483C03BE81A50D5F7BAD73F04BA0CEA048BAC3F2605B1E11FB7FE3F8098ECD6EE33BD3F8464ECFFFFFFFF3F26FA356CC6ADFE3FC2B94AB08D85F43FF621F77891AAFE3FD94DF8074656A33F9D3859B44EBAFD3FFA1A6845CFE3FC3FA0D2776690A8F83FB37BFFFFFFFFFF3F0000000000000040DB3AEEF4E971E83FF35FF6BBA103713F44AA4F848FF8FF3FD06F1CEEDCF2C43F809704A7D221C63F261EDEA6433CFF3F3FDAE4AB8BFDFF3FFAB6A977ECB7F33FC2FB274BA0FCFF3F9B43D627D370383E0000000000000040BFA5BB8DD748643FB845A757CBD03C3EC21512C952EFFD3FDC6088272818533F2C8862E199FDFF3F00000000000000405670FBD61D19243FCDF3D116036EFC3FFEE4FC2CEFC1DA3FEDAA4F909BFFFF3F84D605B7EB7DEE3F4B30855DA482623F9716EA5E6102FF3F255953EEECFFFF3FD2AEAF67F5FFFF3F3BD7A50DC5FFFF3FC72997978AFDFF3F237A81D1229E533E4D3121D898266F3D95E573D00461FF3FB6B3B2CCB579F23FA1C7A500A8116F3E708B1EE2CE60E93F0000000000000040A8FE846DC5D7FE3F5F71724B0868B03F5744164C1BDFFD3FCC42EF5495F8FF3F923CD2439305343FCBA164C1002EFE3F78400DC21BD1F03F1BD02F5C76FBFF3F0CBBE2971BF1F13F5F8EB153D8FFFF3F03E9C8A4E336EB3F56226A7AF927F23CAAC33BF77F6B8B3E25D6DD8D6FC39C3E0000000000000040041E8A05053CA73F22F7797D4E7ADE3F08C9DCB420FFFF3FE58562A3FDFFFF3F73D9818E9485F93FDE20F7908EDBFD3FAD56C01BDFC0BF3FFCA996CE823ABB3F6F3263E6F98FFF3F628CF589DDFFFF3F5143B9E6FFFFFF3F3E811E9E914B633FD01B7195F5FBFF3F109C469AFFFFFF3F4126086F12C7FE3D83271E0E7536FC3F0942C10C3A09513E1EF091B0992DFF3FC1CACB542F558A3F676AFCDA218CEF3F11D34AF17D6E213FC439FBA47DD8FF3F10CD44FCFEFFFF3F5BB76146FFFFFF3F22B7FC277033F93FD04CEF2702F8F13F5A56823460FE5D3F02D560456B68F13FB6EEDD0B6EB0FA3F9BBAC249F4CAC03FF594AB0C6112263F45729215B4CEFB3F8326FDFFFFFFFF3FF4B6E6FFFFFFFF3F429E253DF570DD3FA561B61A8AD8873F11BFBAE4C6DBC03F9248C37CD853B73F9442534C1506FD3FC9D49D19262EB73FD51938F5D85CC13F367204E1CBF5FF3FEC63FFFFFFFFFF3FF529961450E7FF3F2EA64676BAFFFF3FF4069D3AF8DDBB3ED95B0BFCFFFFFF3FEE7064F5FFFFFF3F651D59949ACD5B3E3AEF7F5DC35F533F9BC76E0D88FDFF3FFDD0627DDFEFFF3F4CBC8ED4E83D943F535946C669E8B13FB6D6C85E67E3F23E00000000000000405AF151CB464EE43F1FB431EAD3BD573FAAA6BA804C719B3E30ADAAFAFFFFFF3F69DB5B91B8C3FE3F4B63F5FFFFFFFF3F863498EEF2EEFD3FA0BEB5CB2883743F89F1C2EAE1E5BC3E701DDC5C2037FA3F9B8FA6B0CE4AA93F561DE8ABACD6F43FC3B49858D143743FAAA085EACE38793F933BF8B87466BD3F5BEB091735F6FD3F62583817499BFC3F1FA9A1C132FCFF3F6A04C2D3B8DFFF3F6AB32158F3514E3E290A54F32AC1F03F33302588EFB2FF3FF4EB9320988E253E43808E8DDE23B43F409D5411F7FFFF3F8614EC311CBEFF3F563A273D6F28313E7CF649DE6E4BF33EFD33DD3B19F4263FCF04669574BE733F8EA7E5DE35D6FF3FC423272DEA48333F2B24CA8EB2C1A23FA17068AEFEFFFF3FFF64DC97E6FCFF3FC3ECBCC4FEFFFF3FDE7A631D73ACFD3F7C8CDB429D0FFB3F101AA23ED0F4FF3FF2A06803540DE33F8A77F4B0DD85FF3FCE37BD88413CF33F1435FBFFFFFFFF3F35F0FACE25B2FF3DB135F81F5B39C13FBF4543DFCBB6FF3F9E8F2F825757FB3F38FE7342FAF8C63F458AA01AFEFFFF3F797431B68738463F20E3387F77F5FF3F2A38912D2467943F2F0C0DB854FEFF3FA9C3C75D9A33E13EF1DE608F50FEFF3F005A7C73F3FFFF3FF0105BE4FFFFFF3FE96960D4678ECD3AF2DEE439D2E2FC3F12F34A335547843F88FFFFFFFFFFFF3F20B00ACF2CE8A93E4BCDA847F01B083CC9C79F8842F2FF3FC500F710C58B743F82BA039F8AB6EA3F609EE170BDE1FF3FA662D70800D8FA3EF02F5008E3C5913F7B380F638A2DFD3F3F4E95D226D1773F8936A9C9F23C6A3E6FB5829E51FFFF3FF151DFDAF06AFF3FF94F9FB6FFFFFF3F0D4B4169599F8B3FC8C989F06214CC3F52224F267FECBA3F2BCA26872B7D7E3FF4B945744B48A53F6DCF24FFF9FFFF3FD7F24DB30066703CD2E871FCFFFFFF3FC88303C34742F83FCF6F722455B3BC3FC5148EE2FB2AC33E3CCE85E2EBAFE03F0A956063A76D753FC6D7B9B3F690B73FF835B807FEDBFA3F6BAE6A8C9A3B503F3012758B1F0A2F3F35A8C23B2B19F13F5F596CF1388CC33F57B62AFE3188BA3F08E32A48C2FCFF3FA99EDED5A8C4F73E034F7605184EB33E20CEBB9DCB4D2B3FAF621FFF1593FF3F06BCA1F5A161E73FFDB3C7FFFFFFFF3F36DDD92717FEFF3F5610F8F6ECE6FF3F3A33AE3C4CFFFF3F8FCE520DB4A0F63FCB57B8E8257CF73FFD2FF3FBFFFFFF3F348CFFFFFFFFFF3F773C05D3B383F73CA901ED475EEAFF3F73B70A7C6AEFBC3F7AB6BB250DB1AC3F94164E705A63C93FCF8816D7FA773E3F2AA44F092CED493F500104B7FDFFFF3FF5A3FF3F2962973F1CE8B2649134CF3F7FEC1EE42D3FEE3E2C52693960A7FF3F52EEF28D5650FE3F86FBA6E1D840D43F913D1255C9E9403F6223058AAA96233F6FDAD914E8DBFF3FEF5C717B029FBA3F842D838077ADF53FC68CECBB35BFE53F686232F76F1C463E069ECB89224F063F84049E09F9FFFF3F4658EF68D147E43F4EE28FF328F9E13E0916F5FDFFFFFF3F921A74A382F3D23F97C2FF1AEBF9FF3F2B2AF7FFFFFFFF3FCF3AAF7B5035993FE79C72301B91F13FF0BF51B847EEFF3F084D667624EBF23F2CE9AE83826CD53FCFD4A7825AA2FF3F1084686E1BD6FC3F638494F92DD27F3E62D66AA3F5E1F43FDC2532680DF1DF3F00000000000000404078A7B18137C83FF74F8CB49EAAFB3F684B29783134D43F1665A2591CCCFF3F8329F2B23905583FF15375D36B60F83F0FC72B341806F23F74DAFFFFFFFFFF3F8BA6F82CC3ED543E3E64414CDBFBFF3F3D31ACBA461DFF3FCEACBD02C088D73E286D8CB857D3713FAAA660BB7B67753FB194D32F3174413FF65C3CFE55DFA93F2AFB44ED0FB1E33F1273D730D358D73F22F0A1997AA0FE3FB498A08E00DFD33FED67C4EABCF5B13D7FF853F9FFFFFF3F804EA43A7F290C3F49767D7D7548EA3F3C61ACE4AF63E73FF6299DFB6B72833F06691BDB80F8DE3FEC521D810FCDFF3F5187DF3BAFF2FF3F252E46E168E5973DD03D42FB078CD43DC277B0F6F3DEBC3E3EF883296B6D6C3F"> : tensor<20x20xf64>
    return %cst : tensor<20x20xf64>
  }
}
