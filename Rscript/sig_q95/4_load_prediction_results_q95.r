# visualization of the prediction results

# working directory
setwd("D:/project/Spatial_variablity_paper/")

# load packages and data
source('./Rscripts/source/1_load_data_&_packages.R')


# # calculate number of clusters

source('./Rscripts/sig_q95/1_2_feature_selection_q95.R')


folder <- 'sig_q95'
target_node <- 'q95'


source('./Rscripts/source/7_calculate_number_of_clusters.R')
# selected_data_slope_fdc


# whole data set prediction
prediction_results_whole_data <- 
  readRDS(paste0('./results_data/preciction_results_whole_data_', target_node,'.rds'))

prediction_results_whole_data[, cluster := 0]

prediction_results_whole_data[, cluster_label := 'whole_dataset']


# predictors -------------------------------------------------------------------
prediction_results_predictors <-
  readRDS(
    paste0(
      './results_data/preciction_results_predictors_clustering_',
      target_node,
      '.rds'
    )
  )

# prediction_results_cluster_climate[ , cluster := as.character(cluster)]
clust_num = 1
for (i in cluster_number_predictors[, n]){
  
  prediction_results_predictors[cluster == clust_num,
                                     cluster_label := paste0('cluster ', cluster, '; ', i, ' catchments')]
  clust_num <- clust_num + 1
}



prediction_results_predictors <-
  rbind(prediction_results_predictors, prediction_results_whole_data)

prediction_results_predictors[cluster_label == 'whole_dataset', 
                                   cluster_label := paste0('whole dataset; ', sum(cluster_number_whole$n),' catchments')]

prediction_results_predictors[, cluster := as.numeric(cluster)]

setnames(x = cluster_number_predictors, old = 'cluster_hc', new = 'cluster')

prediction_results_predictors <- 
  merge(prediction_results_predictors, cluster_number_predictors, by = 'cluster', all = TRUE)


# climate cluster --------------------------------------------------------------
prediction_results_cluster_climate <-
  readRDS(
    paste0(
      './results_data/preciction_results_climate_clustering_',
      target_node,
      '.rds'
    )
  )

# prediction_results_cluster_climate[ , cluster := as.character(cluster)]
clust_num = 1
for (i in cluster_number_climate[, n]){
  
  prediction_results_cluster_climate[cluster == clust_num,
                                     cluster_label := paste0('cluster ', cluster, '; ', i, ' catchments')]
  clust_num <- clust_num + 1
}



prediction_results_cluster_climate <-
  rbind(prediction_results_cluster_climate, prediction_results_whole_data)

prediction_results_cluster_climate[cluster_label == 'whole_dataset', 
                                   cluster_label := paste0('whole dataset; ', sum(cluster_number_climate$n),' catchments')]

prediction_results_cluster_climate[, cluster := as.numeric(cluster)]

prediction_results_cluster_climate <- 
  merge(prediction_results_cluster_climate, cluster_number_climate, by = 'cluster', all = TRUE)

# geological cluster -----------------------------------------------------------
prediction_results_cluster_geol <- 
  readRDS(paste0('./results_data/preciction_results_geol_clustering_', target_node, '.rds'))

clust_num = 1
for (i in cluster_number_geol[, n]){
  
  prediction_results_cluster_geol[cluster == clust_num,
                                  cluster_label := paste0('cluster ', cluster, '; ', i, ' catchments')]
  clust_num <- clust_num + 1
}



prediction_results_cluster_geol <-
  rbind(prediction_results_cluster_geol, prediction_results_whole_data)

prediction_results_cluster_geol[cluster_label == 'whole_dataset', 
                                cluster_label := paste0('whole dataset; ', sum(cluster_number_climate$n),' catchments')]

prediction_results_cluster_geol[, cluster := as.numeric(cluster)]

prediction_results_cluster_geol <- 
  merge(prediction_results_cluster_geol, cluster_number_geol, by = 'cluster', all = TRUE)


