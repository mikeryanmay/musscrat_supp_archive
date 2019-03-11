writeAlignment <- function(aln.mat,out.file) {

  aln_format <- basename(out.file)
  aln_format <- strsplit(aln_format,".",fixed=TRUE)[[1]]
  aln_format <- aln_format[length(aln_format)]
  if (length(grep("fas",aln_format))) {
    cat("",sep="",file=out.file,append=FALSE)
    for (i in 1:nrow(aln.mat)) {
      cat(">",rownames(aln.mat)[i],"\n",aln.mat[i,],"\n",sep="",file=out.file,append=TRUE)
    }
  } else if (length(grep("nex",aln_format))) {
    pretty.spaces <- calcPrettySpaces(rownames(aln.mat)) # This will make sure that the first character in every sequence lines up in the alignment
    cat("#NEXUS\n\n","BEGIN DATA;\n","\tDIMENSIONS NTAX=",nrow(aln.mat)," NCHAR=",ncol(aln.mat),";\n","\tFORMAT DATATYPE=DNA MISSING=? GAP=-;\n","MATRIX\n",sep="",file=out.file)
    for (i in 1:nrow(aln.mat)) {
      cat(rownames(aln.mat)[i],rep(" ",pretty.spaces[i]),aln.mat[i,],"\n",sep="",file=out.file,append=TRUE)
    }
    cat(";\nEND;",sep="",file=out.file,append=TRUE)
  } else if (length(grep("phy",aln_format))) {
    pretty.spaces <- calcPrettySpaces(rownames(aln.mat)) # This will make sure that the first character in every sequence lines up in the alignment
    cat(nrow(aln.mat)," ",ncol(aln.mat),"\n",sep="",file=out.file)
    for (i in 1:nrow(aln.mat)) {
      cat(rownames(aln.mat)[i],rep(' ',pretty.spaces[i]),aln.mat[i,],'\n',sep='',file=out.file,append=TRUE)
    }
  } else {
    stop("Alignment output file has unrecognized extension, file must end in .fas(ta), .nex(us), or .phy(lip)")
  }


}