# load variables and packages

# working directory
setwd("D:/project/Spatial_variablity_paper/")

# load packages and data
source('./Rscripts/source/1_load_data_&_packages.R')

# load functions
source('./Rscripts/source/2_functions.r')


# variable selection -----------------------------------------------------------
# load selected features for pc

# 1- slope of fdc
target_node <- 'slope_fdc'
source('./Rscripts/sig_slope_fdc/1_2_feature_selection_slope_fdc.R')


#  2- stream flow elasticity
# target_node <- 'stream_elas'
# source('./Rscripts/sig_stream_elast/1_2_feature_selection_stream_elast.R')


# 3-low_q_dur
# target_node <- 'low_q_dur'
# source('./Rscripts/sig_low_q_dur/1_2_feature_selection_low_q_dur.R')

# write.csv(x = selected_data_slope_fdc, file = './results_text/low_q_dur/data.csv')

# 4- baseflow index
# target_node <- 'baseflow_index'
# source('./Rscripts/sig_baseflow_index/1_2_feature_selection_baseflow_index.R')

# 5- q mean
# target_node <- 'q_mean'
# source('./Rscripts/sig_q_mean/1_2_feature_selection_q_mean.R')

# 6- high q dur
# target_node <- 'high_q_dur'
# source('./Rscripts/sig_high_q_dur/1_2_feature_selection_high_q_dur.R')


# 7- high q freq
# target_node <- 'high_q_freq'
# source('./Rscripts/sig_high_q_freq/1_2_feature_selection_high_q_freq.R')

# 8- low q freq
# target_node <- 'low_q_freq'
# source('./Rscripts/sig_low_q_freq/1_2_feature_selection_low_q_freq.R')


# 9- runoff ratio
# target_node <- 'runoff_ratio'
# source('./Rscripts/sig_runoff_ratio/1_2_feature_selection_runoff_ratio.R')


# # 10- q5
# target_node <- 'q5'
# source('./Rscripts/sig_q5/1_2_feature_selection_q5.R')


# 10- q95
# target_node <- 'q95'
# source('./Rscripts/sig_q95/1_2_feature_selection_q95.R')





# causal discovery -------------------------------------------------------------
# PC algorithm; independence test: Mutual Information

# 1- slope fdc
# source('./Rscripts/sig_slope_fdc/3_BN_development_slope_fdc.R')

# 2- stream elas
# source('./Rscripts/sig_stream_elast/3_BN_development_stream_elast.R')

# 3- low_q_dur
# source('./Rscripts/sig_low_q_dur/3_BN_development_low_q_dur.R')


# 4- baseflow index
# source('./Rscripts/sig_baseflow_index/3_BN_development_baseflow_index.R')


# 5- q mean
# source('./Rscripts/sig_q_mean/3_BN_development_q_mean.R')


# 6- high q dur
# source('./Rscripts/sig_high_q_dur/3_BN_development_high_q_dur.R')


# 7- high q freq
# source('./Rscripts/sig_high_q_freq/3_BN_development_high_q_freq.R')


# 8- low q freq
# source('./Rscripts/sig_low_q_freq/3_BN_development_low_q_freq.R')


# 9- runoff ratio
# source('./Rscripts/sig_runoff_ratio/3_BN_development_runoff_ratio.R')


# 10- q5
# source('./Rscripts/sig_q5/3_BN_development_q5.R')


# 11- q95
# source('./Rscripts/sig_q95/3_BN_development_q95.R')



# prediction with all data -----------------------------------------------------
# prediction

# data_for_prediction <- fread('./results_text/estream_elas/data.txt')
# data_for_prediction$gauge_id <- "id"


# sampling_numbers <- 100
# data_for_prediction <- copy(selected_data_slope_fdc)
# source('./Rscripts/source/6_1_prediction_all_data.R')

# save data; all data set

# 1- slope fdc
# saveRDS(prediction_results_whole_data, './results_data/preciction_results_whole_data_slope_fdc.rds')
# readRDS('./results_data/preciction_results_whole_data_slope_fdc.rds')

# 2- stream_elast
# saveRDS(prediction_results_whole_data, './results_data/preciction_results_whole_data_stream_elas.rds')

