library(RColorBrewer)
library(viridis)
library(tikzDevice)

options(tikzMetricPackages = c("\\usepackage[utf8]{inputenc}",
                               "\\usepackage{mathpazo}","\\usepackage{dsfont}",
                               "\\usepackage[T1]{fontenc}", "\\usetikzlibrary{calc}",
                               "\\usepackage{amssymb}"))

# colors = brewer.pal(5,"Set1")
# colors = c("#9ad0f3", "#e79f00", "#009E73",  "#0072B2", "#D55E00","#CC79A7", "#F0E442")
colors = viridis(5, begin=0.2)

# plot(1:7, col=colors, pch=19, cex=2)

background_model = c("constant_rate","lognormal_noise")
vcv_model        = c("univariate","variance_covariance")

a = ifelse(grid$background_model == "constant_rate", "no background", "background")
b = ifelse(grid$vcv_model == "univariate", "uncorrelated", "correlated")

grid = expand.grid(background_model=background_model, vcv_model=vcv_model, stringsAsFactors=FALSE)

samples = do.call(rbind,apply(grid,1,function(row){
  
  bg  = row[[1]]
  vcv = row[[2]]

  cat(bg,"\t",vcv,"\n", sep="")
  
  samples = do.call(rbind, lapply(paste0("analyses/empirical_analyses/haemulids/step_5/output/",vcv,"_",bg,"/params_posterior_",1:4,".log"), read.table, header=TRUE, sep="\t"))
  
  res = data.frame(background_model=bg,
                   vcv_model=vcv,
                   samples=I(list(samples)))

  return(res)    
  
}))

######################
# summary statistics #
######################

apply(samples, 1, function(x) mean(x$samples$state_ratio))
apply(samples, 1, function(x) quantile(x$samples$state_ratio, prob=c(0.025, 0.975)))
apply(samples, 1, function(x) mean(x$samples$state_ratio > 1))

###################
# plot the ratios #
###################

max = max(apply(samples, 1, function(x) quantile(x$samples$state_ratio, prob=c(0.025,0.975))))
min = min(apply(samples, 1, function(x) quantile(x$samples$state_ratio, prob=c(0.025,0.975))))

ratio_densities = apply(samples, 1, function(x) {
  
  range = quantile(x$samples$state_ratio, prob=c(0.025, 0.975))
  d = density(x$samples$state_ratio)
  return(d)
  
})

xlim = c(0.5, 150)
ylim = c(0, max(sapply(ratio_densities, function(x) x$y)))

ratio_colors = colors[rep(c(2,4), each=2)]
ratio_lty    = rep(c(2,1), times=2)

pdf("analyses/empirical_analyses/haemulids/step_5/figures/state_ratio_comparison.pdf", height=4, width=5)
par(mar=c(5,4,0.1,0.1))
plot(ratio_densities[[1]], log="x", xlim=xlim, ylim=ylim, type="n", zero.line=FALSE, xlab=expression( sigma1[2]^2 / sigma1[1]^2 ), ylab="posterior density", main=NA, las=2, bty="n")
for(i in 1:length(ratio_densities)) {
  lines(ratio_densities[[i]], xlim=xlim, col=ratio_colors[i], lty=ratio_lty[i])
}
box()
legend("topright", legend=paste(a, b, sep=", "), col=ratio_colors, lty=ratio_lty, bty="n")
dev.off()


#############################
# plot the number of events #
#############################

num_changes_tables = apply(samples, 1, function(x) {
  # t = tabulate(x$samples$total_num_changes, nbins=150)
  # names(t) = 1:length(t)
  t = table(x$samples$total_num_changes)
  t = t / sum(t)
  return(t)
})

ylim = c(0, 0.5)
xlim = c(0, 60)

num_colors = colors[rep(c(2,4), each=2)]
num_pch    = rep(c(3,4), each=2)
num_lty    = rep(c(2,1), times=2)

pdf("analyses/empirical_analyses/haemulids/step_5/figures/num_events_comparison.pdf", height=4, width=5)
par(mar=c(5,4,0.1,0.1))
plot(num_changes_tables[[1]], xlim=xlim, ylim=ylim, type="n", xlab="k", ylab="posterior probability", main=NA, las=2, bty="n", xaxt="n")
for(i in 1:length(ratio_densities)) {
  lines(num_changes_tables[[i]], xlim=xlim, col=num_colors[i], lty=num_lty[i], pch=num_pch[i], type="s", lwd=1)
}
box()
axis(1, las=2)
legend("topright", legend=paste(a, b, sep=", "), col=num_colors, lty=num_lty, bty="n")
dev.off()




###################
# combined panels #
###################


par(lend=2)
plot(ratio_densities[[4]], xlim=c(0, 30), main=NA, xaxt="n", yaxt="n", xlab=NA, ylab=NA, zero.line=FALSE, col=colors[2], lwd=2)
lines(ratio_densities[[3]], col=colors[5], lwd=2)

plot(num_changes_tables[[4]], xlim=c(5, 50), main=NA, xaxt="n", yaxt="n", xlab=NA, ylab=NA, col=colors[2], lwd=2, type="s")
lines(num_changes_tables[[3]], col=colors[5], lwd=2, type="s")


