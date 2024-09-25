# Bayesian network for all variables

setwd("D:/project/Spaptial_variablity_paper/Rscripts")
source('./source/load_data_&_packages.R')
source('./source/functions.r')


# data processing --------------------------------------------------------------


# check for NA values ----------------------------------------------------------

# names(ALL_SIGNATURES)
# any_na(ALL_SIGNATURES)                       # any NAs
# n_miss(ALL_SIGNATURES)                       # number of NAs
# prop_miss(ALL_SIGNATURES)                    # NAs/(total number of vars)
# prop_complete(ALL_SIGNATURES)                # (total-NA)/total
# miss_var_summary(ALL_SIGNATURES)             # summary of missing values
# vis_miss(ALL_SIGNATURES)                     # visualization of missing values
# vis_miss(ALL_SIGNATURES, cluster = TRUE)     #       //
# gg_miss_var(ALL_SIGNATURES)                  #       //   


# Find columns with categorical variables
character_columns <- sapply(ALL_SIGNATURES, is.character)
character_column_names <- names(ALL_SIGNATURES)[character_columns]
character_column_names

# remove columns with large number of NAs
ALL_SIGNATURES[ , c('root_depth_50', 
                    'root_depth_99', 
                    'huc_02') := NULL]


# remove categorical columns
ALL_SIGNATURES[, c('gauge_id', 
                   'gauge_name',
                   'geol_1st_class',
                   'geol_2nd_class',
                   'high_prec_timing',
                   'low_prec_timing',
                   'dom_land_cover') := NULL]


ALL_SIGNATURES <- na.omit(ALL_SIGNATURES)

# camels_clim[low_prec_timing == high_prec_timing, ]
# 
# # low/high_prec_timing
# dummie_low_prec <-
#   data.frame(
#     low_prec_timing = unique(ALL_SIGNATURES[, low_prec_timing]),
#     value_low = seq(from = 1, to = length(unique(ALL_SIGNATURES[, low_prec_timing])))
#   )
# 
# # replace low_prec_timing
# ALL_SIGNATURES <-
#   ALL_SIGNATURES[dummie_low_prec, on = 'low_prec_timing']
# 
# ALL_SIGNATURES[, low_prec_timing := NULL]
# setnames(ALL_SIGNATURES, 'value_low', 'low_prec_timing')
# 
# 
# # replace high_prec_timing
# dummie_high_prec <- copy(dummie_low_prec)
# names(dummie_high_prec) <- c('high_prec_timing', 'value_high')
# 
# ALL_SIGNATURES <-
#   ALL_SIGNATURES[dummie_high_prec, on = 'high_prec_timing'][, high_prec_timing := NULL]
# 
# setnames(ALL_SIGNATURES, 'value_high', 'high_prec_timing')
# ALL_SIGNATURES[high_prec_timing == low_prec_timing, ]


# # geol_1st_class
# dummie_geol <-
#   data.frame(geol_1st_class = unique(ALL_SIGNATURES[, geol_1st_class]),
#              value = seq(from = 1, to = length(unique(ALL_SIGNATURES[, geol_1st_class]))))
# ALL_SIGNATURES <-
#   ALL_SIGNATURES[dummie_geol, on = 'geol_1st_class'][, geol_1st_class := NULL]
# setnames(ALL_SIGNATURES, 'value', 'geol_1st_class')


# # dom_land_cover
# dummie_land <-
#   data.frame(dom_land_cover = unique(ALL_SIGNATURES[, dom_land_cover]),
#              value = seq(from = 1, to = length(unique(ALL_SIGNATURES[, dom_land_cover]))))
# dummie_land
# 
# ALL_SIGNATURES <-
#   ALL_SIGNATURES[dummie_land, on = 'dom_land_cover'][, dom_land_cover := NULL]
# setnames(ALL_SIGNATURES, 'value', 'dom_land_cover')
# 
# # remove dummies
# rm(dummie_geol, 
#    dummie_land, 
#    dummie_high_prec, 
#    dummie_low_prec, 
#    character_columns,
#    character_column_names)


