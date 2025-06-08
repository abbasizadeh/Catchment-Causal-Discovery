# ##############################################################################
#                                                                              #
#               Count the number of catchments in each cluster                 #
#                      for all runoff signatures                               #
# ##############################################################################

# count the number of clusters in the geol cluster 
source('./source/5_1_geol_clustering.R')
cluster_number_geol <- count(selected_data_slope_fdc, cluster_hc)
cluster_number_geol$ratio = NA
cluster_number_geol[, ratio := n/sum(n)]
selected_data_slope_fdc[, cluster_hc:= NULL]


# count the number of clusters in the soil cluster
source('./source/5_2_soil_clustering.R')
cluster_number_soil <- count(selected_data_slope_fdc, cluster_hc)
cluster_number_soil$ratio = NA
cluster_number_soil[, ratio := n/sum(n)]
selected_data_slope_fdc[, cluster_hc:= NULL]


# count the number of clusters in the topo cluster
source('./source/5_3_topo_clustering.R')
cluster_number_topo <- count(selected_data_slope_fdc, cluster_hc)
cluster_number_topo$ratio = NA
cluster_number_topo[, ratio := n/sum(n)]
selected_data_slope_fdc[, cluster_hc:= NULL]


# count the number of clusters in the vege cluster
source('./source/5_4_vege_clustering.R')
cluster_number_vege <- count(selected_data_slope_fdc, cluster_hc)
cluster_number_vege$ratio = NA
cluster_number_vege[, ratio := n/sum(n)]
selected_data_slope_fdc[, cluster_hc:= NULL]


# count the number of clusters in the climate cluster
source('./source/5_5_climate_clustering.R')
cluster_number_climate <- count(selected_data_slope_fdc, cluster_hc)
cluster_number_climate$ratio = NA
cluster_number_climate[, ratio := n/sum(n)]
selected_data_slope_fdc[, cluster_hc:= NULL]


# count the number of clusters in the whole data cluster
source('./source/5_6_whole_dataset_clustering.R')
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

