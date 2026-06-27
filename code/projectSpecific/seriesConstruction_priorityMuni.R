
# > PROJECT INFO
# NAME: PROJECT DETERRING DEFORESTATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: PRIORITY MUNI - VARIABLES CONSTRUCTION 
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
load(file.path("data/raw2clean/policy/priorityMuni_mma/output", "policy_la_prioritymuni_2007_df.Rdata"))







# VAR CONSTRUCTION -----------------------------------------------------------------------------------------------------------------------------------

series.priorityMuni <- 
  policy.la.prioritystatus.2007.df %>% 
  dplyr::select(-d1_priorityEver) %>% # remove unnecessary column
  gather(key = "year", value = "d_priority", starts_with("d1")) %>% # convert from wide to long 
  mutate(year = as.numeric(str_sub(year, start = -4))) %>% # keeps only the month number and convert it to numeric
  ungroup() %>% 
  filter(year >= 2002, year <= 2016)  # time frame definition
  



# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.priorityMuni, file = file.path("data/projectSpecific", "series_priorityMuni.Rdata"))




# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------