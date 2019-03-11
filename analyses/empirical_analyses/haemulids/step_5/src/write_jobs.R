# read the stub
lines = readLines("analyses/empirical_analyses/haemulids/step_5/src/template.Rev")

dir.create("analyses/empirical_analyses/haemulids/step_5/jobs", showWarnings=FALSE)

background_model = c("constant_rate","lognormal_noise")
vcv_model        = c("univariate","variance_covariance")
nruns            = 4

grid = expand.grid(background_model=background_model, vcv_model=vcv_model, run=1:nruns, stringsAsFactors=FALSE)

for(i in 1:nrow(grid)) {
  
  this_row = grid[i,]
  this_background_model = this_row[[1]]
  this_vcv_model        = this_row[[2]]
  this_run              = as.numeric(this_row[[3]])
  
  these_lines = lines
  
  these_lines[9]  = paste0("noise_model = \"",this_background_model,"\"")
  these_lines[10] = paste0("mvbm_model  = \"",this_vcv_model,"\"")
  these_lines[11] = paste0("run_ID      = ",this_run)
  these_lines[15] = paste0("# seed(",paste0(sample(0:9, 9, replace=TRUE),collapse=""),")")
  
  this_file = paste0("analyses/empirical_analyses/haemulids/step_5/jobs/job_",this_vcv_model,"_",this_background_model,"_",this_run,".Rev")
  cat(these_lines, file = this_file, sep="\n")
  
  
}
