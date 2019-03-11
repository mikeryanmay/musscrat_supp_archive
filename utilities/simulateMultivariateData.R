library(ape)
library(mvtnorm)

simulateMultivariateData = function(phy, V, root_states) {

  if(missing(root_states)) {
    root_states = numeric(ncol(V))
  }
  
  # get the nodes and tips
  nodes = unique(as.vector(phy$edge))
  num_nodes = length(nodes)
  num_tips = length(phy$tip.label)
  num_internals = num_tips - 2
  num_traits = length(root_states)
    
  # initialize the states
  states = matrix(NA, num_traits, num_nodes)
  colnames(states) = nodes
  states[,as.character(num_tips + 1)] = root_states
  
  # forward simulate from the root
  node_order = names(sort(branching.times(phy), decreasing=TRUE))
  for(i in 1:length(node_order)) {
    
    # get this node and state
    this_node = node_order[i]
    current_state = states[,this_node]
    
    # find this node's descendants
    descendants = which(phy$edge[,1] == this_node)
    descendant_labels = phy$edge[descendants,2]
    
    # simulate the left branch
    t_left = phy$edge.length[descendants[1]]
    state_left = rmvnorm(1, mean=current_state, sigma=t_left * V)[1,]
    states[,as.character(descendant_labels[1])] = state_left
    
    # simulate the right branch
    t_right = phy$edge.length[descendants[2]]
    state_right = rmvnorm(1, mean=current_state, sigma=t_right * V)[1,]
    states[,as.character(descendant_labels[2])] = state_right
    
  }
  
  # format the states
  tip_states = states[,as.character(phy$edge[phy$edge[,2] <= num_tips,2])]
  if(class(tip_states) == "numeric") {
    tip_states = t(as.matrix(tip_states))
  }
  colnames(tip_states) = phy$tip.label
  node_states = states[,nodes > num_tips]
  
  res = list(tip_states=t(tip_states), node_states=t(node_states))
  
  return(res)
  
}