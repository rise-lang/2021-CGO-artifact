package imgproc_rise_and_shine

object Main {
  def main(args: Array[String]): Unit = {
    val typed_e = rise.core.types.infer(apps.cameraPipe.camera_pipe)
    val dpia_e = shine.DPIA.fromRise(typed_e)
    val p = shine.OpenMP.ProgramGenerator.makeCode(dpia_e, "camera_pipe_shine")

    println(">>> GENERATED CODE <<<")
    println(p.code)
    println("<<< CODE GENERATED >>>")
  }
}