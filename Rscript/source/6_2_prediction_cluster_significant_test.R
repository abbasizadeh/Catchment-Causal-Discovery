setwd("~/Catchment-Causal-Discovery/")

# # baseflow index
# source('./Rscripts/sig_baseflow_index/1_2_feature_selection_baseflow_index.R')
# target_node <- 'baseflow_index'
# parents_nodes <- c("frac_snow", "sand_frac", "clay_frac", "geol_porosity", "frac_forest")

# # high_q_dur
# source('./Rscripts/sig_high_q_dur/1_2_feature_selection_high_q_dur.R')
# target_node <- 'high_q_dur'
# parents_nodes <- c("lai_max", "silt_frac", "p_mean")

# # high_q_freq
# source('./Rscripts/sig_high_q_freq/1_2_feature_selection_high_q_freq.R')
# target_node <- 'high_q_freq'
# parents_nodes <- c("frac_forest", "low_prec_freq")

# # low_q_dur
# source('./Rscripts/sig_low_q_dur/1_2_feature_selection_low_q_dur.R')
# target_node <- 'low_q_dur'
# parents_nodes <- c('lai_diff',  'low_prec_dur', 'max_water_content')

# # low_q_dur
# source('./Rscripts/sig_low_q_freq/1_2_feature_selection_low_q_freq.R')
# target_node <- 'low_q_freq'
# parents_nodes <- c('frac_snow',  'geol_porosity', 'frac_forest', 'low_prec_dur', 'low_prec_freq')

# q_mean
# source('./Rscripts/sig_q_mean/1_2_feature_selection_q_mean.R')
# target_node <- 'q_mean'
# parents_nodes <-
#   c('area_gages2',  'p_seasonality', 'frac_forest', 'geol_porosity', 'p_mean', 'low_prec_freq')


# q5
# source('./Rscripts/sig_q5/1_2_feature_selection_q5.R')
# target_node <- 'q5'
# parents_nodes <-
#   c('slope_mean', 'p_mean', 'low_prec_freq')

# q95
# source('./Rscripts/sig_q95/1_2_feature_selection_q95.R')
# target_node <- 'q95'
# parents_nodes <-
#      c('p_seasonality',  'slope_mean',  'frac_forest', 'p_mean', 'low_prec_freq')


# runoff_ratio
# source('./Rscripts/sig_runoff_ratio/1_2_feature_selection_runoff_ratio.R')
# target_node <- 'runoff_ratio'
# parents_nodes <-
#      c('p_seasonality',  'frac_forest', 'p_mean', 'geol_porosity')


# slope_fdc
# source('./Rscripts/sig_slope_fdc/1_2_feature_selection_slope_fdc.R')
# target_node <- 'slope_fdc'
# parents_nodes <-
#      c('p_mean', 'low_prec_freq','lai_max',  'pet_mean')


# stream_elas
source('./Rscripts/sig_stream_elast/1_2_feature_selection_stream_elast.R')
target_node <- 'stream_elas'
parents_nodes <-
     c('low_prec_freq','frac_forest',  'clay_frac')


# # clusters ===================================================================
# source('./Rscripts/source/5_1_geol_clustering.R')
# cluster_name <- 'geol'

# source('./Rscripts/source/5_2_soil_clustering.R')
# cluster_name <- 'soil'

# source('./Rscripts/source/5_4_vege_clustering.R')
# cluster_name <- 'vege'

# source('./Rscripts/source/5_3_topo_clustering.R')
# cluster_name <- 'topo'

source('./Rscripts/source/5_5_climate_clustering.R')
cluster_name <- 'climate'
# ------------------------------------------------------------------------------


data_for_prediction <- copy(selected_data_slope_fdc)
# data processing 
data_cluster_all <- na.omit(data_for_prediction)

sampling_numbers <- 100
# parents_nodes <- parents(x = pc.fit, node = target_node)

# normal_test(data_cluster_all[,-c('gauge_id', 'cluster_hc')])
row_number <- length(unique(data_for_prediction$cluster_hc)) * sampling_numbers

# p_value_F_test <- as.data.table(matrix(data = NA_real_, nrow = row_number, ncol = 3))
p_value_F_test <- as.data.table(matrix(data = NA_real_, nrow = row_number, ncol = 2))
# names(p_value_F_test) <- c('GAM', 'RF', 'cluster')
names(p_value_F_test) <- c('GAM_test', 'cluster')

# convert the columns to numeric
cols_to_convert <- names(p_value_F_test)
p_value_F_test[, (cols_to_convert) := lapply(.SD, as.numeric), 
                   .SDcols = cols_to_convert]



