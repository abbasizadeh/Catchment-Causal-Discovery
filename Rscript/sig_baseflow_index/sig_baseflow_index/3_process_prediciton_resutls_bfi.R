# ##############################################################################
#                                                                              #
#                        process prediction results                            #
#                             baseflow index                                   #
# ##############################################################################
# working directory
setwd("~/Catchment-Causal-Discovery/")

# load packages and data
source('./source/1_load_data_&_packages.R')

# get the prediction results
source('./sig_baseflow_index/source_1_load_prediction_results_baseflow_index.r')

# summary stat of results
source('./sig_baseflow_index/source_2_summary_stat_baseflow_index.R')

# weighted values of restuls
source('./sig_baseflow_index/source_3_summary_stat_baseflow_index.R')
