# settings
runs    = 4

grid = expand.grid(run = 1:runs, stringsAsFactors=FALSE)

# read the stub
lines = readLines("analyses/empirical_analyses/haemulids/step_2/src/template.Rev")

for(i in 1:nrow(grid)) {
  
  this_model = grid[i,]
  these_lines = lines
  
  these_lines[9]  = paste0("run_ID      = ",   this_model[[1]])
  these_lines[12] = paste0("seed(",paste0(sample.int(9, replace=TRUE), collapse=""),")")
  
  this_file = paste0("analyses/empirical_analyses/haemulids/step_2/jobs/job_",i,".Rev")
  
  cat(these_lines, file = this_file, sep="\n")
  
}
