################################################################################
#                                                                              #
#                      learn causal graph for baseflow index                   #
#                                   PC Algorithm                               #
# ##############################################################################

setwd("~/Catchment-Causal-Discovery/")

# get the data
source('./source/1_load_data_&_packages.R')
# load functions
source('./source/2_functions.r')


# add the target variable to the selected variables
selected_data_slope_fdc <- 
  merge(selected_data_slope_fdc, ALL_SIGNATURES[, c('gauge_id', 'baseflow_index')], by = 'gauge_id')

selected_data_slope_fdc <- na.omit(selected_data_slope_fdc)


target_node <- 'baseflow_index'

# transform data to normal------------------------------------------------------
data_slope_fdc <- transform_boxcox(selected_data_slope_fdc[, -c('gauge_id')])

# scale the data
data_slope_fdc[, names(data_slope_fdc) := lapply(.SD, scale)]

# define the black list
blacklist_pc[from == 'target_node', from := (target_node)]

# run algorithms 
# set.seed(123)
# pc.fit <- pc.stable(data_slope_fdc, test = 'cor', blacklist = blacklist_pc, alpha = 0.2)
pc.fit <- pc.stable(data_slope_fdc, test = 'mi-g-sh', blacklist = blacklist_pc, alpha = 0.2)
parents(pc.fit, node = 'baseflow_index')
graphviz.plot(pc.fit)

saveRDS(object = pc.fit, file = './data/output/PC_DAGs/pc_mi_g_sh_bfi.rds')
pc.fit <- readRDS(file = './data/output/PC_DAGs/pc_mi_g_sh_bfi.rds')
graphviz.plot(readRDS(file = './data/output/PC_DAGs/pc_mi_g_sh_bfi.rds'))

# plot(pc.fit)
pc.fit

# use bootstrap to check for stability
set.seed(123)
# pc_boot_strength <- 
#   boot.strength(
#     data_slope_fdc, 
#     R = 1000, 
#     algorithm = 'pc.stable',  
#     algorithm.args = list(test = 'mi-g-sh', blacklist = blacklist_pc, alpha = 0.05)
#     )

# saveRDS(object = pc_boot_strength, file = './data/output/PC_DAGs/boot_pc_mi_g_sh_bfi.rds')
pc_boot_strength <- readRDS(file = './data/output/PC_DAGs/boot_pc_mi_g_sh_bfi.rds')

# str(pc_boot_strength)
# plot(pc_boot_strength)
# qgraph(input = pc_boot_strength, legend.cex = 1, asize = 2, vsize = 2, label.cex = 5,
#   repulsion = 1, edge.color = 'black', directed = TRUE, edge.labels = TRUE, title = "Estimated DAG (bootstrap)"
#   )
dt_boot <- as.data.table(pc_boot_strength)
dt_boot[strength > 0 & to == 'baseflow_index', ]


# get the parents of the signature
vec_parent_nodes_boot <- dt_boot[strength > 0 & to == 'baseflow_index', from]


# Generate the averaged network using a threshold of 0.1 for edge strength
avg_net <- averaged.network(pc_boot_strength, threshold = 0.1)
graphviz.plot(avg_net)
parents(avg_net, node = 'baseflow_index')
avg_net


# read the likelihood ratio test
dt_bfi_reg_test <- 
  readRDS(file = './data/output/regression_test/likelihood_ratio_test_baseflow_index')

dt_target_node_test <- dt_bfi_reg_test[target_1 == (target_node) | target_2 == (target_node),]
dt_target_node_test <- dt_target_node_test[target_1 %in% vec_parent_nodes_boot | target_2 %in% vec_parent_nodes_boot,]
# dt_target_node_test[p_value_fwd < 0.05 | p_value_bwd < 0.06]


# saveRDS(object = pc.fit, file = './data/output/PC_DAGs/pc_mc_mi_g_bfi.rds')
# plot(readRDS(file = './data/output/PC_DAGs/pc_mc_mi_g_bfi.rds'))


# CPDAG to DAG-----------------------------------------------------------------
pc.fit <- readRDS(file = './data/output/PC_DAGs/pc_mi_g_sh_bfi.rds')
parents(pc.fit, node = 'baseflow_index')
plot(pc.fit)
pc.fit
# define edges

