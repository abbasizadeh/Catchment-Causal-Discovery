# ##############################################################################
#                                                                              #
#                        process prediction results                            #
#                                stream_elas                                   #
# ##############################################################################
# working directory
setwd("~/Catchment-Causal-Discovery/")

# load packages and data
source('./source/1_load_data_&_packages.R')

# get the prediction results
source('./sig_stream_elas/source_1_load_prediction_results_stream_elas.r')

# summary stat of results
source('./sig_stream_elas/source_2_summary_stat_stream_elas.R')

# weighted values of resutls
source('./sig_stream_elas/source_3_summary_stat_stream_elas.R')


