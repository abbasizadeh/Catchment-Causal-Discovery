################################################################################
#                                                                              #
#              Permutation test for causal and non-causal models               #
#                          The test is done for:                               #
#                    GAM, RF, and in Cal and Val modes                         #
# ##############################################################################

setwd("~/Catchment-Causal-Discovery/")

# get the data
source('./source/1_load_data_&_packages.R')
# load functions
source('./source/2_functions.r')




                                                                
# climate_R2_bfi <- readRDS(file = './data/output/prediciton_results/prediction_results_climate_clustering_baseflow_index.rds')
# geol_R2_bfi <- readRDS(file = './data/output/prediciton_results/prediction_results_geol_clustering_baseflow_index.rds')
# soil_R2_bfi <- readRDS(file = './data/output/prediciton_results/prediction_results_soil_clustering_baseflow_index.rds')
# topo_R2_bfi <- readRDS(file = './data/output/prediciton_results/prediction_results_topo_clustering_baseflow_index.rds')
# veg_R2_bfi <- readRDS(file = './data/output/prediciton_results/prediction_results_vege_clustering_baseflow_index.rds')
# baseline_R2_bfi <- readRDS(file = './data/output/prediciton_results/prediction_results_whole_data_baseflow_index.rds')


# climate_R2_high_q_dur <- readRDS(file = './data/output/prediciton_results/prediction_results_climate_clustering_high_q_dur.rds')
# geol_R2_high_q_dur <- readRDS(file = './data/output/prediciton_results/prediction_results_geol_clustering_high_q_dur.rds')
# soil_R2_high_q_dur <- readRDS(file = './data/output/prediciton_results/prediction_results_soil_clustering_high_q_dur.rds')
# topo_R2_high_q_dur <- readRDS(file = './data/output/prediciton_results/prediction_results_topo_clustering_high_q_dur.rds')
# veg_R2_high_q_dur <- readRDS(file = './data/output/prediciton_results/prediction_results_vege_clustering_high_q_dur.rds')
# baseline_R2_high_q_dur <- readRDS(file = './data/output/prediciton_results/prediction_results_whole_data_high_q_dur.rds')



# climate_R2_high_q_freq <- readRDS(file = './data/output/prediciton_results/prediction_results_climate_clustering_high_q_freq.rds')
# geol_R2_high_q_freq <- readRDS(file = './data/output/prediciton_results/prediction_results_geol_clustering_high_q_freq.rds')
# soil_R2_high_q_freq <- readRDS(file = './data/output/prediciton_results/prediction_results_soil_clustering_high_q_freq.rds')
# topo_R2_high_q_freq <- readRDS(file = './data/output/prediciton_results/prediction_results_topo_clustering_high_q_freq.rds')
# veg_R2_high_q_freq <- readRDS(file = './data/output/prediciton_results/prediction_results_vege_clustering_high_q_freq.rds')
# baseline_R2_high_q_freq <- readRDS(file = './data/output/prediciton_results/prediction_results_whole_data_high_q_freq.rds')


# climate_R2_low_q_dur <- readRDS(file = './data/output/prediciton_results/prediction_results_climate_clustering_low_q_dur.rds')
# geol_R2_low_q_dur <- readRDS(file = './data/output/prediciton_results/prediction_results_geol_clustering_low_q_dur.rds')
# soil_R2_low_q_dur <- readRDS(file = './data/output/prediciton_results/prediction_results_soil_clustering_low_q_dur.rds')
# topo_R2_low_q_dur <- readRDS(file = './data/output/prediciton_results/prediction_results_topo_clustering_low_q_dur.rds')
# veg_R2_low_q_dur <- readRDS(file = './data/output/prediciton_results/prediction_results_vege_clustering_low_q_dur.rds')
# baseline_R2_low_q_dur <- readRDS(file = './data/output/prediciton_results/prediction_results_whole_data_low_q_dur.rds')



# climate_R2_low_q_freq <- readRDS(file = './data/output/prediciton_results/prediction_results_climate_clustering_low_q_freq.rds')
# geol_R2_low_q_freq <- readRDS(file = './data/output/prediciton_results/prediction_results_geol_clustering_low_q_freq.rds')
# soil_R2_low_q_freq <- readRDS(file = './data/output/prediciton_results/prediction_results_soil_clustering_low_q_freq.rds')
# topo_R2_low_q_freq <- readRDS(file = './data/output/prediciton_results/prediction_results_topo_clustering_low_q_freq.rds')
# veg_R2_low_q_freq <- readRDS(file = './data/output/prediciton_results/prediction_results_vege_clustering_low_q_freq.rds')
# baseline_R2_low_q_freq <- readRDS(file = './data/output/prediciton_results/prediction_results_whole_data_low_q_freq.rds')



