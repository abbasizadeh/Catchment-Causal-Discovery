# variable selection for streamflow elasticity
# load variables and packages
setwd("D:/project/Spatial_variablity_paper/")
source('./Rscripts/source/1_load_data_&_packages.R')

target_node <- 'low_q_dur'

# categories of variables ------------------------------------------------------
climate_vars <- names(camels_clim)
hydro_vars <- names(camels_hydro)
soil_vars <- names(camels_soil)
vege_vars <- names(camels_vege)
geol_vars <- names(camels_geol)
topo_vars <- names(camels_topo)

#  out of bag variable importance ---------------------------------------------
data_for_rf <- 
  ALL_SIGNATURES[,-c(
    'gauge_id',
    'gauge_name',
    'high_prec_timing',
    'low_prec_timing',
    'geol_1st_class',
    'glim_1st_class_frac',
    'geol_2nd_class',
    'glim_2nd_class_frac',
    'dom_land_cover',
    'q_mean',
    'runoff_ratio',
    'stream_elas',
    'slope_fdc',
    'q5',
    'q95',
    'high_q_freq',
    'high_q_dur',
    'low_q_freq',
    # 'low_q_dur',
    'zero_q_freq',
    'hfd_mean',
    'huc_02',
    'root_depth_50',
    'root_depth_99',
    'baseflow_index'
  )]



ALL_SIGNATURES
miss_var_summary(data_for_rf) 
vis_miss(data_for_rf)       

# random forest
rf_baseline <- randomForest(
  low_q_dur ~ .,
  data = na.omit(data_for_rf),
  importance = TRUE,
  ntree = 1000,
  mrty = 10
)

plot(rf_baseline)
hist(data_for_rf[, get(x = target_node)])
summary(lm(rf_baseline$predicted ~ na.omit(data_for_rf)[, get(x = target_node)]))$r.squared
varImpPlot(rf_baseline)


# sorted tabular summary
rf_important_vars <- 
  importance(rf_baseline) %>% 
  as.data.frame() %>% 
  arrange(desc(`%IncMSE`))

rf_important_vars$variable <- rownames(rf_important_vars) 


# %IncMSE is the average increase in squared residuals of the test set when 
#variables are randomly permuted (little importance = little change in model 
#when variable is removed or added). 

# IncNodePurity is the increase in homogeneity in the data partitions.

ImpData <- as.data.frame(importance(rf_baseline))
ImpData$Var.Names <- row.names(ImpData)
# ImpData <- ImpData[order(ImpData$IncNodePurity), ]
ImpData <- as.data.table(ImpData)

ImpData[Var.Names %in% climate_vars, category := "climate"]
ImpData[Var.Names %in% hydro_vars, category := "hydro"]
ImpData[Var.Names %in% soil_vars, category := "soil"]
ImpData[Var.Names %in% vege_vars, category := "vegetation"]
ImpData[Var.Names %in% geol_vars, category := "geology"]
ImpData[Var.Names %in% topo_vars, category := "topography"]


ImpData$Var.Names <- factor(ImpData$Var.Names,
                            levels = ImpData$Var.Names[order(ImpData$`%IncMSE`)])

color_vac <- c('blue', 'red', 'purple', 'orange', 'darkgreen')

# plot 

var_import_plor <- 
  ggplot(ImpData, aes(x = Var.Names, y = `%IncMSE`)) +
    geom_segment(aes(x = Var.Names, xend = Var.Names, y = 0, yend = `%IncMSE`), 
                 alpha = 0.2) +
    geom_point(aes(size = IncNodePurity, color = category, fill = category),
               alpha = 0.6, size = 10) +
  labs(title = 'Variable Importance: Low Flow Duration') +
    theme_light() +
    coord_flip() +
    theme(
      legend.position="bottom",
      panel.grid.major.y = element_blank(),
      # panel.border = element_blank(),
      axis.ticks.y = element_blank(),
      axis.text = element_text(size = 20, face = 'bold'),
      axis.title = element_text(size = 30),
      legend.text = element_text(size = 20),
      legend.title = element_text(size = 20),
      title = element_text(size = 30)
    ) +
    scale_color_manual(values = color_vac) +
    scale_fill_manual(values = color_vac) 

var_import_plor
ggsave(filename = './results_text/low_q_dur/4_low_q_dur_var_importance.png', 
       plot = var_import_plor, width = 30, height = 12,
       dpi = 300)

# correlation between variables ------------------------------------------------
cor_pearson_matrix <- cor(na.omit(data_for_rf), method = 'pearson')
cor_kendall_matrix <- cor(na.omit(data_for_rf), method = "kendall")
cor_spearman_matrix <- cor(na.omit(data_for_rf), method = "spearman")


# Extract correlation of one column (e.g., 'target_node') with other columns

# Pearson correlation 
cor_data_pearson <- data.table(
  cor_coef = c(cor_pearson_matrix[, target_node]), 
  var_names = row.names(as.data.frame(cor_pearson_matrix[, target_node])), 
  cor_method = rep(x = 'Pearson', length(as.data.frame(cor_pearson_matrix[, target_node])))
                               )
