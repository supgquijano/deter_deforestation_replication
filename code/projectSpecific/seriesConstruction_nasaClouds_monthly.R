
# > PROJECT INFO
# NAME: PROJECT DETERRING DEFORESTATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: NASA CLOUDS - VARIABLES CONSTRUCTION 
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



# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# prodes data input
load(file.path("data/raw2clean/geography/cloud_nasa/output","geo_brl_cloudCoverMuni_df.Rdata"))





# VAR CONSTRUCTION -----------------------------------------------------------------------------------------------------------------------------------

series.nasaClouds.monthly <- 
  geo.brl.cloudCoverMuni.df %>% 
  mutate(year_prodes = if_else(month < 8, year, year + 1)) %>% # create year prodes column  
  group_by(muni_code, month, year, year_prodes) %>% 
  dplyr::summarise(share_cloud = mean(cloud_cover)) %>% # calculate average share cloud by prodes year
  ungroup() %>% 
  dplyr::rename(nasaCloud_share = share_cloud) %>% # change column name
  filter(year >= 2001, year <= 2016) %>%   # time frame definition
  arrange(muni_code, year, month)  




# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.nasaClouds.monthly, file = file.path("data/projectSpecific", "series_nasaClouds_monthly.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------