
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
load(file.path("data/built/geography/weather", "geo_global_weather_built_muni2007_2000th2017_spdf.Rdata"))


# extract df
weatherTemp <- geo.global.weather.temp.muni2007.spdf@data
weatherRain <- geo.global.weather.rain.muni2007.spdf@data

rm(geo.global.weather.rain.muni2007.spdf,
   geo.global.weather.temp.muni2007.spdf)


# VAR CONSTRUCTION -----------------------------------------------------------------------------------------------------------------------------------

# PRECIPITATION
series.weatherRain.monthly <- 
  weatherRain %>% 
  dplyr::select(-muni_area, - muni_name, -state_code, -state_uf) %>% # removes columns
  gather("date", "weatherRain", -muni_code) %>% # convert from wide to long
  mutate(year = as.numeric(str_sub(date, start = -4))) %>% # keeps only the year and convert it to numeric
  mutate(month = as.numeric(str_sub(date, start = -7, end = -6))) %>% # keeps only the month number and convert it to numeric
  mutate(year_prodes = if_else(month < 8, year, year + 1)) %>% # create year prodes column  
  group_by(muni_code, month, year, year_prodes) %>% # defines the muni_code + month + year as the level of interest
  dplyr::summarise(weatherRain_total = sum(weatherRain)) %>% # collapse data summing monthly values
  filter(year_prodes >= 2001 & year_prodes <= 2016) %>% 
  arrange(muni_code, year, month) %>%  
  ungroup()

  
# TEMPERATURE
series.weatherTemp.monthly <- 
  weatherTemp %>% 
  dplyr::select(-muni_area, - muni_name, -state_code, -state_uf) %>% # removes columns
  gather("date", "weatherTemp", -muni_code) %>% # convert from wide to long  
  mutate(year = as.numeric(str_sub(date, start = -4))) %>% # keeps only the year and convert it to numeric
  mutate(month = as.numeric(str_sub(date, start = -7, end = -6))) %>% # keeps only the month number and convert it to numeric
  mutate(year_prodes = if_else(month < 8, year, year + 1)) %>% # create year prodes column  
  group_by(muni_code, month, year, year_prodes) %>% # defines the muni_code + month + year as the level of interest
  dplyr::summarise(weatherTemp_mean = mean(weatherTemp)) %>% # collapse data summing monthly values
  filter(year >= 2001 & year <= 2016) %>%
  arrange(muni_code, year, month) %>%  
  ungroup()
  

 

  
# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.weatherRain.monthly, file = file.path("data/projectSpecific", "series_weatherRain_monthly.Rdata"))

save(series.weatherTemp.monthly, file = file.path("data/projectSpecific", "series_weatherTemp_monthly.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------