# make all others numeric
# for (i in names(ALL_SIGNATURES)) ALL_SIGNATURES[,(i) := as.numeric(get(i))]

# subset data for algorithms ---------------------------------------------------

bn.data_climate_q <-
  subset(
    ALL_SIGNATURES,
    select = -c(
      runoff_ratio,
      slope_fdc,
      baseflow_index,
      stream_elas,
      q5,
      q95,
      high_q_freq,
      high_q_dur,
      low_q_freq,
      low_q_dur,
      zero_q_freq,
      hfd_mean
    )
  )
bn.data_climate_q <- subset(bn.data_climate_q, 
                  select = c(
                    p_mean,
                    pet_mean,
                    p_seasonality,
                    frac_snow,
                    aridity,
                    high_prec_freq,
                    high_prec_dur,
                    low_prec_freq,
                    low_prec_dur,
                    q_mean
                  ))


# run algorithms ---------------------------------------------------------------

# pc without constraint (estiamte the DAG) -------------------------------------
pc.fit <- pc.stable(bn.data_climate_q)

# plot network
qgraph(pc.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)


# constrain the edges
whitelist_pc <-
  matrix(c(
    'p_seasonality', 'q_mean',
    'aridity', 'q_mean',
    'pet_mean', 'low_prec_freq',
    'low_prec_dur', 'low_prec_freq',
    'high_prec_freq', 'low_prec_freq',
    'low_prec_freq', 'frac_snow'
  ),ncol = 2,  byrow = TRUE)

colnames(whitelist_pc) <- c('from', 'to')
whitelist_pc <- as.data.frame(whitelist_pc)


blacklist_pc <- rbind(
  data.frame(from = 'aridity', to = 'pet_mean'),
  # data.frame(from = 'aridity', to = 'p_mean'),
  # data.frame(from = 'aridity', to = 'pet_mean'),
  data.frame(from = 'q_mean', to = 'p_mean')
  # data.frame(from = 'high_prec_freq', to = 'low_prec_freq'),
  # data.frame(from = 'low_prec_dur', to = 'low_prec_freq')
  # data.frame(from = 'q_mean', to = 'aridity')
  # data.frame(from = 'low_prec_freq', to = 'pet_mean')
)

# choose algorithm to 
pc.fit_modified <- pc.stable(bn.data_climate_q,
                 whitelist = whitelist_pc,
                 blacklist = blacklist_pc)

# plot network
qgraph(
  pc.fit_modified,
  legend.cex = 0.1,
  vsize = 8,
  repulsion = 0.4,
  title = "Estimated DAG - Climate Variables",
  asize = 5,
  edge.color = 'black',
  label.cex = 2,
  directed = TRUE
)
pc.fit_modified