# saveRDS(prediction_results_whole_data, './results_data/preciction_results_whole_data_stream_elas_generated_data.rds')


# 3- low_q_dur
# saveRDS(prediction_results_whole_data, './results_data/preciction_results_whole_data_low_q_dur.rds')
# readRDS('./results_data/preciction_results_whole_data_low_q_dur.rds')


# 4- baseflow index
# saveRDS(prediction_results_whole_data, './results_data/preciction_results_whole_data_baseflow_index.rds')
# readRDS('./results_data/preciction_results_whole_data_baseflow_index.rds')

# 5- q mean
# saveRDS(prediction_results_whole_data, './results_data/preciction_results_whole_data_q_mean.rds')
# readRDS('./results_data/preciction_results_whole_data_q_mean.rds')


# 6- high q dur
# saveRDS(prediction_results_whole_data, './results_data/preciction_results_whole_data_high_q_dur.rds')
# readRDS('./results_data/preciction_results_whole_data_high_q_dur.rds')


# 7- high q freq
# saveRDS(prediction_results_whole_data, './results_data/preciction_results_whole_data_high_q_freq.rds')
# readRDS('./results_data/preciction_results_whole_data_high_q_freq.rds')


# 8- low q freq
# saveRDS(prediction_results_whole_data, './results_data/preciction_results_whole_data_low_q_freq.rds')
# readRDS('./results_data/preciction_results_whole_data_low_q_freq.rds')


# 9- runoff ratio
# saveRDS(prediction_results_whole_data, './results_data/preciction_results_whole_data_runoff_ratio.rds')
# readRDS('./results_data/preciction_results_whole_data_runoff_ratio.rds')


# 10- q5
# saveRDS(prediction_results_whole_data, './results_data/preciction_results_whole_data_q5.rds')
# readRDS('./results_data/preciction_results_whole_data_q5.rds')

# 11- q95
# saveRDS(prediction_results_whole_data, './results_data/preciction_results_whole_data_q95.rds')
# readRDS('./results_data/preciction_results_whole_data_q95.rds')




# cluster analysis for predictors ----------------------------------------------

# 1- slope fdc
# source('./Rscripts/sig_slope_fdc/7_3_clustering_predictors_slope_fdc.R')

# 2- stream elst
# source('./Rscripts/sig_stream_elast/7_3_clustering_predictors_stream_elast.R')


# 3- low q dur
# source('./Rscripts/sig_low_q_dur/7_3_clustering_predictors_low_q_dur.R')


# 4- baseflow index
# source('./Rscripts/sig_baseflow_index/7_3_clustering_predictors_baseflow_index.R')


# 5- q mean
# source('./Rscripts/sig_q_mean/7_3_clustering_predictors_q_mean.R')


# 6- high q dur
# source('./Rscripts/sig_high_q_dur/7_3_clustering_predictors_high_q_dur.R')


# 7- high q freq
# source('./Rscripts/sig_high_q_freq/7_3_clustering_predictors_high_q_freq.R')

# 8- low q freq
# source('./Rscripts/sig_high_q_freq/7_3_clustering_predictors_low_q_freq.R')

# 9- runoff ratio
# source('./Rscripts/sig_runoff_ratio/7_3_clustering_predictors_runoff_ratio.R')


# 10- q5
# source('./Rscripts/sig_q5/7_3_clustering_predictors_q5.R')


# 11- q95
# source('./Rscripts/sig_q95/7_3_clustering_predictors_q95.R')


# data_for_prediction <- copy(selected_data_slope_fdc)

# prediction
# sampling_numbers <- 100
# source('./Rscripts/source/6_2_prediction_cluster.R')

# 1- slope fdc
# saveRDS(prediction_results_cluster, './results_data/preciction_results_predictors_clustering_slope_fdc.rds')

# 2- stream elas
# saveRDS(prediction_results_cluster, './results_data/preciction_results_predictors_clustering_stream_elas.rds')


# 3- low q dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_predictors_clustering_low_q_dur.rds')
# readRDS(file = './results_data/preciction_results_predictors_clustering_low_q_dur.rds')