# pc.fit <- set.arc(pc.fit, from = 'soil_porosity', to = 'sand_frac')

# pc.fit <- set.arc(pc.fit, from = 'sand_frac', to = 'soil_conductivity') # to be able to change undirected to directed
# pc.fit <- set.arc(pc.fit, from = 'clay_frac', to = 'soil_conductivity')

pc.fit <- set.arc(pc.fit, from = 'elev_mean', to = 'slope_mean')

pc.fit

saveRDS(object = pc.fit, file = './data/output/PC_DAGs/DAG_bfi.rds')

plot(pc.fit)



# library(igraph)
# dag <- readRDS(file = './data/output/PC_DAGs/DAG_bfi.rds')
# # Convert bnlearn object to adjacency matrix
# # adj_mat <- amat(pc.fit)
# adj_mat <- amat(dag)
# 
# # # Create igraph object
# g <- graph_from_adjacency_matrix(adjmatrix = adj_mat, mode = "directed", weighted = FALSE)
# # 
# # # Plot using igraph
# # plot(g, vertex.size = 20, vertex.label.cex= 0.75)
# # 
# # 
# # # Create igraph object
# # g <- graph_from_adjacency_matrix(adj_mat, mode = "directed")
# # # Plot using igraph
# # # set.seed(1)
# # plot(g, vertex.size = 20, vertex.label.cex = 0.8)
# 
# 
# 
# 
# # Optional: manually define node layout (x, y positions)
# layout_coords <- layout_with_fr(g)  # or layout_in_circle, layout_as_tree, or your own matrix
# # layout_coords <- matrix(c(
# #   -0.25, 2.75,  # p_mean
# #   -0.5, 2.5,  # pet_mean
# #   -0.75, 2.25,  # p_season
# #   -1, 2.0,  # frac_snow
# #   -1.25, 1.75,  # high_prec_freq
# #   -1.5, 1.5,  # low_prec_fre
# #   -1.25, 1.25,  # low_prec_dur
# #   -1, 1,  # soil_depth_pe
# #   -0.75, 0.75,  # soil conductivity
# #   -0.5, 0.5,  # sand frac
# #   -0.25, 0.25, # clay frac
# #   0.25, 0.25,  # soil porosity
# #   0.5, 0.5,  # max water content
# #   0.75, 0.75,  # silt frac
# #   1, 1,  # elev mean
# #   1.25, 1.25,  # slope mean
# #   1.5, 1.5,  # area
# #   1.25, 1.75,  # frac forest
# #   1, 2.0,  # lai max
# #   0.75, 2.25,  # lai diff
# #   0.5, 2.5,  # geol permeability
# #   0.25, 2.75,  # geol porosity
# #   
# #   0, 3  # target
# # ), byrow = TRUE, ncol = 2)
# 
# # Set node colors
# # node_colors <- c("skyblue", "tomato", "lightgreen", "gold")[1:vcount(g)]  # example
# # Set edge width (you can use weights if available)
# E(g)$width <- 1  # or scale by edge strength if available
# E(g)$arrow.size <- 0.1  # control arrow size
# V(g)$color <- ifelse(V(g)$name %in% c("baseflow_index"), "lightblue", "orange")
# 
# set.seed(4) 
# # Plot
# plot(
#   g, #layout = layout_coords,
#      # vertex.color = node_colors,
#      vertex.size = 15, vertex.label.cex = 0.7, edge.arrow.size = 0.3, edge.color = "black",  main = "Custom DAG")
# 
# 
# V(g)$name	#Name/label of each node (default from column/row names of adjacency matrix)
# V(g)$color	#Color of each node
# V(g)$size	#Size of each node
# V(g)$label	#Custom label to display (defaults to name)
# V(g)$label.cex	#Text size of the node labels
# V(g)$label.color	#Color of the label text
# V(g)$shape	#Shape of nodes ("circle", "square", "rectangle", "sphere" etc.)
# V(g)$x
# V(g)$y	#Coordinates for manual layout (used only in combination with custom layouts)
# V(g)$frame.color	#Color of the node border/frame
# V(g)$tooltip	#Tooltip text (used in interactive plots)


