This repository contains the data and scripts necessary to recreate the analyses for "A Bayesian Approach for Inferring the Impact of a Discrete Character on Rates of Continuous-Character Evolution in the Presence of Background-Rate Variation".

In general, /data contains input files for a particular set of analyses, /src contains scripts for simulating data, curating input data, and assembling Rev scripts, and /jobs contains Rev scripts for running analyses. R scripts will assume they are running from the top-level directory, while Rev scripts will assume they are running from the directory immediately above /jobs (i.e., to run analyses/empirical_analyses/haemulids/step_4/jobs/job_alpha_gamma_1_run_1.Rev, you should be in the analyses/empirical_analyses/haemulids/step_4/ directory).

The repository is structured as follows:

- /utilities: Contains pre- and post-processing scripts required by the other scripts in the archive.
- /analyses
    - /rev_modules: Contains Rev scripts used for empirical and simulation analyses (these modules are called by templates in the /haemulids and /simulation_study directories to create full analysis scripts).
    - /empirical_analyses
        - /haemulids: Contains scripts for the empirical analysis of the Haemulids.
            - /data
                - /pruned: Contains "pruned" alignments for the Haemulid phylogenetic analyses. These alignments only include species that have sequence data for a particular locus (they are used for phylogenetic analyses that involve only a single locus).
                - /full: Contains "full" alignments for the Haemulid phylogenetic analyses. These alignments include each sampled species, regardless of whether the species actually has sequence for a particular locus (they are used for concatenated analyses of the phylogeny).
                - /traits: Contains the discrete- and continuous-character data for each sampled Haemulid species (transformed as described in the main text).
            - /step_0: Contains scripts for partition the sequence and curating the character data.
                - /src/identify_stem_loop.R identifies stem-loop regions for RNA sequence-data partitions.
                - /src/curate_data.R divides the sequence data into first, second, and third position, performs transformations for the continuous-character data, and generates the nexus files for the discrete- and continuous-character data (these are all deposited in the /haemulids/data directory).
                - /data: Contains all of the input data for the above steps.
            - /step_1: Contains scripts for performing individual gene analyses and posterior predictive simulation for model adequacy.
                - /jobs: Contains the Rev scripts for 4 replicate unrooted phylogenetic analyses of each sequence-data partition under a GTR+G model.
                - /jobs_pps: Contains scripts for generating posterior-predictive test statistics from output of the GTR+G models.
                - /src/compare_pps.R generates the figures of the posterior-predictive test statistics under the GTR+G model.
            - /step_2: Contains scripts for performing concatenated analyses and posterior predictive simulation for model adequacy.
                - /jobs: Contains the Rev scripts for 4 replicate unrooted phylogenetic concatenated analyses under a GTR+G model (partitioned by locus and codon position, when appropriate).
                - /jobs_pps: Contains scripts for generating posterior-predictive test statistics from output of the GTR+G models.
                - /src/compare_pps.R generates the figures of the posterior-predictive test statistics under the GTR+G model.
                - /src/trees.Rev computes MAP trees for each analysis.
            - /step_3: Contains scripts for (relative) divergence-time estimation under a UCLN model.
                - /jobs: Contains the Rev scripts for 4 replicate relaxed-clock analyses under a GTR+G substitution model (partitioned by locus and codon position, when appropriate), a UCLN relaxed-clock model, and a sampled-birth death tree-model prior.
                - /src/estimate_starting_tree.R estimates a starting tree from the output of step_2.
                - /src/trees.Rev computes MAP trees for each analysis.
            - /step_4: Contains scripts for the prior sensitivity analysis for the state-dependent rate model. In this directory, gamma refers to the state-dependent rate ratio zeta^2_1 / zeta^2_0.
                - /jobs: Contains Rev scripts for 4 replicate analyses for each prior sensitivity experiment (more details are available in the main text).
            - /step_5: Contains scripts for the "impact of background-rate-variation" empirical analyses.
                - /jobs: Contains Rev scripts for 4 replicate analyses for each combination of constant/variable background-rate model and univariate/multivariate BM model. Only the multivariate BM model results are reported in the manuscript; the univariate model assumes that the correlation parameters between each pair of continuous characters are 0.
            - /step_6: Contains scripts for the joint analysis of phylogeny reported in the supplemental material.
                - /jobs: Contains scripts for 4 replicate joint analyses of the tree and parameters of the state-dependent rate model.
                - /src/template_prior.Rev runs the model under the prior to generate the marginal prior distribution of tree lengths. This is used to calibrate the rate of discrete-character evolution.
                - /src/trees.Rev computes MAP trees for each analysis.
    - /simulation_study
        - simulate_data.sh simulates all of the data for each simulation experiment.
        - /simulation_1: Scripts and data for constant-background-rate analyses.
            - data.tar.gz: tar containing simulated data for simulation experiment 1.
            - /jobs: Contains Rev scripts for simulation experiment 1.
            - /src: Contains scripts for simulating data for simulation experiment 1.
        - /simulation_2: Scripts and data for variable-background-rate analyses.
            - data.tar.gz: tar containing simulated data for simulation experiment 2.
            - /jobs: Contains Rev scripts for simulation experiment 2.
            - /src: Contains scripts for simulating data for simulation experiment 2.
        - /simulation_3: Scripts and data for the "cost of background-rate-variation" analyses.
            - data.tar.gz: tar containing simulated data for simulation experiment 3.
            - /jobs: Contains Rev scripts for simulation experiment 3.
            - /src: Contains scripts for simulating data for simulation experiment 3.
        - /simulation_4: Scripts and data for the "consequences of ignoring background-rate-variation" analyses.
            - data.tar.gz: tar containing simulated data for simulation experiment 4.
            - /jobs: Contains Rev scripts for simulation experiment 4.
            - /src: Contains scripts for simulating data for simulation experiment 4.