# causal discovery algorithm
# ------------------------------------------------------------------------------

 for(clust_num in unique(data_for_prediction$cluster_hc)) {
   print(paste0("cluster number: ", clust_num, '-------------------'))
   
   clust_num <- as.numeric(clust_num)
    # clust_num <- 7
   
   
   data_cluster <- data_cluster_all[
       cluster_hc == clust_num, ][, c('gauge_id', 'cluster_hc') := NULL]
  
   
   
   for(i in 1:sampling_numbers){
     
     # save cluster number
     p_value_F_test[(clust_num - 1) * sampling_numbers + i, cluster := clust_num]
     
     # split data into train and test test sets
     split = sample.split(data_cluster[, get(x = target_node)], SplitRatio = 0.75)
     train_set = subset(data_cluster, split == TRUE)
     test_set = subset(data_cluster, split == FALSE)
   
     
     # GAM ---------------------------------------------------------------------
     # train GAM model, predictors are the parents of the target variables
     gam_par_formula <-
       as.formula(paste0(
         paste0(target_node, "~"),
         paste0('s(', parents_nodes, ')', collapse = "+")
       ))
      
     gam_par <- gam(
        gam_par_formula, 
        data = train_set,
        method="REML"
      )
    
     pred_gam_parent_val <- predict(gam_par, newdata = test_set)
     
    # GAM prediction (all variables)-----------------------------------------
    # formula
    p <- ncol(train_set) 
    var_names <- names(train_set)[1: p - 1]
      
    gam_formula <-
      as.formula(paste0(
        paste0(target_node, "~"),
        paste0('s(', var_names, ')', collapse = "+")))
      
    gam_all <- gam(gam_formula, 
                   data = train_set, 
                   method = "REML")
    
    pred_gam_all_val <- predict(gam_all, newdata = test_set)
     
      
      
     # nested F-test --------------------------------------------------------
    # Extract RSS and degrees of freedom
    
    # sum of squared error for par model
    RSS1 <- sum(( test_set[, get(target_node)] - pred_gam_parent_val )^2)
    # sum(residuals(gam_par)^2)
      
    # Residual degrees of freedom for GAM Par model
    # residual degrees of freedom = degree of freedom - number of observation
    df1 <- abs(sum(gam_par$edf) - length(test_set[, get(target_node)]))
    # df1
    # gam_par$df.residual
    
    #  check the degree of freedom; 
    # sum(influence(gam_par)) == sum(gam_par$edf)
      
    # sum of squared error for all model 
    RSS2 <- sum(( test_set[, get(target_node)] - pred_gam_all_val )^2)
    # sum(residuals(gam_all)^2)
    
    # Residual degrees of freedom for GAM All model 
    # residual degrees of freedom = degree of freedom - number of observation
    df2 <- abs(sum(gam_all$edf) - length(test_set[, get(target_node)]) )
    # df2 <- gam_all$df.residual
      
      
    # Calculate F-statistic; F value is the ratio of two variances
    F_stat <- ((RSS1 - RSS2)/abs(df1 - df2)) / (RSS2 / (df2))
      
    # anova(gam_par, gam_all)
    
    # Calculate p-value
    p_value <- pf(F_stat, abs(df1 - df2), df2, lower.tail = FALSE)
    # p_value
      
    p_value_F_test[(clust_num - 1) * sampling_numbers + i, GAM_test := p_value]
    
    # anova(gam_par,gam_all, test = 'F')  
    # 
    # pf(11.004, abs(40.046 - 16.842), 16.842, lower.tail = FALSE)
      
    # # Random Forest (parents) ------------------------------------------------
    # 
    # # prediction with rf (using parents of the target variables)
    # rf_par_formula <-
    #   as.formula(paste0(paste0(target_node, "~"), paste0(parents_nodes, 
    #                                                      collapse = "+")))
    # # train RF
    # RF_par <- randomForest(
    #   rf_par_formula,
    #   data = train_set,
    #   ntree = 500,
    #   # keep.forest = FALSE,
    #   # importance = TRUE
    # )
    # 
    # 
    # # Random Forest (All variables) ------------------------------------------
    # # train RF
    # RF_all <- randomForest(
    #   as.formula(paste0(paste0(target_node, '~'), paste0('.'), collapse = ',')), 
    #   data = na.omit(train_set), 
    #   ntree = 500 
    #   # keep.forest = FALSE 
    #   # importance = TRUE
    #   # )
  
   print(i)
  
   }
   }


p_value_F_test
target_node
cluster_name

write.csv(
  x = p_value_F_test,
  file = paste0(
    './results_data/significance_test/',
    target_node,
    '/GAM_test_sig_',
    cluster_name,
    '_',
    target_node,
    '.csv'
  )
)





