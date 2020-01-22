scalaVersion := "2.12.10"

lazy val root = (project in file("."))
  .dependsOn(shine)
  .settings(
    name := "imgproc-rise-and-shine",
    javaOptions ++= Seq("-Xss20m", "-Xms512m", "-Xmx4G")
  )

lazy val shine = ProjectRef(file("../shine"), "shine")