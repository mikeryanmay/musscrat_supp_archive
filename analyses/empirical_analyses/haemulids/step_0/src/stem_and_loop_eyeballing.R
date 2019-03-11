doStats = function(alignment) {

	x = scan(file = alignment,what=character(),sep="\n")

	names = x[grep(">",x)]
	name.indices = grep(">",x)
	seqs = c()

	for (i in 1:(length(name.indices)-1)) {
		seq = paste(x[(name.indices[i]+1):(name.indices[i+1]-1)],collapse="")
		seqs = c(seqs,seq)
	}
	seq = paste(x[(name.indices[length(name.indices)]+1):length(x)],collapse="")
	seqs = c(seqs,seq)

	sequence.data = matrix(nrow=length(seqs),ncol=length(strsplit(seqs[1],"")[[1]]))

	for (i in 1:length(seqs)) {
		sequence.data[i,] = strsplit(seqs[i],"")[[1]]
	}

	fracs = c()
	gaps = c()

	for (i in 1:length(sequence.data[1,])) {
		vec <- sequence.data[,i]
		a = length(grep("a",vec))+length(grep("A",vec))
		c = length(grep("c",vec))+length(grep("C",vec))
		g = length(grep("g",vec))+length(grep("G",vec))
		t = length(grep("t",vec))+length(grep("T",vec))
		gap = length(grep("-",vec,fixed=TRUE))
		frac = max(c(a,c,g,t)) /(a+c+g+t)
		fracs = c(fracs,frac)
		gaps = c(gaps,gap/(a+c+g+t+gap))
	}


	cat("statistics on frequencies of most common base\n")
	cat("\tmean:\t",mean(fracs),"\n")	
	cat("\tsd:\t\t",sd(fracs),"\n")	
	cat("statistics on frequencies of gaps\n")
	cat("\tmean:\t",mean(gaps),"\n")	
	cat("\tsd:\t\t",sd(gaps),"\n")
	hist(fracs,breaks=75,xlim=c(0,1))
	hist(gaps,breaks=75,xlim=c(0,1),col="blue",add=TRUE)
}

doThreshold = function (alignment,threshold.in) {
	x = scan(file = alignment,what=character(),sep="\n")

	names = x[grep(">",x)]
	name.indices = grep(">",x)
	seqs = c()

	for (i in 1:(length(name.indices)-1)) {
		seq = paste(x[(name.indices[i]+1):(name.indices[i+1]-1)],collapse="")
		seqs = c(seqs,seq)
	}
	seq = paste(x[(name.indices[length(name.indices)]+1):length(x)],collapse="")
	seqs = c(seqs,seq)

	sequence.data = matrix(nrow=length(seqs),ncol=length(strsplit(seqs[1],"")[[1]]))

	for (i in 1:length(seqs)) {
		sequence.data[i,] = strsplit(seqs[i],"")[[1]]
	}

	fracs = c()

	for (i in 1:length(sequence.data[1,])) {
		vec <- sequence.data[,i]
		a = length(grep("a",vec))+length(grep("A",vec))
		c = length(grep("c",vec))+length(grep("C",vec))
		g = length(grep("g",vec))+length(grep("G",vec))
		t = length(grep("t",vec))+length(grep("T",vec))
		gap = length(grep("-",vec,fixed=TRUE))
		frac = max(c(a,c,g,t)) /(a+c+g+t)
		fracs = c(fracs,frac)
	}

	plot(fracs,type="l")

	threshold = threshold.in

	stem.loop = c()

	for (i in 1:length(sequence.data[1,])) {
		if (fracs[i] > threshold) {
			stem.loop[i] = 1
		} else {
			stem.loop[i] = 0
		}
	}

	plot(fracs,type="l",col="grey")
	lines(stem.loop,type="l",col="red")
}

doWindow = function (alignment,threshold.in,window.span) {

	x = scan(file = alignment,what=character(),sep="\n")

	names = x[grep(">",x)]
	name.indices = grep(">",x)
	seqs = c()

	for (i in 1:(length(name.indices)-1)) {
		seq = paste(x[(name.indices[i]+1):(name.indices[i+1]-1)],collapse="")
		seqs = c(seqs,seq)
	}
	seq = paste(x[(name.indices[length(name.indices)]+1):length(x)],collapse="")
	seqs = c(seqs,seq)

	sequence.data = matrix(nrow=length(seqs),ncol=length(strsplit(seqs[1],"")[[1]]))

	for (i in 1:length(seqs)) {
		sequence.data[i,] = strsplit(seqs[i],"")[[1]]
	}

	fracs = c()

	for (i in 1:length(sequence.data[1,])) {
		vec <- sequence.data[,i]
		a = length(grep("a",vec))+length(grep("A",vec))
		c = length(grep("c",vec))+length(grep("C",vec))
		g = length(grep("g",vec))+length(grep("G",vec))
		t = length(grep("t",vec))+length(grep("T",vec))
		gap = length(grep("-",vec,fixed=TRUE))
		frac = max(c(a,c,g,t)) /(a+c+g+t)
		fracs = c(fracs,frac)
	}


	window.size = window.span

	window = c()

	threshold = threshold.in

	for (i in 1:window.size) {
		tmp = mean(fracs[1:(i+window.size)])
		if (tmp > threshold) {
			window[i] = 1
		} else {
			window[i] = 0
		}
	}

	for (i in (length(sequence.data[1,])-window.size+1):length(sequence.data[1,])) {
		tmp = mean(fracs[(i-window.size):length(fracs)])
		if (tmp > threshold) {
			window[i] = 1
		} else {
			window[i] = 0
		}
	}

	for (i in (1+ window.size):(length(sequence.data[1,])-window.size)) {
		window.frac = 0
		window.frac = mean(fracs[(i-window.size):(i+window.size)], na.rm=TRUE)
		if (window.frac > threshold) {
			window[i] = 1
		} else {
			window[i] = 0
		}
	}

	plot(fracs,type="l",col="grey",ylim=c(0,1))
	lines(window,type="l",col="red")
	return(window)
}

