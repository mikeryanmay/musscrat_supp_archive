library(TESS)
library(phytools)
source("utilities/readWriteCharacterData.R")

cat("simulating background-rate variation.\n")

# simulation parameters
num_tips   = c(25, 50, 100)
num_traits = c(1, 2, 4, 8)
gamma      = c(1, 2, 4, 8)
reps       = 100
v          = 0.587405

grid = expand.grid(num_tips=num_tips, num_traits=num_traits,
                   gamma=gamma, tree=1:reps, stringsAsFactors=FALSE)

bar = txtProgressBar(style=3, width=40)
for(i in 1:nrow(grid)) {

  this_row = grid[i,]
  this_num_tips   = this_row[[1]]
  this_num_traits = this_row[[2]]
  this_gamma      = this_row[[3]]
  this_tree       = this_row[[4]]

  # read the tree
  this_dir = paste0("analyses/simulation_study/simulation_2/data/n_",this_num_tips,"/k_",this_num_traits,"/g_",this_gamma,"/t_", this_tree)
  tree = read.tree(paste0(this_dir, "/tree.tre"))

  # simulate the branch rates
  num_branches = length(tree$edge.length)
  branch_rates = rlnorm(num_branches, log(1)-(v^2)/2, v)

  background_tree = tree
  background_tree$edge.length = branch_rates

  # save the branchrate tree
  write.tree(background_tree, file=paste0(this_dir,"/background_tree.tre"))

  # increment the progress bar
  setTxtProgressBar(bar, i / nrow(grid))

}

cat("\n")
















