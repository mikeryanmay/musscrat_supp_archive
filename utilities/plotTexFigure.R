library(tikzDevice)
options(tikzMetricPackages = c("\\usepackage[utf8]{inputenc}",
                               "\\usepackage{mathpazo}","\\usepackage{dsfont}",
                               "\\usepackage[T1]{fontenc}", "\\usetikzlibrary{calc}",
                               "\\usepackage{amssymb}"))

plotTexFigure = function( path, height, width, func ){
  
  tikz(paste0(path,".tex"), height=height, width=width, standAlone = TRUE,
       packages = c("\\usepackage{tikz}",
                    "\\usepackage{mathpazo}",
                    "\\usepackage[active,tightpage,psfixbb]{preview}",
                    "\\PreviewEnvironment{pgfpicture}",
                    "\\setlength\\PreviewBorder{0pt}",
                    "\\usepackage{amssymb}",
                    "\\usepackage{dsfont}"))
  
  func()
  
  dev.off()
  tools::texi2pdf(paste0(path,".tex"), clean=TRUE)
  file.rename(basename(paste0(path,".pdf")), paste0(path,".pdf"))
  
  
}