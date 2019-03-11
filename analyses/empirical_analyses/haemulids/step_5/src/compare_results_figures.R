library(RColorBrewer)
library(viridis)
library(tikzDevice)
library(scales)

options(tikzMetricPackages = c("\\usepackage[utf8]{inputenc}",
                               "\\usepackage{mathpazo}","\\usepackage{dsfont}",
                               "\\usepackage[T1]{fontenc}", "\\usetikzlibrary{calc}",
                               "\\usepackage{amssymb}"))

# colors = viridis(5, begin=0.2)
# colors_trans = viridis(5, begin=0.2, alpha=0.5)

colors = seq_gradient_pal(low="blue", high="orange")(seq(0,1,length.out=5))
colors_trans = paste0(colors,"50")

plot(1:length(colors), col=colors, bg=colors_trans, pch=21, cex=3)

lwd = 2
lend = 2
ljoin = 1

# read the samples
constant_rate_samples = do.call(rbind, lapply(paste0("analyses/empirical_analyses/haemulids/step_5/output/variance_covariance_constant_rate/params_posterior_",1:4,".log"), read.table, header=TRUE, sep="\t", stringsAsFactors=FALSE, check.names=FALSE))
variable_rate_samples = do.call(rbind, lapply(paste0("analyses/empirical_analyses/haemulids/step_5/output/variance_covariance_lognormal_noise/params_posterior_",1:4,".log"), read.table, header=TRUE, sep="\t", stringsAsFactors=FALSE, check.names=FALSE))

# compute densities of the rate parameters
constant_state_ratio = constant_rate_samples$state_ratio
variable_state_ratio = variable_rate_samples$state_ratio

mean(constant_state_ratio)
mean(variable_state_ratio)

constant_state_ratio_quantile = quantile(constant_state_ratio, prob=c(0.025, 0.975))
variable_state_ratio_quantile = quantile(variable_state_ratio, prob=c(0.025, 0.975))

constant_state_ratio_density = density(constant_state_ratio, adjust=2)
variable_state_ratio_density = density(variable_state_ratio, adjust=2)

# test_density = density(variable_state_ratio, adjust=2)
# plot(test_density)

# plot(variable_state_ratio_density, xlim=c(0,50))
# lines(constant_state_ratio_density)

constant_state_ratio_x = seq(constant_state_ratio_quantile[1], constant_state_ratio_quantile[2], length.out=5001)
constant_state_ratio_y = approxfun(constant_state_ratio_density)(constant_state_ratio_x)

variable_state_ratio_x = seq(variable_state_ratio_quantile[1], variable_state_ratio_quantile[2], length.out=5001)
variable_state_ratio_y = approxfun(variable_state_ratio_density)(variable_state_ratio_x)

# constant_state_ratio_HPD = density(constant_state_ratio, from=constant_state_ratio_quantile[1], to=constant_state_ratio_quantile[2])
# constant_state_ratio_HPD$y[1] = 0
# constant_state_ratio_HPD$y[length(constant_state_ratio_HPD$y)] = 0
# 
# variable_state_ratio_HPD = density(variable_state_ratio, from=variable_state_ratio_quantile[1], to=variable_state_ratio_quantile[2])
# variable_state_ratio_HPD$y[1] = 0
# variable_state_ratio_HPD$y[length(variable_state_ratio_HPD$y)] = 0

# compute distributions of the number of events
constant_state_number = constant_rate_samples$total_num_changes
variable_state_number = variable_rate_samples$total_num_changes

mean(constant_state_number)
mean(variable_state_number)

constant_state_number_quantile = quantile(constant_state_number, prob=c(0.025, 0.975))
variable_state_number_quantile = quantile(variable_state_number, prob=c(0.025, 0.975))

constant_state_number_table = table(constant_state_number) / length(constant_state_number)
variable_state_number_table = table(variable_state_number) / length(variable_state_number)

