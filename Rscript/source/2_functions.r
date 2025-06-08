# normality test ---------------------------------------------------------------

# Shapiro Wilk test
normal_test <- function(data_for_test) {
  
  hydro_normality <- lapply(data_for_test, shapiro.test)
  shapiro_wilk <-
    data.frame(matrix(
      data = NA,
      nrow = ncol(data_for_test),
      ncol = 2
    ),
    row.names = names(data_for_test))
  names(shapiro_wilk) <- c('w', 'p.value')
  
  for (i in 1:ncol(data_for_test)) {
    shapiro_wilk$w[i] <- hydro_normality[[i]]$statistic
    shapiro_wilk$p.value[i] <- hydro_normality[[i]]$p.value
  }
  print("The results for Shapiro Wilk test: ")
  return(shapiro_wilk)
}



# data_for_transformation <- selected_data_slope_fdc[,-c('gauge_id', 'cluster_hc')]
# data_for_transformation <- selected_data_slope_fdc[,-c('gauge_id')]

# data transformation
transform_boxcox <- function(data_for_transformation){
  
  normalized_data <-
    data.table(matrix(
      nrow = nrow(data_for_transformation),
      ncol = ncol(data_for_transformation)
    )) |> as.data.table()
  
  names(normalized_data) <- names(data_for_transformation)
  
  # add 5 to data with negative values to make it positive
  for(i in seq_along(data_for_transformation)){
    
    if(TRUE %in% (data_for_transformation[[i]] < 0.001)){
      data_for_transformation[[i]] <- 
        data_for_transformation[[i]] + 
        abs(min(data_for_transformation[[i]]) 
            )
      data_for_transformation[[i]] <- data_for_transformation[[i]] + 1
      }
    
    
    }
  # data_for_transformation <- data_for_transformation + 1
  
  for (col_name in names(normalized_data)) {
    boxcox_result <-
      boxcox((data_for_transformation[[col_name]] + 1) ~ 1, plotit = FALSE)
    
    # optimum lambda
    lambda <- boxcox_result$x[which.max(boxcox_result$y)]
    # & any(data_for_transformation[[col_name]] == 0) == FALSE
    if (lambda != 0) {
      normalized_val <- 
        ((data_for_transformation[[col_name]] ^ lambda) - 1) / lambda
    } else{
      normalized_val <- log(data_for_transformation[[col_name]])
      
    }
    normalized_data[[col_name]] <- normalized_val
  }
  
  return(normalized_data)
}




# PC: Gaussian linear model
pc_function_pcalg <- function(data_for_pc,
                              alpha_pc = 0.05,
                              conserv = FALSE,
                              maj_rule = FALSE,
                              solve_confl = FALSE) {
  
  suffStat <- list(C = cor(data_for_pc), n = nrow(data_for_pc))
  pc.fit <- pc(
    suffStat,
    indepTest = gaussCItest,
    # p = ncol(hydro_data_for_pc),
    alpha = alpha_pc,
    labels = colnames(data_for_pc),
    conservative = conserv,
    maj.rule = maj_rule,
    solve.confl = solve_confl
  )
  
  return(pc.fit)
  }

# GIES: score based method
gies_function_pcalg <- function(data_for_gies,
                                score_class = "GaussL0penIntScore") {

    score <- new(score_class, data_for_gies)
    gies.fit <- gies(score)
  
  return(gies.fit)
  }

# LINGAM: linear non-Gaussian method
lingam_funciton_pcalg <- function(data_for_lingam){
    lingam.fit <- lingam(data_for_lingam)
    return(lingam.fit)
  }
