
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
# library(pcalg)
# library(BiocManager)

# BiocManager::install("Rgraphviz")
library(bnlearn)
library(qgraph)
library(psych)
library(grf)  # causal forest


# nonlinearICP: Nonlinear Invariant Causal Prediction
library(nonlinearICP)
library(CondIndTests)
library(InvariantCausalPrediction)

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



# setwd("~/hossein_space/PhD/spatial_variability/modifed_R_scripts_Jonas_Peters/")

files <- list.files('./data/camel_data/signatures/')

# load data camel US

for (i in 1:length(files)) {
  assign(gsub("\\..*","",files[i]), fread(paste0('./data//camel_data/signatures/', files[i])))
}

ALL_SIGNATURES <- merge(camels_name, camels_geol, by = 'gauge_id')
ALL_SIGNATURES <- merge(ALL_SIGNATURES, camels_clim, by = 'gauge_id')
ALL_SIGNATURES <- merge(ALL_SIGNATURES, camels_soil, by = 'gauge_id')
ALL_SIGNATURES <- merge(ALL_SIGNATURES, camels_topo, by = 'gauge_id')
ALL_SIGNATURES <- merge(ALL_SIGNATURES, camels_vege, by = 'gauge_id')
ALL_SIGNATURES <- merge(ALL_SIGNATURES, camels_hydro, by = 'gauge_id')


setnames(ALL_SIGNATURES, old = "geol_porostiy", new = "geol_porosity")
setnames(camels_geol, old = "geol_porostiy", new = "geol_porosity")


rm(files, i)


# select feature for BN
selected_data_slope_fdc <- 
  subset(
    ALL_SIGNATURES,
    select = c(
      gauge_id,
      # ------------------------------------- climate
      p_mean,
      pet_mean,
      p_seasonality,
      frac_snow,
      high_prec_freq,
      # ,
      low_prec_freq,
      low_prec_dur,
      # aridity,
      # ------------------------------------ soil
      soil_depth_pelletier,
      soil_conductivity,
      sand_frac,
      clay_frac,
      # soil_depth_statsgo,
      soil_porosity,
      max_water_content,
      silt_frac,
      # water_frac,
      # organic_frac,
      # other_frac,
      # ------------------------------------ topography
      # gauge_lat,
      elev_mean,
      slope_mean,
      # gauge_lon,
      area_gages2,
      
      # ------------------------------------ vegetation (land cover)
      frac_forest,
      lai_max,
      lai_diff,
      # gvf_max,
      # gvf_diff,
      # dom_land_cover_frac,
      
      
      # ------------------------------------ geology
      # glim_1st_class_frac,
      # glim_2nd_class_frac,
      # carbonate_rocks_frac,
      geol_permeability,
      geol_porosity
    )
  )

