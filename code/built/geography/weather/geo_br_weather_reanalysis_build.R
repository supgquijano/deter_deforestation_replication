
# > PROJECT INFO
# NAME: PANEL FOR JULIANO - CPCG [CLIMATIC DATA, DAILY PRECIPITATION]
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: CREATE PANEL WITH CPCG DATA FOR BRAZIL; LEVEL: MUNI; JAN/2002 - MAY/2017
# AUTHOR: TOMAS DO VALLE
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/21/2020
#
# > NOTES
# 1: -





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCE
source("code/_functions/setup.R")



# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# create a list with all file names (with path)
aux.files <- list.files("data/raw2clean/geography/weather_ncepDoeReanalysis/output", pattern = "geo_br_weather_reanalysis_", full.names = T)

# load and merge all dfs into a single one
geo.br.weather.reanalysis <- do.call(rbind,lapply(aux.files,function(x)get(load(x))))  
  
  
  


# DATA PROCESSING-------------------------------------------------------------------------------------------------------------------------------------

panel.geo.br.weather.reanalysis <-
  geo.br.weather.reanalysis %>% 
  dplyr::select(-lon, -lat) %>% # removes lon, lat columns
  gather("date", "precip_reanalysis", -poly_id) %>% # transform from wide to long
  mutate(year = as.numeric(str_sub(date, 2, 5)),
         month = as.numeric(str_sub(date, -2, -1))) %>% # extract year and month info
  dplyr::rename(muni_code = poly_id) %>% # change column name
  dplyr::select(muni_code, year, month, precip_reanalysis) # order and select columns of interest





# EXPORT PREP----------------------------------------------------------------------------------------------------------------------------------------- 

# LABELS
label(panel.geo.br.weather.reanalysis$muni_code)         <- "municipality code (7-digit, IBGE)"
label(panel.geo.br.weather.reanalysis$year)              <- "year of reference"
label(panel.geo.br.weather.reanalysis$month)             <- "month of reference"
label(panel.geo.br.weather.reanalysis$precip_reanalysis) <- "monthly precipitation (in mm)"





# EXPORT----------------------------------------------------------------------------------------------------------------------------------------------

save(panel.geo.br.weather.reanalysis, file = file.path("data/built/geography/weather", "panel_geo_br_weather_reanalysis.Rdata"))





# END OF SCRIPT---------------------------------------------------------------------------------------------------------------------------------------