
# number of catchments in each cluster

# selected_data_slope_fdc[, cluster_hc:= NULL]


source(paste0('./Rscripts/', folder,'/7_3_clustering_predictors_', target_node,'.R'))

cluster_number_predictors <- count(selected_data_slope_fdc, cluster_hc)
cluster_number_predictors$ratio = NA
cluster_number_predictors[, ratio := n/sum(n)]
selected_data_slope_fdc[, cluster_hc:= NULL]



source('./Rscripts/source/5_1_geol_clustering.R')
cluster_number_geol <- count(selected_data_slope_fdc, cluster_hc)
cluster_number_geol$ratio = NA
cluster_number_geol[, ratio := n/sum(n)]
selected_data_slope_fdc[, cluster_hc:= NULL]



source('./Rscripts/source/5_2_soil_clustering.R')
cluster_number_soil <- count(selected_data_slope_fdc, cluster_hc)
cluster_number_soil$ratio = NA
cluster_number_soil[, ratio := n/sum(n)]
selected_data_slope_fdc[, cluster_hc:= NULL]


source('./Rscripts/source/5_3_topo_clustering.R')
cluster_number_topo <- count(selected_data_slope_fdc, cluster_hc)
cluster_number_topo$ratio = NA
cluster_number_topo[, ratio := n/sum(n)]
selected_data_slope_fdc[, cluster_hc:= NULL]


source('./Rscripts/source/5_4_vege_clustering.R')
cluster_number_vege <- count(selected_data_slope_fdc, cluster_hc)
cluster_number_vege$ratio = NA
cluster_number_vege[, ratio := n/sum(n)]
selected_data_slope_fdc[, cluster_hc:= NULL]


source('./Rscripts/source/5_5_climate_clustering.R')
cluster_number_climate <- count(selected_data_slope_fdc, cluster_hc)
cluster_number_climate$ratio = NA
cluster_number_climate[, ratio := n/sum(n)]
selected_data_slope_fdc[, cluster_hc:= NULL]

source('./Rscripts/source/5_6_whole_dataset_clustering.R')
cluster_number_whole <- count(selected_data_slope_fdc, cluster_hc)
cluster_number_whole$ratio = NA
cluster_number_whole[, ratio := n/sum(n)]
selected_data_slope_fdc[, cluster_hc:= NULL]


setnames(x = cluster_number_geol, old = 'cluster_hc', new = 'cluster')
setnames(x = cluster_number_soil, old = 'cluster_hc', new = 'cluster')
setnames(x = cluster_number_topo, old = 'cluster_hc', new = 'cluster')
setnames(x = cluster_number_vege, old = 'cluster_hc', new = 'cluster')
setnames(x = cluster_number_climate, old = 'cluster_hc', new = 'cluster')
setnames(x = cluster_number_whole, old = 'cluster_hc', new = 'cluster')


# rm(cluster_number_climate,
#    cluster_number_geol,
#    cluster_number_soil,
#    cluster_number_topo,
#    cluster_number_vege,
#    cluster_number_whole)


# # climate 
# clim_clust_catch_num <-
#   data.frame(
#     cluster_1 = 334,
#     cluster_2 = 145,
#     cluster_3 = 88,
#     cluster_4 = 104,
#     whole_dataset = 671
#   )
# 
# sum_climate <- 334 + 145 + 88 + 104 
# (334/sum_climate * 0.61)+ 
#   (145/sum_climate * 0.48) + 
#   (88/sum_climate * 0.62) + 
#   (104/sum_climate * 0.56) 
# 
# 
# # geology
# geol_clust_catch_num <-
#   data.frame(
#     cluster_1 = 149,
#     cluster_2 = 53,
#     cluster_3 = 123,
#     cluster_4 = 118,
#     cluster_5 = 81,
#     cluster_6 = 104,
#     cluster_7 = 43,
#     whole_dataset = 671
#   )
# 
# sum_geol <- 149 + 53 + 123 +118 + 81 + 104 + 43
# (149/sum_geol * 0.72)+ 
#   (53/sum_geol * 0.55) + 
#   (123/sum_geol * 0.65) + 
#   (118/sum_geol * 0.45) +  
#   (81/sum_geol * 0.31) + 
#   (104/sum_geol * 0.60) + 
#   (43/sum_geol *0.72)
# 
# 
# 
# # soil
# soil_clust_catch_num <-
#   data.frame(
#     cluster_1 = 155,
#     cluster_2 = 100,
#     cluster_3 = 138,
#     cluster_4 = 90,
#     cluster_5 = 25,
#     cluster_6 = 95,
#     cluster_7 = 68,
#     whole_dataset = 671
#   )
# 
# sum_soil <- 155 + 100 + 138 + 90 + 25 + 95 + 68
# (155/sum_soil *0.71)+ 
#   (100/sum_soil * 0.54) + 
#   (138/sum_soil * 0.73) + 
#   (90/sum_soil * 0.69) +  
#   (25/sum_soil * 0.31) + 
#   (95/sum_soil * 0.74) + 
#   (68/sum_soil * 0.53)
# 
# 
# # topography
# topo_clust_catch_num <-
#   data.frame(
#     cluster_1 = 56,
#     cluster_2 = 81,
#     cluster_3 = 76,
#     cluster_4 = 145,
#     cluster_5 = 93,
#     cluster_6 = 113,
#     cluster_7 = 22,
#     cluster_8 = 85,
#     whole_dataset = 671
#   )
# 
# sum_topo <- 56 + 81 + 76 + 145 + 93 + 113 + 22 + 82
# (56/sum_topo * 0.55)+ 
#   (81/sum_topo * 0.26) + 
#   (76/sum_topo * 0.39) + 
#   (145/sum_topo * 0.60) +  
#   (93/sum_topo * 0.89) + 
#   (113/sum_topo * 0.64) + 
#   (22/sum_topo * 0.28) +
#   (82/sum_topo * 0.30) 
# 
# 
# # vegetation
# vege_clust_catch_num <-
#   data.frame(
#     cluster_1 = 89,
#     cluster_2 = 131,
#     cluster_3 = 146,
#     cluster_4 = 69,
#     cluster_5 = 106,
#     cluster_6 = 130,
#     whole_dataset = 671
#   )
# 
# sum_vege <- 89 + 131 + 146 + 69 + 106 + 130 
# (89/sum_vege * 0.39)+ 
#   (131/sum_vege * 0.62) + 
#   (146/sum_vege * 0.56) + 
#   (69/sum_vege * 0.54) +  
#   (106/sum_vege * 0.55) + 
#   (130/sum_vege * 0.42) 
# 
# 
# # vegetation
# sum_whole <- 95 + 49 + 55 + 68 + 59 + 31 + 44 + 15 + 44 + 48 + 47 + 53 + 23 + 36
# (95/sum_whole * 0.31)+ 
#   (49/sum_whole * 0.17) + 
#   (55/sum_whole * 0.15) + 
#   (68/sum_whole * 0.33) +
#   (59/sum_whole * 0.32) +
#   (31/sum_whole * 0.81) +
#   (44/sum_whole * 0.09) +
#   (15/sum_whole * 0.001) +
#   (44/sum_whole * 0.22) +
#   (48/sum_whole * 0.49) +
#   (47/sum_whole * 0.24) +
#   (53/sum_whole * 0.36) +
#   (23/sum_whole * 0.21) +
#   (36/sum_whole * 0.26) 
# 
# 
# 
