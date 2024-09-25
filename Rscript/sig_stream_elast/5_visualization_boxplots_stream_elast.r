
# visualization ----------------------------------------------------------------
target_node <- 'Streamflow Elasticity '


# Rsquared
# data_for_visual <- copy(prediction_results_cluster_climate)
# var_name <- "Climate"

# data_for_visual <- prediction_results_cluster_geol
# var_name <- "Geological"

# data_for_visual <- prediction_results_cluster_soil
# var_name <- "Soil"

# data_for_visual <- prediction_results_cluster_topo
# var_name <- "Topography"

# data_for_visual <- prediction_results_cluster_vege
# var_name <- "Vegetation"

data_for_visual <- prediction_results_whole_cluster
data_for_visual <- copy(prediction_results_predictors)
var_name <- "ALL Predictors"


visual_1 <- data_for_visual[, c(
  "BN Cal",
  "BN Val",
  "GAM~Par Cal",
  "GAM~Par Val",
  "GAM~All Cal",
  "GAM~All Val",
  "RF~Par Cal",
  "RF~Par Val",
  "RF~All Cal",
  "RF~All Val",
  "cluster_label"
)]
names(visual_1) <- c(
  "BN-trn",
  "BN-tst",
  "GAM~Par-trn",
  "GAM~Par-tst",
  "GAM~All-trn",
  "GAM~All-tst",
  "RF~Par-trn",
  "RF~Par-tst",
  "RF~All-trn",
  "RF~All-tst",
  "cluster_label"
)

visual_1 <- melt(visual_1, id.vars = c("cluster_label"))

visual_1[, cal_val := ifelse(endsWith(x = as.character(variable), suffix = "trn"), 'Train', 'Test')]
# visual_1[, cluster := factor(cluster)]
# levels(visual_1$cluster)

ggplot(data = visual_1, aes(x = variable,  y = value, fill = cal_val)) +
  geom_boxplot(outlier.shape = NA) +
  facet_wrap( ~ cluster_label, nrow = 1) +
  labs(title = paste0(target_node, "Prediciton Results (R squared); ", var_name," Variables Clusters"),
       x = "Model", y = "R-squared") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        axis.text = element_text(size = 15),
        axis.title = element_text(size = 15),
        legend.position = 'bottom',
        legend.title = element_blank(),
        legend.key.size = unit(1, 'cm'))

# RMSE
visual_1_RMSE <-
  data_for_visual[, c(
    "BN Cal (RMSE)",
    "BN Val (RMSE)",
    "GAM~Par Cal (RMSE)",
    "GAM~Par Val (RMSE)",
    "GAM~All Cal (RMSE)",
    "GAM~All Val (RMSE)",
    "RF~Par Cal (RMSE)",
    "RF~Par Val (RMSE)",
    "RF~All Cal (RMSE)",
    "RF~All Val (RMSE)",
    "cluster_label"
  )]

names(visual_1_RMSE) <- c(
  "BN-trn",
  "BN-tst",
  "GAM~Par-trn",
  "GAM~Par-tst",
  "GAM~All-trn",
  "GAM~All-tst",
  "RF~Par-trn",
  "RF~Par-tst",
  "RF~All-trn",
  "RF~All-tst",
  "cluster_label"
)

visual_1_RMSE <- melt(visual_1_RMSE, id.vars = c("cluster_label"))

visual_1_RMSE[, cal_val := ifelse(grepl(pattern = "trn", x = as.character(variable)), 'Train', 'Test')]


ggplot(data = visual_1_RMSE) +
  geom_boxplot(aes(x = variable,  y = value, fill = cal_val), outlier.shape = NA) +
  facet_wrap( ~ cluster_label, nrow = 1) +
  ylim(c(0, 1.2)) +
  labs(title = paste0(target_node, "Prediciton Results (RMSE); ", var_name," Variables Clusters"),
       x = "Model", y = "RMSE") +
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        axis.text = element_text(size = 15),
        axis.title = element_text(size = 15),
        legend.position = 'bottom',
        legend.title = element_blank(),
        legend.key.size = unit(1, 'cm'))



