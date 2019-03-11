# settings
dataset = c("16s","S7","COI","CYTB","RAG1","RAG2","TMO")
runs    = 4

grid = expand.grid(dataset=dataset, run = 1:runs, stringsAsFactors=FALSE)

# read the stub
lines = readLines("analyses/empirical_analyses/haemulids/step_1/src/template.Rev")

for(i in 1:nrow(grid)) {
  
  this_model = grid[i,]
  these_lines = lines
  
  these_lines[8]  = paste0("region      = \"",this_model[[1]],"\"")
  these_lines[10] = paste0("run_ID      = ",   this_model[[2]])
  these_lines[13] = paste0("seed(",paste0(sample.int(9, replace=TRUE), collapse=""),")")
  
  this_file = paste0("analyses/empirical_analyses/haemulids/step_1/jobs/job_",i,".Rev")
  
  cat(these_lines, file = this_file, sep="\n")
  
}
