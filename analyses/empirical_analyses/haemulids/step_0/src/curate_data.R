library(ape)
source("utilities/writeAlignment.R")

# setwd("~/repos/musscrat/")

# Read in the sequence data
sequence_data <- read.nexus.data("analyses/empirical_analyses/haemulids/step_0/data/Grunts_100_seq.nex")
sequence_species <- names(sequence_data)

# Read in the trait data
trait_data <- readLines("analyses/empirical_analyses/haemulids/step_0/data/trait_data.txt")[-1]
trait_data <- do.call(rbind,lapply(trait_data, function(x) {

  this_x       <- strsplit(x,"\t")[[1]]
  this_species <- this_x[1]
  this_habitat <- tail(this_x, 1)
  this_traits  <- as.numeric(this_x[2:(length(this_x) - 1)])

  res <- data.frame(species=this_species, habitat=this_habitat, traits=I(list(this_traits)), stringsAsFactors=FALSE)
  return(res)

}))

trait_species <- trait_data$species

# find the overlapping species
species_to_retain <- intersect(trait_species, sequence_species)

# prune the data
sequence_data_pruned <- sequence_data[species_to_retain]
trait_data_pruned    <- trait_data[trait_data$species %in% species_to_retain,]

nrow(trait_data_pruned) == length(sequence_data_pruned)

# split the sequence data up by site
sequence_data_pruned <- do.call(rbind, sequence_data_pruned)

x16S_sites <- 1:558
x16S <- sequence_data_pruned[,x16S_sites]

xS7_sites  <- 3331:3695
xS7 <- sequence_data_pruned[,xS7_sites]

COI_1_sites <- seq(559,1097,3)
COI_2_sites <- seq(560,1097,3)
COI_3_sites <- seq(561,1097,3)

COI_1 <- sequence_data_pruned[,COI_1_sites]
COI_2 <- sequence_data_pruned[,COI_2_sites]
COI_3 <- sequence_data_pruned[,COI_3_sites]

CYTB_1_sites <- seq(1100,1825,3)
CYTB_2_sites <- seq(1098,1825,3)
CYTB_3_sites <- seq(1099,1825,3)

CYTB_1 <- sequence_data_pruned[,CYTB_1_sites]
CYTB_2 <- sequence_data_pruned[,CYTB_2_sites]
CYTB_3 <- sequence_data_pruned[,CYTB_3_sites]

RAG1_1_sites <- seq(1828,2556,3)
RAG1_2_sites <- seq(1826,2556,3)
RAG1_3_sites <- seq(1827,2556,3)

RAG1_1 <- sequence_data_pruned[,RAG1_1_sites]
RAG1_2 <- sequence_data_pruned[,RAG1_2_sites]
RAG1_3 <- sequence_data_pruned[,RAG1_3_sites]

RAG2_1_sites <- seq(2558,3330,3)
RAG2_2_sites <- seq(2559,3330,3)
RAG2_3_sites <- seq(2557,3330,3)

RAG2_1 <- sequence_data_pruned[,RAG2_1_sites]
RAG2_2 <- sequence_data_pruned[,RAG2_2_sites]
RAG2_3 <- sequence_data_pruned[,RAG2_3_sites]

TMO_1_sites <- seq(3697,4144,3)
TMO_2_sites <- seq(3698,4144,3)
TMO_3_sites <- seq(3696,4144,3)

TMO_1 <- sequence_data_pruned[,TMO_1_sites]
TMO_2 <- sequence_data_pruned[,TMO_2_sites]
TMO_3 <- sequence_data_pruned[,TMO_3_sites]

# make sure all sites are accounted for
all_sites <- unlist(c(x16S_sites,xS7_sites,
  COI_1_sites,  COI_2_sites, COI_3_sites,
  CYTB_1_sites,CYTB_2_sites,CYTB_3_sites,
  RAG1_1_sites,RAG1_2_sites,RAG1_3_sites,
  RAG2_1_sites,RAG2_2_sites,RAG2_3_sites,
  TMO_1_sites,  TMO_2_sites, TMO_3_sites))

length(all_sites) == ncol(sequence_data_pruned)