x_points_constant = seq(constant_state_number_quantile[1], constant_state_number_quantile[2]+1)
y_points_constant = constant_state_number_table[as.character(x_points_constant[-length(x_points_constant)])]

x_points_constant = as.vector(rbind(x_points_constant[-length(x_points_constant)], x_points_constant[-1]))
y_points_constant = as.vector(rbind(y_points_constant, y_points_constant))

x_points_variable = seq(variable_state_number_quantile[1], variable_state_number_quantile[2]+1)
y_points_variable = variable_state_number_table[as.character(x_points_variable[-length(x_points_variable)])]

x_points_variable = as.vector(rbind(x_points_variable[-length(x_points_variable)], x_points_variable[-1]))
y_points_variable = as.vector(rbind(y_points_variable, y_points_variable))

#################
# make the plot #
#################

tikz("manuscript/figures/step_5/rate_comparisons.tex", height=3, width=8, standAlone = TRUE,
     packages = c("\\usepackage{tikz}","\\usepackage{mathpazo}","\\usepackage[active,tightpage,psfixbb]{preview}","\\PreviewEnvironment{pgfpicture}","\\setlength\\PreviewBorder{0pt}","\\usepackage{amssymb}","\\usepackage{dsfont}"))

par(mar=c(4,4,0.1,0.1), oma=c(0,0,0,4), lend=lend, ljoin=ljoin, mfrow=1:2)

plot(variable_state_ratio_density, zero.line=FALSE, col=colors[1], lwd=lwd, xaxt="n", yaxt="n", main=NA, xlab=NA, ylab=NA, xlim=c(0,30), type="n", bty="n")
abline(v=1, lty=2)

polygon(x=c(variable_state_ratio_x, rev(variable_state_ratio_x)),
        y=c(variable_state_ratio_y, rep(0, 5001)), border=NA, col=colors_trans[1])

polygon(x=c(constant_state_ratio_x, rev(constant_state_ratio_x)),
        y=c(constant_state_ratio_y, rep(0, 5001)), border=NA, col=colors_trans[5])

lines(variable_state_ratio_density, col=colors[1], lwd=lwd)
lines(constant_state_ratio_density, col=colors[5], lwd=lwd)
box()

axis(1, lwd=0, lwd.tick=1)
mtext(text="$\\zeta^2_1 / \\zeta^2_0$", side=1, line=2.5)

axis(2, lwd=0, lwd.tick=1, las=1)
mtext(text="$P(\\zeta^2_1 / \\zeta^2_0 \\mid \\mathcal{X}, \\mathcal{Y}, \\Psi)$", side=2, line=2.5)

legend("topright", legend=c("with background variation","without background variation"), pt.bg=colors_trans[c(1,5)], bty="n", col=colors[c(1,5)], pt.lwd=lwd, pt.cex=2, pch=22)

plot(variable_state_number_table,  col=colors[1], lwd=lwd, xaxt="n", yaxt="n", main=NA, xlab=NA, ylab=NA, xlim=c(5,45), type="s", bty="n")
lines(constant_state_number_table, col=colors[5], lwd=lwd, type="s")

polygon(x=c(x_points_constant, rev(x_points_constant)), y=c(y_points_constant, rep(0, length(x_points_constant))), border=NA, col=colors_trans[5])
polygon(x=c(x_points_variable, rev(x_points_variable)), y=c(y_points_variable, rep(0, length(x_points_variable))), border=NA, col=colors_trans[1])
box()

axis(1, lwd=0, lwd.tick=1, at=seq(5,45,10))
axis(2, lwd=0, lwd.tick=1, las=1)

# axis(1, lwd=0, lwd.tick=1)
mtext(text="$k$", side=1, line=2.5)
mtext(text="$P(k \\mid \\mathcal{X}, \\mathcal{Y}, \\Psi)$", side=2, line=2.5)

dev.off()

tools::texi2pdf("manuscript/figures/step_5/rate_comparisons.tex", clean=TRUE)
file.rename("rate_comparisons.pdf", "manuscript/figures/step_5/rate_comparisons.pdf")
