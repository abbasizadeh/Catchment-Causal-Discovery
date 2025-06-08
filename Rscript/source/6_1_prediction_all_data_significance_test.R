# BN prediction: all data 
setwd("~/Catchment-Causal-Discovery/")

# source('./Rscripts/sig_baseflow_index/1_2_feature_selection_baseflow_index.R')
# target_node <- 'baseflow_index'
# parents_nodes <- c("frac_snow", "sand_frac", "clay_frac", "geol_porosity", "frac_forest")


# source('./Rscripts/sig_high_q_dur/1_2_feature_selection_high_q_dur.R')
# target_node <- 'high_q_dur'
# parents_nodes <- c("lai_max", "silt_frac", "p_mean")


# source('./Rscripts/sig_high_q_freq/1_2_feature_selection_high_q_freq.R')
# target_node <- 'high_q_freq'
# parents_nodes <- c("frac_forest", "low_prec_freq")


# source('./Rscripts/sig_low_q_dur/1_2_feature_selection_low_q_dur.R')
# target_node <- 'low_q_dur'
# parents_nodes <- c('lai_diff',  'low_prec_dur', 'max_water_content')


# source('./Rscripts/sig_low_q_freq/1_2_feature_selection_low_q_freq.R')
# target_node <- 'low_q_freq'
# parents_nodes <- c('frac_snow',  'geol_porosity', 'frac_forest', 'low_prec_dur', 'low_prec_freq')


# source('./Rscripts/sig_q_mean/1_2_feature_selection_q_mean.R')
# target_node <- 'q_mean'
# parents_nodes <-
#   c('area_gages2',  'p_seasonality', 'frac_forest', 'geol_porosity', 'p_mean', 'low_prec_freq')


# source('./Rscripts/sig_q5/1_2_feature_selection_q5.R')
# target_node <- 'q5'
# parents_nodes <- c('slope_mean', 'p_mean', 'low_prec_freq')


# source('./Rscripts/sig_q95/1_2_feature_selection_q95.R')
# target_node <- 'q95'
# parents_nodes <-
#      c('p_seasonality',  'slope_mean',  'frac_forest', 'p_mean', 'low_prec_freq')


# source('./Rscripts/sig_runoff_ratio/1_2_feature_selection_runoff_ratio.R')
# target_node <- 'runoff_ratio'
# parents_nodes <-
#      c('p_seasonality',  'frac_forest', 'p_mean', 'geol_porosity')


# source('./Rscripts/sig_slope_fdc/1_2_feature_selection_slope_fdc.R')
# target_node <- 'slope_fdc'
# parents_nodes <-
#      c('p_mean', 'low_prec_freq','lai_max',  'pet_mean')


source('./Rscripts/sig_stream_elast/1_2_feature_selection_stream_elast.R')
target_node <- 'stream_elas'
parents_nodes <- c('low_prec_freq','frac_forest',  'clay_frac')


data_for_prediction <- copy(selected_data_slope_fdc)

data_all <- data_for_prediction[ ,-c('gauge_id')]
data_all <- na.omit(data_all)


# parents_nodes <- parents(x = pc.fit, node = target_node)

sampling_numbers <- 100
row_number <- sampling_numbers

# p_value_f_test <- as.data.table(matrix(nrow = row_number, ncol = 2))
# names(p_value_f_test) <-
#   c('GAM', 'RF')
p_value_f_test <- as.data.table(matrix(nrow = row_number, ncol = 1))
names(p_value_f_test) <- c('GAM_test')



