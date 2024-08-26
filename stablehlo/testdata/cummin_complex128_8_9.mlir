// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<8x9xcomplex<f64>> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<8x9xcomplex<f64>>
    %1 = call @expected() : () -> tensor<8x9xcomplex<f64>>
    %2 = call @cummin(%0) : (tensor<8x9xcomplex<f64>>) -> tensor<8x9xcomplex<f64>>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<8x9xcomplex<f64>>, tensor<8x9xcomplex<f64>>) -> ()
    return %2 : tensor<8x9xcomplex<f64>>
  }
  func.func private @inputs() -> (tensor<8x9xcomplex<f64>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[(-1.4677210393334497,0.41552308099452268), (0.20019113061261981,-0.51139480480745281), (-3.2674185688668684,1.1456974196290204), (1.5850933901590971,-3.2637841110606303), (-1.8865742482289345,-8.1589268677662563), (-0.79651124762797942,-3.7345324226323293), (1.4442163580960203,-2.7007901412481119), (-2.2268180895898348,0.63544094262781281), (-4.5998469262452009,2.9076761639435293)], [(2.7493258594185317,-2.6592247568818004), (-1.6269914036660902,-3.0104276315729379), (-0.25092432053086267,4.977131293448541), (3.8648248081625107,-1.5353393598791494), (1.5337819800712051,-1.6747902952983429), (-2.0778281827159142,-5.3484216482247717), (-0.16024915668597711,0.67993516653475039), (-2.0545055855961056,-2.7956703041683308), (0.5114051990648425,-4.1152976810144803)], [(-2.7220335753764218,-9.1156288870650624), (-5.5133558514985364,3.6658924424529848), (-1.4244172329825937,1.9245684387461441), (1.4654405354789888,0.83607443056806041), (2.3668180514105104,-0.79863396994275537), (1.125441801848275,1.8377056385998884), (1.5782516894382663,1.0030376584714578), (2.5226228130338688,-0.073525597105629642), (-0.70280064783956098,3.1025746647278014)], [(0.99047002794541494,-5.8924550861705391), (-0.28043249215827681,0.81459373064493068), (-1.9246530398266239,5.8239426302414063), (2.3730363871889399,2.8016477371619941), (2.6801127222413035,-1.6197631960630168), (1.3538017109666609,-0.80931103618661382), (4.1952956616693369,0.86974942131695365), (-3.466974544002932,-1.1985364211114211), (4.2516053804357723,-3.125889733203115)], [(1.1154137612431549,0.55819364387896431), (1.4559909478692161,2.8324812503593839), (5.8129882729777105,4.0866459962471406), (-5.3487807826777551,-1.2335840519217485), (-1.8684466582600983,0.084765274303679333), (-0.11009306281974121,-1.8444404514138983), (4.9398208040714247,-1.3247676777594077), (-2.2140533252625332,-1.5665674562000635), (-0.90060102121649499,-5.9556380368852508)], [(-0.57070286601497555,0.63587290253785111), (3.6711454867978164,-2.480322638509862), (-3.3644133000592342,1.6849559379576511), (-4.7541969415918448,0.57143924530604284), (1.8954954111664672,-2.476678512416564), (-1.4365477088253242,0.64659317532473493), (0.59543672258820968,-3.892822849643323), (-2.1344405356081646,3.9417145109242351), (-2.2393884965509478,-0.36910794833101823)], [(2.6530890398805607,-4.6881922971644796), (2.8538385549493457,1.3879572585022721), (-0.4923909938071469,-2.2966604911607584), (-2.1063683448724255,0.35159047931158482), (3.082779471758478,1.6122851839784937), (-1.893061456712398,-2.3569009958820639), (3.3508741639182786,-1.0038345305984309), (1.2275106950410413,-0.11979803685143754), (0.24185242363000636,0.47730848580845797)], [(1.2098063032859563,-2.4509236572700952), (3.2763365899357408,1.8286324849337512), (-0.14953885184732824,4.6817530151400977), (2.8530124605459637,-1.2006541031261739), (0.51273396057274778,-0.3161995411420937), (4.7766444872660445,-1.3420278558040635), (-2.2545245965937619,-0.80531837688376728), (-3.4645824430677914,5.3600299860951672), (2.6025794834628888,1.7310929788033613)]]> : tensor<8x9xcomplex<f64>>
    return %cst : tensor<8x9xcomplex<f64>>
  }
  func.func private @expected() -> (tensor<8x9xcomplex<f64>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[(-1.4677210393334497,0.41552308099452268), (0.20019113061261981,-0.51139480480745281), (-3.2674185688668684,1.1456974196290204), (1.5850933901590971,-3.2637841110606303), (-1.8865742482289345,-8.1589268677662563), (-0.79651124762797942,-3.7345324226323293), (1.4442163580960203,-2.7007901412481119), (-2.2268180895898348,0.63544094262781281), (-4.5998469262452009,2.9076761639435293)], [(-1.4677210393334497,0.41552308099452268), (-1.6269914036660902,-3.0104276315729379), (-3.2674185688668684,1.1456974196290204), (1.5850933901590971,-3.2637841110606303), (-1.8865742482289345,-8.1589268677662563), (-2.0778281827159142,-5.3484216482247717), (-0.16024915668597711,0.67993516653475039), (-2.2268180895898348,0.63544094262781281), (-4.5998469262452009,2.9076761639435293)], [(-2.7220335753764218,-9.1156288870650624), (-5.5133558514985364,3.6658924424529848), (-3.2674185688668684,1.1456974196290204), (1.4654405354789888,0.83607443056806041), (-1.8865742482289345,-8.1589268677662563), (-2.0778281827159142,-5.3484216482247717), (-0.16024915668597711,0.67993516653475039), (-2.2268180895898348,0.63544094262781281), (-4.5998469262452009,2.9076761639435293)], [(-2.7220335753764218,-9.1156288870650624), (-5.5133558514985364,3.6658924424529848), (-3.2674185688668684,1.1456974196290204), (1.4654405354789888,0.83607443056806041), (-1.8865742482289345,-8.1589268677662563), (-2.0778281827159142,-5.3484216482247717), (-0.16024915668597711,0.67993516653475039), (-3.466974544002932,-1.1985364211114211), (-4.5998469262452009,2.9076761639435293)], [(-2.7220335753764218,-9.1156288870650624), (-5.5133558514985364,3.6658924424529848), (-3.2674185688668684,1.1456974196290204), (-5.3487807826777551,-1.2335840519217485), (-1.8865742482289345,-8.1589268677662563), (-2.0778281827159142,-5.3484216482247717), (-0.16024915668597711,0.67993516653475039), (-3.466974544002932,-1.1985364211114211), (-4.5998469262452009,2.9076761639435293)], [(-2.7220335753764218,-9.1156288870650624), (-5.5133558514985364,3.6658924424529848), (-3.3644133000592342,1.6849559379576511), (-5.3487807826777551,-1.2335840519217485), (-1.8865742482289345,-8.1589268677662563), (-2.0778281827159142,-5.3484216482247717), (-0.16024915668597711,0.67993516653475039), (-3.466974544002932,-1.1985364211114211), (-4.5998469262452009,2.9076761639435293)], [(-2.7220335753764218,-9.1156288870650624), (-5.5133558514985364,3.6658924424529848), (-3.3644133000592342,1.6849559379576511), (-5.3487807826777551,-1.2335840519217485), (-1.8865742482289345,-8.1589268677662563), (-2.0778281827159142,-5.3484216482247717), (-0.16024915668597711,0.67993516653475039), (-3.466974544002932,-1.1985364211114211), (-4.5998469262452009,2.9076761639435293)], [(-2.7220335753764218,-9.1156288870650624), (-5.5133558514985364,3.6658924424529848), (-3.3644133000592342,1.6849559379576511), (-5.3487807826777551,-1.2335840519217485), (-1.8865742482289345,-8.1589268677662563), (-2.0778281827159142,-5.3484216482247717), (-2.2545245965937619,-0.80531837688376728), (-3.466974544002932,-1.1985364211114211), (-4.5998469262452009,2.9076761639435293)]]> : tensor<8x9xcomplex<f64>>
    return %cst : tensor<8x9xcomplex<f64>>
  }
  func.func private @cummin(%arg0: tensor<8x9xcomplex<f64>>) -> tensor<8x9xcomplex<f64>> {
    %cst = stablehlo.constant dense<(0x7FF0000000000000,0.000000e+00)> : tensor<complex<f64>>
    %0 = stablehlo.broadcast_in_dim %cst, dims = [] : (tensor<complex<f64>>) -> tensor<complex<f64>>
    %1 = "stablehlo.reduce_window"(%arg0, %0) <{padding = dense<[[7, 0], [0, 0]]> : tensor<2x2xi64>, window_dimensions = array<i64: 8, 1>}> ({
    ^bb0(%arg1: tensor<complex<f64>>, %arg2: tensor<complex<f64>>):
      %2 = stablehlo.real %arg1 : (tensor<complex<f64>>) -> tensor<f64>
      %3 = stablehlo.real %arg2 : (tensor<complex<f64>>) -> tensor<f64>
      %4 = stablehlo.compare  EQ, %2, %3,  FLOAT : (tensor<f64>, tensor<f64>) -> tensor<i1>
      %5 = stablehlo.compare  LT, %2, %3,  FLOAT : (tensor<f64>, tensor<f64>) -> tensor<i1>
      %6 = stablehlo.imag %arg1 : (tensor<complex<f64>>) -> tensor<f64>
      %7 = stablehlo.imag %arg2 : (tensor<complex<f64>>) -> tensor<f64>
      %8 = stablehlo.compare  LT, %6, %7,  FLOAT : (tensor<f64>, tensor<f64>) -> tensor<i1>
      %9 = stablehlo.select %4, %8, %5 : tensor<i1>, tensor<i1>
      %10 = stablehlo.select %9, %arg1, %arg2 : tensor<i1>, tensor<complex<f64>>
      stablehlo.return %10 : tensor<complex<f64>>
    }) : (tensor<8x9xcomplex<f64>>, tensor<complex<f64>>) -> tensor<8x9xcomplex<f64>>
    return %1 : tensor<8x9xcomplex<f64>>
  }
}
