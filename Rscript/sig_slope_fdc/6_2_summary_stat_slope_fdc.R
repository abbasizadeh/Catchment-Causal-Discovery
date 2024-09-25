# working directory
setwd("D:/project/Spaptial_variablity_paper/")


# whole dataset ----------------------------------------------------------------
whole_data_stat <- fread('./results_data/summary_stat_whole_clust_slope_fdc.csv')
whole_stat <-
  whole_data_stat[is.na(cluster), ]
whole_stat[, V1 := NULL]
# 
# whole_stat[, cluster := 'no cluster']
class(whole_stat)

whole_stat <-
  whole_stat[, .(mean_whole_data = mean(mean),
                 median_whole_data = mean(median)), by = .(variable)]

# predictors -------------------------------------------------------------------
pred_stat <- fread(paste0('./results_data/summary_stat_predictors_clust_', target_node,'.csv'))
head(pred_stat)

pred_stat[, V1 := NULL]

pred_cluster_stat <- na.omit(pred_stat)

pred_cluster_stat <-
  pred_cluster_stat[, .(weighted_mean = sum(mean * ratio),
                        weighted_median = sum(median * ratio)),
                    by = .(variable)]

pred_cluster_stat <- merge(pred_cluster_stat, whole_stat, by = 'variable')

pred_cluster_stat_r_squared <- pred_cluster_stat[grepl(pattern = 'r-squared', x = variable) , ]
pred_cluster_stat_RMSE <- pred_cluster_stat[grepl(pattern = 'RMSE', x = variable) , ]

pred_results <- rbind(pred_cluster_stat_r_squared, pred_cluster_stat_RMSE)
# clim_results[, cluster := "climate"]

# summary_stat_climate_overal_results.csv
write.csv(pred_results, file = paste0('./results_data/weighted_predictors_clust_overal_results_', target_node, '.csv'))




# climate ----------------------------------------------------------------------
clim_stat <- fread('./results_data/summary_stat_climate_clust_slope_fdc.csv')
head(clim_stat)

clim_stat[, V1 := NULL]

clim_cluster_stat <- na.omit(clim_stat)

clim_cluster_stat <-
  clim_cluster_stat[, .(weighted_mean = sum(mean * ratio),
                        weighted_median = sum(median * ratio)),
                    by = .(variable)]

clim_cluster_stat <- merge(clim_cluster_stat, whole_stat, by = 'variable')

clim_cluster_stat_r_squared <- clim_cluster_stat[grepl(pattern = 'r-squared', x = variable) , ]
clim_cluster_stat_RMSE <- clim_cluster_stat[grepl(pattern = 'RMSE', x = variable) , ]

clim_results <- rbind(clim_cluster_stat_r_squared, clim_cluster_stat_RMSE)
# clim_results[, cluster := "climate"]

# summary_stat_climate_overal_results.csv
write.csv(clim_results, file = './results_data/weighted_climate_clust_overal_results_slope_fdc.csv')

# geology ----------------------------------------------------------------------
geol_stat <- fread('./results_data/summary_stat_geology_clust_slope_fdc.csv')

geol_stat[, V1 := NULL]

geol_cluster_stat <- na.omit(geol_stat)

geol_cluster_stat <-
  geol_cluster_stat[, .(weighted_mean = sum(mean * ratio),
                        weighted_median = sum(median * ratio)),
                    by = .(variable)]

geol_cluster_stat <- merge(geol_cluster_stat, whole_stat, by = 'variable')

geol_cluster_stat_r_squared <- geol_cluster_stat[grepl(pattern = 'r-squared', x = variable) , ]
geol_cluster_stat_RMSE <- geol_cluster_stat[grepl(pattern = 'RMSE', x = variable) , ]

geol_results <- rbind(geol_cluster_stat_r_squared, geol_cluster_stat_RMSE)


# summary_stat_climate_overal_results.csv
write.csv(geol_results, file = './results_data/weighted_geol_clust_overal_results_slope_fdc.csv')


# soil ----------------------------------------------------------------------
soil_stat <- fread('./results_data/summary_stat_soil_clust_slope_fdc.csv')
head(soil_stat)

soil_stat[, V1 := NULL]

