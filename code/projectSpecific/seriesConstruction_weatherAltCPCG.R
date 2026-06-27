
# > PROJECT INFO
# NAME: PROJECT DETERRING DEFORESTATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: WEATHER - VARIABLES CONSTRUCTION (TEMPERATURE AND RAINFALL)
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
load(file.path("data/built/geography/weather", "br_weather_CPCG_precipitation.Rdata"))
load(file.path("data/built/geography/weather", "br_weather_CPCG_temperature.Rdata"))




# VAR CONSTRUCTION -----------------------------------------------------------------------------------------------------------------------------------


series.weatherRainCPCG <- 
  br.weather.CPCG.precipitation %>% 
  gather("month", "weatherRainCPCG", -muni_code, -year) %>% # convert from wide to long
  mutate(month = as.numeric(str_sub(month, start = -2, end = -1)), # keeps only the month number and convert it to numeric
         year = as.numeric(year)) %>% 
  mutate(year_prodes = if_else(month < 8, year, year + 1)) %>% # create year prodes column  
  group_by(muni_code, year_prodes) %>% # defines the muni_code + year as the level of interest
  dplyr::summarise(weatherRainCPCG_total = sum(weatherRainCPCG)) %>% # collapse data summing monthly values
  dplyr::rename(year = year_prodes) %>% 
  ungroup()

  

series.weatherTempCPCG <- 
  br.weather.CPCG.temperature %>% 
  gather("month", "weatherTempCPCG", -muni_code, -year) %>% # convert from wide to long
  mutate(month = as.numeric(str_sub(month, start = -2, end = -1)), # keeps only the month number and convert it to numeric
         year = as.numeric(year)) %>% 
  mutate(year_prodes = if_else(month < 8, year, year + 1)) %>% # create year prodes column  
  group_by(muni_code, year_prodes) %>% # defines the muni_code + year as the level of interest
  dplyr::summarise(weatherTempCPCG_mean = mean(weatherTempCPCG)) %>% # collapse data summing monthly values
  dplyr::rename(year = year_prodes) %>% 
  ungroup()
  

 

  
# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.weatherRainCPCG, file = file.path("data/projectSpecific", "series_weatherRainCPCG.Rdata"))

save(series.weatherTempCPCG, file = file.path("data/projectSpecific", "series_weatherTempCPCG.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------