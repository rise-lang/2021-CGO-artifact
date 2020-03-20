package imgproc_rise_and_shine

import apps.harrisCornerDetectionHalide.ocl._
import apps.harrisCornerDetectionHalideRewrite.{ocl => rewrite}

object Main {
  def genKernel(e: rise.core.Expr, name: String, path: String): Unit = {
    val lowered = rewrite.unrollDots(rise.core.types.infer(e))
    val kernel = util.gen.OpenCLKernel(lowered, name)
    util.writeToPath(path, kernel.code)
  }

  def main(args: Array[String]): Unit = {
    genKernel(harrisBufferedVecUnaligned, "harris", "gen/harrisBVU.cl")
    genKernel(harrisBufferedVecAligned, "harris", "gen/harrisBVA.cl")
    genKernel(harrisBufferedVecUnalignedSplitPar, "harris", "gen/harrisBVUSP.cl")
  }
}