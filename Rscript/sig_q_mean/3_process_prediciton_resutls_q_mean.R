# ##############################################################################
#                                                                              #
#                        process prediction results                            #
#                                   q_mean                                     #
# ##############################################################################
# working directory
setwd("~/Catchment-Causal-Discovery/")

# load packages and data
source('./source/1_load_data_&_packages.R')

# get the prediction results
source('./sig_q_mean/source_1_load_prediction_results_q_mean.r')

# summary stat of results
source('./sig_q_mean/source_2_summary_stat_q_mean.R')

# weighted values of restuls
source('./sig_q_mean/source_3_summary_stat_q_mean.R')