# 4- baseflow index
# saveRDS(prediction_results_cluster, './results_data/preciction_results_predictors_clustering_baseflow_index.rds')
# readRDS(file = './results_data/preciction_results_predictors_clustering_low_q_dur.rds')


# 5- q mean
# saveRDS(prediction_results_cluster, './results_data/preciction_results_predictors_clustering_q_mean.rds')
# readRDS(file = './results_data/preciction_results_predictors_clustering_q_mean.rds')


# 6- high q dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_predictors_clustering_high_q_dur.rds')
# readRDS(file = './results_data/preciction_results_predictors_clustering_high_q_dur.rds')


# 7- high q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_predictors_clustering_high_q_freq.rds')
# readRDS(file = './results_data/preciction_results_predictors_clustering_high_q_freq.rds')



# 8- low q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_predictors_clustering_low_q_freq.rds')
# readRDS(file = './results_data/preciction_results_predictors_clustering_low_q_freq.rds')


# 9- runoff ratio
# saveRDS(prediction_results_cluster, './results_data/preciction_results_predictors_clustering_runoff_ratio.rds')
# readRDS(file = './results_data/preciction_results_predictors_clustering_runoff_ratio.rds')


# 10- q5
# saveRDS(prediction_results_cluster, './results_data/preciction_results_predictors_clustering_q5.rds')
# readRDS(file = './results_data/preciction_results_predictors_clustering_q5.rds')


# 11- q95
# saveRDS(prediction_results_cluster, './results_data/preciction_results_predictors_clustering_q95.rds')
# readRDS(file = './results_data/preciction_results_predictors_clustering_q95.rds')




# cluster analysis for geological variables ----------------------------------
# clustering

# rm(prediction_results_cluster)
# selected_data_slope_fdc[, cluster_hc := NULL]
# source('./Rscripts/source/5_1_geol_clustering.R')

# data_for_prediction <- copy(selected_data_slope_fdc)
# sampling_numbers <- 100

# prediction in each cluster
# source('./Rscripts/source/6_2_prediction_cluster.R')


# save data; geology

# 1- slope fdc
# saveRDS(prediction_results_cluster, './results_data/preciction_results_geol_clustering_slope_fdc.rds')

# 2- stream elast
# saveRDS(prediction_results_cluster, './results_data/preciction_results_geol_clustering_stream_elas.rds')
 

# 3- low q dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_geol_clustering_low_q_dur.rds')
 

# 4- baseflow index
# saveRDS(prediction_results_cluster, './results_data/preciction_results_geol_clustering_baseflow_index.rds')


# 5- q mean
# saveRDS(prediction_results_cluster, './results_data/preciction_results_geol_clustering_q_mean.rds')


# 6- high q dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_geol_clustering_high_q_dur.rds')
# readRDS('./results_data/preciction_results_geol_clustering_high_q_dur.rds')


# 7- high q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_geol_clustering_high_q_freq.rds')
# readRDS('./results_data/preciction_results_geol_clustering_high_q_freq.rds')



# 8- low q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_geol_clustering_low_q_freq.rds')
# readRDS('./results_data/preciction_results_geol_clustering_low_q_freq.rds')


# 9- runoff ratio
# saveRDS(prediction_results_cluster, './results_data/preciction_results_geol_clustering_runoff_ratio.rds')
# readRDS('./results_data/preciction_results_geol_clustering_runoff_ratio.rds')



# 10- q5
# saveRDS(prediction_results_cluster, './results_data/preciction_results_geol_clustering_q5.rds')
# readRDS('./results_data/preciction_results_geol_clustering_q5.rds')

# 10- q95
# saveRDS(prediction_results_cluster, './results_data/preciction_results_geol_clustering_q95.rds')
# readRDS('./results_data/preciction_results_geol_clustering_q95.rds')





# # cluster analysis for soil variables ----------------------------------------
# rm(prediction_results_cluster)
# selected_data_slope_fdc[, cluster_hc := NULL]

# source('./Rscripts/source/5_2_soil_clustering.R')

# sampling_numbers <- 100
# data_for_prediction <- copy(selected_data_slope_fdc)

# prediction in each cluster
# source('./Rscripts/source/6_2_prediction_cluster.R')