# climate_R2_q_mean <- readRDS(file = './data/output/prediciton_results/prediction_results_climate_clustering_q_mean.rds')
# geol_R2_q_mean <- readRDS(file = './data/output/prediciton_results/prediction_results_geol_clustering_q_mean.rds')
# soil_R2_q_mean <- readRDS(file = './data/output/prediciton_results/prediction_results_soil_clustering_q_mean.rds')
# topo_R2_q_mean <- readRDS(file = './data/output/prediciton_results/prediction_results_topo_clustering_q_mean.rds')
# veg_R2_q_mean <- readRDS(file = './data/output/prediciton_results/prediction_results_vege_clustering_q_mean.rds')
# baseline_R2_q_mean <- readRDS(file = './data/output/prediciton_results/prediction_results_whole_data_q_mean.rds')



# climate_R2_q5 <- readRDS(file = './data/output/prediciton_results/prediction_results_climate_clustering_q5.rds')
# geol_R2_q5 <- readRDS(file = './data/output/prediciton_results/prediction_results_geol_clustering_q5.rds')
# soil_R2_q5 <- readRDS(file = './data/output/prediciton_results/prediction_results_soil_clustering_q5.rds')
# topo_R2_q5 <- readRDS(file = './data/output/prediciton_results/prediction_results_topo_clustering_q5.rds')
# veg_R2_q5 <- readRDS(file = './data/output/prediciton_results/prediction_results_vege_clustering_q5.rds')
# baseline_R2_q5 <- readRDS(file = './data/output/prediciton_results/prediction_results_whole_data_q5.rds')



# climate_R2_q95 <- readRDS(file = './data/output/prediciton_results/prediction_results_climate_clustering_q95.rds')
# geol_R2_q95 <- readRDS(file = './data/output/prediciton_results/prediction_results_geol_clustering_q95.rds')
# soil_R2_q95 <- readRDS(file = './data/output/prediciton_results/prediction_results_soil_clustering_q95.rds')
# topo_R2_q95 <- readRDS(file = './data/output/prediciton_results/prediction_results_topo_clustering_q95.rds')
# veg_R2_q95 <- readRDS(file = './data/output/prediciton_results/prediction_results_vege_clustering_q95.rds')
# baseline_R2_q95 <- readRDS(file = './data/output/prediciton_results/prediction_results_whole_data_q95.rds')



# climate_R2_runoff_ratio <- readRDS(file = './data/output/prediciton_results/prediction_results_climate_clustering_runoff_ratio.rds')
# geol_R2_runoff_ratio <- readRDS(file = './data/output/prediciton_results/prediction_results_geol_clustering_runoff_ratio.rds')
# soil_R2_runoff_ratio <- readRDS(file = './data/output/prediciton_results/prediction_results_soil_clustering_runoff_ratio.rds')
# topo_R2_runoff_ratio <- readRDS(file = './data/output/prediciton_results/prediction_results_topo_clustering_runoff_ratio.rds')
# veg_R2_runoff_ratio <- readRDS(file = './data/output/prediciton_results/prediction_results_vege_clustering_runoff_ratio.rds')
# baseline_R2_runoff_ratio <- readRDS(file = './data/output/prediciton_results/prediction_results_whole_data_runoff_ratio.rds')


# climate_R2_slope_fdc <- readRDS(file = './data/output/prediciton_results/prediction_results_climate_clustering_slope_fdc.rds')
# geol_R2_slope_fdc <- readRDS(file = './data/output/prediciton_results/prediction_results_geol_clustering_slope_fdc.rds')
# soil_R2_slope_fdc <- readRDS(file = './data/output/prediciton_results/prediction_results_soil_clustering_slope_fdc.rds')
# topo_R2_slope_fdc <- readRDS(file = './data/output/prediciton_results/prediction_results_topo_clustering_slope_fdc.rds')
# veg_R2_slope_fdc <- readRDS(file = './data/output/prediciton_results/prediction_results_vege_clustering_slope_fdc.rds')
# baseline_R2_slope_fdc <- readRDS(file = './data/output/prediciton_results/prediction_results_whole_data_slope_fdc.rds')



climate_R2_stream_elas <- readRDS(file = './data/output/prediciton_results/prediction_results_climate_clustering_stream_elas.rds')
geol_R2_stream_elas <- readRDS(file = './data/output/prediciton_results/prediction_results_geol_clustering_stream_elas.rds')
soil_R2_stream_elas <- readRDS(file = './data/output/prediciton_results/prediction_results_soil_clustering_stream_elas.rds')
topo_R2_stream_elas <- readRDS(file = './data/output/prediciton_results/prediction_results_topo_clustering_stream_elas.rds')
veg_R2_stream_elas <- readRDS(file = './data/output/prediciton_results/prediction_results_vege_clustering_stream_elas.rds')
baseline_R2_stream_elas <- readRDS(file = './data/output/prediciton_results/prediction_results_whole_data_stream_elas.rds')