# define the black list
blacklist_pc <-
  rbind(
    # block path: climate ---> topography
    data.table(from = 'p_mean', to = 'elev_mean'),
    data.table(from = 'p_mean', to = 'slope_mean'),
    data.table(from = 'p_mean', to = 'area_gages2'),
    # data.table(from = 'p_mean', to = 'gauge_lat'),
    
    data.table(from = 'pet_mean', to = 'elev_mean'),
    data.table(from = 'pet_mean', to = 'slope_mean'),
    data.table(from = 'pet_mean', to = 'area_gages2'),
    # data.table(from = 'pet_mean', to = 'gauge_lat'),
    
    data.table(from = 'frac_snow', to = 'elev_mean'),
    data.table(from = 'frac_snow', to = 'slope_mean'),
    data.table(from = 'frac_snow', to = 'area_gages2'),
    # data.table(from = 'frac_snow', to = 'gauge_lat'),
    
    data.table(from = 'high_prec_freq', to = 'elev_mean'),
    data.table(from = 'high_prec_freq', to = 'slope_mean'),
    data.table(from = 'high_prec_freq', to = 'area_gages2'),
    # data.table(from = 'high_prec_freq', to = 'gauge_lat'),
    
    data.table(from = 'low_prec_freq', to = 'elev_mean'),
    data.table(from = 'low_prec_freq', to = 'slope_mean'),
    data.table(from = 'low_prec_freq', to = 'area_gages2'),
    # data.table(from = 'low_prec_freq', to = 'gauge_lat'),
    
    # data.table(from = 'high_prec_dur', to = 'gauge_lat'),
    # data.table(from = 'high_prec_dur', to = 'elev_mean'),
    # data.table(from = 'high_prec_dur', to = 'slope_mean'),
    # data.table(from = 'high_prec_dur', to = 'area_gages2'),
    
    # data.table(from = 'low_prec_dur', to = 'gauge_lat'),
    data.table(from = 'low_prec_dur', to = 'elev_mean'),
    data.table(from = 'low_prec_dur', to = 'slope_mean'),
    data.table(from = 'low_prec_dur', to = 'area_gages2'),
    
    # data.table(from = 'p_seasonality', to = 'gauge_lat'),
    data.table(from = 'p_seasonality', to = 'elev_mean'),
    data.table(from = 'p_seasonality', to = 'slope_mean'),
    data.table(from = 'p_seasonality', to = 'area_gages2'),
    
    
    # block path: soil ---> climate
    data.table(from = 'soil_conductivity', to = 'p_mean'),
    data.table(from = 'soil_conductivity', to = 'pet_mean'),
    data.table(from = 'soil_conductivity', to = 'frac_snow'),
    data.table(from = 'soil_conductivity', to = 'high_prec_freq'),
    data.table(from = 'soil_conductivity', to = 'low_prec_freq'),
    data.table(from = 'soil_conductivity', to = 'low_prec_dur'),
    data.table(from = 'soil_conductivity', to = 'p_seasonality'),
    # data.table(from = 'soil_conductivity', to = 'high_prec_dur'),
    
    data.table(from = 'soil_depth_pelletier', to = 'p_mean'),
    data.table(from = 'soil_depth_pelletier', to = 'pet_mean'),
    data.table(from = 'soil_depth_pelletier', to = 'frac_snow'),
    data.table(from = 'soil_depth_pelletier', to = 'high_prec_freq'),
    data.table(from = 'soil_depth_pelletier', to = 'low_prec_freq'),
    data.table(from = 'soil_depth_pelletier', to = 'low_prec_dur'),
    data.table(from = 'soil_depth_pelletier', to = 'p_seasonality'),
    # data.table(from = 'soil_depth_pelletier', to = 'high_prec_dur'),
    
    data.table(from = 'max_water_content', to = 'p_mean'),
    data.table(from = 'max_water_content', to = 'pet_mean'),
    data.table(from = 'max_water_content', to = 'frac_snow'),
    data.table(from = 'max_water_content', to = 'high_prec_freq'),
    data.table(from = 'max_water_content', to = 'low_prec_freq'),
    data.table(from = 'max_water_content', to = 'low_prec_dur'),
    data.table(from = 'max_water_content', to = 'p_seasonality'),
    # data.table(from = 'max_water_content', to = 'high_prec_dur'),
    
    data.table(from = 'soil_porosity', to = 'p_mean'),
    data.table(from = 'soil_porosity', to = 'pet_mean'),
    data.table(from = 'soil_porosity', to = 'frac_snow'),
    data.table(from = 'soil_porosity', to = 'high_prec_freq'),
    data.table(from = 'soil_porosity', to = 'low_prec_freq'),
    data.table(from = 'soil_porosity', to = 'low_prec_dur'),
    data.table(from = 'soil_porosity', to = 'p_seasonality'),
    # data.table(from = 'soil_porosity', to = 'high_prec_dur'),
    
    data.table(from = 'sand_frac', to = 'p_mean'),
    data.table(from = 'sand_frac', to = 'pet_mean'),
    data.table(from = 'sand_frac', to = 'frac_snow'),
    data.table(from = 'sand_frac', to = 'high_prec_freq'),
    data.table(from = 'sand_frac', to = 'low_prec_freq'),
    data.table(from = 'sand_frac', to = 'low_prec_dur'),
    data.table(from = 'sand_frac', to = 'p_seasonality'),
    # data.table(from = 'sand_frac', to = 'high_prec_dur'),
    
    data.table(from = 'clay_frac', to = 'p_mean'),
    data.table(from = 'clay_frac', to = 'pet_mean'),
    data.table(from = 'clay_frac', to = 'frac_snow'),
    data.table(from = 'clay_frac', to = 'high_prec_freq'),
    data.table(from = 'clay_frac', to = 'low_prec_freq'),
    data.table(from = 'clay_frac', to = 'low_prec_dur'),
    data.table(from = 'clay_frac', to = 'p_seasonality'),
    # data.table(from = 'clay_frac', to = 'high_prec_dur'),
    
    data.table(from = 'silt_frac', to = 'p_mean'),
    data.table(from = 'silt_frac', to = 'pet_mean'),
    data.table(from = 'silt_frac', to = 'frac_snow'),
    data.table(from = 'silt_frac', to = 'high_prec_freq'),
    data.table(from = 'silt_frac', to = 'low_prec_freq'),
    data.table(from = 'silt_frac', to = 'low_prec_dur'),
    data.table(from = 'silt_frac', to = 'p_seasonality'),
    # data.table(from = 'silt_frac', to = 'high_prec_dur'),
    
    
    # block path: geol ---> climate
    data.table(from = 'geol_porosity', to = 'p_mean'),
    data.table(from = 'geol_porosity', to = 'pet_mean'),
    data.table(from = 'geol_porosity', to = 'frac_snow'),
    data.table(from = 'geol_porosity', to = 'high_prec_freq'),
    data.table(from = 'geol_porosity', to = 'low_prec_freq'),
    data.table(from = 'geol_porosity', to = 'low_prec_dur'),
    data.table(from = 'geol_porosity', to = 'p_seasonality'),
    # data.table(from = 'geol_porosity', to = 'high_prec_dur'),
    
    data.table(from = 'geol_permeability', to = 'p_mean'),
    data.table(from = 'geol_permeability', to = 'pet_mean'),
    data.table(from = 'geol_permeability', to = 'frac_snow'),
    data.table(from = 'geol_permeability', to = 'high_prec_freq'),
    data.table(from = 'geol_permeability', to = 'low_prec_freq'),
    data.table(from = 'geol_permeability', to = 'low_prec_dur'),
    data.table(from = 'geol_permeability', to = 'p_seasonality'),
    # data.table(from = 'geol_permeability', to = 'high_prec_dur'),
    
    # block path: vege ---> climate
    data.table(from = 'frac_forest', to = 'p_mean'),
    # data.table(from = 'frac_forest', to = 'pet_mean'),
    data.table(from = 'frac_forest', to = 'frac_snow'),
    data.table(from = 'frac_forest', to = 'high_prec_freq'),
    data.table(from = 'frac_forest', to = 'low_prec_freq'),
    data.table(from = 'frac_forest', to = 'low_prec_dur'),
    data.table(from = 'frac_forest', to = 'p_seasonality'),
    # data.table(from = 'frac_forest', to = 'high_prec_dur'),
    
    data.table(from = 'lai_max', to = 'p_mean'),
    # data.table(from = 'lai_max', to = 'pet_mean'),
    data.table(from = 'lai_max', to = 'frac_snow'),
    data.table(from = 'lai_max', to = 'high_prec_freq'),
    data.table(from = 'lai_max', to = 'low_prec_freq'),
    data.table(from = 'lai_max', to = 'low_prec_dur'),
    data.table(from = 'lai_max', to = 'p_seasonality'),
    # data.table(from = 'lai_max', to = 'high_prec_dur'),
    
    data.table(from = 'lai_diff', to = 'p_mean'),
    # data.table(from = 'lai_diff', to = 'pet_mean'),
    data.table(from = 'lai_diff', to = 'frac_snow'),
    data.table(from = 'lai_diff', to = 'high_prec_freq'),
    data.table(from = 'lai_diff', to = 'low_prec_freq'),
    data.table(from = 'lai_diff', to = 'low_prec_dur'),
    data.table(from = 'lai_diff', to = 'p_seasonality'),
    # data.table(from = 'lai_diff', to = 'high_prec_dur'),
    
    
    # block path: vege ---> topo
    # data.table(from = 'frac_forest', to = 'gauge_lat'),
    data.table(from = 'frac_forest', to = 'elev_mean'),
    data.table(from = 'frac_forest', to = 'slope_mean'),
    data.table(from = 'frac_forest', to = 'area_gages2'),
    
    # data.table(from = 'lai_max', to = 'gauge_lat'),
    data.table(from = 'lai_max', to = 'elev_mean'),
    data.table(from = 'lai_max', to = 'slope_mean'),
    data.table(from = 'lai_max', to = 'area_gages2'),
    
    # data.table(from = 'lai_diff', to = 'gauge_lat'),
    data.table(from = 'lai_diff', to = 'elev_mean'),
    data.table(from = 'lai_diff', to = 'slope_mean'),
    data.table(from = 'lai_diff', to = 'area_gages2'),
    
    # block path: vege ---> geol
    data.table(from = 'frac_forest', to = 'geol_porosity'),
    data.table(from = 'lai_max', to = 'geol_porosity'),
    data.table(from = 'lai_diff', to = 'geol_porosity'),
    
    data.table(from = 'frac_forest', to = 'geol_permeability'),
    data.table(from = 'lai_max', to = 'geol_permeability'),
    data.table(from = 'lai_diff', to = 'geol_permeability'),
    
    
    # block climate --> geol
    data.table(from = 'p_mean', to = 'geol_porosity'),
    data.table(from = 'p_mean', to = 'geol_permeability'),
    
    data.table(from = 'pet_mean', to = 'geol_porosity'),
    data.table(from = 'pet_mean', to = 'geol_permeability'),

    data.table(from = 'frac_snow', to = 'geol_porosity'),
    data.table(from = 'frac_snow', to = 'geol_permeability'),
    
    data.table(from = 'high_prec_freq', to = 'geol_porosity'),
    data.table(from = 'high_prec_freq', to = 'geol_permeability'),

    data.table(from = 'low_prec_freq', to = 'geol_porosity'),
    data.table(from = 'low_prec_freq', to = 'geol_permeability'),

    
    data.table(from = 'low_prec_dur', to = 'geol_porosity'),
    data.table(from = 'low_prec_dur', to = 'geol_permeability'),
    
    data.table(from = 'p_seasonality', to = 'geol_porosity'),
    data.table(from = 'p_seasonality', to = 'geol_permeability'),
    
    # data.table(from = 'high_prec_dur', to = 'geol_porosity'),
    # data.table(from = 'high_prec_dur', to = 'geol_permeability'),

    # block PET --> soil
    data.table(from = 'pet_mean', to = 'soil_depth_pelletier'),
    data.table(from = 'pet_mean', to = 'soil_conductivity'),
    data.table(from = 'pet_mean', to = 'sand_frac'),
    data.table(from = 'pet_mean', to = 'clay_frac'),
    data.table(from = 'pet_mean', to = 'silt_frac'),
    data.table(from = 'pet_mean', to = 'max_water_content'),
    
    
    # block soil --> topo
    data.table(from = 'soil_conductivity', to = 'elev_mean'),
    data.table(from = 'soil_depth_pelletier', to = 'elev_mean'),
    data.table(from = 'max_water_content', to = 'elev_mean'),
    data.table(from = 'soil_porosity', to = 'elev_mean'),
    data.table(from = 'sand_frac', to = 'elev_mean'),
    data.table(from = 'clay_frac', to = 'elev_mean'),
    data.table(from = 'silt_frac', to = 'elev_mean'),
    
    data.table(from = 'soil_conductivity', to = 'slope_mean'),
    data.table(from = 'soil_depth_pelletier', to = 'slope_mean'),
    data.table(from = 'max_water_content', to = 'slope_mean'),
    data.table(from = 'soil_porosity', to = 'slope_mean'),
    data.table(from = 'sand_frac', to = 'slope_mean'),
    data.table(from = 'clay_frac', to = 'slope_mean'),
    data.table(from = 'silt_frac', to = 'slope_mean'),
    
    data.table(from = 'soil_conductivity', to = 'area_gages2'),
    data.table(from = 'soil_depth_pelletier', to = 'area_gages2'),
    data.table(from = 'max_water_content', to = 'area_gages2'),
    data.table(from = 'soil_porosity', to = 'area_gages2'),
    data.table(from = 'sand_frac', to = 'area_gages2'),
    data.table(from = 'clay_frac', to = 'area_gages2'),
    data.table(from = 'silt_frac', to = 'area_gages2'),
    
    
    
    # some wrong links
    data.table(from = 'max_water_content', to = 'clay_frac'),
    data.table(from = 'max_water_content', to = 'sand_frac'),
    data.table(from = 'max_water_content', to = 'silt_frac'),
    data.table(from = 'soil_porosity', to = 'clay_frac'),
    data.table(from = 'soil_porosity', to = 'sand_frac'),
    data.table(from = 'soil_porosity', to = 'silt_frac'),
    data.table(from = 'soil_conductivity', to = 'clay_frac'),
    data.table(from = 'soil_conductivity', to = 'sand_frac'),
    data.table(from = 'soil_conductivity', to = 'silt_frac'),
    data.table(from = 'high_prec_freq', to = 'p_mean'),
    
    data.table(from = 'geol_permeability', to = 'clay_frac'),
    data.table(from = 'geol_permeability', to = 'sand_frac'),
    data.table(from = 'geol_permeability', to = 'silt_frac'),
    data.table(from = 'geol_permeability', to = 'soil_depth_pelletier'),
    data.table(from = 'geol_porosity', to = 'clay_frac'),
    data.table(from = 'geol_porosity', to = 'sand_frac'),
    data.table(from = 'geol_porosity', to = 'silt_frac'),
    data.table(from = 'geol_porosity', to = 'soil_depth_pelletier'),
    data.table(from = 'geol_permeability', to = 'clay_frac'),
    data.table(from = 'geol_permeability', to = 'sand_frac'),
    data.table(from = 'geol_permeability', to = 'silt_frac'),
    data.table(from = 'geol_permeability', to = 'soil_depth_pelletier'),
    data.table(from = 'geol_porosity', to = 'clay_frac'),
    data.table(from = 'geol_porosity', to = 'sand_frac'),
    data.table(from = 'geol_porosity', to = 'silt_frac'),
    data.table(from = 'geol_porosity', to = 'soil_depth_pelletier'),
 
    
    # target node as a child node
    data.table(from = 'target_node', to = 'p_mean'),
    data.table(from = 'target_node', to = 'pet_mean'),
    data.table(from = 'target_node', to = 'frac_snow'),
    data.table(from = 'target_node', to = 'high_prec_freq'),
    data.table(from = 'target_node', to = 'low_prec_freq'),
    # data.table(from = 'target_node', to = 'high_prec_dur'),
    data.table(from = 'target_node', to = 'low_prec_dur'),
    data.table(from = 'target_node', to = 'p_seasonality'),

    # data.table(from = 'target_node', to = 'gauge_lat'),
    data.table(from = 'target_node', to = 'elev_mean'),
    data.table(from = 'target_node', to = 'slope_mean'),
    data.table(from = 'target_node', to = 'area_gages2'),

    data.table(from = 'target_node', to = 'geol_porosity'),
    data.table(from = 'target_node', to = 'geol_permeability'),

    data.table(from = 'target_node', to = 'lai_max'),
    data.table(from = 'target_node', to = 'frac_forest'),
    data.table(from = 'target_node', to = 'lai_diff'),

    data.table(from = 'target_node', to = 'soil_depth_pelletier'),
    data.table(from = 'target_node', to = 'soil_conductivity'),
    data.table(from = 'target_node', to = 'sand_frac'),
    data.table(from = 'target_node', to = 'clay_frac'),
    data.table(from = 'target_node', to = 'silt_frac'),
    data.table(from = 'target_node', to = 'max_water_content')
    
    )


