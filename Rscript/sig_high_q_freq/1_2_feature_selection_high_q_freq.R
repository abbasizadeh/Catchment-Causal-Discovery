# load variables and packages
setwd("D:/project/Spatial_variablity_paper/")
source('./Rscripts/source/1_load_data_&_packages.R')

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
      # aridity,
      high_prec_freq,
      # high_prec_dur,
      low_prec_freq,
      low_prec_dur,
      # ------------------------------------ soil
      soil_depth_pelletier,
      # soil_depth_statsgo,
      # soil_porosity,
      # soil_conductivity,
      # max_water_content,
      sand_frac,
      # silt_frac,
      clay_frac,
      # water_frac,
      # organic_frac,
      # other_frac,
      # ------------------------------------ topography
      gauge_lat,
      # gauge_lon,
      elev_mean,
      slope_mean,
      # area_gages2,
      
      # ------------------------------------ vegetation (land cover)
      frac_forest,
      lai_max,
      # lai_diff,
      # gvf_max,
      # gvf_diff,
      # dom_land_cover_frac,
      
      
      # ------------------------------------ geology
      # glim_1st_class_frac,
      # glim_2nd_class_frac,
      # carbonate_rocks_frac,
      geol_porosity,
      # geol_permeability,
      
      high_q_freq
    )
  )

# selected_data_slope_fdc <- selected_data_slope_fdc[-is.na(stream_elas), ]
selected_data_slope_fdc <- na.omit(selected_data_slope_fdc)



