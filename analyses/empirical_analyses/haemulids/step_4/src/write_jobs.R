# read the stub
lines = readLines("analyses/empirical_analyses/haemulids/step_4/src/template.Rev")

dir.create("analyses/empirical_analyses/haemulids/step_4/jobs", showWarnings=FALSE)

nruns = 4

############################
# iterate over alpha_sigma #
############################

alpha_sigma = c(1/4, 1/2, 1, 2, 4)

for(i in 1:length(alpha_sigma)) {
  
  this_alpha_sigma = alpha_sigma[i]
  
  for(r in 1:nruns) {

    these_lines = lines
    these_lines[10] = paste0("run_ID      = ", r)
    these_lines[12] = paste0("name        = \"alpha_sigma_\" + ",i," + \"_\" + state_model + \"_\" + noise_model")
    these_lines[14] = paste0("# seed(",paste0(sample(0:9, 9, replace=TRUE),collapse=""),")")
    these_lines[39] = paste0("alpha_sigma = ", this_alpha_sigma)
    
    this_file = paste0("analyses/empirical_analyses/haemulids/step_4/jobs/job_alpha_sigma_",i,"_run_",r,".Rev")
    cat(these_lines, file = this_file, sep="\n")
    
  }
  
}

##########################################
# iterate over expected number of events #
##########################################

expected_num_events = c(1, 3, 5, 10, 20)

for(i in 1:length(expected_num_events)) {
  
  this_expected_num_events = expected_num_events[i]
  
  for(r in 1:nruns) {
    
    these_lines = lines
    these_lines[10] = paste0("run_ID      = ", r)
    these_lines[12] = paste0("name        = \"exp_num_events_\" + ",i," + \"_\" + state_model + \"_\" + noise_model")
    these_lines[14] = paste0("# seed(",paste0(sample(0:9, 9, replace=TRUE),collapse=""),")")
    these_lines[32] = paste0("expected_num_changes = ", this_expected_num_events)
    
    this_file = paste0("analyses/empirical_analyses/haemulids/step_4/jobs/job_expected_num_events_",i,"_run_",r,".Rev")
    cat(these_lines, file = this_file, sep="\n")
    
  }
  
}

############################
# iterate over alpha_gamma #
############################

alpha_gamma = c(1/4, 1/2, 1, 2, 4)

for(i in 1:length(alpha_gamma)) {
  
  this_alpha_gamma = alpha_gamma[i]
  
  for(r in 1:nruns) {
    
    these_lines = lines
    these_lines[10] = paste0("run_ID      = ", r)
    these_lines[12] = paste0("name        = \"alpha_gamma_\" + ",i," + \"_\" + state_model + \"_\" + noise_model")
    these_lines[14] = paste0("# seed(",paste0(sample(0:9, 9, replace=TRUE),collapse=""),")")
    these_lines[47] = paste0("alpha_gamma = ", this_alpha_gamma)
    
    this_file = paste0("analyses/empirical_analyses/haemulids/step_4/jobs/job_alpha_gamma_",i,"_run_",r,".Rev")
    cat(these_lines, file = this_file, sep="\n")
    
  }
  
}

####################
# iterate over eta #
####################

eta = c(1/2, 1, 2, 5, 10)

for(i in 1:length(eta)) {
  
  this_eta = eta[i]
  
  for(r in 1:nruns) {
    
    these_lines = lines
    these_lines[10] = paste0("run_ID      = ", r)
    these_lines[12] = paste0("name        = \"eta_\" + ",i," + \"_\" + state_model + \"_\" + noise_model")
    these_lines[14] = paste0("# seed(",paste0(sample(0:9, 9, replace=TRUE),collapse=""),")")
    these_lines[40] = paste0("eta = ", this_eta)
    
    this_file = paste0("analyses/empirical_analyses/haemulids/step_4/jobs/job_eta_",i,"_run_",r,".Rev")
    cat(these_lines, file = this_file, sep="\n")
    
  }
  
}

###################################################
# iterate over variance of the noise distribution #
###################################################

variance = c("H / 2", "H", "2 * H")

for(i in 1:length(variance)) {
  
  this_variance = variance[i]
  
  for(r in 1:nruns) {
    
    these_lines = lines
    these_lines[10] = paste0("run_ID      = ", r)
    these_lines[12] = paste0("name        = \"variance_\" + ",i," + \"_\" + state_model + \"_\" + noise_model")
    these_lines[14] = paste0("# seed(",paste0(sample(0:9, 9, replace=TRUE),collapse=""),")")
    these_lines[54] = paste0("expected_sd = ", this_variance)
    
    this_file = paste0("analyses/empirical_analyses/haemulids/step_4/jobs/job_background_variance_",i,"_run_",r,".Rev")
    cat(these_lines, file = this_file, sep="\n")
    
  }
  
}