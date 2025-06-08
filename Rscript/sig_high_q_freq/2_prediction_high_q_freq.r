# load variables and packages

# working directory
setwd("~/Catchment-Causal-Discovery/")

# load packages and data
source('./source/1_load_data_&_packages.R')

# load functions
source('./source/2_functions.r')

sampling_numbers <- 500
# source('./Rscripts/source/6_1_prediction_all_data.R')


# baseflow index ---------------------------------------------------------------
target_node <- 'high_q_freq'
pc.fit <- readRDS('./data/output/PC_DAGs/DAG_hqf.rds')

# add the target variable to the selected variables
data_for_prediction <- 
  merge(selected_data_slope_fdc, ALL_SIGNATURES[, c('gauge_id', 'high_q_freq')], by = 'gauge_id')
data_for_prediction <- na.omit(data_for_prediction)

# source('./source/6_1_prediction_all_data.R')
# 
# saveRDS(object = prediction_results_whole_data, 
#         file = './data/output/prediciton_results/preciction_results_whole_data_high_q_freq.rds')
# 
# rm(prediction_results_whole_data, data_for_prediction)
# 
# 
# # prediction in clusters =======================================================
# # geol clustering --------------------------------------------------------------
# source('./source/5_1_geol_clustering.R')
# 
# data_for_prediction <- 
#   merge(selected_data_slope_fdc, ALL_SIGNATURES[, c('gauge_id', 'high_q_freq')], by = 'gauge_id')
# data_for_prediction <- na.omit(data_for_prediction)
# 
# 
# source('./source/6_2_prediction_cluster.R')
# 
# saveRDS(object = prediction_results_cluster, 
#         file = './data/output/prediciton_results/preciction_results_geol_clustering_high_q_freq.rds')
# 
# selected_data_slope_fdc[, cluster_hc := NULL]
# rm(prediction_results_cluster, data_for_prediction)
# 
# # soil clustering ----------------------------------------------------------
# source('./source/5_2_soil_clustering.R')
# 
# data_for_prediction <- 
#   merge(selected_data_slope_fdc, ALL_SIGNATURES[, c('gauge_id', 'high_q_freq')], by = 'gauge_id')
# data_for_prediction <- na.omit(data_for_prediction)
# 
# 
# source('./source/6_2_prediction_cluster.R')
# 
# saveRDS(object = prediction_results_cluster, 
#         file = './data/output/prediciton_results/preciction_results_soil_clustering_high_q_freq.rds')
# 
# selected_data_slope_fdc[, cluster_hc := NULL]
# rm(prediction_results_cluster, data_for_prediction)
# 
# 
# # topo clustering ----------------------------------------------------------
# source('./source/5_3_topo_clustering.R')
# 
# data_for_prediction <- 
#   merge(selected_data_slope_fdc, ALL_SIGNATURES[, c('gauge_id', 'high_q_freq')], by = 'gauge_id')
# data_for_prediction <- na.omit(data_for_prediction)
# 
# 
# source('./source/6_2_prediction_cluster.R')
# 
# saveRDS(object = prediction_results_cluster, 
#         file = './data/output/prediciton_results/preciction_results_topo_clustering_high_q_freq.rds')
# 
# selected_data_slope_fdc[, cluster_hc := NULL]
# rm(prediction_results_cluster, data_for_prediction)
# 
# 
# # vege clustering ----------------------------------------------------------
# source('./source/5_4_vege_clustering.R')
# 
# data_for_prediction <- 
#   merge(selected_data_slope_fdc, ALL_SIGNATURES[, c('gauge_id', 'high_q_freq')], by = 'gauge_id')
# data_for_prediction <- na.omit(data_for_prediction)
# 
# 
# source('./source/6_2_prediction_cluster.R')
# 
# saveRDS(object = prediction_results_cluster, 
#         file = './data/output/prediciton_results/preciction_results_vege_clustering_high_q_freq.rds')
# 
# selected_data_slope_fdc[, cluster_hc := NULL]
# rm(prediction_results_cluster, data_for_prediction)


# climate clustering ----------------------------------------------------------
source('./source/5_5_climate_clustering.R')

data_for_prediction <- 
  merge(selected_data_slope_fdc, ALL_SIGNATURES[, c('gauge_id', 'high_q_freq')], by = 'gauge_id')
data_for_prediction <- na.omit(data_for_prediction)


source('./source/6_2_prediction_cluster.R')

saveRDS(object = prediction_results_cluster, 
        file = './data/output/prediciton_results/preciction_results_climate_clustering_high_q_freq.rds')

selected_data_slope_fdc[, cluster_hc := NULL]
rm(prediction_results_cluster, data_for_prediction)







