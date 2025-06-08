# ##############################################################################
#                                                                              #
#                summary statistics of the prediction results                  #
#                                    runoff_ratio                                    #
# ##############################################################################



target_node <- 'runoff_ratio'

# function for summary stat calculation
fun_summary_stat <- function(dt){
  
  names(dt) <- 
    c(
      'cluster',
      "BN-trn r-squared","GAM~Par-trn r-squared","GAM~All-trn r-squared","RF~Par-trn r-squared","RF~All-trn r-squared",
      "BN-tst r-squared","GAM~Par-tst r-squared","GAM~All-tst r-squared","RF~Par-tst r-squared","RF~All-tst r-squared",
      "BN-trn RMSE","GAM~Par-trn RMSE","GAM~All-trn RMSE","RF~Par-trn RMSE","RF~All-trn RMSE",
      "BN-tst RMSE","GAM~Par-tst RMSE","GAM~All-tst RMSE","RF~Par-tst RMSE","RF~All-tst RMSE",
      "cluster_label",'n','ratio')
  
  dt[cluster == 0, cluster := NA]
  
  summary_1 <- melt(dt, id.vars = c('cluster', "cluster_label", 'n', 'ratio'))
  sum_res <- summary_1[, .(
    mean = mean(value, na.rm = TRUE),
    median = median(value, na.rm = TRUE),
    sd = sd(value, na.rm = TRUE),
    min = min(value, na.rm = TRUE),
    max = max(value, na.rm = TRUE),
    iqr = IQR(value, na.rm = TRUE)
  ),
  by = .(variable, cluster, n, ratio)]
  
  return(sum_res)
}



# climate
sum_res <- fun_summary_stat(dt = prediction_results_cluster_climate)
write.csv(
  sum_res, 
  file = paste0('./data/output/summary_stat/runoff_ratio/summary_stat_climate_clust_', target_node,'.csv'))

# geology
sum_res <- fun_summary_stat(dt = prediction_results_cluster_geol)
write.csv(
  sum_res, 
  file = paste0('./data/output/summary_stat/runoff_ratio/summary_stat_geol_clust_', target_node,'.csv'))

# soil
sum_res <- fun_summary_stat(dt = prediction_results_cluster_soil)
write.csv(
  sum_res, 
  file = paste0('./data/output/summary_stat/runoff_ratio/summary_stat_soil_clust_', target_node,'.csv'))

# topo
sum_res <- fun_summary_stat(dt = prediction_results_cluster_topo)
write.csv(
  sum_res, 
  file = paste0('./data/output/summary_stat/runoff_ratio/summary_stat_topo_clust_', target_node,'.csv'))


# vege
sum_res <- fun_summary_stat(dt = prediction_results_cluster_vege)
write.csv(
  sum_res, 
  file = paste0('./data/output/summary_stat/runoff_ratio/summary_stat_vege_clust_', target_node,'.csv'))


# whole data
sum_res <- fun_summary_stat(dt = prediction_results_cluster_vege[is.na(cluster),])
write.csv(
  sum_res, 
  file = paste0('./data/output/summary_stat/runoff_ratio/summary_stat_whole_clust_', target_node,'.csv'))