# ------------------------------------------------------------------------------
# data_for_visual_climate <- copy(prediction_results_cluster_climate)
# data_for_visual_climate[grepl(pattern = 'cluster', x = cluster), cluster:= 'Climate cluster']
# data_for_visual_climate[grepl(pattern = 'whole', x = cluster), cluster := 'No cluster']
# 
# data_for_visual_climate <- 
#   data_for_visual_climate[!grepl(pattern = 'No cluster', x = cluster), ]
# 
# 
# data_for_visual_geology <- copy(prediction_results_cluster_geol)
# data_for_visual_geology[grepl(pattern = 'cluster', x = cluster), cluster:= 'Geology cluster']
# data_for_visual_geology[grepl(pattern = 'whole', x = cluster), cluster := 'No cluster']
# 
# 
# data_for_visual_soil <- copy(prediction_results_cluster_soil)
# data_for_visual_soil[grepl(pattern = 'cluster', x = cluster), cluster:= 'Soil cluster']
# data_for_visual_soil[grepl(pattern = 'whole', x = cluster), cluster := 'No cluster']
# 
# 
# data_for_visual_topography <- copy(prediction_results_cluster_topo)
# data_for_visual_topography[grepl(pattern = 'cluster', x = cluster), cluster:= 'Topography cluster']
# data_for_visual_topography[grepl(pattern = 'whole', x = cluster), cluster := 'No cluster']
# 
# 
# data_for_visual_vegetation <- copy(prediction_results_cluster_vege)
# data_for_visual_vegetation[grepl(pattern = 'cluster', x = cluster), cluster:= 'Vegetation cluster']
# data_for_visual_vegetation[grepl(pattern = 'whole', x = cluster), cluster := 'No cluster']
# 
# 
# data_for_visual_whole <- copy(prediction_results_whole_cluster)
# data_for_visual_whole[grepl(pattern = 'cluster', x = cluster), cluster:= 'Whole cluster']
# data_for_visual_whole[grepl(pattern = 'whole', x = cluster), cluster := 'No cluster']
# 
# 
# 
# 
# 
# visual_1 <- data_for_visual[, c(
#   "BN Cal",
#   "BN Val",
#   "GAM~Par Cal",
#   "GAM~Par Val",
#   "GAM~All Cal",
#   "GAM~All Val",
#   "RF~Par Cal",
#   "RF~Par Val",
#   "RF~All Cal",
#   "RF~All Val",
#   "cluster"
# )]
# names(visual_1) <- c(
#   "BN-trn",
#   "BN-tst",
#   "GAM~Par-trn",
#   "GAM~Par-tst",
#   "GAM~All-trn",
#   "GAM~All-tst",
#   "RF~Par-trn",
#   "RF~Par-tst",
#   "RF~All-trn",
#   "RF~All-tst",
#   "cluster"
# )
# 
# visual_1 <- melt(visual_1, id.vars = c('cluster'))
# 
# visual_1[, cal_val := ifelse(endsWith(x = as.character(variable), suffix = "trn"), 'Train', 'Test')]
# # visual_1[, cluster := factor(cluster)]
# # levels(visual_1$cluster)
# 
# ggplot(data = visual_1, aes(x = variable,  y = value, fill = cal_val)) +
#   geom_boxplot(outlier.shape = NA) +
#   facet_wrap( ~ cluster, nrow = 1) +
#   labs(title = paste0("Prediciton results (R squared); ", var_name, " Variables Clusters"),
#        x = "Model", y = "R-squared") +
#   theme_bw() +
#   theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
#         axis.text = element_text(size = 15),
#         axis.title = element_text(size = 15),
#         legend.position = 'bottom',
#         legend.title = element_blank(),
#         legend.key.size = unit(1, 'cm'))
# 
# # RMSE
# visual_1_RMSE <-
#   data_for_visual[, c(
#     "BN Cal (RMSE)",
#     "BN Val (RMSE)",
#     "GAM~Par Cal (RMSE)",
#     "GAM~Par Val (RMSE)",
#     "GAM~All Cal (RMSE)",
#     "GAM~All Val (RMSE)",
#     "RF~Par Cal (RMSE)",
#     "RF~Par Val (RMSE)",
#     "RF~All Cal (RMSE)",
#     "RF~All Val (RMSE)",
#     "cluster"
#   )]
# 
# names(visual_1_RMSE) <- c(
#   "BN-trn",
#   "BN-tst",
#   "GAM~Par-trn",
#   "GAM~Par-tst",
#   "GAM~All-trn",
#   "GAM~All-tst",
#   "RF~Par-trn",
#   "RF~Par-tst",
#   "RF~All-trn",
#   "RF~All-tst",
#   "cluster"
# )
# 
# visual_1_RMSE <- melt(visual_1_RMSE, id.vars = c('cluster'))
# 
# visual_1_RMSE[, cal_val := ifelse(grepl(pattern = "trn", x = as.character(variable)), 'Train', 'Test')]
# 
# 
# ggplot(data = visual_1_RMSE) +
#   geom_boxplot(aes(x = variable,  y = value, fill = cal_val), outlier.shape = NA) +
#   facet_wrap( ~ cluster, nrow = 1) +
#   ylim(c(0, 0.6)) +
#   labs(title = paste0("Prediciton results (RMSE); ", var_name, " Variables Clusters"),
#        x = "Model", y = "RMSE") +
#   theme_bw()+
#   theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
#         axis.text = element_text(size = 15),
#         axis.title = element_text(size = 15),
#         legend.position = 'bottom',
#         legend.title = element_blank(),
#         legend.key.size = unit(1, 'cm'))
# 


