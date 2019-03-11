cat("copying data from simulation 1.\n")

# settings
num_tips   = c(25, 50, 100)
num_traits = c(1, 2, 4, 8)
true_gamma = c(1, 2, 4, 8)
reps       = 100

dir.create("analyses/simulation_study/simulation_2/data", showWarnings=FALSE)

grid = expand.grid(tree=1:reps, num_tips=num_tips, num_traits=num_traits,
                   gamma=true_gamma, stringsAsFactors=FALSE)

bar = txtProgressBar(style=3, width=40)
for(i in 1:nrow(grid)) {

  this_dataset = grid[i,]
  tree = this_dataset$tree
  num  = this_dataset$num_tips
  k    = this_dataset$num_traits
  g    = this_dataset$gamma

  # source directory
  source = paste0("analyses/simulation_study/simulation_1/data/n_",num,"/k_",k,"/g_",g,"/t_",tree)

  # target directory
  target = paste0("analyses/simulation_study/simulation_2/data/n_",num,"/k_",k,"/g_",g)
  dir.create(target, recursive=TRUE, showWarnings=FALSE)

  # copy the data
  file.copy(source, target, recursive=TRUE)

  setTxtProgressBar(bar, i / nrow(grid))

}

cat("\n")