soil_cluster_stat <- na.omit(soil_stat)

soil_cluster_stat <-
  soil_cluster_stat[, .(weighted_mean = sum(mean * ratio),
                        weighted_median = sum(median * ratio)),
                    by = .(variable)]

soil_cluster_stat <- merge(soil_cluster_stat, whole_stat, by = 'variable')

soil_cluster_stat_r_squared <- soil_cluster_stat[grepl(pattern = 'r-squared', x = variable) , ]
soil_cluster_stat_RMSE <- soil_cluster_stat[grepl(pattern = 'RMSE', x = variable) , ]

soil_results <- rbind(soil_cluster_stat_r_squared, soil_cluster_stat_RMSE)

write.csv(soil_results, file = './results_data/weighted_soil_clust_overal_results_slope_fdc.csv')


# topo -------------------------------------------------------------------------
topo_stat <- fread('./results_data/summary_stat_topo_clust_slope_fdc.csv')

head(topo_stat)

topo_stat[, V1 := NULL]

topo_cluster_stat <- na.omit(clim_stat)

topo_cluster_stat <-
  topo_cluster_stat[, .(weighted_mean = sum(mean * ratio),
                        weighted_median = sum(median * ratio)),
                    by = .(variable)]

topo_cluster_stat <- merge(topo_cluster_stat, whole_stat, by = 'variable')

topo_cluster_stat_r_squared <- topo_cluster_stat[grepl(pattern = 'r-squared', x = variable) , ]
topo_cluster_stat_RMSE <- topo_cluster_stat[grepl(pattern = 'RMSE', x = variable) , ]

topo_results <- rbind(topo_cluster_stat_r_squared, topo_cluster_stat_RMSE)
# clim_results[, cluster := "climate"]

# summary_stat_climate_overal_results.csv
write.csv(topo_results, file = './results_data/weighted_topo_clust_overal_results_slope_fdc.csv')



# vege -------------------------------------------------------------------------
vege_stat <- fread('./results_data/summary_stat_vege_clust_slope_fdc.csv')

head(vege_stat)

vege_stat[, V1 := NULL]

vege_cluster_stat <- na.omit(vege_stat)

vege_cluster_stat <-
  vege_cluster_stat[, .(weighted_mean = sum(mean * ratio),
                        weighted_median = sum(median * ratio)),
                    by = .(variable)]

vege_cluster_stat <- merge(vege_cluster_stat, whole_stat, by = 'variable')

vege_cluster_stat_r_squared <- vege_cluster_stat[grepl(pattern = 'r-squared', x = variable) , ]
vege_cluster_stat_RMSE <- vege_cluster_stat[grepl(pattern = 'RMSE', x = variable) , ]

vege_results <- rbind(vege_cluster_stat_r_squared, vege_cluster_stat_RMSE)
# clim_results[, cluster := "climate"]

# summary_stat_climate_overal_results.csv
write.csv(vege_results, file = './results_data/weighted_vege_clust_overal_results_slope_fdc.csv')



# whole ------------------------------------------------------------------------
whole_data_stat <- fread('./results_data/summary_stat_whole_clust_slope_fdc.csv')

head(whole_data_stat)

whole_data_stat[, V1 := NULL]

whole_data_cluster_stat <- na.omit(whole_data_stat)

whole_data_cluster_stat <-
  whole_data_cluster_stat[, .(weighted_mean = sum(mean * ratio),
                        weighted_median = sum(median * ratio)),
                    by = .(variable)]

whole_data_cluster_stat <- merge(whole_data_cluster_stat, whole_stat, by = 'variable')

whole_data_cluster_stat_r_squared <- whole_data_cluster_stat[grepl(pattern = 'r-squared', x = variable) , ]
whole_data_cluster_stat_RMSE <- whole_data_cluster_stat[grepl(pattern = 'RMSE', x = variable) , ]

whole_data_results <- rbind(whole_data_cluster_stat_r_squared, whole_data_cluster_stat_RMSE)
# clim_results[, cluster := "climate"]

# summary_stat_climate_overal_results.csv
write.csv(whole_data_results, file = './results_data/weighted_whole_clust_overal_results_slope_fdc.csv')