# # Simulate data
# set.seed(123)
# n <- 200
# x1 <- runif(n, 0, 10)
# x2 <- runif(n, 0, 10)
# x3 <- runif(n, 0, 10)
# y <- 3 + sin(x1) + cos(x2) + 0.5 * x3 + rnorm(n, 0, 0.5)
# 
# data <- data.frame(x1, x2, x3, y)
# 
# # Fit nested GAM models
# # Model 1: Simpler model (nested within Model 2)
# model1 <- gam(y ~ s(x1) + s(x2), data = data)
# 
# # Model 2: More complex model
# model2 <- gam(y ~ s(x1) + s(x2) + s(x3), data = data)
# 
# # Manually calculate the F-statistic
# # Extract residual sum of squares (RSS) for both models
# RSS1 <- sum(residuals(model1)^2) # RSS for simpler model
# RSS2 <- sum(residuals(model2)^2) # RSS for more complex model
# 
# 
# # Adjust degrees of freedom for manual F-test
# df1 <- model1$df.residual  # Residual degrees of freedom for simpler model
# df2 <- model2$df.residual  # Residual degrees of freedom for more complex model
# 
# # Calculate F-statistic using effective degrees of freedom
# numerator <- (RSS1 - RSS2) / abs(df1 - df2) # Adjusted numerator using EDF
# denominator <- RSS2 / df2                 # Adjusted denominator
# F_stat_adjusted <- numerator / denominator
# 
# # Calculate p-value
# p_value_adjusted <- pf(F_stat_adjusted, abs(df1 - df2), df2, lower.tail = FALSE)
# 
# # Display results
# cat("F-statistic:", F_stat_adjusted, "\n")
# cat("P-value:", p_value_adjusted, "\n")
# 
# # Optional: Compare with anova()
# anova(model1, model2, test = "F")
# anova_result



# Anova F-test source code
# https://github.com/SurajGupta/r-source/blob/master/src/library/stats/R/anova.R
# dfs <- table[, "Df"]
# Fvalue <- (table[, dev.col]/dfs)/scale
# Fvalue[dfs %in% 0] <- NA
# Fvalue[!is.na(Fvalue) & Fvalue < 0] <- NA # rather than p = 0
# cbind(table,
#       F = Fvalue,
#       "Pr(>F)" = pf(Fvalue, abs(dfs), df.scale, lower.tail = FALSE))



rm(
  data_cluster_all,
  bn_fit,
  data_cluster,
  model_BN_cal,
  model_BN_val,
  model_gam,
  model_rf,
  rf.fit,
  gam.fit,
  p,
  var_names,
  clust_num,
  pred_BN_cal,
  pred_BN_val,
  pred_gam_parent_cal,
  pred_gam_parent_val,
  pred_gam_all_cal,
  pred_gam_all_val,
  pred_rf_parents_cal,
  pred_rf_parents_val,
  pred_rf_all_cal,
  pred_rf_all_val,
  rf_all_cal,
  rf_all_val,
  rf_parents_cal,
  rf_parents_val,
  gam_all_cal,
  gam_all_val,
  row_number,
  split,
  i,
  gam_formula, 
  gam_parent_cal,
  gam_parent_val,
  cols_to_convert,
  BN_prediction_cal,
  BN_prediction_val,
  test_set,
  train_set,
  data_transformed_test_BN,
  data_transformed_scaled_test_BN,
  data_transformed_train_BN,
  data_transformed_scaled_train_BN,
  sampling_numbers,
  train_set_scaled,
  test_set_scaled,
  gam_par_formula,
  parents_nodes,
  rf_par_formula
  )



# Normal F-test (without degree of freedom)-------------------------------------
# rss_small <- sum(( test_set[, .SD, .SDcols = ncol(test_set)] - pred_gam_parent_val )^2)
# 
# rss_large <- sum(( test_set[, .SD, .SDcols = ncol(test_set)] - pred_gam_all_val)^2 )
# 
# # Number of predictors
# p_small <- length(parents_nodes) # Exclude the intercept
# p_large <- length(test_set) - 1
# 
# # Number of observations
# n <- nrow(test_set)
# 
# # Calculate F-statistic
# f_stat <- ((rss_small - rss_large) / (p_large - p_small)) /
#   (rss_large / (n - p_large - 1))
# 
# # Calculate p-value
# df1 <- p_large - p_small
# df2 <- n - p_large - 1
# p_value <- pf(f_stat, df1, df2, lower.tail = FALSE)
# # p_value_f_test$GAM_test[i] <- p_value