# Kendall correlation
cor_data_kendall <- data.table(
  cor_coef = c(cor_kendall_matrix[, target_node]),
  var_names = row.names(as.data.frame(cor_kendall_matrix[, target_node])),
  cor_method = rep(x = 'Kendall', length(as.data.frame(cor_kendall_matrix[, target_node])))
  )

# Spearman correlation
cor_data_spearman <- data.table(
  cor_coef = c(cor_spearman_matrix[, target_node]),
  var_names = row.names(as.data.frame(cor_spearman_matrix[, target_node])),
  cor_method = rep(x = 'Spearman', length(as.data.frame(cor_spearman_matrix[, target_node])))
  )

cor_data <- rbind(cor_data_pearson, cor_data_kendall, cor_data_spearman) 

cor_data[var_names %in% climate_vars, category := "climate"]
cor_data[var_names %in% hydro_vars, category := "hydro"]
cor_data[var_names %in% soil_vars, category := "soil"]
cor_data[var_names %in% vege_vars, category := "vegetation"]
cor_data[var_names %in% geol_vars, category := "geology"]
cor_data[var_names %in% topo_vars, category := "topography"]

cor_data <- cor_data[var_names != paste0(target_node),]

cor_data$var_names <- 
  factor(cor_data$var_names, levels = unique(cor_data$var_names[order(cor_data$cor_coef)]))


# Visualize the correlation of 'target_node' with other columns using a bar plot

corr_plot <- 
  ggplot(cor_data[order(cor_coef), ]) +
    geom_bar(aes(x = var_names, 
                 y = cor_coef, 
                 fill = category), 
             stat = "identity",  color = "black") +
    labs(x = "Variables", 
         y = "Correlation Coefficient", 
         title = "Pearson, Kendall, Spearman Correlations: Low Flow Duration") +
    theme_light() +
    scale_fill_manual(values = color_vac) +
    facet_wrap(vars(cor_method)) +
    theme(axis.text.x = element_text(size = 20,angle = 90, hjust = 1, , face = "bold"),
          legend.position = 'bottom',
          panel.grid.major.y = element_blank(),
          axis.text.y = element_text(size = 20, face = "bold"),
          axis.ticks.y = element_blank(),
          axis.title = element_text(size = 30),
          legend.text = element_text(size = 20),
          legend.title = element_text(size = 20),
          title = element_text(size = 30),
          
          strip.text = element_text(face = "bold", size = 15, colour = 'black'),
          strip.background = element_rect(fill = "azure", colour = "black", linewidth = 0.5
          ))

corr_plot
ggsave(filename = './results_text/low_q_dur/4_low_q_dur_corr.png', 
       plot = corr_plot, width = 30, height = 12,
       dpi = 300)


# mix the results --------------------------------------------------------------
# random forest
rf_imporant <- rf_important_vars[1:20, 'variable']

# correlation
cor_imporant_Pearson <- 
  cor_data[cor_method == 'Pearson' ,][order(cor_coef, decreasing = TRUE), ][1:20, var_names]

cor_imporant_Kendall <- 
  cor_data[cor_method == 'Kendall' ,][order(cor_coef, decreasing = TRUE), ][1:20, var_names]

cor_imporant_Spearman <- 
  cor_data[cor_method == 'Spearman' ,][order(cor_coef, decreasing = TRUE), ][1:20, var_names]


corr_results <- data.frame(
  RF = rf_imporant,
  Pearson = cor_imporant_Pearson,
  Kendall = cor_imporant_Kendall,
  Spearman = cor_imporant_Spearman
)

corr_results
write.csv(x = corr_results, file = './results_text/low_q_dur/corr.csv')


rm(cor_data, cor_data_kendall, cor_data_pearson, cor_data_spearman, 
   cor_imporant_Kendall, cor_imporant_Pearson, cor_imporant_Spearman, 
   cor_kendall_matrix, cor_pearson_matrix, cor_spearman_matrix, data_for_rf,
   ImpData, rf_baseline, rf_important_vars, color_vac,  geol_vars,
   hydro_vars, rf_imporant, soil_vars, topo_vars, vege_vars,
   climate_vars
   )




# theme1 <- trellis.par.get()
# theme1$plot.line$col = rgb(1, 0, 0, .7)
# trellis.par.set(theme1)


# --------------------------------------------------------------------- climate

# feature plot
featurePlot(x = camels_hydro[,get(x = target_node)],
            y = camels_clim[,-c('gauge_id', 'high_prec_timing', 'low_prec_timing')],
            plot = "pairs",
            type = c("p", "smooth"),
            span = 0.5)


# correlation matrix
corr_matrix_data <- cbind(camels_hydro[,get(x = target_node)],
                          camels_clim[,-c('gauge_id',
                                     'high_prec_timing',
                                     'low_prec_timing')])

setnames(corr_matrix_data, old = 'V1', new = paste0(target_node))

# correlation matrix pearson, kendall and spearman
corr_matrix_pearson <- cor(na.omit(corr_matrix_data), method = "pearson")
names(which(abs(corr_matrix_pearson[, 1])> 0.4))[-c(1)]

