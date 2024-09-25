# BN prediction: all data 

data_all <- data_for_prediction[ ,-c('gauge_id')]
data_all <- na.omit(data_all)


parents_nodes <- parents(x = pc.fit, node = target_node)


row_number <- sampling_numbers

prediction_results_whole_data <- as.data.table(matrix(nrow = row_number, ncol = 20))
names(prediction_results_whole_data) <-
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
    'RF~All Val (RMSE)'
  )

# convert the columns to numeric
cols_to_convert <- names(prediction_results_whole_data)
prediction_results_whole_data[, (cols_to_convert) := lapply(.SD, as.numeric), 
                           .SDcols = cols_to_convert]



# causal discovery algorithm
# ------------------------------------------------------------------------------

for(i in 1:sampling_numbers) {
  
    
    # split data into train and test test sets
    split = sample.split(data_all[, get(x = target_node)], SplitRatio = 0.75)
    train_set = subset(data_all, split == TRUE)
    test_set = subset(data_all, split == FALSE)
    
    
    # Bayesian Network ---------------------------------------------------------
    
    # data_transform_train_BN <- train_set # transform_boxcox(train_set) 
    # data_scaled_transformed_train_BN <-
    #   as.data.table(lapply(data_transform_train_BN[, -ncol(data_transform_train_BN), with = FALSE], scale))
    # 
    # data_scaled_transformed_train_BN <- 
    #   cbind(data_scaled_transformed_train_BN, data_transform_train_BN[, get(x = target_node)])
    # 
    # setnames(x = data_scaled_transformed_train_BN, old = 'V2', new = paste0(target_node))
    
    data_scaled_transformed_train_BN <- train_set
    
    
    
    # train BN
    bn_fit <- bn.fit(pc.fit, data = data_scaled_transformed_train_BN)
    
    # calibration
    # prediction with BN using train data set
    pred_BN_cal <- predict(bn_fit, 
                           node = paste0(target_node), 
                           data = data_scaled_transformed_train_BN,
                           method = "bayes-lw")
    
    
    # check the performance of BN using train data set
    # fit linear model to calculate R squared
    model_BN_cal <- lm(pred_BN_cal ~ data_scaled_transformed_train_BN[, get(x = target_node)])
    BN_prediction_cal <- summary(model_BN_cal)$r.squared   
    
    # save BN results using train data set
    # r squared
    prediction_results_whole_data[i, `BN Cal` := BN_prediction_cal]
    # RMSE
    prediction_results_whole_data[i, `BN Cal (RMSE)` := 
                                 RMSE(pred = pred_BN_cal, 
                                      obs = data_scaled_transformed_train_BN[, get(x = target_node)], 
                                      na.rm = TRUE)]
    
    
    # validation
    # data_transformed_test_BN <- test_set #transform_boxcox(test_set)
    # 
    # data_scaled_transformed_test_BN <- 
    #   as.data.table(lapply(data_transformed_test_BN[,-ncol(data_transformed_test_BN), with = FALSE], scale))
    # 
    # data_transformed_test_BN <-
    #   cbind(data_scaled_transformed_test_BN, data_transformed_test_BN[, get(x = target_node)])
    # 
    # setnames(x = data_transformed_test_BN, old = 'V2', new = paste0(target_node))
    
    
    data_scaled_transformed_test_BN <- test_set
    
    # prediction with BN using test set
    pred_BN_val <- predict(bn_fit, 
                       node = paste0(target_node),
                       data = data_scaled_transformed_test_BN, 
                       method = "bayes-lw")
    
    
    
    # check the performance of BN 
    model_BN_val <- lm(pred_BN_val ~ data_scaled_transformed_test_BN[, get(x = target_node)])
    BN_prediction_val <- summary(model_BN_val)$r.squared
    # print(paste0('BN predriction for cluster numeber ', clust_num))
    # print(summary(model_BN)$r.squared)
    
    # save BN results
    prediction_results_whole_data[i, `BN Val` := BN_prediction_val]
    
    prediction_results_whole_data[i, `BN Val (RMSE)` := 
                                    RMSE(pred = pred_BN_val, 
                                         obs = data_scaled_transformed_test_BN[, get(x = target_node)], 
                                         na.rm = TRUE)]
    
    
    # GAM ----------------------------------------------------------------------
    
    # scale the predictors in train and test sets
    # train_set_scaled <- 
    #   as.data.table(lapply(train_set[,-ncol(train_set), with = FALSE], scale))
    # 
    # train_set <- cbind(train_set_scaled, train_set[, get(x = target_node)])
    # 
    # setnames(x = train_set, old = 'V2', new = paste0(target_node))
    # 
    train_set_scaled <- train_set
    
    # test_set_scaled <- 
    #   as.data.table(lapply(test_set[,-ncol(test_set), with = FALSE], scale))
    # 
    # test_set <- cbind(test_set_scaled, test_set[, get(x = target_node)])
    # 
    # setnames(x = test_set, old = 'V2', new = paste0(target_node))
    
    test_set_scaled <- test_set
    
    # train GAM model, predictors are the parents of the target variables 
    gam_par_formula <-
      as.formula(paste0(
        paste0(target_node, "~"),
        paste0('s(', parents_nodes, ')', collapse = "+")
      ))
    
    model_gam <- gam(
      formula = gam_par_formula, 
      data = train_set,
      method="REML"
    )
    
    
    # calibration
    # prediction using train data 
    pred_gam_parent_cal <- predict(model_gam, newdata = train_set)
    gam_parent_cal <- summary(lm(pred_gam_parent_cal ~ train_set[, get(x = target_node)]))$r.squared
    
    # r squared calibration
    prediction_results_whole_data[i, `GAM~Par Cal` := gam_parent_cal]
    # RMSE calibaration 
    prediction_results_whole_data[i, `GAM~Par Cal (RMSE)` :=
                                 RMSE(pred = pred_gam_parent_cal, obs = train_set[, get(x = target_node)])]
    
    
    # validation
    # fit linear model; obs vs pred
    pred_gam_parent_val <- predict(model_gam, newdata = test_set)
    gam_parent_val <- summary(lm(pred_gam_parent_val ~ test_set[, get(x = target_node)]))$r.squared
    
    
    # r squared
    prediction_results_whole_data[i, `GAM~Par Val` := gam_parent_val]
    # RMSE 
    prediction_results_whole_data[i, `GAM~Par Val (RMSE)`:= 
                                 RMSE(pred = pred_gam_parent_val, 
                                      obs = test_set[, get(x = target_node)], na.rm = TRUE)]
    
      
    
    
    # GAM prediction (all variables)-----------------------------------------
    
    # formula
    p <- ncol(train_set) 
    var_names <- names(train_set)[1:p-1]
    gam_formula <- as.formula(paste0(paste0(target_node,"~"),paste0('s(',var_names, ')', collapse="+")))
    
    gam.fit <- gam(gam_formula, data = train_set, method="REML")
    
    
    # calibration
    pred_gam_all_cal <- predict(gam.fit, newdata = train_set)
    gam_all_cal <- summary(lm(pred_gam_all_cal ~ train_set[, get(x = target_node)]))$r.squared
    
    # save calibration results
    prediction_results_whole_data[i, `GAM~All Cal` := gam_all_cal]
    prediction_results_whole_data[i, `GAM~All Cal (RMSE)` := 
                                 RMSE(pred = pred_gam_all_cal, obs = train_set[, get(x = target_node)])]
    
    #  validation 
    # check the performance of gam
    pred_gam_all_val <- predict(gam.fit, newdata = test_set)
    gam_all_val <- summary(lm(pred_gam_all_val ~ test_set[, get(x = target_node)]))$r.squared
    
    
    # save results
    # r squared
    prediction_results_whole_data[i,`GAM~All Val` := gam_all_val]
    # RMSE
    prediction_results_whole_data[i, `GAM~All Val (RMSE)` := 
                                 RMSE(pred = pred_gam_all_val, 
                                      obs = test_set[, get(x = target_node)], na.rm = TRUE)]
    
    
    
    # Random Forest (parents) -------------------------------------------------
    
    # prediction with rf (using parents of the target node)
    
    
    rf_par_formula <-
      as.formula(paste0(paste0(target_node, "~"), paste0(parents_nodes, 
                                                         collapse = "+")))
    
    model_rf <- randomForest(
      rf_par_formula,
      data = na.omit(train_set),
      ntree = 500,
      # keep.forest = FALSE,
      # importance = TRUE
    )
    
    
    # print(paste0('RF prediction (slope_fds ~ parents) for cluster number ', clust_num))
    
    # calibration
    pred_rf_parents_cal <- 
      predict(model_rf, newdata = train_set[, -ncol(train_set), with = FALSE])
    
    rf_parents_cal <- 
      summary(lm(pred_rf_parents_cal ~ train_set[, get(x = target_node)]))$r.squared
    
    # save the results
    # r squared
    prediction_results_whole_data[i, `RF~Par Cal` := rf_parents_cal]
    
    # RMSE
    prediction_results_whole_data[i, `RF~Par Cal (RMSE)` := 
                                 RMSE(pred = pred_rf_parents_cal, 
                                      obs = train_set[, get(x = target_node)])]
    
    # validation
    
    # check the performance of rf
    pred_rf_parents_val <- predict(model_rf, newdata = test_set[, -ncol(test_set), with = FALSE])
    
    rf_parents_val <- 
      summary(lm(pred_rf_parents_val ~ test_set[, get(x = target_node)]))$r.squared
    
    # save the results
    # r squared
    prediction_results_whole_data[i, `RF~Par Val` := rf_parents_val]
    # RMSE
    prediction_results_whole_data[i, `RF~Par Val (RMSE)` := 
                                 RMSE(pred = pred_rf_parents_val, 
                                      obs = test_set[, get(x = target_node)], na.rm = TRUE)]
    

    
    # Random Forest (All variables) --------------------------------------------
    rf.fit <- randomForest(
      as.formula(paste0(paste0(target_node, '~'), paste0('.'), collapse = ',')), 
      data = na.omit(train_set), 
      ntree = 500 
      # keep.forest = FALSE 
      # importance = TRUE
    )
    
    
    # calibration
    pred_rf_all_cal <- predict(rf.fit, newdata = train_set[,-ncol(train_set), with = FALSE])
    rf_all_cal <- summary(lm(pred_rf_all_cal ~ train_set[, get(x = target_node)] ))$r.squared
    
    # save the results
    # r squared
    prediction_results_whole_data[i, `RF~All Cal` := rf_all_cal]
    # RMSE
    prediction_results_whole_data[i, `RF~All Cal (RMSE)` := 
                                 RMSE(pred = pred_rf_all_cal, obs = train_set[, get(x = target_node)])]
    
    
    #  validation
    pred_rf_all_val <- predict(rf.fit, newdata = test_set[,-ncol(test_set), with = FALSE])
    # print(paste0('RF prediction (slope_fds ~ all variable) for cluster number ', clust_num))
    rf_all_val <-
      summary(lm(pred_rf_all_val ~ test_set[, get(x = target_node)]))$r.squared
    
    # save the results
    # r squared
    prediction_results_whole_data[i, `RF~All Val` := rf_all_val]
    # RMSE
    prediction_results_whole_data[i, `RF~All Val (RMSE)` := 
                                 RMSE(pred = pred_rf_all_val, 
                                      obs = test_set[, get(x = target_node)], na.rm = TRUE)]
    
    

    print(i)
 }
  



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



