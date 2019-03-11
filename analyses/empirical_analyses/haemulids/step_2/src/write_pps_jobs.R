# settings
dataset = c("16s","S7","COI","CYTB","RAG1","RAG2","TMO")

# read the stub
lines = readLines("analyses/empirical_analyses/haemulids/step_2/src/pps_template.Rev")

for(i in 1:length(dataset)) {
  
  these_lines     = lines
  these_lines[5]  = paste0("region      = \"",dataset[i],"\"")
  this_file       = paste0("analyses/empirical_analyses/haemulids/step_2/jobs_pps/job_",i,".Rev")
  cat(these_lines, file = this_file, sep="\n")
  
}