# # PC with normalized data ------------------------------------------------------
# bn.data_climate_q_normal <- transform_boxcox(bn.data_climate_q)
# pc.fit_normal <- pc.stable(bn.data_climate_q_normal)
# 
# # plot network
# qgraph(pc.fit_normal, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
#        title = "Estimated DAG", asize = 5, edge.color = 'black',
#        label.cex = 2, directed = TRUE)
# 
# 
# # constrain the edges
# whitelist_pc_normal <-
#   matrix(c(
#     # 'p_seasonality', 'q_mean',
#     'high_prec_freq', 'p_seasonality',
#     'p_mean', 'p_seasonality',
#     'low_prec_dur', 'p_seasonality',
#     'p_mean', 'frac_snow',
#     'pet_mean', 'frac_snow',
#     'p_mean', 'aridity',
#     'p_seasonality', 'high_prec_dur'
#     # 'high_prec_freq', 'low_prec_freq',
#     # 'high_prec_dur', 'low_prec_freq',
#     # 'high_prec_freq', 'low_prec_dur',
#     # 'high_prec_dur', 'low_prec_dur'
#     # # 'low_prec_freq', 'frac_snow'
#   ),ncol = 2,  byrow = TRUE)
# 
# colnames(whitelist_pc_normal) <- c('from', 'to')
# whitelist_pc <- as.data.frame(whitelist_pc_normal)
# 
# 
# blacklist_pc_normal <- rbind(
#   # data.frame(from = 'aridity', to = 'pet_mean'),
#   # data.frame(from = 'aridity', to = 'p_mean'),
#   data.frame(from = 'q_mean', to = 'aridity'),
#   data.frame(from = 'q_mean', to = 'p_seasonality')
#   # data.frame(from = 'high_prec_freq', to = 'low_prec_freq'),
#   # data.frame(from = 'low_prec_dur', to = 'low_prec_freq')
#   # data.frame(from = 'q_mean', to = 'aridity')
#   # data.frame(from = 'low_prec_freq', to = 'pet_mean')
# )
# 
# # choose algorithm to 
# Res_pc_normal <- pc.stable(bn.data_climate_q_normal,
#                  whitelist = whitelist_pc_normal,
#                  blacklist = blacklist_pc_normal)
# 
# # plot network
# qgraph(Res, legend.cex = 0.1, vsize = 8, repulsion = 0.4,
#        title = "Estimated DAG - Climate Variables", asize = 5, edge.color = 'black',
#        label.cex = 2, directed = TRUE)
# Res


# Incremental Association (iamb) -----------------------------------------------
iamb.fit <- iamb(bn.data_climate_q)

qgraph(iamb.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)

whitelist_iamb <- rbind(
  # data.frame(from = 'aridity', to = 'pet_mean'),
  # data.frame(from = 'aridity', to = 'p_mean'),
  # data.frame(from = 'aridity', to = 'pet_mean'),
  # data.frame(from = 'q_mean', to = 'p_mean')
  data.frame(from = 'high_prec_freq', to = 'p_seasonality'),
  data.frame(from = 'high_prec_dur', to = 'p_seasonality')
  # data.frame(from = 'q_mean', to = 'aridity')
  # data.frame(from = 'low_prec_freq', to = 'pet_mean')
)

iamb.fit_modified <- iamb(bn.data_climate_q, 
                          whitelist = whitelist_iamb)

qgraph(iamb.fit_modified, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)


# gs  Grow-Shrink Markov Blanket -----------------------------------------------
gs.fit <- gs(bn.data_climate_q)

# plot network
qgraph(gs.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)

whitelist_gs <- rbind(
  # data.frame(from = 'aridity', to = 'pet_mean'),
  # data.frame(from = 'aridity', to = 'p_mean'),
  # data.frame(from = 'aridity', to = 'pet_mean'),
  # data.frame(from = 'q_mean', to = 'p_mean')
  data.frame(from = 'high_prec_freq', to = 'p_seasonality'),
  data.frame(from = 'high_prec_dur', to = 'p_seasonality')
  # data.frame(from = 'q_mean', to = 'aridity')
  # data.frame(from = 'low_prec_freq', to = 'pet_mean')
)


gs.fit_modified <- gs(bn.data_climate_q, 
                      whitelist = whitelist_gs)
# plot network
qgraph(gs.fit_modified, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)


# Fast Incremental Association (fast.iamb) -------------------------------------
fast.iamb.fit <- fast.iamb(bn.data_climate_q)
qgraph(fast.iamb.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)

# Interleaved Incremental Association (inter.iamb)
inter.iamb.fit <- inter.iamb(bn.data_climate_q)
qgraph(inter.iamb.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)

# Incremental Association with FDR (iamb.fdr)
iamb.fdr.fit <- iamb.fdr(bn.data_climate_q)
qgraph(iamb.fdr.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)


# Available Score-based Learning Algorithms

