library(ape)

# read in the MAP tree from the combined unrooted analysis

tree = read.nexus("analyses/empirical_analyses/haemulids/step_2/output/combined_unrooted/map_tree_1.trees")

# root the tree
rooted_tree = root(tree, node=78, resolve.root=TRUE)
rooted_tree$edge.length = pmax(rooted_tree$edge.length, 0.001)

# time-calibrate the tree
calibrated_tree = chronos(rooted_tree)
plot(calibrated_tree)

# write the tree to file
write.tree(calibrated_tree, file="analyses/empirical_analyses/haemulids/data/starting_tree.tre")
