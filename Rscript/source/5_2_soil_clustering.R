# cluster analysis of soil signatures for slope of fdc


cluster_data <- copy(camels_soil)

# check NAs
# miss_var_summary(camels_soil)             # summary of missing values
# vis_miss(camels_soil)                     # visualization of missing values
# there is no NA values

# Find columns with categorical variables
# there is no categorical values


# as.data.table(lapply(camels_soil[, -1, with = FALSE], scale))
scaled_soil <- as.data.table(lapply(camels_soil[,-c(1)], scale))
scaled_soil


# # K mean -----------------------------------------------------------------------
# # calulate the distance between the columns
# soil_dist <- dist(x = scaled_soil, method = 'euclidean')
# # Use map_dbl to run many models with varying value of k (centers)
# tot_withinss <- map_dbl(1:20,  function(k){
#   model <- kmeans(x = scaled_soil, centers = k)
#   model$tot.withinss
# })
# 
# # finding the best number of clusters using Elbow and Silhouette method
# # Generate a data frame containing both k and tot_withinss
# 
# # Elbow method
# elbow_df <- data.frame(
#   k = 1:20,
#   tot_withinss = tot_withinss
# )
# 
# # Plot the relationship between k and sil_width
# ggplot(elbow_df, aes(x = k, y = tot_withinss)) +
#   geom_line() +
#   scale_x_continuous(breaks = 1:20)
# 
# # Silhouette method
# # Use map_dbl to run many models with varying value of k
# sil_width <- map_dbl(2:20,  function(k){
#   model <- pam(x = scaled_soil, k = k)
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

# the best Silhouet score is for k = 7

# kmean method with k = 7
cluster_model_geol_kmean <- pam(x = scaled_soil, k = 6)

# add the clusters to the dataste
segment_geol_kmean_complete <-
  mutate(cluster_data, cluster_hc = cluster_model_geol_kmean$clustering)

print(count(segment_geol_kmean_complete, cluster_hc))


merge_data <- segment_geol_kmean_complete[, c('gauge_id', 'cluster_hc')]
selected_data_slope_fdc <- merge(selected_data_slope_fdc, merge_data, by = 'gauge_id')
# ALL_SIGNATURES <- merge(ALL_SIGNATURES, merge_data, by = 'gauge_id')
rm(scaled_soil, 
   merge_data, 
   cluster_data, 
   cluster_model_geol_kmean, 
   segment_geol_kmean_complete)


# a <- merge(selected_data_slope_fdc, camels_soil, by = 'gauge_id')
# selected_data_slope_fdc[, mean(clay_frac), by = cluster_hc]
# a[, mean(sand_frac), by = cluster_hc]
# a[, mean(silt_frac), by = cluster_hc]

# # hc clustering ----------------------------------------------------------------
# # calculate distance
# soil_dist <- daisy(x = scaled_soil, metric = 'euclidean')
# 
# # hierarchical clustering
# hc <- hclust(soil_dist, method = 'complete')
# 
# # choose k, number of clusters
# cluster <- cutree(hc, k = 5)
# 
# plot(hc, labels = FALSE)
# rect.hclust(hc, k = 5, border = "red")
# 
# 
# # Generate the segmented customers data frame
# segment_hc_complete <-
#   mutate(selected_data_slope_fdc, cluster_hc = as.factor(cluster))
# 
# merge_data <- segment_hc_complete[, c('gauge_id', 'cluster_hc')]
# 
# selected_data_slope_fdc <- merge(selected_data_slope_fdc, merge_data, by = 'gauge_id')
# # Count the number of customers that fall into each cluster
# 
# print(count(selected_data_slope_fdc, cluster_hc))



# camels_clim, camels_soil, camels_hydro, camels_name, camels_soil, camels_topo, camels_vege
# rm(merge_data, scaled_soil, cluster_data, hc, segment_hc_complete, cluster, soil_dist)

