# specify the gene regions
regions = "combined"

# loop over gene regions
for(i in 1:length(regions)) {
  
  # get the file with the statistics
  this_region = regions[i]
  cat(this_region,"\n")
  
  this_file   = paste0("analyses/empirical_analyses/haemulids/step_2/output/",this_region,"_unrooted/pps_statistics.csv")
  
  if(file.exists(this_file)) {
    
    # read the statistics
    these_stats = read.csv(this_file, header=FALSE)
    
    # compute the number of subsets
    num_subsets = ncol(these_stats)
    
    # get the observed and simulated statistics  
    these_obs_stats = these_stats[1,]
    these_sim_stats = these_stats[-1,]
    
    # plot the densities
    layout_mat = matrix(1:num_subsets, nrow=1)
    
    pdf(paste0("analyses/empirical_analyses/haemulids/step_2/output/",this_region,"_unrooted/pps_summary.pdf"), height=5, width=5 * num_subsets)
    layout(layout_mat)
    for(j in 1:num_subsets) {
      
      # get the relevant statistics
      this_obs_stat = as.numeric(these_obs_stats[j])
      this_sim_stat = as.numeric(these_sim_stats[,j])
      
      # compute the p-value
      this_p_value  = mean(this_sim_stat >= this_obs_stat)
      
      # plot the densities
      # plot(density(this_sim_stat), main=paste0("seq[",j,"]"))
      hist(this_sim_stat, main=paste0("seq[",j,"]"), breaks=50, col="grey", border=NA, freq=FALSE, xlab="statistic")
      abline(v=this_obs_stat, lty=2)
      legend("topleft", legend=sprintf("p = %.3f",this_p_value), bty="n")
      
    }
    dev.off()
    
  }
  
}







