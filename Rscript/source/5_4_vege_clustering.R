# cluster analysis of sinatures for slope of fdc

cluster_data <- copy(camels_vege)


any_na(camels_vege)                       # any NAs
# n_miss(camels_vege)                       # number of NAs
# prop_miss(camels_vege)                    # NAs/(total number of vars)
# prop_complete(camels_vege)                # (total-NA)/total
miss_var_summary(camels_vege)             # summary of missing values
# vis_miss(camels_vege)                     # visualization of missing values
# vis_miss(camels_vege, cluster = TRUE)     #       //
# gg_miss_var(camels_vege)                  #       //

cluster_data[, root_depth_50:= NULL]
cluster_data[, root_depth_99:= NULL]
miss_var_summary(cluster_data)

# -------------------------------------------------------- vegetation clustering
# replace NA by mean value of geol prosisty
# cluster_data[is.na(root_depth_50), root_depth_50 :=
#               mean(cluster_data$root_depth_50, na.rm = TRUE)]
# 
# cluster_data[is.na(root_depth_99), root_depth_99 :=
#               mean(cluster_data$root_depth_99, na.rm = TRUE)]

# cluster_data[, root_depth_50 := NULL]
# cluster_data[, root_depth_99 := NULL]

# Find columns with categorical variables
character_columns <- sapply(camels_vege, is.character)
character_column_names <- names(camels_vege)[character_columns]
character_column_names



# as.data.table(lapply(cluster_data[, -1, with = FALSE], scale))
scaled_data <- as.data.table(lapply(cluster_data[,-c(1, 8)], scale))
scaled_data <- cbind(scaled_data, cluster_data[,c(8)])

# scaled_data
# scaled_data <- as.data.table(lapply(cluster_data[, -c(1)], scale))

scaled_data[, dom_land_cover := as.factor(dom_land_cover)]


# calculate distance
d_dist <- daisy(scaled_data, metric = "gower")

# K mean -----------------------------------------------------------------------
# calulate the distance between the columns
# 
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
# # the best Silhouet score is for k = 6
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

# # Plot the relationship between k and sil_width
# ggplot(elbow_df, aes(x = k, y = tot_withinss)) +
#   geom_line() +
#   scale_x_continuous(breaks = 1:20)



# kmean method with k = 6
cluster_model_geol_kmean <- pam(x = scaled_data, k = 6)

# add the clusters to the dataste
segment_geol_kmean_complete <-
  mutate(cluster_data, cluster_hc = cluster_model_geol_kmean$clustering)

print(count(segment_geol_kmean_complete, cluster_hc))


merge_data <- segment_geol_kmean_complete[, c('gauge_id', 'cluster_hc')]
selected_data_slope_fdc <- merge(selected_data_slope_fdc, merge_data, by = 'gauge_id')
# ALL_SIGNATURES <- merge(ALL_SIGNATURES, merge_data, by = 'gauge_id')
rm(scaled_data, merge_data, cluster_data, cluster_model_geol_kmean, segment_geol_kmean_complete,
   d_dist, character_column_names, character_columns)





# calculate distance
# d_dist <- daisy(scaled_data, metric = "gower")
# 
# # hierarchical clustering
# hc <- hclust(d_dist, method = "complete")
# 
# 
# # plot dendrogram
# # plot(hc, labels = FALSE)
# # rect.hclust(hc, k = 4, border = "red")
# 
# # dend_geol_complete <- as.dendrogram(hc)
# # plot(color_branches(dend_geol_complete, h = 0.62))
# 
# # choose k, number of clusters
# cluster <- cutree(hc, k = 4)
# # add cluster to original data
# scaled_data <- cbind(scaled_data, as.factor(cluster))
# 
# 
# segment_hc_complete <-
#   mutate(cluster_data, cluster_hc = scaled_data$V2)
# 
# print('clustering geological variables according to the Gower score: ')
# print(count(segment_hc_complete, cluster_hc))
# 
# merge_data <- segment_hc_complete[, c('gauge_id', 'cluster_hc')]
# # ALL_SIGNATURES <- merge(ALL_SIGNATURES, merge_data, by = 'gauge_id')
# selected_data_slope_fdc <- merge(selected_data_slope_fdc, merge_data, by = 'gauge_id')
# 
# # cluster_data, camels_geol, camels_hydro, camels_name, camels_soil, camels_vege, camels_vege
# rm(segment_hc_complete, merge_data, hc, cluster_data, scaled_data, cluster, d_dist, character_column_names, character_columns)
# 
# # count(ALL_SIGNATURES, cluster_hc)
# # count(selected_data_slope_fdc, cluster_hc)

