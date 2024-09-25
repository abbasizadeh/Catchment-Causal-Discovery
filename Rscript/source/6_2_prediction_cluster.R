

# data processing 
data_cluster_all <- na.omit(data_for_prediction)

parents_nodes <- parents(x = pc.fit, node = target_node)

# normal_test(data_cluster_all[,-c('gauge_id', 'cluster_hc')])
row_number <- length(unique(data_for_prediction$cluster_hc)) * sampling_numbers

prediction_results_cluster <- as.data.table(matrix(nrow = row_number, ncol = 21))
names(prediction_results_cluster) <-
  c(
    'BN Cal',
    'GAM~Par Cal',
    'GAM~All Cal',
    'RF~Par Cal',
    'RF~All Cal',
    
    'BN Val',
    'GAM~Par Val',
    'GAM~All Val',
    'RF~Par Val',
    'RF~All Val',
    
    'BN Cal (RMSE)',
    'GAM~Par Cal (RMSE)',
    'GAM~All Cal (RMSE)',
    'RF~Par Cal (RMSE)',
    'RF~All Cal (RMSE)',
    
    'BN Val (RMSE)',
    'GAM~Par Val (RMSE)',
    'GAM~All Val (RMSE)',
    'RF~Par Val (RMSE)',
    'RF~All Val (RMSE)',
    
    'cluster'
  )

# convert the columns to numeric
cols_to_convert <- names(prediction_results_cluster)
prediction_results_cluster[, (cols_to_convert) := lapply(.SD, as.numeric), 
                   .SDcols = cols_to_convert]