# soil cluster -----------------------------------------------------------------
prediction_results_cluster_soil <-
  readRDS(
    paste0(
      './results_data/preciction_results_soil_clustering_',
      target_node,
      '.rds'
    )
  )

clust_num = 1
for (i in cluster_number_soil[, n]){
  
  prediction_results_cluster_soil[cluster == clust_num,
                                  cluster_label := paste0('cluster ', cluster, '; ', i, ' catchments')]
  clust_num <- clust_num + 1
}


prediction_results_cluster_soil <-
  rbind(prediction_results_cluster_soil, prediction_results_whole_data)

prediction_results_cluster_soil[cluster_label == 'whole_dataset', 
                                cluster_label := paste0('whole dataset; ', sum(cluster_number_climate$n),' catchments')]


prediction_results_cluster_soil[, cluster := as.numeric(cluster)]

prediction_results_cluster_soil <- 
  merge(prediction_results_cluster_soil, cluster_number_soil, by = 'cluster', all = TRUE)


# topography cluster -----------------------------------------------------------
prediction_results_cluster_topo <-
  readRDS(
    paste0(
      './results_data/preciction_results_topo_clustering_',
      target_node,
      '.rds'
    )
  )

clust_num = 1
for (i in cluster_number_topo[, n]){
  
  prediction_results_cluster_topo[cluster == clust_num,
                                  cluster_label := paste0('cluster ', cluster, '; ', i, ' catchments')]
  clust_num <- clust_num + 1
}


prediction_results_cluster_topo <-
  rbind(prediction_results_cluster_topo, prediction_results_whole_data)

prediction_results_cluster_topo[cluster_label == 'whole_dataset', 
                                cluster_label := paste0('whole dataset; ', sum(cluster_number_climate$n),' catchments')]

prediction_results_cluster_topo[, cluster := as.numeric(cluster)]

prediction_results_cluster_topo <- 
  merge(prediction_results_cluster_topo, cluster_number_topo, by = 'cluster', all = TRUE)

# vegetation or land cover cluster ---------------------------------------------
prediction_results_cluster_vege <-
  readRDS(paste0(
    './results_data/preciction_results_veg_clustering_',
    target_node,
    '.rds'
  ))

clust_num = 1
for (i in cluster_number_vege[, n]){
  
  prediction_results_cluster_vege[cluster == clust_num,
                                  cluster_label := paste0('cluster ', cluster, '; ', i, ' catchments')]
  clust_num <- clust_num + 1
}


prediction_results_cluster_vege <-
  rbind(prediction_results_cluster_vege, prediction_results_whole_data)

prediction_results_cluster_vege[cluster_label == 'whole_dataset', 
                                cluster_label := paste0('whole dataset; ', sum(cluster_number_climate$n),' catchments')]

prediction_results_cluster_vege[, cluster := as.numeric(cluster)]

prediction_results_cluster_vege <- 
  merge(prediction_results_cluster_vege, cluster_number_vege, by = 'cluster', all = TRUE)


# all variable cluster ---------------------------------------------------------
prediction_results_whole_cluster <-
  readRDS(
    paste0(
      './results_data/preciction_results_whole_data_clustering_',
      target_node,
      '.rds'
    )
  )

clust_num = 1
for (i in cluster_number_whole[, n]){
  
  prediction_results_whole_cluster[cluster == clust_num,
                                   cluster_label := paste0('cluster ', cluster, '; ', i, ' catchments')]
  clust_num <- clust_num + 1
}


prediction_results_whole_cluster <-
  rbind(prediction_results_whole_cluster, prediction_results_whole_data)

prediction_results_whole_cluster[cluster_label == 'whole_dataset', 
                                 cluster_label := paste0('whole dataset; ', sum(cluster_number_climate$n),' catchments')]

prediction_results_whole_cluster[, cluster := as.numeric(cluster)]

prediction_results_whole_cluster <- 
  merge(prediction_results_whole_cluster, cluster_number_whole, by = 'cluster', all = TRUE)

rm(clust_num, i)
