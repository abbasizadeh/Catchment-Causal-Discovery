################################################################################
#                                                                              #
#                       learn causal graph for q mean                          #
#                                PC Algorithm                                  #
# ##############################################################################
setwd("~/Catchment-Causal-Discovery/")

# get the data
source('./source/1_load_data_&_packages.R')
# load functions
source('./source/2_functions.r')

target_node <- 'q_mean'

# add the target variable to the selected variables
selected_data_slope_fdc <- 
  merge(selected_data_slope_fdc, ALL_SIGNATURES[, c('gauge_id', 'q_mean')], by = 'gauge_id')

selected_data_slope_fdc <- na.omit(selected_data_slope_fdc)

# transform data to normal
data_slope_fdc <- transform_boxcox(selected_data_slope_fdc[,-c('gauge_id')])

# scale the data
data_slope_fdc[, names(data_slope_fdc) := lapply(.SD, scale)]

# define black list 
blacklist_pc[from == 'target_node', from := (target_node)]

# run PC algorithms ---------------------------------------------------------------
set.seed(123)
pc.fit <- pc.stable(data_slope_fdc, test = 'mi-g-sh', blacklist = blacklist_pc, alpha = 0.2)
graphviz.plot(pc.fit)
parents(x = pc.fit, node = 'q_mean')
saveRDS(object = pc.fit, file = './data/output/PC_DAGs/pc_mi_g_sh_q_mean.rds')
graphviz.plot(readRDS(file = './data/output/PC_DAGs/pc_mi_g_sh_q_mean.rds'))

# plot(pc.fit)
# pc.fit$nodes$sand_frac


# use bootstrap to check for stability
set.seed(123)
pc_boot_strength <- 
  boot.strength(
    data_slope_fdc, 
    R = 1000, 
    algorithm = 'pc.stable',  
    algorithm.args = list(test = 'mi-g-sh', blacklist = blacklist_pc, alpha = 0.05)
  )

# str(pc_boot_strength)
# plot(pc_boot_strength)

saveRDS(object = pc_boot_strength, file = './data/output/PC_DAGs/boot_pc_mi_g_sh_q_mean.rds')

dt_boot <- as.data.table(pc_boot_strength)


# get the parents of the signature
vec_parent_nodes_boot <- dt_boot[strength > 0 & to == (target_node), from]

# Generate the averaged network using a threshold of 0.1 for edge strength
avg_net <- averaged.network(pc_boot_strength, threshold = 0.1)
graphviz.plot(avg_net)
parents(avg_net, node = target_node)
avg_net


# read the likelihood ratio test
dt_hqd_reg_test <- 
  readRDS(file = './data/output/regression_test/likelihood_ratio_test_q_mean')

dt_target_node_test <- dt_hqd_reg_test[target_1 == (target_node) | target_2 == (target_node),]
dt_target_node_test <- dt_target_node_test[target_1 %in% vec_parent_nodes_boot | target_2 %in% vec_parent_nodes_boot,]
# dt_target_node_test[p_value_fwd < 0.05 | p_value_bwd < 0.06]

dt_target_node_test
dt_boot[strength > 0 & to == (target_node),]
parents(x = pc.fit, node = 'q_mean')










# CPDAG to DAG-----------------------------------------------------------------
pc.fit <- readRDS(file = './data/output/PC_DAGs/pc_mi_g_sh_q_mean.rds')
parents(x = pc.fit, node = 'q_mean')
plot(pc.fit)
pc.fit

# define edges
# pc.fit <- set.arc(pc.fit, from = 'p_mean', to = 'high_prec_freq')
pc.fit <- set.arc(pc.fit, from = 'soil_porosity', to = 'sand_frac')

pc.fit <- set.arc(pc.fit, from = 'clay_frac', to = 'sand_frac') # to be able to change undirected to directed
pc.fit <- set.arc(pc.fit, from = 'clay_frac', to = 'soil_conductivity')

pc.fit <- set.arc(pc.fit, from = 'elev_mean', to = 'slope_mean')


plot(pc.fit)

saveRDS(object = pc.fit, file = './data/output/PC_DAGs/DAG_q_mean.rds')