# write the alignments to file
writeAlignment(x16S, "analyses/empirical_analyses/haemulids/step_0/output/full/16s.nex")

writeAlignment(xS7, "analyses/empirical_analyses/haemulids/step_0/output/full/S7.nex")

writeAlignment(COI_1, "analyses/empirical_analyses/haemulids/step_0/output/full/COI_pos_1.nex")
writeAlignment(COI_2, "analyses/empirical_analyses/haemulids/step_0/output/full/COI_pos_2.nex")
writeAlignment(COI_3, "analyses/empirical_analyses/haemulids/step_0/output/full/COI_pos_3.nex")

writeAlignment(CYTB_1, "analyses/empirical_analyses/haemulids/step_0/output/full/CYTB_pos_1.nex")
writeAlignment(CYTB_2, "analyses/empirical_analyses/haemulids/step_0/output/full/CYTB_pos_2.nex")
writeAlignment(CYTB_3, "analyses/empirical_analyses/haemulids/step_0/output/full/CYTB_pos_3.nex")

writeAlignment(RAG1_1, "analyses/empirical_analyses/haemulids/step_0/output/full/RAG1_pos_1.nex")
writeAlignment(RAG1_2, "analyses/empirical_analyses/haemulids/step_0/output/full/RAG1_pos_2.nex")
writeAlignment(RAG1_3, "analyses/empirical_analyses/haemulids/step_0/output/full/RAG1_pos_3.nex")

writeAlignment(RAG2_1, "analyses/empirical_analyses/haemulids/step_0/output/full/RAG2_pos_1.nex")
writeAlignment(RAG2_2, "analyses/empirical_analyses/haemulids/step_0/output/full/RAG2_pos_2.nex")
writeAlignment(RAG2_3, "analyses/empirical_analyses/haemulids/step_0/output/full/RAG2_pos_3.nex")

writeAlignment(TMO_1, "analyses/empirical_analyses/haemulids/step_0/output/full/TMO_pos_1.nex")
writeAlignment(TMO_2, "analyses/empirical_analyses/haemulids/step_0/output/full/TMO_pos_2.nex")
writeAlignment(TMO_3, "analyses/empirical_analyses/haemulids/step_0/output/full/TMO_pos_3.nex")

# now prune the alignments to exclude unsampled species
pruneAlignment <- function(x) x[rowSums(x != "-") != 0,]

writeAlignment(pruneAlignment(x16S), "analyses/empirical_analyses/haemulids/step_0/output/pruned/16s.nex")

writeAlignment(pruneAlignment(xS7), "analyses/empirical_analyses/haemulids/step_0/output/pruned/S7.nex")

writeAlignment(pruneAlignment(COI_1), "analyses/empirical_analyses/haemulids/step_0/output/pruned/COI_pos_1.nex")
writeAlignment(pruneAlignment(COI_2), "analyses/empirical_analyses/haemulids/step_0/output/pruned/COI_pos_2.nex")
writeAlignment(pruneAlignment(COI_3), "analyses/empirical_analyses/haemulids/step_0/output/pruned/COI_pos_3.nex")

writeAlignment(pruneAlignment(CYTB_1), "analyses/empirical_analyses/haemulids/step_0/output/pruned/CYTB_pos_1.nex")
writeAlignment(pruneAlignment(CYTB_2), "analyses/empirical_analyses/haemulids/step_0/output/pruned/CYTB_pos_2.nex")
writeAlignment(pruneAlignment(CYTB_3), "analyses/empirical_analyses/haemulids/step_0/output/pruned/CYTB_pos_3.nex")

writeAlignment(pruneAlignment(RAG1_1), "analyses/empirical_analyses/haemulids/step_0/output/pruned/RAG1_pos_1.nex")
writeAlignment(pruneAlignment(RAG1_2), "analyses/empirical_analyses/haemulids/step_0/output/pruned/RAG1_pos_2.nex")
writeAlignment(pruneAlignment(RAG1_3), "analyses/empirical_analyses/haemulids/step_0/output/pruned/RAG1_pos_3.nex")

