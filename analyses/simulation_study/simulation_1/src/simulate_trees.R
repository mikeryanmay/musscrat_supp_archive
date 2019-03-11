library(TESS)

cat("simulating trees.\n")

# simulation parameters
num_tips   = c(25, 50, 100)
num_traits = c(1, 2, 4, 8)
gamma      = c(1, 2, 4, 8)
reps       = 100

grid = expand.grid(num_tips=num_tips, num_traits=num_traits,
                   gamma=gamma, tree=1:reps, stringsAsFactors=FALSE)

# simulate the trees
bar = txtProgressBar(style=3, width=40)
for(i in 1:nrow(grid)) {

  this_row = grid[i,]
  this_num_tips   = this_row[[1]]
  this_num_traits = this_row[[2]]
  this_gamma      = this_row[[3]]
  this_tree       = this_row[[4]]

  # create the directories if necessary
  this_dir = paste0("analyses/simulation_study/simulation_1/data/n_",this_num_tips,"/k_",this_num_traits,"/g_",this_gamma,"/t_", this_tree)
  if ( !dir.exists(this_dir) ) {
    dir.create(this_dir, recursive=TRUE, showWarnings=FALSE)
  }

  # simulate the tree
  tree = ladderize(tess.sim.taxa(1, this_num_tips, 10, 1, 0.5)[[1]])

  # rescale the tree
  tree$edge.length = tree$edge.length / max(branching.times(tree))

  # write the tree
  write.tree(tree, file=paste0(this_dir,"/tree.tre"))

  # increment the progress bar
  setTxtProgressBar(bar, i / nrow(grid))

}

cat("\n")