doGaps = function(alignment) {
	
	x = scan(file = alignment,what=character(),sep="\n")

	names = x[grep(">",x)]
	name.indices = grep(">",x)
	seqs = c()

	for (i in 1:(length(name.indices)-1)) {
		seq = paste(x[(name.indices[i]+1):(name.indices[i+1]-1)],collapse="")
		seqs = c(seqs,seq)
	}
	seq = paste(x[(name.indices[length(name.indices)]+1):length(x)],collapse="")
	seqs = c(seqs,seq)

	sequence.data = matrix(nrow=length(seqs),ncol=length(strsplit(seqs[1],"")[[1]]))

	for (i in 1:length(seqs)) {
		sequence.data[i,] = strsplit(seqs[i],"")[[1]]
	}

	fracs = c()
	gaps = c()

	for (i in 1:length(sequence.data[1,])) {
		vec <- sequence.data[,i]
		a = length(grep("a",vec))+length(grep("A",vec))
		c = length(grep("c",vec))+length(grep("C",vec))
		g = length(grep("g",vec))+length(grep("G",vec))
		t = length(grep("t",vec))+length(grep("T",vec))
		gap = length(grep("-",vec,fixed=TRUE))
		frac = max(c(a,c,g,t)) /(a+c+g+t)
		fracs = c(fracs,frac)
		gaps = c(gaps,gap/(a+c+g+t+gap))
	}

	gaps = 1 - gaps
	
	plot(fracs,type="l",col="grey",ylim=c(0,1))
	lines(gaps,type="l",col="red")
}

findGappyTaxa = function(alignment,threshold=0.8) {

	x = scan(file = alignment,what=character(),sep="\n",quiet=TRUE)

	names = x[grep(">",x)]
	name.indices = grep(">",x)
	seqs = c()

	for (i in 1:(length(name.indices)-1)) {
		seq = paste(x[(name.indices[i]+1):(name.indices[i+1]-1)],collapse="")
		seqs = c(seqs,seq)
	}
	seq = paste(x[(name.indices[length(name.indices)]+1):length(x)],collapse="")
	seqs = c(seqs,seq)

	sequence.data = matrix(nrow=length(seqs),ncol=length(strsplit(seqs[1],"")[[1]]))

	for (i in 1:length(seqs)) {
		sequence.data[i,] = strsplit(seqs[i],"")[[1]]
	}

	gaps = c()
	fracs = c()

	for (i in 1:length(sequence.data[1,])) {
		vec <- sequence.data[,i]
		a = length(grep("a",vec))+length(grep("A",vec))
		c = length(grep("c",vec))+length(grep("C",vec))
		g = length(grep("g",vec))+length(grep("G",vec))
		t = length(grep("t",vec))+length(grep("T",vec))
		gap = length(grep("-",vec))
		frac = max(c(a,c,g,t,gap)) /(a+c+g+t+gap)
		fracs = c(fracs,frac)
		if (gap > (a+c+g+t)) {
			gaps = c(gaps,1)
		} else {
			gaps = c(gaps,0)
		}
	}

	odd.gap = c()
	odd.sequence = c()

	for (i in 1:length(sequence.data[,1])) {
		bad.gap = 0
		bad.sequence = 0
		for (j in 1:length(sequence.data[1,])) {
			if (fracs[j] != "NaN") {
				if (fracs[j] >= threshold) {
					if (sequence.data[i,j] == "-") {
						if (gaps[j] != 1)
							bad.gap = bad.gap + 1
					} else {
						if (sequence.data[i,j] != "-") {
							if (gaps[j] != 0) {
								bad.sequence = bad.sequence + 1
							}
						}
					}
				}
			}
		}
		odd.gap = c(odd.gap, bad.gap)
		odd.sequence = c(odd.sequence, bad.sequence)		
	}

	check.above.gap = mean(odd.sequence) + sd(odd.sequence)
	culprits.gaps = which(odd.gap > check.above.gap)
	sort(names[culprits.gaps])

	check.above.sequence = mean(odd.gap) + sd(odd.gap)
	culprits.sequences = which(odd.gap > check.above.sequence)
	sort(names[culprits.sequences])

	results = list(sort(names[culprits.gaps]),sort(names[culprits.sequences]))
	return(results)

}
