################################################################################
#                                                                              #
#                          regression base test                                #
#                                                                              #
# ##############################################################################

setwd("~/Catchment-Causal-Discovery/")

# get the data
source('./source/1_load_data_&_packages.R')
# load functions
source('./source/2_functions.r')


# add the target variable to the selected variables
selected_data_slope_fdc <- 
  merge(selected_data_slope_fdc, ALL_SIGNATURES[, c('gauge_id', 'q5')], by = 'gauge_id')

selected_data_slope_fdc <- na.omit(selected_data_slope_fdc)





# pc.fit <- readRDS('./data/output/PC_DAGs/DAG_bfi.rds')
# pc.fit$learning
# parents_nodes <- parents(x = pc.fit, node = 'q5')
# set.seed(1)
# graphviz.plot(pc.fit)


{
# define a data table to save the results
dt_p_value_results <- as.data.table(matrix(nrow = 0, ncol = 8))
names(dt_p_value_results) <- 
  c('target_1', 'target_2', 
    'p_value_fwd', 'p_value_bwd', 
    'anova_1_fwd', 'anova_2_fwd', 
    'anova_1_bwd', 'anova_2_bwd')


dt_p_value_results[, target_1 := as.character(target_1) ]
dt_p_value_results[, target_2 := as.character(target_2) ]
dt_p_value_results[, p_value_fwd := as.numeric(p_value_fwd) ]
dt_p_value_results[, p_value_bwd := as.numeric(p_value_bwd) ]
dt_p_value_results[, anova_1_fwd := as.numeric(anova_1_fwd) ]
dt_p_value_results[, anova_2_fwd := as.numeric(anova_2_fwd) ]
dt_p_value_results[, anova_1_bwd := as.numeric(anova_1_bwd) ]
dt_p_value_results[, anova_2_bwd := as.numeric(anova_2_bwd) ]

# dummy results
dt_p_value_dummy <- as.data.table(matrix(nrow = 1, ncol = 8))
names(dt_p_value_dummy) <- 
  c('target_1', 'target_2', 
    'p_value_fwd', 'p_value_bwd',
    'anova_1_fwd', 'anova_2_fwd', 
    'anova_1_bwd', 'anova_2_bwd')


dt_p_value_dummy[, target_1 := as.character(target_1) ]
dt_p_value_dummy[, target_2 := as.character(target_2) ]
dt_p_value_dummy[, p_value_fwd := as.numeric(p_value_fwd) ]
dt_p_value_dummy[, p_value_bwd := as.numeric(p_value_bwd) ]
dt_p_value_dummy[, anova_1_fwd := as.numeric(anova_1_fwd) ]
dt_p_value_dummy[, anova_2_fwd := as.numeric(anova_2_fwd) ]
dt_p_value_dummy[, anova_1_bwd := as.numeric(anova_1_bwd) ]
dt_p_value_dummy[, anova_2_bwd := as.numeric(anova_2_bwd) ]

}


# ------------------------------------------------------------------------------
# # 1
# selected_data_slope_fdc <-
#   # selected_data_slope_fdc[, -c('lai_max', "frac_forest", 'p_mean')]
#   selected_data_slope_fdc[, c('lai_max', "frac_forest", 'p_mean','low_prec_freq', 'low_prec_dur', 'lai_diff')]
# target_node_1 <- 'low_prec_freq'
# target_node_2 <- 'low_prec_dur'


# selected_data_slope_fdc <-
#   selected_data_slope_fdc[, -c("frac_snow")]
# target_node_1 <- 'pet_mean'
# target_node_2 <- 'low_prec_freq'


# # 2
# selected_data_slope_fdc <-
#   selected_data_slope_fdc[, -c('p_mean', "low_prec_freq")]
# target_node_1 <- 'frac_forest'
# target_node_2 <- 'lai_max'

# 3
# selected_data_slope_fdc <- selected_data_slope_fdc[, -c('sand_frac')]
# target_node_1 <- 'soil_conductivity'
# target_node_2 <- 'frac_forest'

# 4
# selected_data_slope_fdc <- selected_data_slope_fdc[, -c('soil_depth_pelletier', 'snow_frac')]
selected_data_slope_fdc <- selected_data_slope_fdc[, -c('p_mean')]
target_node_1 <- 'elev_mean'
target_node_2 <- 'slope_mean'


# # 5
# selected_data_slope_fdc <- selected_data_slope_fdc[, -c('lai_max', "frac_forest", 'p_mean')]
# target_node_1 <- 'low_prec_freq'
# target_node_2 <- 'high_prec_freq'

# # 6
# selected_data_slope_fdc <-
#   selected_data_slope_fdc[, c('clay_frac',
#                               'sand_frac',
#                               'soil_conductivity',
#                               'silt_frac',
#                               'max_water_content',
#                               'soil_porosity',
#                               'q5')]
# target_node_1 <- 'sand_frac'
# target_node_2 <- 'soil_conductivity'




# ------------------------------------------------------------------------------


vec_all_nodes <- names(selected_data_slope_fdc[, -c('gauge_id')])


vec_target_nodes <- copy(vec_all_nodes)
vec_z_set <- copy(vec_all_nodes)