writeAlignment(pruneAlignment(RAG2_1), "analyses/empirical_analyses/haemulids/step_0/output/pruned/RAG2_pos_1.nex")
writeAlignment(pruneAlignment(RAG2_2), "analyses/empirical_analyses/haemulids/step_0/output/pruned/RAG2_pos_2.nex")
writeAlignment(pruneAlignment(RAG2_3), "analyses/empirical_analyses/haemulids/step_0/output/pruned/RAG2_pos_3.nex")

writeAlignment(pruneAlignment(TMO_1), "analyses/empirical_analyses/haemulids/step_0/output/pruned/TMO_pos_1.nex")
writeAlignment(pruneAlignment(TMO_2), "analyses/empirical_analyses/haemulids/step_0/output/pruned/TMO_pos_2.nex")
writeAlignment(pruneAlignment(TMO_3), "analyses/empirical_analyses/haemulids/step_0/output/pruned/TMO_pos_3.nex")









# setwd("~/repos/musscrat/")


# write the discrete-trait data to file (we still have to edit this afterward to make sure the datatype is correct)
discrete_trait <- t(t(as.integer(trait_data_pruned[,2] == "reef")))
rownames(discrete_trait) <- trait_data_pruned$species
writeAlignment(discrete_trait, "analyses/empirical_analyses/haemulids/step_0/output/habitat.nex")

# compute the continuous-traits
traits <- strsplit(readLines("analyses/empirical_analyses/haemulids/step_0/data/trait_data.txt")[1],"\"")[[1]]
traits <- traits[traits != " "]
traits <- traits[-c(1,length(traits))]

# feeding traits
# x: trait (name in data table)
# 1: adductor mass (AM Mass) -> cube root then log transform
# 2: open ratio (Open Ratio) -> no transformation
# 3: close ratio (Close Ratio) -> no transformation
# 4: ascending process (Ascending Process Length) -> log transformation
# 5: raker length (Raker Length) -> log transformation
# 6: eye width (Eye Width) -> log transformation
# 7: sunction index (Suction Index) -> no transformation
# 8: buccal length (Buccal Length) -> log transformation
# 9: buccal width (Buccal Width) -> log transformation
# 10: head height (Head Height) -> log transformation
# 11: head length (Head Length) -> log transformation
# NOTE: original paper also does "size correction"

raw_continuous_traits <- do.call(rbind,trait_data_pruned$traits)
transformed_continuous_traits <- matrix(NA, nrow=length(species_to_retain), ncol=11)
rownames(transformed_continuous_traits) <- species_to_retain

transformed_continuous_traits[,1] <- log(raw_continuous_traits[,13]^(1/3))  # AM Mass
transformed_continuous_traits[,2] <- raw_continuous_traits[,11]             # open ratio
transformed_continuous_traits[,3] <- raw_continuous_traits[,12]             # close ratio
transformed_continuous_traits[,4] <- log(raw_continuous_traits[,10])        # AP length
transformed_continuous_traits[,5] <- log(raw_continuous_traits[,14])        # raker length
transformed_continuous_traits[,6] <- log(raw_continuous_traits[,5])         # eye width
transformed_continuous_traits[,7] <- raw_continuous_traits[,15]             # suction index
transformed_continuous_traits[,8] <- log(raw_continuous_traits[,8])         # buccal length
transformed_continuous_traits[,9] <- log(raw_continuous_traits[,9])         # buccal width
transformed_continuous_traits[,10] <- log(raw_continuous_traits[,6])        # head height
transformed_continuous_traits[,11] <- log(raw_continuous_traits[,7])        # head width

write.table(transformed_continuous_traits, file="analyses/empirical_analyses/haemulids/step_0/output/traits/continuous_traits.nex",sep=" ", col.names=FALSE, quote=FALSE)

transformed_continuous_traits <- cbind(log(raw_continuous_traits[,1]), transformed_continuous_traits) # body length
write.table(transformed_continuous_traits, file="analyses/empirical_analyses/haemulids/step_0/output/traits/continuous_traits_body_size.nex",sep=" ", col.names=FALSE, quote=FALSE)

# locomotion traits
# x: trait (formula)
# 1: fineness ratio: Body Length / sqrt(Body Width * Body Depth)
# 2: caudal fin aspect ratio: ?
# 3:
# This is pretty much hopeless. Wish we had their actual data?



