# hill climbing ---------------------------------------------------------------
hc.fit <- hc(bn.data_climate_q)
qgraph(hc.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)
bic_score <- score(hc.fit, bn.data_climate_q)

# Tabu Search (tabu) -----------------------------------------------------------
tabu.fit <- tabu(bn.data_climate_q)
qgraph(tabu.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)
bic_score <- score(tabu.fit, bn.data_climate_q)


# Available Hybrid Learning Algorithms (combination of constraint-based and score-based algorithms)

# Max-Min Hill-Climbing --------------------------------------------------------
mmhc.fit <- mmhc(bn.data_climate_q)
qgraph(mmhc.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated mmhc DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)

# Restricted Maximization ------------------------------------------------------
rsmax2.fit <- rsmax2(bn.data_climate_q)
qgraph(rsmax2.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated rsmax2 DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)

# Hybrid HPC: a hybrid algorithm combining HPC and hill-climbing.
h2pc.fit <- h2pc(bn.data_climate_q)
qgraph(h2pc.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated h2pc DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)


# Other (Constraint-Based) Local Discovery Algorithms

# Max-Min Parents and Children -------------------------------------------------
mmpc.fit <-  mmpc(bn.data_climate_q)
qgraph(mmpc.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated mmpc DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)

# Hiton Parents and Children ---------------------------------------------------
si.hiton.pc.fit <- si.hiton.pc(bn.data_climate_q)
qgraph(si.hiton.pc.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated si.hiton.pc DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)

# Hybrid Parents and Children --------------------------------------------------
hpc.fit <- hpc(bn.data_climate_q)
qgraph(hpc.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated hpc DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)


# Pairwise Mutual Information Algorithms

# Chow-Liu ---------------------------------------------------------------------
chow.liu.fit <- chow.liu(bn.data_climate_q)
qgraph(chow.liu.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated chow.liu DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)
qgraph(chow.liu.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated chow.liu DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)

# ARACNE -----------------------------------------------------------------------
aracne.fit <- aracne(bn.data_climate_q)
qgraph(aracne.fit, legend.cex = 0.1, vsize = 8, repulsion = 0.5,
       title = "Estimated aracne DAG", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE)



# Now we can fit the model
fit <- bn.fit(Res, climate_signatures)
bn.fit.qqplot(fitted = fit)
# bn.fit.histogram(fit)
# bn.fit.xyplot(fit)

# narcs(fit)
# fit$p_mean
# fit$aridity

# use bootstrap to check for stability
boot <- boot.strength(climate_signatures,
                      R = 1000,
                      algorithm = 'pc.stable',
                      algorithm.args = list(
                        whitelist = Whitelist,
                        blacklist = Blacklist
                      ))
boot <- boot.strength(climate_signatures,
                      R = 1000, algorithm = 'pc.stable')
boot

qgraph(boot, legend.cex = 0.1, vsize = 10, repulsion = 0.20,
       title = "Estimated DAG (bootstrap)", asize = 5, edge.color = 'black',
       label.cex = 2, directed = TRUE, edge.labels = FALSE, edge.color = 'black')




# Bayesian network -------------------------------------------------------------


# Define the structure of the Bayesian network
dag <- empty.graph(nodes = names(bn.data_climate_q))
arcs <- matrix(names(bn.data_climate_q), ncol = 2, byrow = TRUE)
arcs(dag) <- arcs

# Learn the structure from data using Hill Climbing algorithm
dag <- hc(bn.data_climate_q)
fitted_dag <- bn.fit(dag, bn.data_climate_q)
bic_score <- score(dag, bn.data_climate_q)
print(bic_score)

dag$nodes$glim_2nd_class_frac$parents

# plot network
qgraph(dag, legend.cex = 0.1, vsize = 5, repulsion = 0.45,
       title = "Estimated DAG", asize = 2, edge.color = 'black',
       label.cex = 2, directed = TRUE)