# # -----------------------------------------------------------------------------
# # bootstrap test: ================================================================
# 
# # baseline -------------------------------------------------
# # Function to calculate bootstrap confidence intervals for a metric
# bootstrap_diff <- function(metric_full, metric_nested, n_bootstrap) {
# 
#   # number of runs
#   n <- length(metric_full)
# 
#   # bootstrapping metrics with replacement
#   bootstrap_differences <-
#     replicate(n_bootstrap, {
#       sample_indices <- sample(seq_len(n), size = n, replace = TRUE)
#       mean(metric_full[sample_indices]) - mean(metric_nested[sample_indices])
#     })
# 
#   ci <- quantile(bootstrap_differences, probs = c(0.05, 0.95))
# 
#   list(differences = bootstrap_differences, ci = ci)
# 
# }
# 
# 
# dta <- baseline_R2_bfi
# n_bootstrap <- 10000  # Number of bootstrap samples
# bootstrap_r2 <- bootstrap_diff(dta[, `RF~All Val`], dta[,`RF~Par Val`], n_bootstrap)
# bootstrap_rmse <- bootstrap_diff(dta[, `RF~All Val (RMSE)`], dta[,`RF~Par Val (RMSE)`], n_bootstrap)
# 
# bootstrap_r2$ci
# mean(dta[,`RF~All Val`]) - mean(dta[,`RF~Par Val`])
# 
# bootstrap_rmse$ci
# mean(dta[,`RF~All Val (RMSE)`]) - mean(dta[,`RF~Par Val (RMSE)`])
# 
# 
# # clusters -------------------------------------------
# 
# dta_clust <- climate_R2_bfi
# # dta_clust <- geol_R2_bfi
# # dta_clust <- soil_R2_low_q_freq
# # dta_clust <- topo_R2_slope_fdc
# # dta_clust <- veg_R2_slope_fdc
# 
# bootstrap_r2_clust <- vector("list", length = length(dta_clust[, unique(cluster)]))
# bootstrap_rmse_clust <- vector("list", length = length(dta_clust[, unique(cluster)]))
# 
# 
# 
# # hist(bootstrap_r2$differences,
# #      breaks = 50,
# #      main = "Simple Permutation Test",
# #      xlab = "t-statistic",
# #      col = "skyblue",
# #      border = "white")
# # 
# # abline(v = bootstrap_r2$ci[1], col = "red", lwd = 2, lty = 2)
# # abline(v = bootstrap_r2$ci[2], col = "red", lwd = 2, lty = 2)
# 
# 
# for (clus_num in dta_clust[, unique(cluster)]){
# 
#   bootstrap_r2_ <-
#     bootstrap_diff(dta_clust[cluster == clus_num, `RF~All Val`],
#                    dta_clust[cluster == clus_num,`RF~Par Val`],
#                    n_bootstrap)
# 
#   bootstrap_r2_clust[[clus_num]] <- bootstrap_r2_$ci
# 
#   bootstrap_rmse_ <-
#     bootstrap_diff(dta_clust[cluster == clus_num, `RF~All Val (RMSE)`],
#                    dta_clust[cluster == clus_num,`RF~Par Val (RMSE)`],
#                    n_bootstrap)
# 
#   bootstrap_rmse_clust[[clus_num]] <- bootstrap_rmse_$ci
#   
#   }
# 
# 
# dta_clust[, mean(`RF~All Val`)-mean(`RF~Par Val`), by = cluster]
# bootstrap_r2_clust
# 
# bootstrap_rmse_clust



# permutation test =============================================================
dta <- baseline_R2_stream_elas
# RF
# model1 <- dta[, `RF~Par Val`]
# model2 <- dta[, `RF~All Val`]
model1 <- dta[, `RF~Par Cal`]
model2 <- dta[, `RF~All Cal`]

# GAM
# model1 <- dta[, `GAM~Par Val`]
# model2 <- dta[, `GAM~All Val`]
# model1 <- dta[, `GAM~Par Cal`]
# model2 <- dta[, `GAM~All Cal`]

# Observed difference in means
observed_diff <- mean(model1 - model2)

# Combine data into one pool
combined_data <- c(model1, model2)
n <- length(model1)

# Permutation test
n_permutations <- 10000
permuted_diffs <- numeric(n_permutations)

for (i in 1:n_permutations) {
  shuffled <- sample(combined_data, replace = TRUE) # Shuffle the combined data
  group1 <- shuffled[1:n]          # Assign first half to group 1
  group2 <- shuffled[(n+1):(2*n)]  # Assign second half to group 2
  permuted_diffs[i] <- mean(group1 - group2)
}


