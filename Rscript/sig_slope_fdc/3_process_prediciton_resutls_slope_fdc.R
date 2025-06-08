# ##############################################################################
#                                                                              #
#                        process prediction results                            #
#                                slope_fdc                                     #
# ##############################################################################
# working directory
setwd("~/Catchment-Causal-Discovery/")

# load packages and data
source('./source/1_load_data_&_packages.R')

# get the prediction results
source('./sig_slope_fdc/source_1_load_prediction_results_slope_fdc.r')

# summary stat of results
source('./sig_slope_fdc/source_2_summary_stat_slope_fdc.R')

# weighted values of restuls
source('./sig_slope_fdc/source_3_summary_stat_slope_fdc.R')