# save data; soil
# 1- slope fdc
# saveRDS(prediction_results_cluster, './results_data/preciction_results_soil_clustering_slope_fdc.rds')

# 2- stream elast
# saveRDS(prediction_results_cluster, './results_data/preciction_results_soil_clustering_stream_elas.rds')
# 

# 3- low_q_dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_soil_clustering_low_q_dur.rds')
 

# 4- baseflow index
# saveRDS(prediction_results_cluster, './results_data/preciction_results_soil_clustering_baseflow_index.rds')


# 5- q mean
# saveRDS(prediction_results_cluster, './results_data/preciction_results_soil_clustering_q_mean.rds')
# readRDS('./results_data/preciction_results_soil_clustering_q_mean.rds')


# 6- high q dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_soil_clustering_high_q_dur.rds')
# readRDS('./results_data/preciction_results_soil_clustering_high_q_dur.rds')


# 7- high q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_soil_clustering_high_q_freq.rds')
# readRDS('./results_data/preciction_results_soil_clustering_high_q_freq.rds')


# 8- low q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_soil_clustering_low_q_freq.rds')
# readRDS('./results_data/preciction_results_soil_clustering_low_q_freq.rds')



# 9- runoff ratio
# saveRDS(prediction_results_cluster, './results_data/preciction_results_soil_clustering_runoff_ratio.rds')
# readRDS('./results_data/preciction_results_soil_clustering_runoff_ratio.rds')


# 10- q5
# saveRDS(prediction_results_cluster, './results_data/preciction_results_soil_clustering_q5.rds')
# readRDS('./results_data/preciction_results_soil_clustering_q5.rds')


# 11- q95
# saveRDS(prediction_results_cluster, './results_data/preciction_results_soil_clustering_q95.rds')
# readRDS('./results_data/preciction_results_soil_clustering_q95.rds')





# # cluster analysis for topo variables ----------------------------------------
# rm(prediction_results_cluster)
# selected_data_slope_fdc[, cluster_hc := NULL]
# cluster topo
# gauge_lat   elev_mean  slope_mean
# source('./Rscripts/source/5_3_topo_clustering.R')

# sampling_numbers <- 100
# data_for_prediction <- copy(selected_data_slope_fdc)

# prediction in each cluster
# source('./Rscripts/source/6_2_prediction_cluster.R')

# save data; topo

# 1- slope fdc
# saveRDS(prediction_results_cluster, './results_data/preciction_results_topo_clustering_slope_fdc.rds')
# readRDS('./results_data/preciction_results_topo_clustering.rds')

# 2- stream elast
# saveRDS(prediction_results_cluster, './results_data/preciction_results_topo_clustering_stream_elast.rds')
# readRDS('./results_data/preciction_results_topo_clustering_stream_elast.rds')
# selected_data_slope_fdc[, cluster_hc := NULL]

# 3- low q dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_topo_clustering_low_q_dur.rds')
# readRDS('./results_data/preciction_results_topo_clustering_low_q_dur.rds')
# selected_data_slope_fdc[, cluster_hc := NULL]

# 4-baseflow index
# saveRDS(prediction_results_cluster, './results_data/preciction_results_topo_clustering_baseflow_index.rds')
# readRDS('./results_data/preciction_results_topo_clustering_baseflow_index.rds')


# 5- q mean
# saveRDS(prediction_results_cluster, './results_data/preciction_results_topo_clustering_q_mean.rds')
# readRDS('./results_data/preciction_results_topo_clustering_q_mean.rds')

# 6- high q dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_topo_clustering_high_q_dur.rds')
# readRDS('./results_data/preciction_results_topo_clustering_high_q_dur.rds')


# 7- high q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_topo_clustering_high_q_freq.rds')
# readRDS('./results_data/preciction_results_topo_clustering_high_q_freq.rds')


# 8- low q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_topo_clustering_low_q_freq.rds')
# readRDS('./results_data/preciction_results_topo_clustering_low_q_freq.rds')


# 9- runoff ratio
# saveRDS(prediction_results_cluster, './results_data/preciction_results_topo_clustering_runoff_ratio.rds')
# readRDS('./results_data/preciction_results_topo_clustering_runoff_ratio.rds')