corr_matrix_kendall <- cor(na.omit(corr_matrix_data), method = "kendall")
names(which(abs(corr_matrix_kendall[, 1])> 0.4))[-c(1)]

corr_matrix_spearman <- cor(na.omit(corr_matrix_data), method = "spearman")
names(which(abs(corr_matrix_spearman[, 1])> 0.4))[-c(1)]



# --------------------------------------------------------------------- geology

# feature plot
featurePlot(x = camels_hydro[, get(x = target_node)],
            y = camels_geol[,-c('gauge_id', 'geol_1st_class',
                                'glim_1st_class_frac',
                                'geol_2nd_class',
                                'glim_2nd_class_frac')],
            plot = "pairs",
            type = c("p", "smooth"),
            span = 0.5)

corr_matrix_data <- cbind(camels_hydro[, get(x = target_node)],
                          camels_geol[,-c('gauge_id', 'geol_1st_class',
                                'glim_1st_class_frac',
                                'geol_2nd_class',
                                'glim_2nd_class_frac')])

setnames(corr_matrix_data, old = 'V1', new = paste0(target_node))

corr_results

# correlation matrix pearson, kendall and spearman
corr_matrix_pearson <- cor(na.omit(corr_matrix_data), method = "pearson")
names(which(abs(corr_matrix_pearson[, 1])> 0.4))[-c(1)]

corr_matrix_kendall <- cor(na.omit(corr_matrix_data), method = "kendall")
names(which(abs(corr_matrix_kendall[, 1])> 0.4))[-c(1)]

corr_matrix_spearman <- cor(na.omit(corr_matrix_data), method = "spearman")
names(which(abs(corr_matrix_spearman[, 1])> 0.4))[-c(1)]



# ------------------------------------------------------------------------- soil
# feature plot
featurePlot(x = camels_hydro[, get(x = target_node)],
            y = camels_soil[,-c('gauge_id',
                                # 'soil_depth_pelletier',
                                'soil_porosity',
                                'silt_frac',
                                # 'clay_frac',
                                'water_frac',
                                'organic_frac',
                                'other_frac')],
            plot = "pairs",
            type = c("p", "smooth"),
            span = 0.5)

corr_matrix_data <- cbind(camels_hydro[, get(x = target_node)],
                          camels_soil[,-c('gauge_id')])

setnames(corr_matrix_data, old = 'V1', new = 'slope_fdc')

corr_results

# correlation matrix pearson, kendall and spearman
corr_matrix_pearson <- cor(na.omit(corr_matrix_data), method = "pearson")
names(which(abs(corr_matrix_pearson[, 1])> 0.4))[-c(1)]

corr_matrix_kendall <- cor(na.omit(corr_matrix_data), method = "kendall")
names(which(abs(corr_matrix_kendall[, 1])> 0.4))[-c(1)]

corr_matrix_spearman <- cor(na.omit(corr_matrix_data), method = "spearman")
names(which(abs(corr_matrix_spearman[, 1])> 0.4))[-c(1)]



# ------------------------------------------------------------------- topography
featurePlot(x = camels_hydro[, get(x = target_node)],
            y = camels_topo[,-c('gauge_id')],
            plot = "pairs",
            type = c("p", "smooth"),
            span = 0.5)



corr_matrix_data <- cbind(camels_hydro[, get(x = target_node)],
                          camels_topo[,-c('gauge_id')])

setnames(corr_matrix_data, old = 'V1', new = 'slope_fdc')

corr_matrix_pearson <- cor(na.omit(corr_matrix_data), method = "pearson")
names(which(abs(corr_matrix_pearson[, 1])> 0.4))[-c(1)]

corr_matrix_kendall <- cor(na.omit(corr_matrix_data), method = "kendall")
names(which(abs(corr_matrix_kendall[, 1])> 0.4))[-c(1)]

corr_matrix_spearman <- cor(na.omit(corr_matrix_data), method = "spearman")
names(which(abs(corr_matrix_spearman[, 1])> 0.4))[-c(1)]


# ------------------------------------------------------------------- vegetation
featurePlot(x = camels_hydro[, get(x = target_node)],
            y = camels_vege[,-c('gauge_id', 'dom_land_cover')],
            plot = "pairs",
            type = c("p", "smooth"),
            span = 0.5)
#
# corr_matrix_data <- cbind(camels_hydro$slope_fdc,
#                           camels_vege[,-c('gauge_id', 'dom_land_cover')])
# setnames(corr_matrix_data, old = 'V1', new = 'slope_fdc')
#
# corr_matrix_pearson <- cor(na.omit(corr_matrix_data), method = "pearson")
# names(which(abs(corr_matrix_pearson[, 1])> 0.4))[-c(1)]
#
# corr_matrix_kendall <- cor(na.omit(corr_matrix_data), method = "kendall")
# names(which(abs(corr_matrix_kendall[, 1])> 0.4))[-c(1)]
#
# corr_matrix_spearman <- cor(na.omit(corr_matrix_data), method = "spearman")
# names(which(abs(corr_matrix_spearman[, 1])> 0.4))[-c(1)]
#