# causal discovery algorithm
# ------------------------------------------------------------------------------

 for(clust_num in unique(data_for_prediction$cluster_hc)) {
   print("cluster number:")
   print(clust_num)
   print('-------------------')
   
   
   clust_num <- as.numeric(clust_num)
    # clust_num <- 7
   
   
   data_cluster <- data_cluster_all[
       cluster_hc == clust_num, ][, c('gauge_id', 'cluster_hc') := NULL]
  
   
   
   for(i in 1:sampling_numbers){
     
     # save cluster number
     prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, cluster := clust_num]
     
     # split data into train and test test sets
     split = sample.split(data_cluster[, get(x = target_node)], SplitRatio = 0.75)
     train_set = subset(data_cluster, split == TRUE)
     test_set = subset(data_cluster, split == FALSE)
   
     
     # Bayesian Network --------------------------------------------------------
   
     data_transformed_train_BN <- train_set # transform_boxcox(train_set) 
     data_transformed_scaled_train_BN <-
       as.data.table(lapply(data_transformed_train_BN[,-ncol(data_transformed_train_BN), with = FALSE], scale))
   
     data_transformed_scaled_train_BN <- cbind(data_transformed_scaled_train_BN, 
                                             data_transformed_train_BN[, get(x = target_node)])
     setnames(x = data_transformed_scaled_train_BN, old = 'V2', new = paste0(target_node))
   
     
     # train BN
     bn_fit <- bn.fit(pc.fit, data = data_transformed_scaled_train_BN)
     
     # calibration
     # prediction with BN using train data set
     # prediction using averaging likelihood weighting simulations
     pred_BN_cal <- predict(bn_fit, 
                            node = paste0(target_node), 
                            data = data_transformed_scaled_train_BN,
                            method = "bayes-lw")
     
     # check the performance of BN using train data set
     # fit linear model to calculate R squared
     
     model_BN_cal <- lm(pred_BN_cal ~ data_transformed_train_BN[, get(x = target_node)])
     BN_prediction_cal <- summary(model_BN_cal)$r.squared    
     
     # save BN results using train data set
     # r squared
     prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, 
                                `BN Cal` := BN_prediction_cal]
     # RMSE
     prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, 
                                `BN Cal (RMSE)` := 
                                  RMSE(pred = pred_BN_cal, 
                                       obs = data_transformed_train_BN[, get(x = target_node)], 
                                       na.rm = TRUE)]
     
     
     # validation
     data_transformed_test_BN <- test_set #transform_boxcox(test_set)
     data_transformed_scaled_test_BN <- 
       as.data.table(lapply(data_transformed_test_BN[,-ncol(data_transformed_train_BN), with = FALSE], scale))
   
     data_transformed_test_BN <-
       cbind(data_transformed_scaled_test_BN, data_transformed_test_BN[, get(x = target_node)])
     
     setnames(x = data_transformed_test_BN, old = 'V2', new = paste0(target_node))
   
     # prediction with BN using test set
     pred_BN_val <- predict(bn_fit, 
                        node = paste0(target_node),
                        data = data_transformed_test_BN, 
                        method = "bayes-lw")
    
  
     
     # check the performance of BN 
     model_BN_val <- lm(pred_BN_val ~ data_transformed_test_BN[, get(x = target_node)])
     BN_prediction_val <- summary(model_BN_val)$r.squared
     
     
     # save BN validation results
     # r squared
     prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `BN Val` := BN_prediction_val]
     # RMSE
     prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `BN Val (RMSE)` := 
                                  RMSE(pred = pred_BN_val, 
                                       obs = data_transformed_test_BN[, get(x = target_node)], na.rm = TRUE)]
     
     
     
     # GAM ---------------------------------------------------------------------
     
     # scale the predictors in train and test sets
     train_set_scaled <- 
       as.data.table(lapply(train_set[,-ncol(train_set), with = FALSE], scale))
     
     train_set <- cbind(train_set_scaled, train_set[, get(x = target_node)])
     setnames(x = train_set, old = 'V2', new = paste0(target_node))
     
     test_set_scaled <- 
       as.data.table(lapply(test_set[,-ncol(test_set), with = FALSE], scale))
     
     test_set <- cbind(test_set_scaled, test_set[, get(x = target_node)])
     setnames(x = test_set, old = 'V2', new = paste0(target_node))
    
     
     # train GAM model, predictors are the parents of the target variables
     gam_par_formula <-
       as.formula(paste0(
         paste0(target_node, "~"),
         paste0('s(', parents_nodes, ')', collapse = "+")
       ))
      
     model_gam <- gam(
        gam_par_formula, 
        data = train_set,
        method="REML"
      )
    
     # calibration
     # prediction using train data 
     pred_gam_parent_cal <- predict(model_gam, newdata = train_set)
     gam_parent_cal <- summary(lm(pred_gam_parent_cal ~ train_set[, get(x = target_node)]))$r.squared
      
     # r squared calibration
     prediction_results_cluster[(clust_num-1)*sampling_numbers + i, `GAM~Par Cal` := gam_parent_cal]
     # RMSE calibaration 
     prediction_results_cluster[(clust_num-1)*sampling_numbers + i, `GAM~Par Cal (RMSE)` :=
                                   RMSE(pred = pred_gam_parent_cal, obs = train_set[, get(x = target_node)])]
      
      # validation
      # check the performance of gam
      pred_gam_parent_val <- predict(model_gam, newdata = test_set)
      gam_parent_val <- summary(lm(pred_gam_parent_val ~ test_set[, get(x = target_node)]))$r.squared
  
      # save gam results
      # r squared
      prediction_results_cluster[(clust_num-1)*sampling_numbers + i, `GAM~Par Val` := gam_parent_val]
      # RMSE 
      prediction_results_cluster[(clust_num-1)*sampling_numbers + i, `GAM~Par Val (RMSE)` := 
                                   RMSE(pred = pred_gam_parent_val, 
                                        obs = test_set[, get(x = target_node)])]
      
      # GAM prediction (all variables)-----------------------------------------
      # formula
      p <- ncol(train_set) 
      var_names <- names(train_set)[1: p - 1]
      gam_formula <-
        as.formula(paste0(
          paste0(target_node, "~"),
          paste0('s(', var_names, ')', collapse = "+")))
      
      
      gam.fit <- gam(gam_formula, data = train_set, method = "REML")
      
      # calibration
      pred_gam_all_cal <- predict(gam.fit, newdata = train_set)
      gam_all_cal <- summary(lm(pred_gam_all_cal ~ train_set[, get(x = target_node)]))$r.squared
      
      # save calibration results
      prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `GAM~All Cal` := gam_all_cal]
      prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `GAM~All Cal (RMSE)` := 
                                   RMSE(pred = pred_gam_all_cal, obs = train_set[, get(x = target_node)])]
      
      
      # validation
      # check the performance of gam
      pred_gam_all_val <- predict(gam.fit, newdata = test_set)
      gam_all_val <- summary(lm(pred_gam_all_val ~ test_set[, get(x = target_node)]))$r.squared
      
      
      # save results
      # r squared
      prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `GAM~All Val` := gam_all_val]
      # RMSE
      prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `GAM~All Val (RMSE)` := 
                                   RMSE(pred = pred_gam_all_val, 
                                        obs = test_set[, get(x = target_node)])]
      
      # Random Forest (parents) ------------------------------------------------
      
      # prediction with rf (using parents of the target variables)
      rf_par_formula <-
        as.formula(paste0(paste0(target_node, "~"), paste0(parents_nodes, 
                                                           collapse = "+")))
      
      # train RF
      model_rf <- randomForest(
        rf_par_formula,
        data = train_set,
        ntree = 500,
        # keep.forest = FALSE,
        # importance = TRUE
      )
      
      # calibration
      pred_rf_parents_cal <- predict(model_rf, newdata = train_set[,-ncol(train_set), with = FALSE])
      rf_parents_cal <- summary(lm(pred_rf_parents_cal ~ train_set[, get(x = target_node)]))$r.squared
      
      # save the results
      # r squared
      prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `RF~Par Cal` := rf_parents_cal]
      # RMSE
      prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `RF~Par Cal (RMSE)` := 
                                   RMSE(pred = pred_rf_parents_cal, obs = train_set[, get(x = target_node)])]
      
      # validation
      # check the performance of rf
      pred_rf_parents_val <- predict(model_rf, newdata = test_set[,-ncol(test_set), with = FALSE])
      rf_parents_val <- summary(lm(pred_rf_parents_val ~ test_set[, get(x = target_node)]))$r.squared
      
      # save the results
      # r squared
      prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `RF~Par Val` := rf_parents_val]
      # RMSE
      prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `RF~Par Val (RMSE)` := 
                                   RMSE(pred = pred_rf_parents_val, obs = test_set[, get(x = target_node)])]
      

      
      # Random Forest (All variables) ------------------------------------------
      # train RF
      rf.fit <- randomForest(
        as.formula(paste0(paste0(target_node, '~'), paste0('.'), collapse = ',')), 
        data = na.omit(train_set), 
        ntree = 500 
        # keep.forest = FALSE 
        # importance = TRUE
        )
  
      # calibration
      pred_rf_all_cal <- predict(rf.fit, newdata = train_set[,-ncol(train_set), with = FALSE])
      rf_all_cal <- summary(lm(pred_rf_all_cal ~ train_set[, get(x = target_node)]))$r.squared
      
      # save the results
      # r squared
      prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `RF~All Cal` := rf_all_cal]
      # RMSE
      prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `RF~All Cal (RMSE)` := 
                                   RMSE(pred = pred_rf_all_cal, obs = train_set[, get(x = target_node)])]
      
      # validation
      pred_rf_all_val <- predict(rf.fit, newdata = test_set[,-ncol(test_set), with = FALSE])
      # print(paste0('RF prediction (slope_fds ~ all variable) for cluster number ', clust_num))
      rf_all_val <-  summary(lm(pred_rf_all_val ~ test_set[, get(x = target_node)]))$r.squared
      
      # save the results
      # r squared
      prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `RF~All Val` := rf_all_val]
      # RMSE
      prediction_results_cluster[(clust_num - 1) * sampling_numbers + i, `RF~All Val (RMSE)` := 
                                   RMSE(pred = pred_rf_all_val, obs = test_set[, get(x = target_node)])]
      
  
  
  
   print(i)
  }
  
 }


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

