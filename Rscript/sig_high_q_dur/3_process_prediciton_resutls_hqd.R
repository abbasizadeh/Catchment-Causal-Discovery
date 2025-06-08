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
source('./sig_high_q_dur/source_1_load_prediction_results_high_q_dur.r')

# summary stat of results
source('./sig_high_q_dur/source_2_summary_stat_high_q_dur.R')

# weighted values of restuls
source('./sig_high_q_dur/source_3_summary_stat_high_q_dur.R')


