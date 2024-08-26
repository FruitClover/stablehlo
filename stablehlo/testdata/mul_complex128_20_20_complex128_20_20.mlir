// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xcomplex<f64>> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<20x20xcomplex<f64>>, tensor<20x20xcomplex<f64>>)
    %1 = call @expected() : () -> tensor<20x20xcomplex<f64>>
    %2 = stablehlo.multiply %0#0, %0#1 : tensor<20x20xcomplex<f64>>
    stablehlo.custom_call @check.expect_almost_eq(%2, %1) {has_side_effect = true} : (tensor<20x20xcomplex<f64>>, tensor<20x20xcomplex<f64>>) -> ()
    return %2 : tensor<20x20xcomplex<f64>>
  }
  func.func private @inputs() -> (tensor<20x20xcomplex<f64>> {mhlo.layout_mode = "default"}, tensor<20x20xcomplex<f64>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x0E84B4E7F942DCBF1AFEAB68D2600F40BB9788E3D947F63F8A5BBC81B5F4F23F5FFC902BF5D104C0DA103C57B6D0C6BFE4873F70024DF1BFCC34710DAB1901C0E455F284C10A1D405CBD8BE2032D1E405ED7A8F01C5E18400AD75EC9CC99CFBF543A133119D815C09E4E9E5BBE9F0A4000ACA2A10F2601C0040E2D85F62B1740BC47A5492D13B73F13E5E40AEBA903400A56D79F1D95FD3F590146EE73180B403C0CCC92A1CD08409AD405B1C2B4014055E7DCE9B8D1F73FB82DD7CD8A42CFBF04A9BB00CB63EABF398905F7AFCBE9BF1850A9A53AE90940CEBC088422D309C0285FD33B2136C0BF017E855716600EC0EF0E56E25E510FC0F3EF3BAD067E02C0F296276C30B2F63F716EB40ACB00FA3FC862916CDE97FD3F6587427931F9AABFB254F7D484DF004027005639E0690A405C6733B31F7CF6BF3DBAB8698AD707C07244B21D5FB9F83F964A8966431DE23F22DB6AFC1AB6F93F0D8907A2A7D4FF3FC944AA1EE39219C0B1EEDCCA5ABC15C0289DAB4EDABC1F409EAED4B886FC00405606C136018F16C0BE248E45127201C006064D5D0321FF3F422C71A03C6A0DC0832EFD81FCDE02C023987DB9E8CFE4BFB4B9C77F7B23D93FD52F55027EFCE1BF738C33CD3F78C23F4601F3A7F138F93F8ABF641E769B09C06B238744F65101C05151D2C3E4C80240085E5C1B8DD6FABFFA8D033F223F084088A1302E4AA30540960D4ECA2599FD3F04279815D1BDCDBF74A9D556E622FEBF66BEFC47A9A5E53F26A0405D1369F4BF78120C8E639613408334A8BC709E0FC04E516C3CE459E7BF216DA191291E0BC072026C5E797C11C0D2CDE621AF9FFBBF1659582C1322F8BFB03CF6177F0AF03F5E2FF6B7EEF4FD3F1E3C5B6A35630D40DE7F8A86F7E812406CD39368BEBFDFBFD40761269AAB09C01D4C2B47EBFA0C40B070DDADE11D0DC0521ED7E11E830940BFDA88BE0A29074075D2F1939DD303C05BD954DF54AA1CC07631B9D7A539F43FE2D9DE604897EA3F438A6EF17AA10CC0914CEE5227A2D03F6A8925E73F17F3BFD0522B4992E20DC0BA83C39DF283EC3F93055E1CEAB912409E878C635431F9BFB06A191C135B0AC0755FB95E0338E3BF760CF411947BFBBFA7CABFA9EEB3FEBF56FCF1F5AB8BFFBFE678D6E672EE014023BDBF56896410C028E8B76A6AA20040D087378D907415C0269746A5367309405F20948540740EC0A6DA06B028E2C43F1B1F4AB9085BFF3FACECC25DD82CF23F8AACACAE96D007C08ECECECAAEC0F73FA40839B8EE17F9BFF604FDFD6DAFFDBF7E04827C6183C53FF3173B38C5D7F3BFD3ACC6B212D409C0BA252290E2DF1040C7660E93C619FA3F02D81EF0B008E8BFEE1287CE712EFFBF5CB60DC0B59AEE3FA800910016A6E03FF0DAF19B42C1BD3F30BF6FB048D201C0CA8227015ECBE63FCAFA387CCE63F0BF00B95BAD57D1FBBFA4885BBD08BB18C027B5D5786D0306C0C067C762953603408A65607243150540F57D6B033DA2134090254E8164FFFABFC66C55FBACB0F43F4CC67D731747ED3F2262AB4849451040B6F71DC2DAD4FC3FF89A6080A73CEBBF20AE59593A03EDBFBECE52BEADAAFFBF7DEE1F7F238314C0CEDC7537A63FFDBF6ED16BAC27D6F2BF6B227E73CDB3C13FBEB9A3952429FE3F0A41911ABC7DDABFC258FCED7A6AFBBF2A3948AE6D110AC0DFF741C114D815C0C86BBCDC12A60AC0A4F669E77DB2CABF1C128C81737A0AC0E00A098C114FC13F041529F898210A4027FFBFE6B5BBF63F2928CED484B28C3F125237F612CDBDBF4417E5E7C2D411C0004732801DFB10400BFC18205E4819C015AE6F321DE7D0BFE7600C8E6509E8BF6EFC7B6AB0C005C09093864B09D1DD3F98264E52510802C06D5ECA32F888BF3F0C82418EB587D93F629590F0281C08C053D771A85EB107C010010853349602C0F8C9DA42FD9AF03F3451C9DDBA00F4BF0211191FA48307C0B4D36BAD2F41C73F2C0ACAAB31FDF0BFB6531E9A1E5FE3BF2F7B03E9296CD7BF461B870371A50DC09FBA72D8D49D1840A64069B8ACF91C406E7F0159F9E9E8BF11421FD2797805C05BDF14E9093FF33FD292B90A6F4701C0B0D448446D14DB3FDE0C3127F3FB1CC0E6711701145B1640EE956E8F940E0440AE4C5A83B187FDBFCE7674B3873AF0BFF59B5BBD6F2AE43FA8466886A43C1C4078F0BD0FB51E01408570C8DEF6040240FFD317D72DD9E43F2342E4D3B3F600C0D57E9F3814ACD9BF349EF5194C9DFFBF480DD5507CA804C072D69EE6343E01C0DC649A1885130B40EB4CBBE8B8220B401C4B1C4C4D9B16C04EF7304E5A5812406CD4A992C165F5BF2ADD5564E781F2BF3C6D9806787004C02B11F8C0931BEFBFA026E6AB72690EC0890D746A97F50B40BEAEE599A21811C0F92E90E9C4E81F407A267F2E19A70A405AAE2F5F3B1A04C0505F46B53A60EE3F698DB4A2159008C089DFE9ACDC510D405E3A43C5F7570CC0F7F8589C92531240580367D76C3612C0A84875F93138EBBF06D0B1F6D3920AC0663F56AB1C5DDF3F22FFF0C8BA51F43F5CF1009CB37AE43F031F3EC720D80BC0B8BE643852D7FE3FBAD08A5608751E407A0FD3AA68C001C098ABBA91AA4A18C0403C1AE9F03FF23FE8B7566B8860FEBFEA08BFC3EA26CA3FB8EEE051A9B50CC073FE5EA59C59C83F7EB9F209C489FCBF54768C156B79B63F221DDDBD87700940EE095CF38C4C124082C1EACE785402C06AB82E6C96E3F63F26E5CBAD27D20140339E1561FD5F01C0DAC6386550D8FD3FF7235A8E06F51340A364A89A3B60024065D5B6A33FE7B3BF0E66A9364146EABF2A77B31208D2F13FEEE0E6158EA014400172E6DB82B4064036445931F985ED3F0E3A65AC05230DC0ACDB3C5F7632104007F17C65E70609C063C452BE7F8003C09BF5BA1D218EEA3F1239A15AF85C04409FF62FBE279F00C0F8E9ACBEEA0620C0545B83E0218FFEBF72CFA3F62D40E73F74153C588E3300C06075C01731E9D93F0FE70D5A817114C056F1D17AAE87F83FA6761E50B25618409419352796BEFDBF6C86B2B463AF1340B5AAC37D93AAD73F0C81AA2E68D0FE3F681FAFA359D60BC02AAF276CA06F1440147F06498C75D03F57C497BC68A6034011E8ECC3FE8D004058469872851108C0C0F71FB85417F13FFE4D39D3702CF73FD3B498F82EA0F03FD90D4B16E118A5BF95EDA15054AC124087FDB3F5BD6FD13F826AD44F2A82C7BFEC5B93FE113B07C099E0B2B5EF9918C0E089A1513613F5BFC5C7E51A9959C03F97F8F5CEBAFEE83F6E06670D38FCF63F2CEE5CDB8BA900C0DCCF45773C220A40AD5224D05AF80E40C41E01249DB1F7BF84A35C6FCDB8DBBFA83B3463471AEABFF9459A5E7B2DB6BF3624893C589809C07A8644D30352F5BF733216E6016DF6BF854CCFDD8CE523C0DD9FF409E05DF43F6AFC8BB6575CEB3F6F99938E73420C40B4742A5983460540102316E3271FFABF732C93C4A85905C0B157AC9AB978DD3F9489202894FCF0BF83D4137D09ABF13F89719A2584BD00C00DE40F37128BAEBF7ECA6A851F40E7BF9A3C9BF55E551CC0F4B3BE31E843E43F3D10F358E4E9F63F26FFC93F6396E43F32CFBA77318AFFBFD40E56A6FD7F02C0EC1167971A87E73F16D83CF82651EB3F6C22333F58341140EE233DFC4372FF3F5273E1DF6197064020F884A87B56F6BF1413C3A160BD06C02E72F993413DDBBF686CD067B49EF5BFA209434E8138F33FBF5BB249062DE6BF8659AE58AF0317409978B9AECF711340D2F240978BD20CC0BC17EA57C55AF8BF4E6A49D6C6B4D3BF85C8BA6F5C39F03FC43A7A653DB4DA3F863C7B0C69DCDD3FB9B1CDB9A4CCF0BFDA36B9BE617214400C53C6CFB49C124071E50BF398E3E23F2E17DA1BD3DAE7BF32E38560461004C0DC2D8754B7310AC0A20E36880A5A20408A7F01C28ABCD6BFDE5541C735EA08C0ECC8A855F0220140CE5F16FCF18911C0FC3035F5A46AE83F4DDA58408B3003C066F3AB5443B702C002482B08F2ACD8BF0F137182FE27F83FEAB1C2281F1CF23F280167B8E9FC0D40FC060BAF2E93FB3F85F6438E9FB90940E69E174357FB01C0B0FFB6CBF2BF104080BEFE7ECEDA164082E7BCBC582BCEBFE039FE3A6E7C08401615E625EDD2C6BF4A934B4E0A8C0940A00FCDE03F2AF13F82FC8F818D93693FDABB88E1DBB50540D3F75CAEB080D63F13C5A9B64D0D0140B4C70208C8E4F3BF406646BEF974F9BF2EFDC8E31DD8144016CD1FB7FE9110C006AC5FAF09D6FB3FF437ED98EB3EE93FD422A3F93F0805C0FCA6F1DBCD3CD8BF4644DFB5BD04F3BFA38769576F6E1BC0EB19B5679F72E63FE8497E8CC73BE63FAA488330434710C0493885B19FBA07C05822281AE3EF03C0606ADA51793A06407D287CD26E3D02C050A5745C7B3402409B54353830BC00409C7327C08F24044066A8914E4756F7BF8874033958780AC039F10B3EDC35E53F568C51164B26E1BFC473BEA2472FFBBFBC2175FCA13BEDBFED0BD40FCE0D0540B7A08EB52079154000C5C386E061FB3F4CC2C78584B2F13FFFB0F9B1EF17FEBF54A285FED60FF23F066FCE92E7B7FCBF2C5411D28D120A40E816B8685C6BF93FEAC47B09986D1640EC6059194A1EFE3F02B78729DBD9F33FD2F8171A71C2FA3FA5C22ED56FDB03407BAD2459633AB63F42C49513638FC8BFE2A1CAD98811044052C2B8EC2FB0F63F67070C22A7A4EABFACE82B0CD013EF3FCAEF04FAF0F3EDBF8ADB550532531A400792125F1E2306C09680D4A85656EEBFC8EBD46158E20C401572EC18DA18E33F948E25E24ABB06C059FA23DD26741140A2CC655BA3110B4042762471FDA4DDBF5F5047398D4B014037BF732BFBFC04C0BB779065EB3AC2BF880AAF198B1F14C0A299A958EFE719C0F838884EB9D9DD3F7C16EE9C15060940F061D37F34460940441671318F21F13F25AB2B5D3622F43FBA0E529626B9BDBFEA956BD9387111C0CD189A24FBBDF7BFA02E4934EC9C0640C35033EE12D8F33F48CE4A632EF90A40763222C42250E3BFCEB031D7AE7201404CA6B2370E8D0C4072A18989B20C02C01CCEB078CE75FABF31E0948801A406C0900A7AD8EC28F4BFA64F2CE77562FEBFAEEAE142286D03C020BEE88209A31040C18417B8EFC311C03295FD204EA2FBBFDE042FB0968918C0AFBEAF4956D21540F77AC1E7DEC4FF3FF793CEB5EA44F7BF56E192830C95104060425E8F21F316C0242BBDC20175C23F8263349A48FF14C0EC409A3BC37FD2BFFAEF9D14D1871640D6EB06BC7ED3F13FEA94E3AF03451940EC0FEEE1E8430B40BBEF675480E8F4BFE4D1CD68FF6719C0A2E8A73276510840B411CB00664113C0709672E500C90CC05D6548D44571FBBF82968C8F439CC03FD5439D72D08E01C042DF0A06F98A0DC0621768028EE4ED3F542F11FE200FF83F958C6F31082A00C07CEA824E5957D13FEEA28E2B3E5CE5BF254EC06D15AFF8BF15FD95C56465FF3F91EFD566153A0240F6805D7884BEF2BFE4C7EC497EAF02C04BB5B3BBDDAAF33F79FBCE49B63609C0D66CB396D5D0F83F14459D2FB00FFC3F286AD8DAAE0B024042834A4B35D8F3BF48512492C3D013C002C048EA0A9AD73FCC5C1AAED6900E40C14AABB98B90E1BF6F04197776B90DC01C127D2320B2F23FA0FC3BE08D580AC0E22FDE851131014098D09B24624205C0523936E7F3DB0C40E6DABF1C047FB03FC0AEF932F8A406406DA387DBBE14E2BF86D5C6BEB710FABF168183C3668AFF3F3C3747F453FB08C097AD656BFC1B1640C86D05565FE9FBBFE5776175CF8509C03EDC4A8F530802C004D133C6C730DE3F728F13DFE1D5E33F1E96D1AC359B03C02EACCA0D571817C0A54C9025122FF33F97C422FC08080040C98E65A9E6B51A4004BFAF7C93DED73FACE0E490C2880140B0485A537A77FD3F4DED7C541ABC973F9EC83684253AF63FAFDB36696BBB11C04E35FFCFDB4607C00EBD751642A7DB3FE80A5CDB52DE1840D802ED4846E007C046385744CF1213C0327479A1CA5916403C68EE1F8082BC3F1538C0FA2B96F43FFC7343294ECE11C02E23DC74A4D878BF1D8009105A591340D811C7A25CD3F63F1A3858E522D1F7BF4058375220DFF5BF7151932D6891F03F76ABB9960CA8F1BF4204C9E12932FDBF22804478B754084080903F3187090D404268116677A3F3BF3625F55B703BFC3F7D58E107838502403D560E8007A100C0F8D2C34A797C0340C526D61A8D62F6BF8114CD8F9B70DF3F248CCAF53BE9B2BFC1342B377BD412C05D1990EAA3E90A40832618E3CC7D09C05682D7BC1CCBF23F0B8587359A64E6BF11BBD49148BCB93F18045D6972F30F4074AA2E312C61FA3F8C9B5E3C3AB308C07AC2A354B166EBBF0B86C615715D0740B534160521B10FC0CA722A86CBC100C010DBF70F51AD05C014165A5F536115402AF7FE671F5712407F61D4F380F103408E2E290C57C8FF3F6DFE25188F1FEABF520A447A589A0AC08BCBDB1A4D0406C0D1AE8E766C93014083A904B643AA03405B0872E0C3570740E486DF3F087D04C0D8DBF3EDDFD808C01EA70EE544761D40521AEC737B6DEB3F69F99B1AA74D14405DC9C8482A23FABFC4564291A10DFABF7083C20C410104C072703D76D53F09C08A19213A5327F03F1498E6109A4D0440E71257A6E2DA0A40FEB935D48E8709C0843CD3E69CAF1BC0BE5F6D64F728FD3F4F0C5D57DC5704405146A5DCA5DB0640D552DD09031EF23FF25E049258431840815184AB426604C0FA2A594D0D05FBBFDEACDBAA85AE034022C6C0D8CF5704C0ED6F10BCBE7AFBBFD25A58AD25EAEABF9C39F52238A70F40FFCE566317AE13406FF1EEB3E00E10C0CEA7CFD76F4EF33FF2A1D0C4B23510C0F07C965665CBFD3FDDB6E42F91D3F63FF06D15AF2BC909409F2F3446E3A103406DEAC3E48DE217C020EDFE9D3D7908C0C11B45A807E5EB3F07697068996DC33F5A3E6D147C90A8BFF4DB8F1DF54BB83F4B14B2B19FEF09406E229289542BF1BFEA2D45FAEFFBFEBFA0A7A913BF43DFBF1AFCBF31DD05E63F32FA23822406E6BF68599CCAE8AEF8BF570130F33621FDBFDEE2A08FC68010C0A009E13A1A7800C022EA39A9B342E7BF31B436AA8C1AC5BF4952E8059F18D93FE62FDD929385F53FB1BC3D02376B11C08A51FEDEC84FD13F7D54F103730F0DC01476EC077ABE1B40C0301186379F04C06DBAF3846C47F3BF5608727F0299ED3FAE4A341D39E513C09E3FD3744D76FFBFBF646F357BFA0B40607A21F63A590240ACAA83972F0AF8BFCA59A4005AD9F1BF7D067311EDA0E83FA3417103AEAC20C0F6D7DB7475F70240F904BD0FFD350A40CD76B5C28C1A00C0FCF1B44F4CA2A93F672DE2801FE7F63F40AF7F25552401C0181C7B2AE502E53FDCB4481E25A6FABF339E5BA90D7CF0BF706BB64CE53D0AC04F52E5A2BE8EE93FB2306EC4510402C05843A0FE37D9F5BFCD94D003C480124021CE82E54D37EABF9FB03D85268506C0F5183E38AF0E13C0DCEFB8E195659D3FBD708519482D004034868E2684080A40FED20139D111E93FA6A4E24D454D17C08CA352787EC812C0D4B63C3BD93F0AC0456D3C7411111340B11B13B79130F3BFB2737B33240BCC3FAD762C7874BD0040A88AA5163E7202C0FC1C84A92ED9C03FF114DE447D5DEDBF7892027047DE09405A5901EF4FA503C0DA27E5AAC124F9BF8E08C9D0B4C30EC0EA3316286D52FD3F57CF186C69760AC0C6C6E06D5726FB3F3211AFE62ECDFFBF52388C592A940A40664CF59C956208407DD85556D2700B4044AF5260D6D00840ACB715010D7904402A9D3F5EF42F074040AF9065DA3B18C09C0E79286F490DC01C19840A0679F3BFE286FB12C31A0740A526F9DA8A07E1BF2B8CD503181811C0B053A1CFE017F6BF9492DDFA306B0DC0508D8AA9ED900EC0F131340687B60340F4C828D90B8CD3BF705203BD4E11EBBF48B4B363F4B216C0B23A1D44C48BCDBF22E36C1E4732E63F4CCE5CA98BF609409388E13F25C9E4BFB8CD09990931054079D5243FA0C6E1BFBB2D0128CF070AC09376FB766278E43FDAC66EBF69EBF03FA67C32AF4899F23F6232DC0D2253ED3F0D7815ED0CA708C0C4DF88104220FD3F52E6995B10B6F1BFF550070A1016DFBF538F2F4CFCDAF3BFEE9EB77D910811C08000BD24F09502C0B4F63AA2349204C0868C974E433D0BC066BBA6B2956916C0BC78026D033A1A40506255CFA8D8E0BF564C4C8D5EAF13C0D8219BAE7609F3BF2210616B7F30F6BF856185CDDB4FE43F62849562BC54E2BFF05A8A26940FED3F9A09BBA04E8EFEBFB70E93BFB0CA0140958AEB11F54206C0F0899AF64EA00640B44F2EE34CF80840A0BE5293B144044054792FFD2664FC3F0EF7C113D8D3F6BF6C9839CE2E20FC3F1CD0C928EB0D0AC01EE44A2D4737E33FBD158A2055FBF4BFBA8D3F4A2A0FED3F32E2A1C1820807408FDB44D6F70C1640F83EB4996D0B0A40F044B2354E5BDC3FB119FE14CB640940B38F84C968C2FFBF89FC748CFF5CD63FD393E249DCF4F33FA0A16DFBA7A9F8BF8E9FB0688DC20540FA85A8A7FEBF11C0C427E336359014C0D63D6CC27A4DFD3F2E04A7F1465EFBBF61D814398E3CE7BFB45F93C69682D1BF5012087677FDA7BFF89F63EBC35702C02AE04A72BAC6D1BF2E24D4534E6FD13F514771938AC3F63FED266FFA1817D5BF3B57C6B9498BC8BFBFE45BC4D132EC3FEEEAB7109A8FC7BFE012B3EB1FD4F73FA4471932CFB6E1BFF82764A7BFC2E8BF8BA31A7A5FDFF03FB8DF0DAB0686F8BF4B7F19C15981E23FECEAC38AA95C184008F9075C43D91040273C7C374EF500C09617C79ECDD6F23FE4830B9C941CEBBF55BA29A0C57B05C0BCD5ADB7401D15406E276C56FC681440FEDC3DDB840AFDBFC49FEC438F4F0FC0504240476316F8BF70C6697E0253FE3FBACF04FD62DC01C0B8837E703879FF3FC00EBF522979F4BF74F6577151C8EEBFF884D349CD3E00C0E6D8FCA3FE60D1BF87E44A23132A06C0E8DF103D104606C0081F0618F448F3BF"> : tensor<20x20xcomplex<f64>>
    %cst_0 = stablehlo.constant dense<"0x0840A6CC7B070DC042B05F605BDFF4BF464D05269A05DFBFB06FC764C25CDE3FF79ED397AC7FCD3F9C97468C1D3200C01E257947FFC107401BDB51820B83D73FF64D963C009208C0D867E04A80F4E6BFD0D0575C1B91F1BFBCBDCC1E885D06C0307EF88400330A406CC97136827BFC3F4F847191A330D43F97AFA26A5398E6BFC0B06BA520DEE6BF2B69D721240DE63F6337B081DB99014082A6800E6077D03F98C40536206C14C01494367725C7F23FD735F809A73001403EF43C3549ABFD3F46A26CEAD606FABF6FCFF49CD5D4F1BF4CB2A415B44FEC3F724116AB837B06C051AB4B23A586FABF3618CD0FD0FEFD3FF149F7BC472D01C018FF1F84D79F13C07DEFB61D91DB07409D90A080D82E0CC05880E4AF96661D40D15539F80E6FAD3FBA4C1A5220E3FB3F212776F78143E53F74A318ED2A2F0640301A00CAB59307401283FAC15F4BFDBF5D1BB69DCA7D14C05A69421AE1C30E40C0123A74D88608C0776F88A9CD84F3BF0AEEE245E99BFB3F6815DF46AB45FB3FD0777BA5ECD80EC00B3C38254A19114014D8766C60AD00409224427CB576FD3F1A6FEE22EBD0EE3F1DABF884658302C00E4B0C4D1DBDFE3FC27572D212D51940AFBF347C2FB6F8BF1E0406877BB3F43FD002470C169811400E42F01B606FF5BFDBDCC42D151FD7BF70F6D542889313C0F3A8E00D6F98104055D4171F7A281040951E199F28221040B4403B459D59FABF48EB02081BB8E93F0AE6477725020940F0757E21EC0E09C0220BBE217EF9DCBF6E3F6EC0F24DE83F01E1C7F4673B064026412C9A2D800AC0EE1703A7DC1A06409472B0F04B1606405EE1BA46307201C0240AA8C378341D40701142C61C281040C1F9E39174E5F73FF0F24F38A83FFDBF90C1069599620DC05C96ABA46CB103C02C20179E880F713F9497CC3C51BF00C0D4C929D577C2F03FB2D2DB8DB1F40CC06437DD612378E03F0E5CB6E9765DE93F5DECFACB3983FD3F8E2F3CD9AEFED9BF726FD6F7504E02C070802D0EF2B8FEBF8CDA72E1B31610C03407AD4ED06CD5BF261D0FCF1FD80BC05D5E6D03AAAE0DC0157B7261E8EC02C00A3E3A19216CE4BFB45DDE68E2C7E13FDCC38778EE6301C0E0363C8568D9F1BFDABC06C705E912C068CC6F5D79CC05C04C9EF4ACCCD9C33F8AF7CFF92DBE0940110938E9E9B01A40BF649624138A14407E7BDE73E15B0F409462414C2C45EEBFFFAEFE37D49BE53F2EA16A045B42E7BFD203EB0C835ADF3F26344A923C890940404DF664789C0CC060ACE8B88269F63F960BD446C0A205C05CA9820004EFFCBF5C5360DB2105A73FBB9D675FEB5307404731158F459FF4BF27F5AF77C57110C09D221A9CF78D16C067E10CC4C40013C0DB520704099219404CC2D4A0DF9612C09C82DEBE55330840056BF8513A91E9BF516DF8FA420512402B259055E2D20AC0C5DBC69B4EDD07405AEE6A6D3FD2144033C3A886E00004C0B76A1545665E07C02A2F0EC883250A40837008F4CB80F73F3444495024D712C0486A8F923B8C134060091ED4E1C405C07829598D958D07C088827DB1BFD3F2BF9C4B0C9B5D0A0840361BB57B8E8310C0F81C6DEE7FB200400A243BCB92EF0F40B53124678D93124053F145C08C020440B6539E4B932716C0B026A660009F0B40729BC0091195BFBF5F8D5D63049AE43F468D24BADDC60F407DC0BE6215B9F5BF9F5E48087FB60840F900D78780E111C080D95177C27002C0FBEB99CFDD3BF23F89CDD64C1E34E83F6C89B8150629FB3F0A9765A583F30AC046DA8001E95CD23FC2F56DC22CA3024038AA7C18DA55DB3FD63DB9BECD6A14C0EEB9946B4B82FEBFD4BFB8C385D3D3BFBFF2CD95C522CABF50710A09B2870C40B25A4D88930A1AC09C54BB20B606D0BF750DEC7E6C5C1CC0A0709F2EDAE60040605AC9315248F1BF85BD7C9AB48D04402FC4AB53F8E3C73F9805E92198260040A4218175E5F10EC0209D699F8CC30F408EDC34FBF10C10C029F024244A331DC09BB1218A7F06D03FB82E5A4264BEFA3F7772A73B2A64C63FF7628CD18027E63F7AD09240B27B0040441E24E012330AC038CF705F88F4F5BF3C1C86E3E7ADFDBFA2122E6DCE8CF3BF7A306F6DAD9AD1BFF29D74370470FEBFCBAFEB95F3550240829DE14C0363D1BF3B013AE6E54EE73F2E7BED707A80F03F322F32D7CDC1BABF348310A5E0D908C030D113ACFB6004C08714FF1CB3C8FDBFF8AFEC51EA76EA3F292A1033097CE63F4D303206EAEE0740FE70BC6F396F04C0F6125D231FBFE1BFA378AE95890AF8BFFB5C88BBFB7A174076BA5A3DDB7FF43FEC1B2E1A99A4DCBF08B24347B3B7F4BF8CB6259320661240BEAEDE03CA61FDBFB44C014DCC180C407B31642AC1D60740DA1B7D9994BE09C09D71530D24DB10C069D43AB3EA59EA3F72E1F2E21158E33F360B4B92B565E53F1D7FD119D09E11C083459E728B89E3BF42C6BDB6227003409C3842808319E93FED995DC2FFB012C09D5B7426E13E0940927818E6587EF83FD0EDA3BC596B09404A7560ACDB641340D1B8C25525711840F1ECDAC8630DC63FE233242E5133F5BF8D2791D63505EE3F029637E2DBD2F0BFB8E6071189DB0E40E103DE115A69BCBFD2FBBD86EC261140E13A24CA6A54F33F5687AC21EE41F93F68D33648757220C08A390CA9D850E6BFEAE370DDA43BE03F28DB6174C6290740061F2CB6956DD93FB824CEEFBA721340E876DC61047DE63F55B044F04CB6F53F2083705029E8EC3F21905CF449A118C008B54E08D561FFBF3E72D613059CFDBF6368D7EEA64701C0D08AE13DF6FCF7BF076BC67E3F3BE9BF378C564F62FC09C02EC59B39DD42DB3FF39D2EBADC71D63F0D93569DAD2604C0FE584DD947950A404358C956CC300AC02D861D519269F2BF7207026D9EC7D2BF349FD82274720EC0709C8386816303C04BD0F9A5597F00C023F6FAEA36B11840AB1ABAE67C0A15C0A6227D8701D505405FD74410C17003C0AABA16A28039EFBFD50CE615B382E73FF00931504A6B06C090458A678CDA02401921A6D3248CF93F02A53AEA2A8AFABF76CFC3FDBCFEF33FF9934021463310C0B5EB5DD5839107C046AAA39DB6D00BC092CF088EC016F23FED61AEA4CFBC2040B00A15BDA5E120407E5314D05845F73F806DA7D927D7024022C81D8D8AAB0440BA0FF7A190FA1840B8B8664D77BEE8BF18F5276E5117F03FD0CD562EE94F0AC0538EF787B949DD3F3E6BC44183D3F23F4AB268A9B2431A40E44F787B0A0CF83F82658C625D45E7BFE67E7480DB6600400E06B18B29F9E13F4600DA32B07EE73F3D3443C14A9ED33F74DE2CDD14F80340D05664C1BF1EDC3F061688E8941F0AC06608ED498B3AF63FD46C782B51C20DC0D1F9A56393EC1D40E59CF587C4ACEFBFEA50EAD778290D407D790273798BE53F218328A0BB61ABBF5445404CE367DE3F5D72C1F747AA08C088478694B6E700C0FAD2FE8ABA3A05C0AC56BFF4022AF03F7CEEB17BA0B2FA3F9A372FD311F500408E1D101E63C208C056878B30BD64014088654DBABD29EABF3EB1D14756F9D9BF40053A3FB3FE18C0A64E76756DC506C0D3A9F75D3D60D7BF08B315BFFEE906C0A450134B96B5F33FBB4AF81367D706C0CB61DAC03090E13F2B150F99205DF43FC1ED7DA7E04EF23F42F10E03BE91ACBF16685E431D87DFBFB537250C1B38BCBF3C2DF15B3229134097AA64FB4E9AC5BF6EBAB8FFFCA70540713F5391D88E03C0A0EE7555B53018C0E6AC8F176A83D3BF98C89BBD51D3FFBFE3C01C25F4C501C00432C945D07014409E4C1619960608409DC95153846E0440CFA1B02A0C3712C08A4F630063C90E40F4D434E561ADFFBF0EEF2169D15AEBBF591D9A2D600BF6BF3A9D1B183CCF04409FBAAC4AE88EE6BFCA35FCD12F51F53FCFAD0656D24FE93F704A9DC5C03610404C1A4C08AABC02C05DD8D1BF562C0440D61B4AEC9FFE0940223B3E995733DEBF824086F0983C19C04C74A1B652520C407E7DF27DCAC6F6BF94BD78059F5918407E0955BE14DD04C0FC2E4371F98C0DC0BB49C797839312C044E60F4572FFFF3F0B8DD0BD00D70040E2FFA6E9267CF3BF5D3171A1FC1A05400F7790352A8D11C083251DCCBE2617C05A4CDF61C18F08C016CC024805180140B13B172ACFA4114080D6D6476F73F63F950A95AB7303F6BF0AD3CD1A51251CC022CF9516BC0203C036A5FB5D8FA0054016B4600B196B0040B9F032EF6FE5E6BFB83D75CB74FFF3BFF3887DA072B8ECBFC7A28091AF161640910725A8BEE90E403CFB6AFAD482D5BF2DF8BF8F1AFA0740221CCB2C2630E23FCB80C85DB1B412C0843F5AD47D091C40BC3E4016B8300040DE60A20F95C6EF3FAA18B38BE9610FC0B23EF185564DFE3F321657652C0101C0521FE550A85B0140AC91EE427A090240160DEF638EF5F8BFBC092EC4CBD2FDBFE203B14425030C40A240D1C6A2F21B40240FB0F4E1EA04409ED313D13AA5E3BFE4E3D9D3215FF63F8AAC130377E0FDBFDA4589A795D808402ADC1BEF15451740FB0FC67A9801EABF48AF7DD1CEB607C09436C9599D02F33F4ACFB841F2E8BBBF54CAD3D0740BD33FA656BA8BFBA1FB3FF2D877F2118FE63F1F657D9C293B2240DC43310EAFA30FC05321BAF33442F83F2143E5AC1D210040FE98E7AE7B521540E52608F998640FC02C5B3AE44E0C0CC0C6417574D1ECFE3F82AF52489A65F03F0ABF5555906D0EC01ABB2A0764AC0D40F92E229530000340E9E7B8A197D707C0CE3264BFDE150040F4DF4BD302E701403E96FF0CF89BC8BF20C73A7A46270EC0BF7CF087B30B03C0781000FB612D0D40DEDDF0A3FACED8BF86BBE1C3C2B40F406439C0640B98DB3FF2270334D852F23F92F04110FC2A12C0F8F24A27CA9FDDBF4E44B33CE96E11409A11236907E4F8BFE9E5ECF41EC5F13F78F2514054901940E962D08254CAFD3FEBD552D6A07106406645C6CE1230F03F2C597859082A12C0B60F8CC545F815C077D73E298620F73FB8F0EEC2C1D7DFBF56C19C6BC4C1F33FC65151A7195CE53F2AE3510A1F94E83FF6165EDF25FE0B409631DD6EAA69E23F57359A9DFAF0004017BBC94DFEB703C03A5F431DBA0EF73FB783CF28722706C0AB5062E55E0D0AC0CDDED252C20A02C07EACD48708C5014084F8637BA342F2BFE401827B66D8FB3FB424FE1FBCB00F4062B32A2996C0E1BF1AEB7037E9A11340F8B90267F6F8F3BFF2365A1DCD9FEABF5CCAE5ED02B7C43F3169FAAC29BB1E40B419D1296948FA3F9EF38CAA5FD6DE3FD345173E7F27F63F7CAB54D3A84C15C0BC0D69F86750F5BF626D3A848A2817C03C6A81FA5D5F09C0A0A7617B4B600E4074B8DA6B951A12C09AB5C6E2728EF4BF724BEACAAB08C63F9B96E6877ACD074046A71CF659F2EBBF545D89B4EF5113C0B7B75EDA989117C09F9184868A47E53F8F2B97F8ED480EC0663663E4C779C73FA2D1CB2CA831094040BF79A70C2F1DC0FA516B2203B3F53FD7E4D36E31B504C0B43830E7B270E63F623F04E22F00FFBF94BD080975BAE03F24280E526512F03FA085166500F8DA3F2A6D9233BD1AF7BF31B0D5624B9407C01BD6203281F0E03F006E726218B1F3BFA87F6C803E6BF83FE1B62E9FE1C3E8BFA59F2966E994FFBF5A41DFC91D6609402044D0C6E4B2FABF2A231023A87C14C0C1317ADE0925F6BFE5E8EF8250DF01C060BA83F69F2102401D1EE77E5F441240663651F22D9F0740B388EC5D0B91E9BF26F55984075606C00CE4D2F9A4F3F4BF26C5D2EA78D3F0BF74174A512DDC12C07D7797196DF5D8BF60D91A1EBA9F014089927B1885A7FA3FBAE68873B002034017B89E60AC97BA3FC93D61B578BBE6BFFA54A9BDF9F10140323A8272E1400540867F4A6F64FDF23FA9951776A55BF13F10F04C274377E7BF0EDBB44C67F119C000EEDCECC09F0EC08D7D65830252F4BFA87FC09BABD3E9BF0B4B29C619FF03C0029BB630465AF7BFBD49554CD3FA0540D4254619704B1340CBF8C95E3A6B07C0D8FA212A5CA00040D007D15F30E505C0799568A83EB707C04BF93CBE529320C088B2DCA6AD2D0BC0223C2774A57A14C0A611CCBC6DEC0CC0E000A74DC1F60A40D2F30CAAE3E3E33F34857E610A56DC3FC1B41E592BFAEFBFEFAA4994A28EC33F5AE1942EC2E2F43F3497423CD4B4E93F1C444B8AF1370A402A5AACD86B24E83FAAACCF0D2196F2BF785E5B7CDCC4124056B38BDFC85CF93FF1BE4C14222F0F40CA182906F89D0BC0D5F1B2518E83CF3F1CA4A1381444F2BF5C3900231EE704C00E46D8038D2D1040CA6E5A303732F63F71EDB493DD7C09C09E30FDBA4EFD0E40FC02E339F16DFABF6442F3D47C06F63FEA76AC144B96E33F94EDEEF9AEFAFA3F98445A956744D8BF2A8A9A793887F83FE81CD4F5469B0640903C9EC40CF2E43F3CAC35B906BB01405C50102203D0F8BFC49B191853B801C056124861667215C01D60C38A1CC40DC0567A7B3BD5B3F7BFDDF56D203C53E5BF1AF7ED50EE88FDBFE6A10C262C3FF9BFA2C8B9875DD40340F10D82173577C03FCC739EECB5BCFEBF1C84C71840CAF83F1CE5FD949FB2F23F68D348CD88F904401C9C047F5EEA0EC0A6F1C47492921CC0580B234A71D70BC0EB3366B3281EFA3FF5B797C5404B11409D708CAD5F54EF3F52F0FD712B16F23FC0964098504B0D40CE04FF1E0539E4BF903B615CE17DF5BF7EE618D6657BFC3F527FA2826526C43F471B89089A3DC43FF7411300DF3D0EC09A8D990041F60640C67B92EF1B53D03F80F91AE3AD17F9BF7700FAEA9C36B4BF322FF70FA86805C02CC293A51AB01840C815D0F2480BE53F0AAE68D8C69E0EC03AF3D98C5480F83FCEDB6D73532205408115DD8FFC1C0240B2C3588061510740546A41221AD2E7BFAADD938F5E01EFBF78DFFC857B9518C03099EB10A305F13FB6AE677E2A14FD3F2CE24601D428FABFD4B712121AC0084089D643BB35B4E43F4A0F44FBC5B9114049004EA095CEEEBF22A5F081A7B503406A0A79B6AA5AED3FD1F0A8939F4E00408F18286F8A160DC060CB48B4A9E1F4BF0A7B3CCBEC4C04C096197EC86FF6FCBF53BEB5A302D7EBBF7F287A2FB16621C06DD0403ADB2011C0C8443878F8E908C0535C962A6AFC1740CEA47360475102C00CE4B30E071B25C05A0EB0526EC709C00481D3DFE02FE43FA2084386A2F9F3BF61E1A80E988607C00EFB5E58E91D05C0D4DC2B8DEB0F12401DDBED648FE201C0B2A95FECBCADE6BF02B80FE0C8D80D4023B0E4A0D5E709C096AB50BE649FCD3F66CBBD915C530640A4A4D440EEBCFBBF2EC5D6FD98E90C407A64C46BE25512C02C2D15A7871CE63FCA293C48AD4EFFBFCE4500BD0C5E03C0451E697911D216C07CCE922216030A409255333A78B2823F9AF62C8D1935F43F368E8B14E92EF23FC3F07C8A18D2E7BF4E8C94D97D4B0FC02499DC45D05FEEBF8FE61C27966B0740C8666B1C37E9F8BF08F9DB28779E0FC07CBF1116CADAF33F5F4BB4A9F1C9074012CD05282591FEBF35136044E3A710C076C9178EE2EC0D408A7E6D165A23C2BF8C842B8B8D09F83FD3FB3B810A6F0E40587C47405F54FABF3876DE873E6B1FC026113EBA0519D0BF5C04890A2F301140AC68044765230C40B8C071B2FEF2D13F0F21A1EE571A04407E0EF2AF3A582040306DC49ED25E0BC0A2CD23369B1D2040B0EE4DB8B77012409399B81BD155FDBFC829EDABCE4AF73F930D47C73F4EFD3F11C1D55FD1F4FCBFCC4E6FEB2E3600403BBF56D08E070140ACB5DCB0EF220F4082D86E5DADBE0C40A8D8F3C34FE6FCBF41CC7F8C4CA4FCBF805E95F7D93DBA3FDD8440D9285016C0587CC2980F26F23FB8522BE3F0DCBCBFB864F333474AF83FEF3C08A03F051140B4BF81CC38041C408289A38CDB81CA3F6389D49837D00F404DA3A4581E5BFA3F7E2EEA6570D71940E0AA91D3CD8CC33F6E2CEDD49AEC0A406C5FDF29C1410940686343A58074F13F1C00C5C2B9CF18C004DA74CFB48B0140CC7D5D4D715770BFD2FA79073C92C7BFABA8325BAE5BF73F92C076EA4F85E43F341C4C36999911C000B003D8E60CDEBF4A59308F2168F43F824605FDDDCCA0BF5FF78407316E04409852921DF081FD3FBB3AB0F9507DFCBFC03DE75332D90AC003F20E5F0233E53FBCD608087F290740021C20BCA661D6BF04BC224A3FC518C0B568309C720413C00ADC0DC7DF78FE3FC39AC7FAA0109FBFB062E9C4BB06BD3F5A40A0FE85F51340E889F858265510C0E8B06B18DFDDFFBFEB938BAE6C9802C0367CD39B9120B93F0CF9DDB6AA3CDD3F90CC8C8BF1B8FEBF75AD6FB9BCDFF23F58A173099E631940346FD8F749F6F3BF7268EBF32B3018C0D64F52407563F4BF4A65FE78D73012C0A9BE4901D61CE83F0AB9BA2F91A6FBBFA1774976C74AE63FD0F0A442112125C09B27A026F2C2F53F5ABB0DF0EE4013C0613C1E3EB2FCD1BF5B2FD23CCBA4A3BFCBF357DC862DC53FF8FE6FFFA91EF9BF774D9589D4E6F7BFFB875329F2EDF63F4C113FB49E63F13F92752BA81F451D40C5DA3F39E61FFA3F58A2EAFDC665FC3F5CFB426428DB0140DDE3E185913F15409F5F9ADF7FA6F3BFA6148D54D6A417408C5F2374EED2F73FFEC5606F64EBF0BF5C176ED5C5480A40FEC272EC916FF53F684CEEFCBE80F43FC23BC95FF4A505C04A49AF41037D0AC0B21B519DA5AE1040088E4E562BA01140409A2C078A050FC0DA4611151039E43F5E8A4420F12800403A9034D1435810409E2346688B1F01C0709CB787EB3FD13F349F2E05F67EF93F4FAAA66B3F45FB3FB203E2CA058C0DC04C930189242AF63F84B48D1E33E30940C71F713A4DA4F33F90B2174DBF5C1340BDE46A86BC72F4BFEF5D4C3369C1CDBF149F3DEDE1ABF0BF751DA1C9034F00C07068A41126B2E6BF73147A071A640EC06CBD4E3EC2FF8C3F5B8947BDF60406C0C652301D937CA93F753AA1735A3E00C007372919BFAF174052A630B2E8A8DBBF04095F933E440840EC5606B108B4F4BF8E9CEA0E95B003C03D35011E05C81240409A3A5C28CCDE3F"> : tensor<20x20xcomplex<f64>>
    return %cst, %cst_0 : tensor<20x20xcomplex<f64>>, tensor<20x20xcomplex<f64>>
  }
  func.func private @expected() -> (tensor<20x20xcomplex<f64>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x46BC40735BE01A40AA0E994723502BC01126B73EEFCAF3BFCFAE447A861CB63FC18A7D196EBDEEBF90E48C631BE914407F4C35613B6803C0774C91BF02FB1AC01F379EB431E330C0514B4264C3603CC01E7EA197C0831DC0091F1F0E89C230C074EE517507CF37C0E687F10CA1D6F23F4549682920500B408C7382B37EBA0A40AF0450619F21FCBF7080A45B361CFBBF3F8FF81F4092094087216E00A6B51F4025EEE18A4B6D32C06590FA972FA51EC0127C8C6BB6360D40BC4B7C97D6E2014017E22120C75BDC3F8464E6C5C5D7014098551B9E5CD318C04A65179A9FEA27C03FD28485F74F1D407459C1F2BE3A1840DA05626C697B07C078F6FAAE4E2B38404E5D5EF847E92340AC0CE827D944C3BF1FC307F90D322B40AA2E779A38FAD1BF083CC59E02B7F73F832A52C5F29F1C40E142AFDF778B1340F22DBE12D4CF28C0E24C7A967318B23F16691016B2E721C0AFDC90B2DD8E284060B5B36B90CA054069E0B642162D314011E62DF5FD9C11C09DCAB9E02AB635406EF9DDD9AEF93AC0BF637E12D28F33C0A03FB9F21C1435C0FAB2AB6C847E1C406DFBA4E5D99613C0ED1DD1CE4FD51A40B89CC3F9BD3608C0635537A771B2FA3F0BE25F243DF210C00322C07E14FD1AC08433F3D4E36405400E31A16D6D0C0C406845F30C393A1040591E28114D2112C06B6EB7A57DF33140AE017E4FE857F53FA56EBFC2762637407B2A399EDBE006C03292A51E50E9FD3FB590225F0E270EC044F888C960072040361D81813D2209C02951B7A0917C09C02CD8A4EB44CD2AC0291BCCCA182126400658C0D113A00540C6CF3AFC117035C019C2EE9D278E2D40BF8FDE74E6A122C0CBA74EB9250DF43FFE0BC6AFA81E2240D7C6C5F8994C25401F6362D4992236C0D8DF80ED9FC0F33FB8F28B0C52961F40AC1705781D2B0EC07FF3F7CACED326402BE24398AE102AC07B6DC903ADAC21C0D1354C091B82264056A48962F08024C0A5C94AAA5835F63F2AC45B4914D709C0BAF782A94CAB1F40F5015E6B98CA2B40962831B37F3429C0FD4068A2219D154060E89AC23E131F404F678C255D7A33C03FF53BA4FDAE0640C9FDE15063A4F33F8A1BD78F608AE3BFE6AB11E48E9D1140803080E5B1980D40C453E77969192D4030EB798FE9112B40A591A899E54E1A403FF94A8964B544403206AEE45D1D39C0001F908DFBBC21404830C2B068EE31C0FD4D4ECBB68DF83F9F42C33AB346F33F9BB33074051E2440EA0338C93F570140B895F61D4AE608C0384E5EAE08C11E400F41A9FD54491540B6B25C9B51340740BF7B7DF29CB72240AFE4CDD587170EC0352C3548254EF43F90E867A0207233C0359B39B30C1814C03CB09395221D2D40248B97DD3910214046C133A956E6F1BF380286CF28DAF6BF93C4FDE9B2531BC02F2596E4C9DECCBF32DC993266031CC0D2A705810DFF3A40744A3D9C447E3BC0F1866EFDA7CA2B40E894CDB80B430040BF78A522E272F63F585826FEDEE933400F4F3044C70CFA3F960148196FAC2CC0B827E7A6E1F82240FC1BD2524F862BC0675AD5D667FEDB3F17BAB24091AA19407C2BF570DE7E1F404968599D531D194026ED3CB88CF627C03E73DBB1DA1C3FC0E989E721F16D01C045139C2647771B408EC3903B49D4194060CE5C274396FABF4AE7A39612AE2740B808FDF2DACE21C042C56DF556B431409709DD55B7B128C0503F97A39FC91AC05F6DE302718D2E40DC48C19C268802C0CEECF31E0A990E4056F4D40434AC034075457A54270D13C0D7D002C71AB424402897228EBACDF8BFFE22823F0C733EC0B842335E5B5E38C030A5C07C8556D13FF2195F85CC39F83FDF0778B33EB3F1BF30BBEBC68C9523C022A9DEB73A692D40FEFE33985067CEBFBBB44970914F0C40F26EF90A07363640FCDAFF8D125622404C6A3F55BF6514C09ECA1216B1BD0540AB3D25D254CAFD3F1F3FDFCBD54B2540BC0C68E906BF28C072BBC298F649C4BFBCF708A2625C244004B2A64FF868184061A0E4835CA2F8BF395FF4550F820FC0D5B5CC167C1C16408C65B4597AC924C080384C2B10D707C052EB7AA1DCA016C0AB2F0A847470E73F539ED6FFC41404C0002B6DA38A7921400FA092B8DB6030C08742B83A9E1420404812AF5ECFD7F33F309FCA12AF19F1BFF0F7874E5334F63FC1A0804EEFDB1C40302F3FF3141EEDBF54DBD13E7DE528C07DD289F4C84EE13F21A379A7B5F1114082CE9ACB7A84164027D8E88604B504C084F72E55329A1540B8CCCD7A11C01B4021CA2F5522FF38C0B026D70FB18A2D4029FFBA4CF1C014C0A72D0DB58FCF2040507DC5857D351C406CE9656E569D12C0721EB381403620405D82C7437CC01CC0DE8CD3426DC0B4BFD9270C74D4A536400DAB32ED2FE22640C372332C699142C03A89C930AD8D0D409A43C822E2ADE63F305AB63B703918C07330E6172AE4294053DDCB0A2E5E27407F573B1371EF16C07C5BCC3DCA291CC06FCC09D400DE41409A06BC4627812240BC6EDA91A6261FC05221BD27378915C06D262B85C04D2240A181B430950112C0669D9AF57B29F7BFE043E2CD11A123408691CB4E3C771440FCBE95DF3F7722C0975CFCC09B2D37C0C293657F0FBD1C40FB85C760690D1BC0494AF7F578303DC08448FBDC92611DC0D66234F65DB5E83FA5FB85891672F53F489A1165E125F0BFB9B19255F37B224007E9858A54DA3740CB31F18660B31FC0C272C25CA62DB2BF72C53DF0BC42114079EDF3AB2A0831407B71011A37E71CC0AA59B5212D1611C0CAFFF8841D0E2EC0B14F969EA5FCE0BFBB66F2884AADF43FB1BD56DEEB4117C0B3D04725AB4630C0D1396905DD8D0A4074B1CB27344D1BC093849BF82B78F23F281DF01B01613940B34C69BDEE130740FFCB90D33DC90D40DA652D48DC150840BB2417A8BB6527C0A975052B52E04A400559C44C86980D40E30BD69EB9202040201BA0B18A1122C0E7CAF6DCEC4315403B633122B8C0EF3F8B82B3DF9053E13FDD31E59CDEE52E40C36A35E1E24E314002006AE34B561540CAEEC89B1A4021C0252A875496251640F7CF1B141D0D32C0346AECCE99D620400F03AC23E80D32C052A369D001871340344121FF9FB60840C437513B710643407CA84230CA901BC089341633762016C08068009046F905C0603F613667752740BEA16E9CEAA612C043F01C9FA6350DC07A02479426FCE9BF9DAA2711D351E73F52671B8FC57B4240AAA8D861BD4D3AC024DE4CD33230FEBF5752B46AD465F23F8817C1D4E66CE93F0E1647BB77120B40C8F485DAA03E04C0348BC8390D29FC3FC36F8CBCB1A02440F3292B2783EDFFBF3D0DD9A2AA610440EE080EB6AB7E00406DCD4FF4C8413840CE6A16A4A9812640DD6494F17DB6194086A5856193C20BC0282FDD7D04851AC0719073C39939F63F9A037E6D329826404801BFA551A7EEBF95817B8A81E723C071F49353D4DB0CC00CFC4B9A5EB70BC0F008275C4AE70FC0B3329CA1E5ACF23F76CE5114738116401635797FB46412C0DBAE13C6614CF93FFD83EC0ACDFB45C03228CB4AE2A81D4032FA9F23EB78F4BF1F164D5B073B11C04AEE101660BCE23F1FCFDEDF2AC1194085061896D2CB1840F45C91B19CF20AC0AB035A084CAE0EC00E4D9F7DD0CD1940989CE7DED680F43FFFB1028E2703F2BF7136E5F33A8A2B40C7B2AB905D7F19C0BA87E18867D60D40490251643092EDBFEF258F83DF821CC05F6D0B81684816C0ECF31FDCF8A81F40B8E71B6068DA29C0DAF850C7BD902F40477804C2F60E2EC048D74BCF951D0CC02CED3BC632120240E6F4B7229A900DC0157DCF7A549BE0BF94BBA9A32CCB1940A174E48E0C7222C0F8216BE6FDC81FC001047D498D942640E6AD9D0F69EF0E40C758B8D0E8CAE83F6C906A5082DD41C038153A7071381BC0AE09C082EA5E214096FDB256EF9719403A77EB189290134021114A462F842EC0CD3E4B4E446C0D4084836C9DC7D53140DECBBD3CABB516405519DC5EB7622BC02E59C908302CCF3FA3A12DADAD0E21C047E3A72CD7DA34C023BB292D553BE0BFDA17BE6F4F2010400BB901667F4B21C000D14EBA1B0F4240CCC4FED3DF660AC0EDFD8D96C88525403A60ACA7D4FD30C061E0F12204EF2CC0D4A0E5C1BE251840DE94F8158727F83FA3D05324DA8BF7BF7D45B05E8C4232C0189EC2A28BD821C0EE5F4E33C6A02040C26E4F44F435F03FC10D4A792C9B1E40DD97D77DC5D6FBBF07F0925C838E17C09BE5FD7BF86F38C0766392AFB1510140FD2A596D21D924C028E215666A67DDBF510192D9EF380EC0CB3B55BE4A273B401DEF11B4ABAC49C06BB9E186ECC9154004FFF82F2C2F1EC0924007CEF75A30400BEC5A677AA210406CF07EA7F9AFEEBF21872FC109C025404BAB356EB1C92040CADFEF8E42AAF23F179AC105737FDA3FE15C8386F3112740EC92C459EAD938C0DE0E4B18BF1410C017E4C0BC24A30540C0BB1A6883CCD23F6E99C625EEDE19C0FEE4DE0A7C011FC0BDB7AA88724F4040CD5D63B5715F1640C5B6B5364CB4F0BF0BBDE558D78E1B4042AB7F9C864EDA3FACFE728FED02E13F49A98292C40812402FADFE7D4A2A14405930205A26474D40CD01C21FAE1014C07C292671BADAF7BF7763C6B91126144029A4A86CD4242B40D9342B35078E22C0264CA4D817B410C03882B944F15422C06DC4CD88E86AFBBFE946CD5396FC18C05EB80E5E324D1740C04A26FAF8A4F2BF5C428FFF9E192CC03B781A31C87A35407D8043AC7AD6F6BF941D49E8158620400DA15E94330722C0351D543C0D9422404EA65601C9393140A10E1D555F4C2540DAC53F1A9B2406C07C6360CDA2BC2040AAB2455F17360DC0DE4D7E957A812740E17BD3BC248E3E403FE69B5F90ED32C0E4A9454B61CC10C0F37859E56F6411C0E981D81F8032324067BEF2BC32732940AC8BB36B9A2E0D40DFFBAC77FE50EE3F618E5A99834D2740F6B4320648B03E40EB41CC47A9CF12401265D5BCD6B9D83F70D3B491CD43124068C68C6ACA15F83FBD9A8BCC13A025C084501B27D3BE24409DADF2CD95A101409CF2819FF4EA16C0BBAA94173B952140E907E03FAD20EFBFE1A51EC2EF3005C02DCB13F856D1294064C260783F0BDF3F5E86C9233D413340B17C516B3C4B29404DD2359A25F60F409197074745B63640BE1DF83B1B5B13400A2835852B69FFBF50F99AF28A2936401C5C000E4100134031B8051F9DC6F0BF3158DF8D5CED43C0AAACD9D0ECAF25C030934FBEB7BDF23F292B66030AAC204008209B7E62193DC045BF6C7D46903AC0A904606C542829C0CE7BD9086E754440C3B32A24957D24C02C4409BCA30440C08FD0DED518AC13408692CEEDEA58F93FCA0B85ED757DF8BF8A452915D5921AC0B1A0430E3B573740CAA250213E3F3140C71EB9138F981AC0A69D4931E0241CC0B41CD049FC360140BA81C5976763E73F489A9E3D6B3021406FA00FD0A56830C02B826477C44D14C02287595145851240A00837A038100F403C66A5C543D20CC0AEFF9895338E0EC07AD756E1096CCD3F21C09ACCAF761040AD74FC9465DA20C01B511FF98B031BC0E20B81BCD888F1BFB54A937863280C403CEF08EFD02E16403D8C13E277C22940F7177634805D1640F15ECE1222D132C0E37E706B4E51DFBFD394234771D221C096A67CED58F7F1BF6EF92763C2861F408ED2D2D6C59E30409E9D9C0128A01F40DFA2D9AF5F700FC001027D49E4841C407944EBDAFBF60AC0BCF801CB6B583D40C142AFAD6AD22140D0305D3B9AD51E406265F98F8BCA04C08866C5610A8113C00F9CB953354812C0FC1D400167D3FABFAFB15CCBC43CE6BFA5B05E1A042330C0689F961B904C29C0A8A924F7CC7613C0750456FEEA322440780E15AB35E22B40A510AFE2CC1A10C07C5C4234F9141CC0AAEB56A1E76B03C0AF35759A556728C0FB584C6FD1FFBA3FA4086156EE790840F8FCA731D73F21C012691AC6A8403540488698A9494C40C0AF7DD6DF12881540CCE1E51ADAA9384049BD82B3B1AA2440ABE02408F3F212C003BFA1C0122F2E40E306E878A5CF36407E9365A0134C36C090975DD6CE4A2640C86E09D9107BD4BF5EDB4FC1C123F8BF17CD2F4489B7EBBF3098EAD0E02CF43F708A486EF54C13C0DD4039FCA208044015E2EDD99FA429405C1080DD348CF4BF6C40B5E88ED329C0D0D13FE83C5C1640136C4BAD4B9429C0CB6B36083CF710C064BBF4B4CED512405A97ECAB8B5200C09DF4467A6B6E28C0E5C71725CF44164034094075C006324015AB4548F17020C082739776E880F0BF6AEFE9B72B1E1B400DB65024E4A716C0DCA0DEC1DDD519C01762C57F84DC18405B001B9BBA7CEC3F9C030DC3569C10C0E881F1CC6A5C03C04884B51497A523C02CAA39FB260621C064C7AB34D3440240565968E6620C304006FCA831DCAE09406BD365CB111B3EC0843934D75A3321C0BBEE42DFE842B83FD92255DDBBE906C017410ED6C1E31F4092E8C74B891E23C00CBFA6AB0612F93FDB47AAE5AF2D12C09B50D0D84ABD17C0F6A566EBD4D62AC0C892584722211F40150AE13DCADC3540BA43E39DD5FD23402B8743FC11021840FE4551850A513140B3A4D980A4202340DD7850AD40ED2FC05CC8FA282E16FEBF0B40977105020D402A32B458048D24403DE56769199D2BC06B6B91802A36184051B9B357D2892DC00AF6D5095D5FAABF6F6B5320C842EB3FB470947ACEB035C062FE3D1809AE33C001FFE709FF630AC002EC2409CC8B0C40C09ACBEA3BFF1BC0574DBBF3328819C0A72FE59E161824C06AC228FB494819C0AED52C6FA8AD36C0110443478A8B29C017F68D40C8AC2AC0EA692F87799B17C0001EF69CE9D924C037DF334B7EE3204094D18114766D3240FB7A23504DC827C041239BF118ED2A4077BFF3132F48FEBFC1DA30DD3C7002407D049F428FC725C0054642B251E4D33FB882ED6ABC87E43F745463154A2820C0DF2FEAC4341907C00FEF77283CB40740AE0A28AFC0B50FC03242ADA1316505404A3F07BD3ED6FDBFE9D1054EB4BCF0BF51EDB09466A41440AC8A8FAC002841C0E44C38E2026E3340DB6D10F2CE341A4085E502CC260C234074FDCA1F473FB7BFACE916CDC9D40540D19C6611283A3CC0A8C5464955CF4440F81D52D3237511C0AED3CBCBBD0805C0729872B77A333BC03C1F0A68B17425C0A3FF6F263BFC0AC08CE520783B7B1B4093887119FBB825403CEAC77EC12931C01A13195C27B627C05CA600D67D781AC002A66391038218C0D0EBE3304E45E0BF9F25E888BBB741C0C836EC3065D440C0BD6417C32119204075176C033B0003C0CBFC03ADADA2144036318EC8E0B9264094701C3007B212400CFC8126F7D01BC03B11C737DCC60540B3DDA733B1B7F5BF5868F9D5312128C038C3B46074E319407BF4EF66105717405BD0977E42E7114008B5EB39A3683440F86A7523E3E0FCBF32875A139F6A1D40728F78DAA0B717C07E70FB0669712240CF6765E59CC83340082086A1E20C2040AC754D67B9C5274080A6BD349A563740DA5B7178F81517C060EC90BF9C0B32C0FD573C6750244540AA908C6C58A30F4019587320C8C83440CF99DA89F384C73FF6F818B27FAF1D40DD6F305FB27A1BC09708BC35498332C05D04308F68EA36C02792F1A20E7532C09037430E90672CC0B8B1A6E8F7EF05C0072B7E2EE4E821C027DF21FEB08011C0B7956E1BD86104400A2C7DF4538C23C0C2A037B3672931C0929174B6143CE5BF3C156505D62531407AEA94E7B0461B4028083708C44217C03B4909686E0D11C0FD8FF13D9D9722C031FDB46DAC8A42408517C78C46150240279F9D9A8BAE15C0D5C68BEB37043040CA9DF9D7C3F63140E7E9FBE5A66C124093FDDACCC54731C05FEA91A44BA032406DFB7858000D3EC03398E4CEDF77F63FEBF37EE72C7E204007644B20B3290C403C618249AFD632C08CF5E3B0C5E9B6BF3984F136333C13C01C47977FD6F7C0BF22AA1A359F0AE3BF335F1613BCE4104022BCEF2F5968EC3FD24072F3F83B2D4025A03BB60697F4BF553666449D30F63FB798F2C5852AF73F2B7E4A0EFB0B2040EB434AAAFDB718C024737C8648D31BC0D3E78013918D10C006F17678482B0A408BD3F19FC3D301C01CD95C2890CB29C0CEF69CE3D32E3B40A152C708C0B53240779F68A0EF942640034EF63B9C59E2BF4D46A009DCB1EABFE9C417C69AB836C0DB349974086836C06CE9BFFD2653EBBFFBFE30E76A1C164016ECC2654FBCD43F0DBF19EC54EBCD3FB522C5E5A049E03FAB386822FEF31240F5162733EE492540E2C9889DEE6F34C0B98C9CA92F402AC01FCE3577717A36C00DFFAB26BDB729C05BC1413F72A418C02962F4BC47DBF33FCE040E35862010C030B0FA0084CB4040833E1303108C25C0B64D983CF4441A40EF3BA5C0910210C039BCA140575CF0BF0768CF0874F3D03F0F8924191DCC11C05D88E510663C16C0481B919A31D31A404C07AD598C5DE33F975170E3F9A6E03F6B8FEC0521652340BB5AA9031B9D21C095C35B979E31F63F632D8F93D2E23DC0C1893BA3CBDB35C0842065FCABBE2A40992F286A0F891DC08A9B6A5421ABFA3F77AC421F85C500C003B4B821BE0007405FEE46CC100E09C04EA12E012775FA3F473408E4985BC73FD43DB95FEF8A1D40C98FD1B050941340BE8A4C058DE4C73FC884CEF0494E0CC03CA760DD51D419C036E65067B40C02401453A28C634BF63F2782639B9C1CF83F674D2888CD2B1140EC210F5317A4E4BF7BC2C6A4562525C0F738BBAA7EB135C0FE72D7E38A3B30400D73649F5104FBBF0605AAEE8377124042963DDA726C16C0EB37FE06547F18405DAB2218FF22F93F97690296E46027C029F863A785CAB43F5A67157572C72D40399B0BE696A7164077352A3DF86B14C072A178402EF518401ABD712A3AAA0C406A92E115387E2C406DD1E263364D1A40A1090A6D845200C0BBAE015AC7DE19C00E203F0E5E031140C81D824B4EFC28C00E9E4C2F1BFF1BC0"> : tensor<20x20xcomplex<f64>>
    return %cst : tensor<20x20xcomplex<f64>>
  }
}
