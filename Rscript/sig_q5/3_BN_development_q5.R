# Bayesian network for all variables

# setwd("D:/project/Spaptial_variablity_paper/")
# source('./source/load_data_&_packages.R')
source('./Rscripts/source/2_functions.r')

# data processing --------------------------------------------------------------

# transform to normal
# write.csv(x = selected_data_slope_fdc, file = './results_text/q5/data_q5.csv')
target_node <- 'q5'

data_slope_fdc <- transform_boxcox(selected_data_slope_fdc[,-c('gauge_id')])


data_slope_fdc_scaled <- as.data.table(lapply(data_slope_fdc[, -ncol(data_slope_fdc), with = FALSE], scale))
data_slope_fdc <- cbind(data_slope_fdc_scaled, data_slope_fdc[, get(x = target_node)])
setnames(x = data_slope_fdc, old = 'V2', new = paste0(target_node))
# run algorithms ---------------------------------------------------------------

# pc without constraint (estiamte the DAG) -------------------------------------
pc.fit <- pc.stable(data_slope_fdc, test = 'mc-mi-g')


# defind the direction of edges based on the expert knowledge
# pc.fit <- set.arc(pc.fit, from = 'geol_porosity', to = 'frac_forest')

# pc.fit <- set.arc(pc.fit, from = 'lai_diff', to = 'low_q_dur')

# pc.fit <- set.arc(pc.fit, from = 'frac_forest', to = 'lai_diff')
pc.fit <- set.arc(pc.fit, from = 'geol_porosity', to = 'frac_forest')

pc.fit <- set.arc(pc.fit, from = 'lai_max', to = 'frac_forest')

# pc.fit <- set.arc(pc.fit, from = 'frac_forest', to = '')

pc.fit <- set.arc(pc.fit, from = 'slope_mean', to = 'q5')
pc.fit <- set.arc(pc.fit, from = 'slope_mean', to = 'geol_porosity')
pc.fit <- set.arc(pc.fit, from = 'slope_mean', to = 'high_prec_freq')
# pc.fit <- set.arc(pc.fit, from = 'slope_mean', to = 'soil_depth_pelletier')


pc.fit <- set.arc(pc.fit, from = 'elev_mean', to = 'p_mean')
pc.fit <- set.arc(pc.fit, from = 'elev_mean', to = 'lai_max')
pc.fit <- set.arc(pc.fit, from = 'elev_mean', to = 'frac_snow')
pc.fit <- set.arc(pc.fit, from = 'elev_mean', to = 'slope_mean')
pc.fit <- set.arc(pc.fit, from = 'elev_mean', to = 'p_seasonality')

pc.fit <- set.arc(pc.fit, from = 'gauge_lat', to = 'low_prec_freq')
pc.fit <- set.arc(pc.fit, from = 'gauge_lat', to = 'frac_snow')
pc.fit <- set.arc(pc.fit, from = 'gauge_lat', to = 'pet_mean')


# pc.fit <- set.arc(pc.fit, from = 'clay_frac', to = 'soil_conductivity')
pc.fit <- drop.arc(pc.fit, from = 'clay_frac', to = 'high_prec_freq')
pc.fit <- drop.arc(pc.fit, from = 'clay_frac', to = 'frac_snow')


# pc.fit <- set.arc(pc.fit, from = 'soil_depth_pelletier', to = 'geol_porosity')
pc.fit <- set.arc(pc.fit, from = 'soil_conductivity', to = 'frac_forest')

pc.fit <- set.arc(pc.fit, from = 'sand_frac', to = 'frac_forest')
pc.fit <- set.arc(pc.fit, from = 'sand_frac', to = 'geol_porosity')
pc.fit <- set.arc(pc.fit, from = 'sand_frac', to = 'soil_conductivity')



pc.fit <- set.arc(pc.fit, from = 'sand_frac', to = 'geol_porosity')
pc.fit <- set.arc(pc.fit, from = 'sand_frac', to = 'frac_forest')

pc.fit <- set.arc(pc.fit, from = 'low_prec_freq', to = 'lai_max')
pc.fit <- set.arc(pc.fit, from = 'low_prec_freq', to = 'q5')

pc.fit <- set.arc(pc.fit, from = 'high_prec_freq', to = 'low_prec_freq')


pc.fit <- set.arc(pc.fit, from = 'slope_mean', to = 'p_seasonality')


# pc.fit <- set.arc(pc.fit, from = 'low_prec_freq', to = 'high_q_freq')

