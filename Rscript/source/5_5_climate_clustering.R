# cluster analysis of sinatures for slope of fdc

cluster_data <- copy(camels_clim)

# any_na(camels_clim)                       # any NAs
# n_miss(camels_clim)                       # number of NAs
# prop_miss(camels_clim)                    # NAs/(total number of vars)
# prop_complete(camels_clim)                # (total-NA)/total
# miss_var_summary(camels_clim)             # summary of missing values
# vis_miss(camels_clim)                     # visualization of missing values
# vis_miss(camels_clim, cluster = TRUE)     #       //
# gg_miss_var(camels_clim)                  #       //

# ----------------------------------------------------------- climate clustering
# scaled_data <- as.data.table(lapply(cluster_data[,-c(1)], scale))
# scaled_data <- scaled_data[, c(3, 4, 5)]

# Find columns with categorical variables
character_columns <- sapply(camels_clim, is.character)
character_column_names <- names(camels_clim)[character_columns]
character_column_names



# as.data.table(lapply(cluster_data[, -1, with = FALSE], scale))
scaled_data <- as.data.table(lapply(cluster_data[,-c(1, 9, 12)], scale))
scaled_data <- cbind(scaled_data, cluster_data[,c(9, 12)])

# scaled_data
# scaled_data <- as.data.table(lapply(cluster_data[, -c(1)], scale))

scaled_data[, high_prec_timing := as.factor(high_prec_timing)]
scaled_data[, low_prec_timing := as.factor(low_prec_timing)]


# calculate distance
d_dist <- daisy(scaled_data, metric = "gower")

# K mean -----------------------------------------------------------------------
# calulate the distance between the columns


# # Silhouette method
# # Use map_dbl to run many models with varying value of k
# sil_width <- map_dbl(2:20,  function(k){
#   model <- pam(x = scaled_data, k = k)
#   model$silinfo$avg.width
# })
# 
# # Generate a data frame containing both k and sil_width
# sil_df <- data.frame(
#   k = 2:20,
#   sil_width = sil_width
# )
# 
# # Plot the relationship between k and sil_width
# ggplot(sil_df, aes(x = k, y = sil_width)) +
#   geom_line() +
#   scale_x_continuous(breaks = 2:20)
# 
# # the best Silhouet score is for k = 4
# 
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
# )
# 
# # Plot the relationship between k and sil_width
# ggplot(elbow_df, aes(x = k, y = tot_withinss)) +
#   geom_line() +
#   scale_x_continuous(breaks = 1:20)


# kmean method with k = 4
cluster_model_geol_kmean <- pam(x = scaled_data, k = 4)

# add the clusters to the dataste
segment_geol_kmean_complete <-
  mutate(camels_soil, cluster_hc = cluster_model_geol_kmean$clustering)

print(count(segment_geol_kmean_complete, cluster_hc))


merge_data <- segment_geol_kmean_complete[, c('gauge_id', 'cluster_hc')]
selected_data_slope_fdc <- merge(selected_data_slope_fdc, merge_data, by = 'gauge_id')
# ALL_SIGNATURES <- merge(ALL_SIGNATURES, merge_data, by = 'gauge_id')
rm(scaled_data, merge_data, cluster_data, cluster_model_geol_kmean, 
   segment_geol_kmean_complete, character_column_names, character_columns, d_dist)

