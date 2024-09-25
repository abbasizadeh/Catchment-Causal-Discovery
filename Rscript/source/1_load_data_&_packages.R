
# general packages, data processing and visualization
library(data.table)
library(ggplot2)
library(dplyr)
library(naniar)
library(fixr)
library(caTools) # split sample training and test

# ML packages
library(caret)
library(randomForest)
library(mgcv) # nonlinear regression (gam)

# causal structural learning and graph visualization
library(pcalg)
library(BiocManager)

# BiocManager::install("Rgraphviz")
library(bnlearn)
library(qgraph)
library(psych)
library(grf)  # causal forest


# nonlinearICP: Nonlinear Invariant Causal Prediction
library(nonlinearICP)
library(CondIndTests)

# Independence test
library(dHSIC)
library(mgcv)

# data transformation (box cox method)
library(MASS)

# clustering
library(dendextend)
library(purrr)
library(cluster)

# spatial data
library(sf)
library(terra)
library(tmap)



setwd("D:/project/Spatial_variablity_paper/")

files <- list.files('./data/signatures/')

# load data camel US

for (i in 1:length(files)) {
  assign(gsub("\\..*","",files[i]), fread(paste0('./data/signatures/', files[i])))
}

ALL_SIGNATURES <- merge(camels_name, camels_geol, by = 'gauge_id')
ALL_SIGNATURES <- merge(ALL_SIGNATURES, camels_clim, by = 'gauge_id')
ALL_SIGNATURES <- merge(ALL_SIGNATURES, camels_soil, by = 'gauge_id')
ALL_SIGNATURES <- merge(ALL_SIGNATURES, camels_topo, by = 'gauge_id')
ALL_SIGNATURES <- merge(ALL_SIGNATURES, camels_vege, by = 'gauge_id')
ALL_SIGNATURES <- merge(ALL_SIGNATURES, camels_hydro, by = 'gauge_id')


setnames(ALL_SIGNATURES, old = "geol_porostiy", new = "geol_porosity")
setnames(camels_geol, old = "geol_porostiy", new = "geol_porosity")
# colnames(ALL_SIGNATURES)[colnames(ALL_SIGNATURES) == "geol_porostiy"] <- "geol_porosity"
# colnames(camels_geol)[colnames(camels_geol) == "geol_porostiy"] <- "geol_porosity"
rm(files, i)



# --------------------------------------------------------------------------- UK
# files_uk <- list.files('./data/signatures_UK/')
# 
# # load data camel US
# fread('./data/signatures_UK/CAMELS_GB_climatic_attributes.csv')
# 
# for (i in 1:length(files_uk)) {
#   assign(gsub("\\..*","",files_uk[i]), fread(paste0('./data/signatures_UK/', files_uk[i])))
# }
# 
# ALL_SIGNATURES_UK <-
#   merge(CAMELS_GB_climatic_attributes,
#         CAMELS_GB_humaninfluence_attributes,
#         by = 'gauge_id')
# ALL_SIGNATURES_UK <-
#   merge(ALL_SIGNATURES_UK,
#         CAMELS_GB_hydrogeology_attributes,
#         by = 'gauge_id')
# ALL_SIGNATURES_UK <-
#   merge(ALL_SIGNATURES_UK,
#         CAMELS_GB_hydrologic_attributes,
#         by = 'gauge_id')
# ALL_SIGNATURES_UK <-
#   merge(ALL_SIGNATURES_UK,
#         CAMELS_GB_hydrometry_attributes,
#         by = 'gauge_id')
# ALL_SIGNATURES_UK <-
#   merge(ALL_SIGNATURES_UK,
#         CAMELS_GB_landcover_attributes,
#         by = 'gauge_id')
# ALL_SIGNATURES_UK <-
#   merge(ALL_SIGNATURES_UK,
#         CAMELS_GB_topographic_attributes,
#         by = 'gauge_id')
# ALL_SIGNATURES_UK <-
#   merge(ALL_SIGNATURES_UK,
#         CAMELS_GB_soil_attributes,
#         by = 'gauge_id')
# 
# names(ALL_SIGNATURES_UK)
# rm(files_uk, i)
# 
# names(camels_geol)










# cluster_1 <- ALL_SIGNATURES[cluster_kmean == 1,]
# names(camels_geol)
# 
# geol_feature_clust_1_range <-
#   cluster_1[, .(
#     range(glim_1st_class_frac),
#     range(glim_2nd_class_frac),
#     range(carbonate_rocks_frac),
#     range(geol_porosity),
#     range(geol_permeability)
#   )]
# 
# names(geol_feature_clust_1_range) <- 
#   c('glim_1st_class_frac', 
#     'glim_2nd_class_frac', 
#     'carbonate_rocks_frac', 
#     'geol_porosity', 
#     'geol_permeability')
# 
# 
# climate_features_clust_1 <-
#   cluster_1[, .(
#     range(p_mean),
#     range(pet_mean),
#     range(p_seasonality),
#     range(high_prec_freq),
#     range(low_prec_freq)
#   )]
# 
# names(climate_features_clust_1) <- 
#   c('p_mean', 'pet_mean', 'p_seasonality', 'high_prec_freq', 'low_prec_freq')
# 
# climate_features_clust_1
# 
# names(camels_clim)
# 
# ALL_SIGNATURES_UK
# rm(cluster_1, clust_range)


