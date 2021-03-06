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
    // genKernel(rewrite.harrisBufferedSplitPar(strip)(highLevel),
    //  "harris", "gen/harrisB3SPRW.cl")
    // genKernel(harrisBufferedVecUnaligned(3, vWidth), "harris", "gen/harrisBVU.cl")
    // genKernel(harrisBufferedVecAligned(3, vWidth), "harris", "gen/harrisBVA.cl")
    // genKernel(harrisSplitPar(strip, vWidth, harrisBufferedVecUnaligned(3, vWidth)),
    //  "harris", "gen/harrisB3VUSP.cl")
    // genKernel(harrisSplitPar(strip, vWidth, harrisBufferedVecUnaligned(4, vWidth)),
    //  "harris", "gen/harrisB4VUSP.cl")
    // genKernel(rewrite.harrisBufferedVecUnalignedSplitPar(vWidth, strip)(highLevel),
    //  "harris", "gen/harrisB3VUSPRW.cl")
    //genKernel(harrisSplitPar(strip, vWidth, harrisBufferedVecAligned(3, vWidth)),
    //  "harris", "gen/harrisB3VASP.cl")
    //genKernel(harrisSplitPar(strip, vWidth, harrisBufferedVecAligned(4, vWidth)),
    //  "harris", "gen/harrisB4VASP.cl")
    genKernel(rewrite.harrisBufferedVecAlignedSplitPar(vWidth, strip)(highLevel),
      "harris", s"gen/vec${vWidth}/cbuf.cl")
    //genKernel(harrisSplitPar(strip, vWidth, harrisBufferedRegRotVecAligned(3, vWidth)),
    //  "harris", "gen/harrisB3VASPRR.cl")
    //genKernel(harrisSplitPar(strip, vWidth, harrisBufferedRegRotVecAligned(4, vWidth)),
    //  "harris", "gen/harrisB4VASPRR.cl")
    genKernel(rewrite.harrisBufferedRegRotVecAlignedSplitPar(vWidth, strip)(highLevel),
      "harris", s"gen/vec${vWidth}/cbuf+rrot.cl")
  }
}