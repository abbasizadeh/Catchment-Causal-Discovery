# ##############################################################################
#                                                                              #
#                        process prediction results                            #
#                               high q freq                                    #
# ##############################################################################
# working directory
setwd("~/Catchment-Causal-Discovery/")

# load packages and data
source('./source/1_load_data_&_packages.R')

# get the prediction results
source('./sig_low_q_freq/source_1_load_prediction_results_low_q_freq.r')

# summary stat of results
source('./sig_low_q_freq/source_2_summary_stat_low_q_freq.R')

# weighted values of results
source('./sig_low_q_freq/source_3_summary_stat_low_q_freq.R')


