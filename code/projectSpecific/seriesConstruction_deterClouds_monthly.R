
# > PROJECT INFO
# NAME: PROJECT DETERRING DEFORESTATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: DETER CLOUDS - VARIABLES CONSTRUCTION 
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
load(file.path("data/built/land_cover/deter", "policy_la_deter_built_clouds_coverage_panel_df.Rdata"))





# VAR CONSTRUCTION -----------------------------------------------------------------------------------------------------------------------------------

series.deterClouds.monthly <- 
  panel.policy.la.deter.built.clouds.coverage.df %>% 
  gather(key = "month", value = "share_cloud", starts_with("share")) %>% # convert from wide to long 
  mutate(month = as.numeric(str_sub(month, start = -2))) %>% # keeps only the month number and convert it to numeric
  mutate(year_prodes = if_else(month < 8, year, year + 1)) %>% # create year prodes column  
  group_by(muni_code, year, month, year_prodes) %>% 
  dplyr::summarise(share_cloud = mean(share_cloud)) %>% # calculate average share cloud by prodes year
  ungroup() %>% 
  dplyr::rename(deterCloud_share = share_cloud) %>% # change column name
  filter(year >= 2001, year <= 2016) %>%   # time frame definition
  arrange(muni_code, year, month)




# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.deterClouds.monthly, file = file.path("data/projectSpecific", "series_deterClouds_monthly.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------