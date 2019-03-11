library(ape)
library(RColorBrewer)
source("scripts/summarizeBranchRates.R")
source("scripts/matchNodes.R")
library(tikzDevice)

options(tikzMetricPackages = c("\\usepackage[utf8]{inputenc}",
                               "\\usepackage{mathpazo}","\\usepackage{dsfont}",
                               "\\usepackage[T1]{fontenc}", "\\usetikzlibrary{calc}",
                               "\\usepackage{amssymb}"))

# colors
colors = brewer.pal(5, "Set1")[c(2,4,5)]
bins = seq(0, 1, length.out=101)
color_ramp = colorRampPalette(colors)(100)

# read the tree
tree = read.nexus("analyses/empirical_analyses/haemulids/data/sequence_tree.tree")
map  = matchNodes(tree)

# read the trait data
disc_traits = read.nexus.data("analyses/empirical_analyses/haemulids/data/traits/habitat.nex")
order = tree$edge[tree$edge[,2] <= length(tree$tip.label),2]
disc_trait_colors = brewer.pal(5, "Set1")[c(2,5)]
names(disc_trait_colors) = c("0","1")

# for the constant-rates
constant_rate_samples = do.call(rbind, lapply(paste0("analyses/empirical_analyses/haemulids/step_5/output/variance_covariance_constant_rate/params_posterior_",1:4,".log"), read.table, header=TRUE, sep="\t", check.names=FALSE, stringsAsFactors=FALSE))

# compute the relative amount of time in each state
constant_rate_branch_rates = constant_rate_samples[,grep("state_branch_rate", colnames(constant_rate_samples))]
constant_rate_state_rates  = constant_rate_samples[,grepl("state_rates",colnames(constant_rate_samples)) & !grepl("relative_state_rates",colnames(constant_rate_samples))]

# compute the relative times
constant_relative_times = matrix(NA, nrow(constant_rate_branch_rates), nrow(tree$edge))
for(i in 1:ncol(constant_rate_branch_rates)) {
  
  these_branch_rates = constant_rate_branch_rates[,i]
  
  time_in_state_0 = (these_branch_rates - constant_rate_state_rates[,2]) / (constant_rate_state_rates[,1] - constant_rate_state_rates[,2])
  time_in_state_1 = 1 - time_in_state_0
  
  constant_relative_times[,i] = time_in_state_1
  
}
constant_relative_times = constant_relative_times[,map[match(tree$edge[,2], map$R),2]]

# find the intervals
constant_relative_times_mean = colMeans(constant_relative_times)
constant_relative_times_colors = color_ramp[findInterval(constant_relative_times_mean, bins, all.inside=TRUE)]

# now for the variable-rates
variable_rate_samples = do.call(rbind, lapply(paste0("analyses/empirical_analyses/haemulids/step_5/output/variance_covariance_lognormal_noise/params_posterior_",1:4,".log"), read.table, header=TRUE, sep="\t", check.names=FALSE, stringsAsFactors=FALSE))

# compute the relative amount of time in each state
variable_rate_branch_rates = variable_rate_samples[,grep("state_branch_rate", colnames(variable_rate_samples))]
variable_rate_state_rates  = variable_rate_samples[,grepl("state_rates",colnames(variable_rate_samples)) & !grepl("relative_state_rates",colnames(variable_rate_samples))]

# compute the relative times
variable_relative_times = matrix(NA, nrow(variable_rate_branch_rates), nrow(tree$edge))
for(i in 1:ncol(variable_rate_branch_rates)) {
  
  these_branch_rates = variable_rate_branch_rates[,i]
  
  time_in_state_0 = (these_branch_rates - variable_rate_state_rates[,2]) / (variable_rate_state_rates[,1] - variable_rate_state_rates[,2])
  time_in_state_1 = 1 - time_in_state_0
  
  variable_relative_times[,i] = time_in_state_1
  
}
variable_relative_times = variable_relative_times[,map[match(tree$edge[,2], map$R),2]]

# find the intervals
variable_relative_times_mean = colMeans(variable_relative_times)
variable_relative_times_colors = color_ramp[findInterval(variable_relative_times_mean, bins, all.inside=TRUE)]







new_tree = tree
new_tree$tip.label = gsub("_"," ",new_tree$tip.label)

tikz("manuscript/figures/step_5/branch_time_comparison.tex", width=8, height=4, standAlone = TRUE,
     packages = c("\\usepackage{tikz}","\\usepackage{mathpazo}","\\usepackage[active,tightpage,psfixbb]{preview}","\\PreviewEnvironment{pgfpicture}","\\setlength\\PreviewBorder{0pt}","\\usepackage{amssymb}","\\usepackage{dsfont}"))

par(mar=c(0.1,0.1,0.1,0.1), lend=2, ljoin=1, mfrow=c(1,2))

plot(new_tree, edge.color=constant_relative_times_colors, cex=0.5, edge.width=2, label.offset=0.02, x.lim=c(0,1.3), show.tip.label=TRUE)

# now plot the data
points(x=rep(1.0, length(tree$tip.label)), y=1:length(tree$tip.label), pch=15, col=disc_trait_colors[unlist(disc_traits[tree$tip.label])[order]], cex=0.75)


plot(new_tree, edge.color=variable_relative_times_colors, cex=0.5, edge.width=2, label.offset=0.02, x.lim=c(0,1.3), show.tip.label=TRUE)

# now plot the data
points(x=rep(1.0, length(tree$tip.label)), y=1:length(tree$tip.label), pch=15, col=disc_trait_colors[unlist(disc_traits[tree$tip.label])[order]], cex=0.75)

gradient.rect(0.05,1,0.1,15, col=colorRampPalette(colors)(10), border=NA, gradient="y")
text(x=0.12, y=1 + pretty(c(0,1)) * 14, labels=sprintf("%0.1f",pretty(c(0,1))), adj=0, cex=0.75)
text("relative time in reef", x=0.02, y=8, srt=90, cex=0.75)

dev.off()

tools::texi2pdf("manuscript/figures/step_5/branch_time_comparison.tex", clean=TRUE)
file.rename("branch_time_comparison.pdf", "manuscript/figures/step_5/branch_time_comparison.pdf")