# Calculate p-value
p_value <- mean(abs(permuted_diffs) >= abs(observed_diff))

p_value
# # Results
# cat("Observed Difference:", observed_diff, "\n")
# cat("P-value:", p_value, "\n")
# 
# # Visualize the permutation distribution
# hist(permuted_diffs, breaks = 50, main = "Permutation Test Distribution",
#      xlab = "Mean Difference", xlim = c(-1*observed_diff, observed_diff))
# abline(v = observed_diff, col = "red", lwd = 2)



# for clusters
# dta_clust <- climate_R2_stream_elas
# dta_clust <- geol_R2_stream_elas
# dta_clust <- soil_R2_stream_elas
# dta_clust <- topo_R2_stream_elas
dta_clust <- veg_R2_stream_elas



bootstrap_r2_clust <- vector("list", length = length(dta_clust[, unique(cluster)]))
bootstrap_rmse_clust <- vector("list", length = length(dta_clust[, unique(cluster)]))

permuted_diffs <- numeric(n_permutations)
permuted_diffs_rmse <- numeric(n_permutations)

for (clus_num in dta_clust[, unique(cluster)]){

  # R squaed -------------------------------------------------------------------
  # RF
  # model1_clust <- dta_clust[cluster == clus_num, `RF~Par Val`]
  # model2_clust <- dta_clust[cluster == clus_num, `RF~All Val`]

  model1_clust <- dta_clust[cluster == clus_num, `RF~Par Cal`]
  model2_clust <- dta_clust[cluster == clus_num, `RF~All Cal`]

  # GAM
  # model1_clust <- dta_clust[cluster == clus_num, `GAM~Par Val`]
  # model2_clust <- dta_clust[cluster == clus_num, `GAM~All Val`]
  
  # model1_clust <- dta_clust[cluster == clus_num, `GAM~Par Cal`]
  # model2_clust <- dta_clust[cluster == clus_num, `GAM~All Cal`]
  # 
  
  # Observed difference in means
  observed_diff_clust <- mean(model1_clust - model2_clust)
  
  # Combine data into one pool
  combined_data <- c(model1_clust, model2_clust)

  n <- length(model1_clust)


  for (i in 1:n_permutations) {
    shuffled <- sample(combined_data, replace = TRUE) # Shuffle the combined data
    group1 <- shuffled[1:n]          # Assign first half to group 1
    group2 <- shuffled[(n + 1):(2 * n)]  # Assign second half to group 2
    permuted_diffs[i] <- mean(group1 - group2)
  }

  
  if(mean(model1_clust) > mean(model2_clust)){
    bootstrap_r2_clust[[clus_num]] <- 1
  }else{
    bootstrap_r2_clust[[clus_num]] <- mean(abs(permuted_diffs) >= abs(observed_diff_clust))
  }



  # RMSE -----------------------------------------------------------------------
  # model1_clust_rmse <- dta_clust[cluster == clus_num, `RF~Par Val (RMSE)`]
  # model2_clust_rmse <- dta_clust[cluster == clus_num, `RF~All Val (RMSE)`]
  
  # model1_clust_rmse <- dta_clust[cluster == clus_num, `GAM~Par Val (RMSE)`]
  # model2_clust_rmse <- dta_clust[cluster == clus_num, `GAM~All Val (RMSE)`]
  
  model1_clust_rmse <- dta_clust[cluster == clus_num, `GAM~Par Cal (RMSE)`]
  model2_clust_rmse <- dta_clust[cluster == clus_num, `GAM~All Cal (RMSE)`]

  # Observed difference in means
  observed_diff_clust_rmse <- mean(model1_clust_rmse - model2_clust_rmse)
  
  # Combine data into one pool
  combined_data_rmse <- c(model1_clust_rmse, model2_clust_rmse)


  for (i in 1:n_permutations) {
    shuffled_rmse <- sample(combined_data_rmse, replace = TRUE) # Shuffle the combined data
    group1_rmse <- shuffled_rmse[1:n]          # Assign first half to group 1
    group2_rmse <- shuffled_rmse[(n+1):(2*n)]  # Assign second half to group 2
    permuted_diffs_rmse[i] <- mean(group1_rmse - group2_rmse)
  }

  
  if (mean(model1_clust_rmse) < mean(model2_clust_rmse)) {
    bootstrap_rmse_clust[[clus_num]] <- 1
  }else{
    bootstrap_rmse_clust[[clus_num]] <- mean(abs(permuted_diffs_rmse) >= abs(observed_diff_clust_rmse))
  }
  
  # bootstrap_rmse_clust[[clus_num]] <- bootstrap_rmse_$ci
}

bootstrap_r2_clust
bootstrap_rmse_clust



