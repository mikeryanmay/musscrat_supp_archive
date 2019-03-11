library(ape)
source("utilities/writeAlignment.R")
source("analyses/empirical_analyses/haemulids/step_0/src/stem_and_loop_eyeballing.R")

# for 16s full (same as pruned, since all species have data)
x16s <- do.call(rbind,read.nexus.data("analyses/empirical_analyses/haemulids/step_0/output/full/16s.nex"))
x16s_pattern <- doWindow("analyses/empirical_analyses/haemulids/step_0/output/full/16s.fasta", threshold.in=0.95, window.span=5)

x16s_stem <- x16s[,which(x16s_pattern == 1)]
x16s_loop <- x16s[,which(x16s_pattern == 0)]

dim(x16s)
dim(x16s_stem) + dim(x16s_loop)

writeAlignment(x16s_stem, "analyses/empirical_analyses/haemulids/step_0/output/full/16s_stem.nex")
writeAlignment(x16s_loop, "analyses/empirical_analyses/haemulids/step_0/output/full/16s_loop.nex")

writeAlignment(x16s_stem, "analyses/empirical_analyses/haemulids/step_0/output/pruned/16s_stem.nex")
writeAlignment(x16s_loop, "analyses/empirical_analyses/haemulids/step_0/output/pruned/16s_loop.nex")

# now for S7
S7 <- do.call(rbind,read.nexus.data("analyses/empirical_analyses/haemulids/step_0/output/full/S7.nex"))
S7_pattern <- doWindow("analyses/empirical_analyses/haemulids/step_0/output/full/S7s.fasta", threshold.in=0.95, window.span=10)

S7_stem <- x16s[,which(S7_pattern == 1)]
S7_loop <- x16s[,which(S7_pattern == 0)]

dim(S7)
dim(S7_stem) + dim(S7_loop)

writeAlignment(S7_stem, "analyses/empirical_analyses/haemulids/step_0/output/full/S7_stem.nex")
writeAlignment(S7_loop, "analyses/empirical_analyses/haemulids/step_0/output/full/S7_loop.nex")

writeAlignment(S7_stem, "analyses/empirical_analyses/haemulids/step_0/output/pruned/S7_stem.nex")
writeAlignment(S7_loop, "analyses/empirical_analyses/haemulids/step_0/output/pruned/S7_loop.nex")









