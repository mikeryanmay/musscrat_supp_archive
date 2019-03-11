library(TESS)
library(phytools)
source("utilities/readWriteCharacterData.R")
source("utilities/simulateLKJMatrix.R")
source("utilities/simulateMultivariateData.R")

cat("simulating continuous characters.\n")

# simulation parameters
num_tips   = c(25, 50, 100)
num_traits = c(1, 2, 4, 8)
gamma      = c(1, 2, 4, 8)
reps       = 100

grid = expand.grid(num_tips=num_tips, num_traits=num_traits,
                   gamma=gamma, tree=1:reps, stringsAsFactors=FALSE)

# simulate the continuous characters
bar = txtProgressBar(style=3, width=40)
for(i in 1:nrow(grid)) {

  this_row        = grid[i,]
  this_num_tips   = this_row[[1]]
  this_num_traits = this_row[[2]]
  this_gamma      = this_row[[3]]
  this_tree       = this_row[[4]]

  # read the tree and states
  this_dir     = paste0("analyses/simulation_study/simulation_1/data/n_",this_num_tips,"/k_",this_num_traits,"/g_",this_gamma,"/t_", this_tree)
  tree         = read.tree(paste0(this_dir, "/tree.tre"))
  state_0_tree = read.tree(paste0(this_dir, "/state_0.tre"))
  state_1_tree = read.tree(paste0(this_dir, "/state_1.tre"))

  # compute the state-specific rates
  state_0_rate = 2 / (1 + this_gamma)
  state_1_rate = 2 * this_gamma / (1 + this_gamma)

  # compute the branch lengths
  state_dependent_tree = tree
  state_dependent_tree$edge.length = tree$edge.length * (state_0_tree$edge.length * state_0_rate + state_1_tree$edge.length * state_1_rate)

  # simulate a variance-covariance matrix
  if (this_num_traits == 1) {
    corr = matrix(1, 1, 1)
  } else {
    corr = simulateLKJMatrix(1, this_num_traits)
  }

  # simulate the relative rates
  vars          = rgamma(this_num_traits, 4, 1)
  relative_vars = vars / mean(vars)
  relative_sds  = sqrt(relative_vars)

  # construct the variance-covariance matrix
  sigma = diag(relative_sds) %*% corr %*% diag(relative_sds)

  # simulate the continuous trait data
  sim = simulateMultivariateData(state_dependent_tree, sigma)

  # save the continuous traits
  writeCharacterData(sim$tip_states, file=paste0(this_dir,"/cont_traits.nex"), type="Continuous")

  # save the correlation and variance-covariance matrix
  write.table(corr, file=paste0(this_dir,"/corr_matrix.txt"), quote=FALSE, row.names=FALSE, col.names=FALSE, sep="\t")
  write.table(sigma, file=paste0(this_dir,"/vcv_matrix.txt"), quote=FALSE, row.names=FALSE, col.names=FALSE, sep="\t")

  # increment the progress bar
  setTxtProgressBar(bar, i / nrow(grid))

}

cat("\n")
















