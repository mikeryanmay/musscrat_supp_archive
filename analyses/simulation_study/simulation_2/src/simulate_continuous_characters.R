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

grid = expand.grid(num_tips=num_tips,
                   num_traits=num_traits,
                   gamma=gamma,
                   tree=1:reps,
                   stringsAsFactors=FALSE)

# simulate the continuous characters
bar = txtProgressBar(style=3, width=40)
for(i in 1:nrow(grid)) {

  this_row        = grid[i,]
  this_num_tips   = this_row[[1]]
  this_num_traits = this_row[[2]]
  this_gamma      = this_row[[3]]
  this_tree       = this_row[[4]]

  # read the tree and rates
  this_dir        = paste0("analyses/simulation_study/simulation_2/data/n_",this_num_tips,"/k_",this_num_traits,"/g_",this_gamma,"/t_", this_tree)
  tree            = read.tree(paste0(this_dir, "/tree.tre"))
  state_0_tree    = read.tree(paste0(this_dir, "/state_0.tre"))
  state_1_tree    = read.tree(paste0(this_dir, "/state_1.tre"))
  background_tree = read.tree(paste0(this_dir, "/background_tree.tre"))

  # compute the state-specific rates
  state_0_rate = 2 / (1 + this_gamma)
  state_1_rate = 2 * this_gamma / (1 + this_gamma)

  # compute the branch lengths
  overall_rate_tree = tree
  overall_rate_tree$edge.length = tree$edge.length * (state_0_tree$edge.length * state_0_rate + state_1_tree$edge.length * state_1_rate) * background_tree$edge.length

  # read the variance-covariance matrix
  sigma = as.matrix(read.table(paste0(this_dir,"/vcv_matrix.txt")))

  # simulate the continuous trait data
  sim = simulateMultivariateData(overall_rate_tree, sigma)

  # save the continuous traits
  writeCharacterData(sim$tip_states, file=paste0(this_dir,"/cont_traits.nex"), type="Continuous")

  # increment the progress bar
  setTxtProgressBar(bar, i / nrow(grid))

}

cat("\n")
















