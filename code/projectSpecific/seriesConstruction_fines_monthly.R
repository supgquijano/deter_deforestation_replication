
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
series.fines.monthly <- 
  policy.la.fines.muni.level.per.month.df %>% 
  filter(violation == "Flora") %>% 
  dplyr::rename(month = fine_sanction_month,  # dplyr::rename columns
         year = fine_sanction_year,
         fine_sum_sanction_value = sum_fine_sanction_value_month,
         fine_count = number_of_fines_month) %>% 
  mutate(year_prodes = if_else(month < 8, year, year + 1)) %>% # create year prodes column  
  filter(year >= 2001, year <= 2016) %>%   # time frame definition
  arrange(muni_code, year, month) %>% 
  dplyr::select(muni_code, month, year, year_prodes, fine_count, fine_sum_sanction_value) # dplyr::select columns of interest


  


# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.fines.monthly, file = file.path("data/projectSpecific", "series_fines_monthly.Rdata"))




# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------