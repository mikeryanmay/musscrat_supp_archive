#!/bin/bash

################
# simulation 1 #
################

# simulate the trees
Rscript analyses/simulation_study/simulation_1/src/simulate_trees.R;

# simulate discrete-character data
Rscript analyses/simulation_study/simulation_1/src/simulate_discrete_traits.R;

# simulate continuous-character data
Rscript analyses/simulation_study/simulation_1/src/simulate_continuous_characters.R;

# write the Rev scripts
Rscript analyses/simulation_study/simulation_1/src/write_jobs.R;

################
# simulation 2 #
################

# copy the tree data from simulation 1
Rscript analyses/simulation_study/simulation_2/src/copy_data.R;

# simulate background-rate variation
Rscript analyses/simulation_study/simulation_2/src/simulate_background_variation.R;

# simulate continuous-character data
Rscript analyses/simulation_study/simulation_2/src/simulate_continuous_characters.R;

# write the Rev scripts
Rscript analyses/simulation_study/simulation_2/src/write_jobs.R;

################
# simulation 3 #
################

# copy the tree data from simulation 1
Rscript analyses/simulation_study/simulation_3/src/copy_data.R;

# write the Rev scripts
Rscript analyses/simulation_study/simulation_3/src/write_jobs.R;

################
# simulation 4 #
################

# copy the tree data from simulation 2
Rscript analyses/simulation_study/simulation_4/src/copy_data.R;

# write the Rev scripts
Rscript analyses/simulation_study/simulation_4/src/write_jobs.R;
