
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
load(file.path("data/built/geography/weather", "panel_geo_br_weather_reanalysis.Rdata"))






# VAR CONSTRUCTION -----------------------------------------------------------------------------------------------------------------------------------


series.weatherRainReanalysis <- 
  panel.geo.br.weather.reanalysis %>% 
  mutate(year_prodes = if_else(month < 8, year, year + 1)) %>% # create year prodes column  
  group_by(muni_code, year_prodes) %>% # defines the muni_code + year as the level of interest
  dplyr::summarise(weatherRainReanalysis_total = sum(precip_reanalysis)) %>% # collapse data summing monthly values
  dplyr::rename(year = year_prodes) %>% 
  ungroup()

  


# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.weatherRainReanalysis, file = file.path("data/projectSpecific", "series_weatherRainReanalysis.Rdata"))






# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------