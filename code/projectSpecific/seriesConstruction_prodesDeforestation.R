
# > PROJECT INFO
# NAME: PROJECT DETERRING DEFORESTATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: PRODES - VARIABLES CONSTRUCTION (DEFORESTATION, CLOUDS AND NON-OBSERVABLE)
# AUTHOR: JOAO VEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/22/2020
#
# > NOTES
# -



# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions", "setup.R"))
source(file.path("code/_functions", "unit_conversion.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# prodes data input
load(file.path("data/raw2clean/land_cover/prodes_inpe/municipality_level/output", "landcover_la_prodes_munilevel_df.Rdata"))

rm(landcover.la.prodes.munilevel.wide.df)

# dataTreated sample input
load(file.path("data/projectSpecific", "series_sample_df.Rdata"))




# VAR CONSTRUCTION -----------------------------------------------------------------------------------------------------------------------------------

# filter for desired time frame and keep columns of interest
prodes.subset <- 
  landcover.la.prodes.munilevel.long.df %>% 
  filter(year >= 2001, year <= 2016) %>% # time frame definition
  mutate_each(funs = as.numeric, year) %>% # change column class
  right_join(series.sample.df, by = c("muni_code", "year")) %>% # merge prodes info with sample, 7 munis from the sample don't have prodes info
  dplyr::select(muni_code, year, muni_area, prodes_deforest_increment, prodes_nonobserved, prodes_cloud, prodes_forest, prodes_deforest_accumulated) # dplyr::select columns of interest


# create column with 2003 deforestation increment
prodes.2003 <-
  prodes.subset %>% 
  filter(year == 2003) %>% # time frame definition
  dplyr::rename(prodes_def_inc_2003 = prodes_deforest_increment) %>% # change column name
  mutate(prodes_forest_share_2003 = (prodes_forest*convert.sqkm.to.ha)/muni_area) %>% # calculate prodes forest share of the muni area 
  mutate(prodes_deforest_share_2003 = (prodes_deforest_accumulated*convert.sqkm.to.ha)/muni_area) %>% # calculate prodes deforest share of the muni area
  dplyr::select(muni_code, prodes_def_inc_2003, prodes_forest_share_2003, prodes_deforest_share_2003) # dplyr::select and order columns of interest


# recover full dataTreated
series.prodes <- 
  prodes.subset %>% 
  left_join(prodes.2003, by = c("muni_code")) %>% # merge both objects to have a panel from 2002-2016 and the new def vars
  dplyr::rename(prodes_cloud_coverage = prodes_cloud, prodes_nonobserved_area = prodes_nonobserved) %>% # dplyr::rename prodes cloud and nonobserved columns
  dplyr::select(-muni_area, -prodes_forest, -prodes_deforest_accumulated) # excludes unnecessary columns
  




# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.prodes, file = file.path("data/projectSpecific", "series_prodes.Rdata"))




# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------