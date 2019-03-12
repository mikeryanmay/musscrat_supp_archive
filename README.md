# MuSSCRat Supplemental Archive

This repository contains the data and scripts necessary to recreate the analyses reported in the  manuscript "A Bayesian Approach for Inferring the Impact of a Discrete Character on Rates of Continuous-Character Evolution in the Presence of Background-Rate Variation".

In general, /data contains input files for a particular set of analyses, /src contains scripts for simulating data, curating input data, and assembling Rev scripts, and /jobs contains Rev scripts for running analyses. R scripts will assume they are being run from the top-level directory, while Rev scripts will assume they are being run from the directory immediately above /jobs (i.e., to run analyses/empirical_analyses/haemulids/step_4/jobs/job_alpha_gamma_1_run_1.Rev, you should be in the analyses/empirical_analyses/haemulids/step_4/ directory).

The repository is structured as follows:

- /utilities: Contains pre- and post-processing scripts required by the other scripts in the archive.
- /analyses
    - /rev_modules: Contains Rev scripts used for analyses of empirical and simulated data (these modules are called by templates in the /haemulids and /simulation_study directories to create full analysis scripts).
    - /simulation_study
        - simulate_data.sh simulates all of the data for each simulation experiment.
        - /simulation_1: Scripts and data for analyses under a constant background rate.
            - data.tar.gz: tar containing simulated data for simulation experiment 1.
            - /jobs: Contains Rev scripts for simulation experiment 1.
            - /src: Contains scripts to simulate data for simulation experiment 1.
        - /simulation_2: Scripts and data for analyses under variable background rates.
            - data.tar.gz: tar containing simulated data for simulation experiment 2.
            - /jobs: Contains Rev scripts for simulation experiment 2.
            - /src: Contains scripts to simulate data for simulation experiment 2.
        - /simulation_3: Scripts and data for analyses exploring the "cost of accommodating background-rate variation".
            - data.tar.gz: tar containing simulated data for simulation experiment 3.
            - /jobs: Contains Rev scripts for simulation experiment 3.
            - /src: Contains scripts to simulate data for simulation experiment 3.
        - /simulation_4: Scripts and data for analyses exploring the "consequences of ignoring background-rate variation".
            - data.tar.gz: tar containing simulated data for simulation experiment 4.
            - /jobs: Contains Rev scripts for simulation experiment 4.
            - /src: Contains scripts to simulate data for simulation experiment 4.
    - /empirical_analyses
        - /haemulids: Contains scripts and data for the empirical (haemulid) analyses.
            - /data
                - /pruned: Contains "pruned" alignments for the haemulid phylogenetic analyses. These alignments only include species that have sequence data for a particular locus (they are used for phylogenetic analyses that involve only a single locus).
                - /full: Contains "full" alignments for the haemulid phylogenetic analyses. These alignments include each sampled species, regardless of whether the species actually has sequence for a particular locus (they are used for concatenated analyses of the phylogeny).
                - /traits: Contains the discrete- and continuous-character data for each sampled haemulid species (transformed as described in the main text).
            - /step_0: Contains scripts to partition the sequence alignment and to curate the character data.
                - /src/identify_stem_loop.R identifies stem/loop regions for RNA gene regions.
                - /src/curate_data.R divides the sequence alignment into first, second, and third codon positions, performs transformations for the continuous-character data, and generates nexus files for the discrete- and continuous-character data (these are all deposited in the /haemulids/data directory).
                - /data: Contains all of the input data for the above steps.
            - /step_1: Contains scripts to perform phylogenetic analyses of individual gene regions and posterior-predictive simulation analyses to assess model adequacy.
                - /jobs: Contains the Rev scripts to perform 4 replicate (unrooted tree) analyses of each data subset under a GTR+G model.
                - /jobs_pps: Contains scripts to generate posterior-predictive test statistics from output of the phylogenetic analyses (performed under the GTR+G model).
                - /src/compare_pps.R generates figures of the posterior-predictive test statistics for the phylogenetic analyses (performed under the GTR+G model).
            - /step_2: Contains scripts to perform phylogenetic analyses of concatenated dataset and posterior-predictive simulation analyses to assess model adequacy.
                - /jobs: Contains the Rev scripts to perform 4 replicate (unrooted tree) analyses of the concatenated dataset under a composite substitution model (with an independent GTR+G model for each data subset of the concatenated alignment).
                - /jobs_pps: Contains scripts to generate posterior-predictive test statistics of the phylogenetic analyses of the concatenated dataset.
                - /src/compare_pps.R generates figures of the posterior-predictive test statistics for the phylogenetic analyses of the concatenated dataset (performed under the composite model).
                - /src/trees.Rev computes the MAP tree for each analysis.
            - /step_3: Contains scripts to estimate (relative) divergence times from the concatenated dataset.
                - /jobs: Contains the Rev scripts to perform 4 replicate relaxed-clock analyses of the concatenated dataset under a composite substitution model (with an independent GTR+G model for each data subset), a UCLN branch-rate prior model, and a sampled-birth-death node-age prior model.
                - /src/estimate_starting_tree.R estimates a starting tree from the output of step_2.
                - /src/trees.Rev computes the MAP tree for each analysis.
            - /step_4: Contains scripts for the prior-sensitivity experimennts described in the manuscript. In this directory, gamma refers to the state-dependent rate ratio zeta^2_1 / zeta^2_0.
                - /jobs: Contains Rev scripts to perform 4 replicate analyses for each prior-sensitivity experiment (more details are available in the main text).
            - /step_5: Contains scripts for the "impact of background-rate-variation" analyses that appear in the manuscript.
                - /jobs: Contains Rev scripts to perform 4 replicate analyses for each combination of constant/variable background-rate model and univariate/multivariate BM model. Only the multivariate BM model results are reported in the manuscript; the univariate model assumes that the correlation parameters between each pair of continuous characters are 0.
            - /step_6: Contains scripts to perform the joint analysis of phylogeny and state-dependent model parameters that appears in the supplemental material.
                - /jobs: Contains scripts to perform 4 replicate joint analyses of the tree and parameters of the state-dependent rate model.
                - /src/template_prior.Rev runs the MCMC under the prior to generate the marginal prior distribution of tree lengths. This is used to calibrate the rate of discrete-character evolution.
                - /src/trees.Rev compute a MAP trees for each analysis.
