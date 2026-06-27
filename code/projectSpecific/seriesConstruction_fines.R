
# > PROJECT INFO
# NAME: PROJECT DETERRING DEFORESTATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: FINES - VARIABLES CONSTRUCTION 
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

# fines data input
load(file.path("data/built/policy/fines", "policy_la_fines_built_munilevel_df.Rdata"))







# VAR CONSTRUCTION -----------------------------------------------------------------------------------------------------------------------------------

# filter for desired time frame and keep columns of interest
series.fines <- 
  policy.la.fines.muni.flora.yearprodes.df %>% 
  dplyr::rename(year = year_prodes, # dplyr::rename columns
         fine_sum_sanction_value = sum_fine_sanction_value_year_prodes,
         fine_count = number_of_fines_year_prodes) %>% 
  filter(year >= 2001, year <= 2016) %>% # time frame definition
  dplyr::select(muni_code, year, fine_count, fine_sum_sanction_value) # dplyr::select columns of interest


  


# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.fines, file = file.path("data/projectSpecific", "series_fines.Rdata"))




# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------