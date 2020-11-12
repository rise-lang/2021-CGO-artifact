libPath <- "lib/Rlibs/"
.libPaths(c(libPath, .libPaths()))

usePackage <- function(p) {
   if (!is.element(p, installed.packages()[,1]))
       install.packages(p, repos = "https://cloud.r-project.org/")
   library(p, character.only = TRUE)
}

usePackage("tidyverse")
usePackage("extrafont")
font_import(prompt=FALSE, pattern='DejaVuSans.ttf')
loadfonts()