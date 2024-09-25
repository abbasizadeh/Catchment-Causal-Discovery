# cluster analysis of sinatures for slope of fdc

cluster_data <- copy(ALL_SIGNATURES)

cluster_data[, gauge_name := NULL]
cluster_data[, gauge_lon := NULL]
cluster_data[, huc_02 := NULL]

# any_na(cluster_data)                       # any NAs
# n_miss(cluster_data)                       # number of NAs
# prop_miss(cluster_data)                    # NAs/(total number of vars)
# prop_complete(cluster_data)                # (total-NA)/total
# miss_var_summary(cluster_data)             # summary of missing values
# vis_miss(cluster_data)                     # visualization of missing values
# vis_miss(cluster_data, cluster = TRUE)     #       //
# gg_miss_var(cluster_data)                  #       //

cluster_data[, geol_2nd_class:= NULL]
cluster_data[, glim_2nd_class_frac:= NULL]
cluster_data[, root_depth_50:= NULL]
cluster_data[, root_depth_99:= NULL]

cluster_data <- na.omit(cluster_data)
cluster_data <- 
  cluster_data[, -c('q_mean', 
                  'runoff_ratio', 
                  'baseflow_index', 
                  'stream_elas', 
                  'q5',
                  'q95',
                  'high_q_freq',
                  'low_q_freq',
                  'low_q_dur',
                  'zero_q_freq',
                  'high_q_dur',
                  'hfd_mean','slope_fdc')]

# Find columns with categorical variables
character_columns <- sapply(cluster_data, is.character)
character_column_names <- names(cluster_data)[character_columns]
character_column_names

head(cluster_data)


# cluster_data[,c(1, 2, 14, 17, 36)]
# as.data.table(lapply(cluster_data[, -1, with = FALSE], scale))
scaled_data <- as.data.table(lapply(cluster_data[,-c(1, 2, 14, 17, 40)], scale))
scaled_data <- cbind(scaled_data, cluster_data[,c(2, 14, 17, 40)])

# scaled_data
# scaled_data <- as.data.table(lapply(cluster_data[, -c(1)], scale))
scaled_data[, geol_1st_class := as.factor(geol_1st_class)]
scaled_data[, high_prec_timing := as.factor(high_prec_timing)]
scaled_data[, low_prec_timing := as.factor(low_prec_timing)]
scaled_data[, dom_land_cover := as.factor(dom_land_cover)]


# calculate distance
d_dist <- daisy(scaled_data, metric = "gower")

# K mean -----------------------------------------------------------------------
# calulate the distance between the columns


# # Silhouette method
# # Use map_dbl to run many models with varying value of k
# sil_width <- map_dbl(2:30,  function(k){
#   model <- pam(x = scaled_data, k = k)
#   model$silinfo$avg.width
# })
# 
# # Generate a data frame containing both k and sil_width
# sil_df <- data.frame(
#   k = 2:30,
#   sil_width = sil_width
# )
# 
# # Plot the relationship between k and sil_width
# ggplot(sil_df, aes(x = k, y = sil_width)) +
#   geom_line() +
#   scale_x_continuous(breaks = 2:30)
# # 
# 
# # Elbow method
# tot_withinss <- map_dbl(1:20,  function(k){
#   model <- pam(x = scaled_data, k = k)
#   mean(model$clusinfo[, 3])
# })
# 
# #
# elbow_df <- data.frame(
#   k = 1:20 ,
#   tot_withinss = tot_withinss
#  )
# 
# # Plot the relationship between k and sil_width
# ggplot(elbow_df, aes(x = k, y = tot_withinss)) +
#   geom_line() +
#   scale_x_continuous(breaks = 1:20)

# #-------------------------------------------------------------------------------
# # elbow method (Average Within-Cluster Distance to Centroid)
# elbow <- map_dbl(2:30,  function(k){
#   model <- pam(x = scaled_data, k = k)
#   model$clusinfo[1, 3]
# })
# 
# # Generate a data frame containing both k and sil_width
# elbow_df <- data.frame(
#   k = 2:30,
#   elbow = elbow
# )
# 
# # Plot the relationship between k and sil_width
# ggplot(sil_df, aes(x = k, y = sil_width)) +
#   geom_line() +
#   scale_x_continuous(breaks = 2:30)
# 
# 
# # the best Silhouet score is for k = 14
# # the best Silhouet score is for k = 11

# kmean method with k = 7
cluster_model_geol_kmean <- pam(x = scaled_data, k = 10)

# add the clusters to the dataste
segment_geol_kmean_complete <-
  mutate(cluster_data, cluster_hc = cluster_model_geol_kmean$clustering)

print(count(segment_geol_kmean_complete, cluster_hc))

merge_data <- segment_geol_kmean_complete[, c('gauge_id', 'cluster_hc')]
selected_data_slope_fdc <- merge(selected_data_slope_fdc, merge_data, by = 'gauge_id')
# ALL_SIGNATURES <- merge(ALL_SIGNATURES, merge_data, by = 'gauge_id')
rm(scaled_data, merge_data, cluster_data, cluster_model_geol_kmean, segment_geol_kmean_complete,
   character_column_names, character_columns, d_dist)