# # pred_redults_1 <- pred_redults[cluster == 1, ]
# prediction_results_cluster_climate[, cluster := paste0('climate_', cluster)]
# prediction_results_cluster_geol[, cluster := paste0('geology_', cluster)]
# prediction_results_cluster_soil[, cluster := paste0('soil_', cluster)]
# prediction_results_cluster_topo[, cluster := paste0('topography_', cluster)]
# prediction_results_cluster_vege[, cluster := paste0('vegetation_', cluster)]
# prediction_results_cluster <- rbind(prediction_results_cluster_climate, 
#                                     prediction_results_cluster_geol,
#                                     prediction_results_cluster_soil, 
#                                     prediction_results_cluster_topo,
#                                     prediction_results_cluster_vege)
# 
# 
# visual_1 <- prediction_results_cluster[, c("BN","gam_parents","gam_all","rf_parents","rf_all", "cluster")]
# visual_1 <- melt(visual_1, id.vars = c('cluster'))
# 
# 
# ggplot(data = visual_1, aes(x = variable,  y = value)) +
#   geom_boxplot(outlier.shape = NA) +
#   facet_wrap( ~ cluster) +
#   labs(title = "Prediciton results (R squared); Geol Clustering",
#        x = "Model", y = "R-squared") +
#   theme_bw()




# -------------------------------------------------------------------------------
# prediction_results_whole_data <- readRDS('./results_data/preciction_results_whole_data.rds')
# 
# 
# visual_1 <- prediction_results_whole_data[, c("BN","gam_parents","gam_all","rf_parents","rf_all")]
# visual_1 <- melt(visual_1)
# 
# 
# ggplot(data = visual_1, aes(x = variable,  y = value)) +
#   geom_boxplot(outlier.shape = NA) +
#   labs(title = "Prediciton results (r squared); whole dataset",
#        x = "Model", y = "R-squared") +
#   theme_bw() +
#   theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
#         axis.text = element_text(size = 15),
#         axis.title = element_text(size = 15))
# 
# 
# visual_1_RMSE <- prediction_results_whole_data[, 
#                                                c("BN_RMSE",
#                                                  "gam_parents_RMSE",
#                                                  "gam_all_RMSE",
#                                                  "rf_parents_RMSE",
#                                                  "rf_all_RMSE")]
# 
# visual_1_RMSE <- melt(visual_1_RMSE)
# 
# ggplot(data = visual_1_RMSE) +
#   geom_boxplot(aes(x = variable,  y = value), outlier.shape = NA) +
#   ylim(c(0, 1.2)) +
#   labs(title = "Prediciton results (RMSE); whole dataset",
#        x = "Model", y = "RMSE") +
#   theme_bw()