# 10- q5
# saveRDS(prediction_results_cluster, './results_data/preciction_results_topo_clustering_q5.rds')
# readRDS('./results_data/preciction_results_topo_clustering_q5.rds')


# 11- q95
# saveRDS(prediction_results_cluster, './results_data/preciction_results_topo_clustering_q95.rds')
# readRDS('./results_data/preciction_results_topo_clustering_q95.rds')




# # cluster analysis for vegetation variables ------------------------------------
# used values: gauge_lat   elev_mean  slope_mean
rm(prediction_results_cluster)
selected_data_slope_fdc[, cluster_hc := NULL]

source('./Rscripts/source/5_4_vege_clustering.R')

sampling_numbers <- 100
data_for_prediction <- copy(selected_data_slope_fdc)

# prediction in each cluster
source('./Rscripts/source/6_2_prediction_cluster.R')

# save vege

# 1- slope fdc
# saveRDS(prediction_results_cluster, './results_data/preciction_results_veg_clustering_slope_fdc.rds')


# 2- stream elas
# saveRDS(prediction_results_cluster, './results_data/preciction_results_veg_clustering_stream_elas.rds')
# readRDS('./results_data/preciction_results_veg_clustering_stream_elas.rds')

# 3- low q dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_veg_clustering_low_q_dur.rds')
# readRDS('./results_data/preciction_results_veg_clustering_low_q_dur.rds')

# 4- baseflow index
# saveRDS(prediction_results_cluster, './results_data/preciction_results_veg_clustering_baseflow_index.rds')
# readRDS('./results_data/preciction_results_veg_clustering_baseflow_index.rds')

# 5- q mean
# saveRDS(prediction_results_cluster, './results_data/preciction_results_veg_clustering_q_mean.rds')
# readRDS('./results_data/preciction_results_veg_clustering_q_mean.rds')

# 6- high q dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_veg_clustering_high_q_dur.rds')
# readRDS('./results_data/preciction_results_veg_clustering_high_q_dur.rds')


# 7- high q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_veg_clustering_high_q_freq.rds')
# readRDS('./results_data/preciction_results_veg_clustering_high_q_freq.rds')


# 8- low q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_veg_clustering_low_q_freq.rds')
# readRDS('./results_data/preciction_results_veg_clustering_low_q_freq.rds')


# 9- runoff ratio
# saveRDS(prediction_results_cluster, './results_data/preciction_results_veg_clustering_runoff_ratio.rds')
# readRDS('./results_data/preciction_results_veg_clustering_runoff_ratio.rds')


# 10- q5
# saveRDS(prediction_results_cluster, './results_data/preciction_results_veg_clustering_q5.rds')
# readRDS('./results_data/preciction_results_veg_clustering_q5.rds')

# 11- q95
# saveRDS(prediction_results_cluster, './results_data/preciction_results_veg_clustering_q95.rds')
# readRDS('./results_data/preciction_results_veg_clustering_q95.rds')



# # cluster analysis for climate variables -------------------------------------
rm(prediction_results_cluster)
selected_data_slope_fdc[, cluster_hc := NULL]
source('./Rscripts/source/5_5_climate_clustering.R')

# selected_data_slope_fdc

sampling_numbers <- 100
data_for_prediction <- copy(selected_data_slope_fdc)

# prediction in each cluster
source('./Rscripts/source/6_2_prediction_cluster.R')

# 1- slope fdc 
# saveRDS(prediction_results_cluster, './results_data/preciction_results_climate_clustering_slope_fdc.rds')

# 2- steam elast
# saveRDS(prediction_results_cluster, './results_data/preciction_results_climate_clustering_stream_elas.rds')
# readRDS('./results_data/preciction_results_climate_clustering_stream_elas.rds')

# 3- low q dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_climate_clustering_low_q_dur.rds')
# readRDS('./results_data/preciction_results_climate_clustering_low_q_dur.rds')

# 4- baseflow index
# saveRDS(prediction_results_cluster, './results_data/preciction_results_climate_clustering_baseflow_index.rds')
# readRDS('./results_data/preciction_results_climate_clustering_baseflow_index.rds')