# pc.fit <- set.arc(pc.fit, from = 'high_prec_freq', to = 'low_prec_freq')

pc.fit <- set.arc(pc.fit, from = 'p_mean', to = 'q5')
pc.fit <- set.arc(pc.fit, from = 'p_mean', to = 'low_prec_freq')
pc.fit <- set.arc(pc.fit, from = 'p_mean', to = 'lai_max')

pc.fit <- set.arc(pc.fit, from = 'p_mean', to = 'p_seasonality')
# pc.fit <- set.arc(pc.fit, from = 'p_seasonality', to = '')

rm(data_slope_fdc, data_slope_fdc_scaled)
plot(pc.fit)


# edge strength
# boot <- boot.strength(data = data_slope_fdc, R = 1000, algorithm = "pc.stable")
# saveRDS(object = boot, file = './results_data/boot.rds')
# boot<- readRDS('./results_data/boot.rds')
# 
# boot_result <- boot[(boot$strength > 0.85) & (boot$direction >= 0.5), ]
# 
# boot_list <- boot_result[, c('from', 'to')]
# row.names(boot_list) <- c(1:nrow(boot_list))
# 
# boot_list
# 
# # 3: p_seasonality elev_mean; 4: p_seasonality slope_mean
# # 6: slope_mean elev_mean; 7: frac_forest low_prec_freq
# # 8: frac_forest slope_mean; 9: lai_max elev_mean
# whitelist_boot <- boot_list[-c(3, 4, 6, 7, 8, 9, 10, 12), ]
# blacklist_boot <- boot_list[c(3, 4, 6, 7, 8, 9, 10, 12), ]
# 
# # select edge strength more than 10%
# boot[110:120, ]
# 
# # pc
# pc.fit_modified <- pc.stable(data_slope_fdc,
#                              whitelist = whitelist_boot,
#                              blacklist = blacklist_boot)

# # constrain the edges
# whitelist_pc <- 
#   rbind(whitelist_boot,
#         data.frame(from = 'gauge_lat', to = 'p_mean'),
#         data.frame(from = 'pet_mean', to = 'slope_fdc'),
#         data.frame(from = 'gauge_lat', to = 'pet_mean'),
#         data.frame(from = 'gauge_lat', to = 'low_prec_freq'),
#         data.frame(from = 'low_prec_freq', to = 'slope_fdc'),
#         data.frame(from = 'gauge_lat', to = 'low_prec_freq')
#   )
# 
# 
# blacklist_pc <- 
#   rbind(blacklist_boot
#   ) 


# # choose algorithm to 
# pc.fit_modified <- pc.stable(data_slope_fdc,
#                             whitelist = whitelist_pc,
#                             blacklist = blacklist_pc)

# pc.fit_modified <- reverse.arc(x = pc.fit_modified, from = 'geol_porosity', to = 'elev_mean')
# pc.fit_modified <- reverse.arc(x = pc.fit_modified, from = 'geol_porosity', to = 'slope_mean')
# pc.fit_modified <- reverse.arc(x = pc.fit_modified, from = 'p_mean', to = 'elev_mean')


# plot network
# qgraph(
#   pc.fit_modified,
#   legend.cex = 0.1,
#   vsize = 8,
#   repulsion = 0.7,
#   title = "Estimated DAG - slope_fdc",
#   asize = 5,
#   edge.color = 'black',
#   label.cex = 2,
#   directed = TRUE
# )
# pc.fit_modified


# # Hybrid Learning Algorithms (combination of constraint-based and score-based algorithms)
# 
# # Max-Min Hill-Climbing --------------------------------------------------------
# mmhc.fit <- mmhc(data_slope_fdc)
# qgraph(mmhc.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.4,
#        title = "Estimated mmhc DAG", asize = 5, edge.color = 'black',
#        label.cex = 2, directed = TRUE)
# 
# mmhc.fit
# 
# # Restricted Maximization ------------------------------------------------------
# rsmax2.fit <- rsmax2(data_slope_fdc)
# qgraph(rsmax2.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.4,
#        title = "Estimated rsmax2 DAG", asize = 5, edge.color = 'black',
#        label.cex = 2, directed = TRUE)
# 
# rsmax2.fit
# 
# # Hybrid HPC: a hybrid algorithm combining HPC and hill-climbing.
# h2pc.fit <- h2pc(data_slope_fdc)
# qgraph(h2pc.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
#        title = "Estimated h2pc DAG", asize = 5, edge.color = 'black',
#        label.cex = 2, directed = TRUE)
# 
# h2pc.fit$arcs



