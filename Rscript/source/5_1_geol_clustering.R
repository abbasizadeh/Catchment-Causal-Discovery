# cluster analysis of geological variables for slope of fdc

cluster_data <- copy(camels_geol)

# any_na(cluster_data)                       # any NAs
# n_miss(cluster_data)                       # number of NAs
# prop_miss(cluster_data)                    # NAs/(total number of vars)
# prop_complete(cluster_data)                # (total-NA)/total
# miss_var_summary(cluster_data)             # summary of missing values
# vis_miss(cluster_data)                     # visualization of missing values
# vis_miss(cluster_data, cluster = TRUE)     #       //
# gg_miss_var(cluster_data)                  #       //



# ----------------------------------------------------------- geology clustering
# check if there is still any NA value
# cluster_data[is.na(cluster_data), ]

cluster_data[is.na(geol_porosity), 
             geol_porosity := mean(cluster_data$geol_porosity, na.rm = TRUE)]


# as.data.table(lapply(cluster_data[, -1, with = FALSE], scale))
scaled_data <- as.data.table(lapply(cluster_data[,-c(1, 2, 4)], scale))
scaled_data <- cbind(scaled_data, cluster_data[,c(2, 4)])

# scaled_data
# scaled_data <- as.data.table(lapply(cluster_data[, -c(1)], scale))


# mixed categorical and numeric clustering using Gower score
scaled_data[, geol_2nd_class := NULL]
scaled_data[, glim_2nd_class_frac := NULL]


scaled_data[, geol_1st_class := as.factor(geol_1st_class)]


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
# 
# # the best Silhouet score is for k = 7
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
# 
# # Plot the relationship between k and sil_width
# ggplot(elbow_df, aes(x = k, y = tot_withinss)) +
#   geom_line() +
#   scale_x_continuous(breaks = 1:20)
# 

# kmean method with k = 7
cluster_model_geol_kmean <- pam(x = scaled_data, k = 7)

# add the clusters to the dataste
segment_geol_kmean_complete <-
  mutate(cluster_data, cluster_hc = cluster_model_geol_kmean$clustering)

print(count(segment_geol_kmean_complete, cluster_hc))


merge_data <- segment_geol_kmean_complete[, c('gauge_id', 'cluster_hc')]
selected_data_slope_fdc <- merge(selected_data_slope_fdc, merge_data, by = 'gauge_id')

# ALL_SIGNATURES <- merge(ALL_SIGNATURES, merge_data, by = 'gauge_id')
rm(scaled_data, 
   merge_data, 
   cluster_data, 
   cluster_model_geol_kmean, 
   segment_geol_kmean_complete,
   d_dist)



# # hierarchical clustering
# hc <- hclust(d_dist, method = "complete")
# 
# 
# # # plot dendrogram
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
# rm(segment_hc_complete, merge_data, hc, cluster_data, scaled_data, cluster, d_dist)

# count(ALL_SIGNATURES, cluster_hc)
# count(selected_data_slope_fdc, cluster_hc)

