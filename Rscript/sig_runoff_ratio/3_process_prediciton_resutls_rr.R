# ##############################################################################
#                                                                              #
#                        process prediction results                            #
#                               runoff_ratio                                   #
# ##############################################################################
# working directory
setwd("~/Catchment-Causal-Discovery/")

# load packages and data
source('./source/1_load_data_&_packages.R')

# get the prediction results
source('./sig_runoff_ratio/source_1_load_prediction_results_runoff_ratio.r')

# summary stat of results
source('./sig_runoff_ratio/source_2_summary_stat_runoff_ratio.R')

# weighted values of resutls
source('./sig_runoff_ratio/source_3_summary_stat_runoff_ratio.R')


