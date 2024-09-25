
# data_for_summary_stat <- prediction_results_cluster_climate
# data_for_summary_stat <- prediction_results_cluster_geol
# data_for_summary_stat <- prediction_results_cluster_soil
# data_for_summary_stat <- prediction_results_cluster_topo
# data_for_summary_stat <- prediction_results_cluster_vege
# data_for_summary_stat <- prediction_results_whole_cluster
data_for_summary_stat <- prediction_results_predictors

target_node <- 'q_mean'
  
unique(data_for_summary_stat$cluster)
names(data_for_summary_stat)


names(data_for_summary_stat) <- c(
  'cluster',
  "BN-trn r-squared",
  "GAM~Par-trn r-squared",
  "GAM~All-trn r-squared",
  "RF~Par-trn r-squared",
  "RF~All-trn r-squared",
  
  "BN-tst r-squared",
  "GAM~Par-tst r-squared",
  "GAM~All-tst r-squared",
  "RF~Par-tst r-squared",
  "RF~All-tst r-squared",
  
  "BN-trn RMSE",
  "GAM~Par-trn RMSE",
  "GAM~All-trn RMSE",
  "RF~Par-trn RMSE",
  "RF~All-trn RMSE",
  
  "BN-tst RMSE",
  "GAM~Par-tst RMSE",
  "GAM~All-tst RMSE",
  "RF~Par-tst RMSE",
  "RF~All-tst RMSE",
  
  "cluster_label",
  'n',
  'ratio'
)

data_for_summary_stat[cluster == 0, cluster := NA]

summary_1 <- melt(data_for_summary_stat, id.vars = c('cluster', "cluster_label", 'n', 'ratio'))
sum_res <- summary_1[, .(
  mean = mean(value, na.rm = TRUE),
  median = median(value, na.rm = TRUE),
  sd = sd(value, na.rm = TRUE),
  min = min(value, na.rm = TRUE),
  max = max(value, na.rm = TRUE),
  iqr = IQR(value, na.rm = TRUE)
),
by = .(variable, cluster, n, ratio)]

sum_res



# write.csv(sum_res, file = paste0('./results_data/summary_stat_climate_clust_', target_node,'.csv'))
# write.csv(sum_res, file = paste0('./results_data/summary_stat_geology_clust_', target_node,'.csv'))
# write.csv(sum_res, file = paste0('./results_data/summary_stat_soil_clust_', target_node,'.csv'))
# write.csv(sum_res, file = paste0('./results_data/summary_stat_topo_clust_', target_node,'.csv'))
# write.csv(sum_res, file = paste0('./results_data/summary_stat_vege_clust_', target_node,'.csv'))
# write.csv(sum_res, file = paste0('./results_data/summary_stat_whole_clust_', target_node,'.csv'))
write.csv(sum_res, file = paste0('./results_data/summary_stat_predictors_clust_', target_node,'.csv'))



# summary_2 <- summary_1[cluster != 'whole_dataset; numbers: 671 catchments' ,]
# sum_res <- summary_2[, .(
#   mean = mean(value, na.rm = TRUE),
#   median = median(value, na.rm = TRUE),
#   sd = sd(value, na.rm = TRUE),
#   min = min(value, na.rm = TRUE),
#   max = max(value, na.rm = TRUE),
#   iqr = IQR(value, na.rm = TRUE)
# ),
# by = .(variable)]