# 5- q mean
# saveRDS(prediction_results_cluster, './results_data/preciction_results_climate_clustering_q_mean.rds')
# readRDS('./results_data/preciction_results_climate_clustering_q_mean.rds')

# 6- high q dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_climate_clustering_high_q_dur.rds')
# readRDS('./results_data/preciction_results_climate_clustering_high_q_dur.rds')


# 7- high q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_climate_clustering_high_q_freq.rds')
# readRDS('./results_data/preciction_results_climate_clustering_high_q_freq.rds')


# 8- low q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_climate_clustering_low_q_freq.rds')
# readRDS('./results_data/preciction_results_climate_clustering_low_q_freq.rds')


# 9- runoff ratio
# saveRDS(prediction_results_cluster, './results_data/preciction_results_climate_clustering_runoff_ratio.rds')
# readRDS('./results_data/preciction_results_climate_clustering_runoff_ratio.rds')


# 10- q5
# saveRDS(prediction_results_cluster, './results_data/preciction_results_climate_clustering_q5.rds')
# readRDS('./results_data/preciction_results_climate_clustering_q5.rds')

# 11- q95
# saveRDS(prediction_results_cluster, './results_data/preciction_results_climate_clustering_q95.rds')
# readRDS('./results_data/preciction_results_climate_clustering_q95.rds')



# cluster analysis for whole dataset -------------------------------------------
rm(prediction_results_cluster)
selected_data_slope_fdc[, cluster_hc := NULL]
source('./Rscripts/source/5_6_whole_dataset_clustering.R')

sampling_numbers <- 100
data_for_prediction <- copy(selected_data_slope_fdc)


# prediction in each cluster
source('./Rscripts/source/6_2_prediction_cluster.R')

# 1- slope fdc
# saveRDS(prediction_results_cluster, './results_data/preciction_results_whole_data_clustering_slope_fdc.rds')

# 2- stream elas
# saveRDS(prediction_results_cluster, './results_data/preciction_results_whole_data_clustering_stream_elas.rds')

# 3- low q dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_whole_data_clustering_low_q_dur.rds')


# 4- baseflow index
# saveRDS(prediction_results_cluster, './results_data/preciction_results_whole_data_clustering_baseflow_index.rds')
# readRDS('./results_data/preciction_results_whole_data_clustering_baseflow_index.rds')


# 5- q mean
# saveRDS(prediction_results_cluster, './results_data/preciction_results_whole_data_clustering_q_mean.rds')
# readRDS('./results_data/preciction_results_whole_data_clustering_q_mean.rds')


# 6- high q dur
# saveRDS(prediction_results_cluster, './results_data/preciction_results_whole_data_clustering_high_q_dur.rds')
# readRDS('./results_data/preciction_results_whole_data_clustering_high_q_dur.rds')


# 7- high q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_whole_data_clustering_high_q_freq.rds')
# readRDS('./results_data/preciction_results_whole_data_clustering_high_q_freq.rds')



# 8- low q freq
# saveRDS(prediction_results_cluster, './results_data/preciction_results_whole_data_clustering_low_q_freq.rds')
# readRDS('./results_data/preciction_results_whole_data_clustering_low_q_freq.rds')


# 9- runoff ratio
# saveRDS(prediction_results_cluster, './results_data/preciction_results_whole_data_clustering_runoff_ratio.rds')
# readRDS('./results_data/preciction_results_whole_data_clustering_runoff_ratio.rds')


# 10- q5
# saveRDS(prediction_results_cluster, './results_data/preciction_results_whole_data_clustering_q5.rds')
# readRDS('./results_data/preciction_results_whole_data_clustering_q5.rds')


# 11- q95
# saveRDS(prediction_results_cluster, './results_data/preciction_results_whole_data_clustering_q95.rds')
# readRDS('./results_data/preciction_results_whole_data_clustering_q95.rds')






# causal discovery using PC algorithm
# source('./Rscripts/sig_slope_fdc/3_BN_development_slope_fdc.R')

# plot network
# qgraph(pc.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.6,
#        title = "Estimated DAG", asize = 5, edge.color = 'black',
#        label.cex = 2, directed = TRUE)


