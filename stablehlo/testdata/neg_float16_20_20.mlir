// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xf16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = stablehlo.negate %0 : tensor<20x20xf16>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xf16>, tensor<20x20xf16>) -> ()
    return %2 : tensor<20x20xf16>
  }
  func.func private @inputs() -> (tensor<20x20xf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x943D2C4057B19140F8C210BEFBC253BE753704C365C10EB71544353B1D4492B95D456C3E18A375C31E3C33BD0F3AE843F8402FC0A73DFFC2FAC22C42FC3E26BDA8C0AF465043993A6DC30E3D98C2612677C2B246BF42A7C043B02FBAF7BFFA45DEC4263912C2FA43C644603C913A5FC571444440E640CAC494BDE7BD4CC12F41C8BBE0A34FBE9E4486B616AFD63661C17E425C41C041D9B4D036194017411FBE103B2B36CAC1E3BC5F477940893FABBE89B75AC12CBE05BCFFB74B4177C022C6ADC2103E3BBD4F393D444CC4BCBB14C1643E5841113AE63CC13CE9BE76B42DAAB3BB17C087C5333BF141C6468E431145FBB226C2E3335BB610BE114113C47B3D6E38E4413139A3433D4156BC14BAB0C131C0353058C572C3324381C37C3611C3E2C7BABBE23846BC1EBEE5C383421EC17B30CEAEC33FABC334C630440045B5BACEBD4D3C1B38BF3AD83C263E5BC084C506C21BC1DFC09ABD69BC42C04F3CDF39E9BD343C2E40FE42C2B91EB95DAF4C415FBA193ABAC0C44692C8B338B6B5073DECBD4F47C63CC141A73B024249C56530A44546409A4304BE763F283EBBC05542DDC1EEBDF544C8B388388246C03D98BE5EBEF2C108C1164284445B26A23C1B3B2A3A413E74459F3524B970BF20BAA73B3D3F13C0C43C6239B3C3F44497BD71BE4E4030C084426C44FD404AB43EC1E7C4A5405F3A92C322C0BA3CEC423A3A01C25A3A6741BFBD863C01C14043F244D8344E3CF13A1CBE9DBC7A42C5B4A6BEDD38334014BC873CBABD63BD8844C2B814449DC0463A29C042BA903EFCB26CC075B6C8409843364654C447BDE6B9DD431A45673D3D44D0BCFAC46138133F86C0B4403BC1A73DFCBDEC273440734756409FC063BC9FC7F4C40C38843DD8C31DBC2AC68EB1C1BC7EABB644643C09436946C844F7431ABA893D0FC0C63382C29A3DB84531C14643CFBC4F42D64144BF0640673E07445BC5F83C954725BCA4C2893E5B3E9144B43E8DBB1DC2EEBEF1406240E03D7241623F53422CC37041DCC316C54CAF3EC2A3C532BDF542413F984340B474439EC474425E41254465347DC0C03EA7C24DC43543CFC0D2C0883E96BF05B515B448C01B3C353AD3C0113970C4E6440DC0"> : tensor<20x20xf16>
    return %cst : tensor<20x20xf16>
  }
  func.func private @expected() -> (tensor<20x20xf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x94BD2CC0573191C0F842103EFB42533E75B7044365410E3715C435BB1DC492395DC56CBE182375431EBC333D0FBAE8C3F8C02F40A7BDFF42FA422CC2FCBE263DA840AFC650C399BA6D430EBD984261A67742B2C6BFC2A74043302F3AF73FFAC5DE4426B91242FAC3C6C460BC91BA5F4571C444C0E6C0CA44943DE73D4C412FC1C83BE0234F3E9EC48636162FD6B661417EC25CC1C0C1D934D0B619C017C11F3E10BB2BB6CA41E33C5FC779C089BFAB3E89375A412C3E053CFF374BC177402246AD4210BE3B3D4FB93DC44C44BC3B144164BE58C111BAE6BCC1BCE93E76342D2AB33B1740874533BBF1C1C6C68EC311C5FB322642E3B35B36103E11C113447BBD6EB8E4C131B9A3C33DC1563C143AB041314035B05845724332C381437CB61143E247BA3BE2B8463C1E3EE54383C21E417BB0CE2EC3BFAB43344630C400C5B53ACE3D4DBC1BB8BFBAD8BC26BE5B40844506421B41DF409A3D693C42404FBCDFB9E93D34BC2EC0FEC2C2391E395D2F4CC15F3A19BABA40C4C69248B3B8B63507BDEC3D4FC7C6BCC1C1A7BB02C2494565B0A4C546C09AC3043E76BF28BEBB4055C2DD41EE3DF5C4C83388B882C6C0BD983E5E3EF241084116C284C45BA6A2BC1BBB2ABA41BE74C59FB52439703F203AA7BB3DBF1340C4BC62B9B343F4C4973D713E4EC0304084C26CC4FDC04A343E41E744A5C05FBA92432240BABCECC23ABA01425ABA67C1BF3D86BC014140C3F2C4D8B44EBCF1BA1C3E9D3C7AC2C534A63EDDB833C0143C87BCBA3D633D88C4C23814C49D4046BA2940423A90BEFC326C407536C8C098C336C65444473DE639DDC31AC567BD3DC4D03CFA4461B813BF8640B4C03B41A7BDFC3DECA734C073C756C09F40633C9F47F4440CB884BDD8431D3C2A468E31C13C7E2BB6C464BC09C369C6C8C4F7C31A3A89BD0F40C6B382429ABDB8C5314146C3CF3C4FC2D6C1443F06C067BE07C45B45F8BC95C7253CA44289BE5BBE91C4B4BE8D3B1D42EE3EF1C062C0E0BD72C162BF53C22C4370C1DC4316454C2F3E42A345323DF5C241BF98C3403474C39E4474C25EC125C465B47D40C0BEA7424D4435C3CF40D24088BE963F0535153448401BBC35BAD34011B97044E6C40D40"> : tensor<20x20xf16>
    return %cst : tensor<20x20xf16>
  }
}
