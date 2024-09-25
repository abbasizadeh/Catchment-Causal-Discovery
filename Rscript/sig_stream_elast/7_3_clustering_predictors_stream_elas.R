# cluster analysis of signatures for stream elast

cluster_data <- copy(selected_data_slope_fdc[, -c('stream_elas')])

# any_na(cluster_data)                       # any NAs
# n_miss(cluster_data)                       # number of NAs
# prop_miss(cluster_data)                    # NAs/(total number of vars)
# prop_complete(cluster_data)                # (total-NA)/total
# miss_var_summary(cluster_data)             # summary of missing values
# vis_miss(cluster_data)                     # visualization of missing values
# vis_miss(cluster_data, cluster = TRUE)     #       //
# gg_miss_var(cluster_data)                  #       //

# Find columns with categorical variables
# character_columns <- sapply(cluster_data, is.character)
# character_column_names <- names(cluster_data)[character_columns]
# character_column_names


# remove columns with large number of NAs
# cluster_data[ , c(character_column_names) := NULL]
# cluster_data

# cluster_data[is.na(geol_porosity), ]
# cluster_data[is.na(geol_porosity), 
#              geol_porosity := mean(cluster_data$geol_porosity, na.rm = TRUE)]




# as.data.table(lapply(cluster_data[, -1, with = FALSE], scale))
scaled_predictors <- as.data.table(lapply(cluster_data[, c(1)], scale))
# scaled_predictors


# K mean -----------------------------------------------------------------------
# # calulate the distance between the columns
# dist_predictors <- dist(x = scaled_predictors, method = 'euclidean')
# 
# 
# # Use map_dbl to run many models with varying value of k (centers)
# tot_withinss <- map_dbl(1:20,  function(k){
#   model <- kmeans(x = scaled_predictors, centers = k)
#   model$tot.withinss
# })
# 
# # finding the best number of clusters using Elbow and Silhouette method
# # Generate a data frame containing both k and tot_withinss
# 
# # Elbow method
# elbow_df <- data.frame(
#   k = 1:20 ,
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
#   model <- pam(x = scaled_predictors, k = k)
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
# # the best Silhouet score is for k = 3

# kmean method with k = 3
cluster_model_geol_kmean <- pam(x = scaled_predictors, k = 3)

# add the clusters to the dataste
segment_geol_kmean_complete <-
  mutate(cluster_data, cluster_hc = cluster_model_geol_kmean$clustering)

print(count(segment_geol_kmean_complete, cluster_hc))


merge_data <- segment_geol_kmean_complete[, c('gauge_id', 'cluster_hc')]
selected_data_slope_fdc <- merge(selected_data_slope_fdc, merge_data, by = 'gauge_id')

# ALL_SIGNATURES <- merge(ALL_SIGNATURES, merge_data, by = 'gauge_id')
rm(scaled_predictors, 
   merge_data, 
   cluster_data, 
   cluster_model_geol_kmean, 
   segment_geol_kmean_complete)



# hierarchical clustering 
# # calculate distance
# # dist_predictors <- dist(x = scaled_predictors, method = 'euclidean')
# dist_predictors <- daisy(x = scaled_predictors, metric = 'euclidean')
# 
# # hierarchical clustering
# hc <- hclust(dist_predictors, method = 'complete')
# 
# # choose k, number of clusters
# cluster <- cutree(hc, k = 5)
# 
# 
# # plot(hc, labels = FALSE)
# # rect.hclust(hc, k = 5, border = "red")
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
# 
# 
# 
# # camels_clim, camels_soil, camels_hydro, camels_name, camels_soil, cluster_data, camels_vege
# rm(merge_data, scaled_predictors, cluster_data, hc, segment_hc_complete, cluster, dist_predictors, scaled_data,
#    character_column_names, character_columns, geol_dist)