# calculation of p-values for conditional independent test of adjacent nodes 
for (target_node_1 in vec_all_nodes) {
  # get the first variable
  dt_p_value_dummy[, target_1 := target_node_1]
  
  
  # get target variable and remove it from the variable in each loop
  vec_target_nodes <- setdiff(vec_target_nodes, target_node_1)
  
  
  
  
  for (target_node_2 in vec_target_nodes) {
    
    # vector of covariates 
    vec_z_set <- setdiff(vec_all_nodes, target_node_1)
    vec_z_set <- setdiff(vec_z_set, target_node_2)
    
    # get the second variable
    dt_p_value_dummy[, target_2 := target_node_2]
  
    # 1- Fit the models=============================================================
    
    #   A. Fit two models predicting Xi:............................................
    #       - Null model (M0a): predict Xi from Z
    #       - Alternative model (M1a): predict Xi from Xj + Z
    
    # Model M0a: Xi ~ Z
    formula_z_fwd <-
      as.formula(paste0(paste0(target_node_1, "~"), paste0('s(', vec_z_set, ', bs = "cr")', collapse = "+")))
    
    gam_z_fwd <- gam(formula =  formula_z_fwd, data = selected_data_slope_fdc, method="REML")
    
    # Model M1a: Xi ~ Xj + Z
    # formula_z_adj_fwd <-
    #   as.formula(paste0(paste0(target_node_1, "~", target_node_2, '+'), paste0('s(', vec_z_set, ', bs = "cr")', collapse = "+")))
    
    formula_z_adj_fwd <-
      as.formula(paste0(paste0(target_node_1, "~"), paste0('s(',target_node_2, ', bs = "cr")', '+'), 
                        paste0('s(', vec_z_set, ', bs = "cr")', collapse = "+")))
    
    gam_z_adj_fwd <- 
      gam(formula =  formula_z_adj_fwd, data = selected_data_slope_fdc, method="REML")
    
    
    #    B. Fit two models predicting Xj:...........................................
    #        Null model (M0b): predict Xj from Z
    #        Alternative model (M1b): predict Xj from Xi + Z
    
    # Model M0a: Xj ~ Z
    formula_z_bwd <-
      as.formula(paste0(paste0(target_node_2, "~"), paste0('s(', vec_z_set, ', bs = "cr")', collapse = "+")))
    
    gam_z_backward <- 
      gam(formula = formula_z_bwd, data = selected_data_slope_fdc, method="REML")
    
    # Model M1a: Xj ~ Xi + Z
    # formula_z_adj_bwd <-
    #   as.formula(paste0(paste0(target_node_2, "~", target_node_1, '+'), paste0('s(', vec_z_set, ', bs = "cr")', collapse = "+")))
    formula_z_adj_bwd <-
      as.formula(paste0(paste0(target_node_2, "~"), paste0('s(',target_node_1, ', bs = "cr")', '+'), 
                        paste0('s(', vec_z_set, ', bs = "cr")', collapse = "+")))
    
    gam_z_adjacent_backward <- 
      gam(formula =  formula_z_adj_bwd, data = selected_data_slope_fdc, method="REML")
    
    
    
    # 2- Likelihood Ratio Tests=====================================================
    
    #  If the obtained P-value is smaller than alpha level you have evidence that 
    # Xi and Xj are dependent, even after conditioning on Z
    
    
    # forward model
    log_like_z_fwd <- logLik(gam_z_fwd)
    log_like_z_adj_fwd <- logLik(gam_z_adj_fwd)
    
    lrt_stat_fwd <- 2 * (as.numeric(log_like_z_adj_fwd) - as.numeric(log_like_z_fwd))
    df_fwd <- attr(log_like_z_adj_fwd, "df") - attr(log_like_z_fwd, "df")
    pval_fwd <- pchisq(lrt_stat_fwd, df = df_fwd, lower.tail = FALSE)
    
    dt_p_value_dummy[, p_value_fwd := pval_fwd]
    
    
    # backward model
    log_like_z_bwd <- logLik(gam_z_backward)
    log_like_z_adj_bwd <- logLik(gam_z_adjacent_backward)
    
    lrt_stat_bwd <- 2 * (as.numeric(log_like_z_adj_bwd) - as.numeric(log_like_z_bwd))
    df_bwd <- attr(log_like_z_adj_bwd, "df") - attr(log_like_z_bwd, "df")
    pval_bwd <- pchisq(lrt_stat_bwd, df = df_bwd, lower.tail = FALSE)
    
    
    dt_p_value_dummy[, p_value_bwd := pval_bwd]
    
    
    # anova test
    dt_p_value_dummy[, anova_1_fwd := anova(gam_z_fwd, gam_z_adj_fwd, test = "Chisq")$`Pr(>Chi)`[1]]
    dt_p_value_dummy[, anova_2_fwd := anova(gam_z_fwd, gam_z_adj_fwd, test = "Chisq")$`Pr(>Chi)`[2]]
    
    dt_p_value_dummy[, anova_1_bwd := anova(gam_z_backward, gam_z_adjacent_backward, test = "Chisq")$`Pr(>Chi)`[1]]
    dt_p_value_dummy[, anova_2_bwd := anova(gam_z_backward, gam_z_adjacent_backward, test = "Chisq")$`Pr(>Chi)`[2]]
    
    # save the results
    dt_p_value_results <- rbind(dt_p_value_results,  dt_p_value_dummy)
    
    # dt_p_value_results
    
    }
  
  }