# ------------------------------------------------------------------------------
for(i in 1:sampling_numbers) {
  
    
    # split data into train and test test sets
    split = sample.split(data_all[, get(x = target_node)], SplitRatio = 0.75)
    train_set = subset(data_all, split == TRUE)
    test_set = subset(data_all, split == FALSE)
    
    
    # GAM ----------------------------------------------------------------------
    # train GAM model, predictors are the parents of the target variables
    gam_par_formula <-
      as.formula(paste0(
        paste0(target_node, "~"),
        paste0('s(', parents_nodes, ')', collapse = "+")
      ))

    gam_par <- gam(
      formula = gam_par_formula,
      data = train_set,
      method="REML"
    )

    
    pred_gam_parent_val <- predict(gam_par, newdata = test_set)
    
    # GAM prediction (all variables)-------------------------------------------
    # formula
    p <- ncol(train_set)
    var_names <- names(train_set)[1:p-1]
    gam_formula <- as.formula(paste0(paste0(target_node,"~"), paste0('s(',var_names, ')', collapse="+")))

    gam_all <- gam(
      formula = gam_formula,
      data = train_set)

    # # Check using anova() function
    # anova_result <- anova(gam_par, gam_all, test = 'F')
    # p_value_f_test$GAM[i] <- anova_result$`Pr(>F)`[2]
    
    pred_gam_all_val <- predict(gam_all, newdata = test_set)
    
    # nested F-test ------------------------------------------------------------
    # Calculate Residual Sum of Squares (RSS)
    # rss_small <- sum(( test_set[, .SD, .SDcols = ncol(train_set)] - pred_gam_parent_val )^2)
    # 
    # rss_large <- sum((test_set[, .SD, .SDcols = ncol(train_set)] - pred_gam_all_val)^2 )
    # 
    # # Number of predictors
    # p_small <- length(parents_nodes) # Exclude the intercept
    # p_large <- length(train_set) - 1
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
    
    p_value_f_test$GAM_test[i] <- p_value
    
    # -------------------------------------------------------------------------- 
    print(i)
    
    }
  
p_value_f_test
target_node

write.csv(x = p_value_f_test, 
        file = paste0('./results_data/significance_test/', target_node,
                      '/GAM_test_sig_basline_', target_node, '.csv'))



rm(
  data_all,
  bn_fit,
  model_BN_cal,
  model_BN_val,
  model_gam,
  model_rf,
  rf.fit,
  gam.fit,
  p,
  var_names,
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
  data_scaled_transformed_test_BN,
  data_transform_train_BN,
  data_scaled_transformed_train_BN,
  sampling_numbers,
  train_set_scaled,
  test_set_scaled,
  gam_par_formula,
  rf_par_formula,
  parents_nodes
)

# compare manual and R-base Anova
anova(gam_par, gam_all, test = 'F')

RSS1 <- sum(residuals(gam_par)^2)
# Residual degrees of freedom for GAM Par model
df1 <- gam_par$df.residual
# sum of squared error for all model 
RSS2 <- sum(residuals(gam_all)^2)
# Residual degrees of freedom for GAM All model 
df2 <-  gam_all$df.residual
# Calculate F-statistic; F value is the ratio of two variances
F_stat <- ((RSS1 - RSS2)/abs(df1 - df2)) / (RSS2 / (df2))
F_stat
# Calculate p-value
p_value <- pf(F_stat, abs(df1 - df2), df2, lower.tail = FALSE)
p_value

# # Random Forest (parents) -------------------------------------------------
# # prediction with rf (using parents of the target node)
# rf_par_formula <-
#   as.formula(paste0(paste0(target_node, "~"), paste0(parents_nodes, 
#                                                      collapse = "+")))
# 
# RF_par <- randomForest(rf_par_formula,
#                          data = na.omit(train_set),
#                          ntree = 500)
# 
# 
# # Random Forest (All variables) --------------------------------------------
# RF_all <- randomForest(
#   as.formula(paste0(paste0(target_node, '~'), paste0('.'), collapse = ',')), 
#   data = na.omit(train_set), 
#   ntree = 500)
# 
# resid_par <- train_set[, get(x = target_node)] - RF_par$predicted
# 
# resid_all <- train_set[, get(x = target_node)] - RF_all$predicted 
# 
# wilcox_test_result <- wilcox.test(resid_par, resid_all, paired = TRUE)
# p_value_f_test$RF[i] <- wilcox_test_result$p.value
# 
# # Paired t-test
# residual_diff <- resid_par - resid_all
# t_test_result <- t.test(residual_diff)


# # one-way ANOVA
# model_labels <- rep(c("Model1", "Model2"), each = length(resid_par))
# residuals_combined <- c(resid_par, resid_all)
# anova_data <- data.frame(Residuals = residuals_combined, Model = model_labels)
# 
# # Perform one-way ANOVA
# anova_result <- aov(Residuals ~ Model, data = anova_data)
# summary(anova_result)
