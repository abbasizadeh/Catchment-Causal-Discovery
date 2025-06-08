# ##############################################################################
#                                                                              #
#                        process prediction results                            #
#                                   q95                                         #
# ##############################################################################
# working directory
setwd("~/Catchment-Causal-Discovery/")

# load packages and data
source('./source/1_load_data_&_packages.R')

# get the prediction results
source('./sig_q95/source_1_load_prediction_results_q95.r')

# summary stat of results
source('./sig_q95/source_2_summary_stat_q95.R')

# weighted values of restuls
source('./sig_q95/source_3_summary_stat_q95.R')

