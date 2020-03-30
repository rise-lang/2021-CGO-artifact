package imgproc_rise_and_shine

import apps.harrisCornerDetectionHalide.harris
import apps.harrisCornerDetectionHalide.ocl._
import apps.harrisCornerDetectionHalideRewrite.{ocl => rewrite}

object Main {
  def genKernel(e: rise.core.Expr, name: String, path: String): Unit = {
    val lowered = rewrite.unrollDots(rise.core.types.infer(e))
    val kernel = util.gen.OpenCLKernel(lowered, name)
    util.writeToPath(path, kernel.code)
  }

  def main(args: Array[String]): Unit = {
    val strip = 32
    val vWidth = args(0).toInt
    val highLevel = rise.core.types.infer(harris(strip, vWidth))
    genKernel(harrisBufferedVecUnaligned(vWidth), "harris", "gen/harrisBVU.cl")
    genKernel(harrisBufferedVecAligned(vWidth), "harris", "gen/harrisBVA.cl")
    genKernel(harrisSplitPar(strip, vWidth, harrisBufferedVecUnaligned(vWidth)),
      "harris", "gen/harrisBVUSP.cl")
    genKernel(rewrite.harrisBufferedVecUnalignedSplitPar(vWidth, strip)(highLevel),
      "harris", "gen/harrisBVUSPRW.cl")
    genKernel(harrisSplitPar(strip, vWidth, harrisBufferedVecAligned(vWidth)),
      "harris", "gen/harrisBVASP.cl")
    genKernel(harrisSplitPar(strip, vWidth, harrisBufferedRegRotVecAligned(vWidth)),
      "harris", "gen/harrisBVASPRR.cl")
  }
}