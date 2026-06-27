
# > PROJECT INFO
# NAME: CENTRAL DATA REPOSITORY CONSTRUCTION - GRIDDED TERRESTRIAL AIR TEMPERATURE AND TERRESTRIAL PRECIPITATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT RAW DATA
# AUTHOR: CHRISTIANE SZERMAN
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/17/2020
#
# > NOTES
# -





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions/setup.R"))




# LIBRARIES
# called in the setup.R script





# FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------

WeatherInput <- function(dir.input, weather.var, year.start, year.end) {

  # INPUTS RAW WEATHER DATA & BUILDS PANEL FOR CONSECUTIVE YEARS IN SELECTED PERIOD
  #
  # ARGS
  #   dir.input  : directory containing raw files
  #   weather.var: as string ('air_temp" for terrestrial air temperature, 'precip' for terrestrial precipitation)
  #   year.start : first sample year (earliest: 1900)
  #   year.end   : last sample year  (latest: 2017)
  #
  # RETURNS
  #   untreated panel in long format


  # FIRST PANEL YEAR
  fctn.obj      <- read.table(file = file.path("data/raw2clean/geography/weather_uniDelaware/input", paste0(weather.var,".", year.start)))  # inputs as data frame
  fctn.obj$year <- as.integer(year.start)                                                                                     # adds ref year marker


  # SUBSEQUENT PANEL YEARS
  for (y in (year.start + 1):year.end) {
    aux.obj      <- read.table(file = file.path("data/raw2clean/geography/weather_uniDelaware/input", paste0(weather.var,".", y)))
    aux.obj$year <- as.integer(y)

    fctn.obj     <- rbind(fctn.obj, aux.obj)  # combines multiple years
  }


  # RETURN
  return(fctn.obj)  # full panel
}



WeatherTreatment <- function(raw.panel.long) {

  # TREATS RAW WEATHER DATA
  #
  # ARGS
  #   raw.panel.long: output from 'WeatherInput' function
  #
  # RETURNS
  #   treated panel in long format


  # COLUMN CLEANUP
  # column names
  names(raw.panel.long)[names(raw.panel.long) == "V1"]  <- "coordy_long"
  names(raw.panel.long)[names(raw.panel.long) == "V2"]  <- "coordx_lat"
  names(raw.panel.long)[names(raw.panel.long) == "V3"]  <- "month01"
  names(raw.panel.long)[names(raw.panel.long) == "V4"]  <- "month02"
  names(raw.panel.long)[names(raw.panel.long) == "V5"]  <- "month03"
  names(raw.panel.long)[names(raw.panel.long) == "V6"]  <- "month04"
  names(raw.panel.long)[names(raw.panel.long) == "V7"]  <- "month05"
  names(raw.panel.long)[names(raw.panel.long) == "V8"]  <- "month06"
  names(raw.panel.long)[names(raw.panel.long) == "V9"]  <- "month07"
  names(raw.panel.long)[names(raw.panel.long) == "V10"] <- "month08"
  names(raw.panel.long)[names(raw.panel.long) == "V11"] <- "month09"
  names(raw.panel.long)[names(raw.panel.long) == "V12"] <- "month10"
  names(raw.panel.long)[names(raw.panel.long) == "V13"] <- "month11"
  names(raw.panel.long)[names(raw.panel.long) == "V14"] <- "month12"


  # order
  raw.panel.long <- raw.panel.long[, c(1:2, 16, 3:14)]


  # RETURN
  return(raw.panel.long)
}





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# METADATA
#  TERRESTRIAL AIR TEMPERATURE: 1900-2017 GRIDDED MONTHLY TIME SERIES (V 5.01)
# files: multiple ASCII files compressed under Unix (original compressed file name 'air_temp_2017.tar.gz'; original ASCII files 'air_temp.YYYY' where 
#        YYYY represents reference year)
# content: monthly-mean air temperatures interpolated to a 0.5 by 0.5 degree grid resolution and centered on 0.25 degree (ASCII files); global, but
#          terrestrial only (extent); monthly for JAN/1900 through DEC/2017 (frequency/date of reference)
# source: Willmott, C. J. and Matsuura, K. (2018) Terrestrial Air Temperature and Precipitation: Monthly and Annual Time Series (1900 - 2017)
# available at: http://climate.geog.udel.edu/~climate/html_pages/download.html
# raw data downloaded on: JUL/11/2019
# raw data archived at: https://web.archive.org/web/20200910183757/http://climate.geog.udel.edu/~climate/html_pages/Global2017/air_temp_2017.tar.gz
# raw data archived on: SEP/10/2020 


# TERRESTRIAL PRECIPITATION: 1900-2017 GRIDDED MONTHLY TIME SERIES (V 5.01)
# files: multiple ASCII files compressed under Unix (original compressed file name 'precip_2017.tar.gz'; original ASCII files 'precip.YYYY' where YYYY
#        represents reference year)
# content: monthly total precipitation interpolated to a 0.5 by 0.5 degree grid resolution and centered on 0.25 degree (ASCII files); global, but
#          terrestrial only (extent); monthly for JAN/1900 through DEC/2017 (frequency/date of reference)
# source: Willmott, C. J. and Matsuura, K. (2018) Terrestrial Air Temperature and Precipitation: Monthly and Annual Time Series (1900 - 2017)
# available at: http://climate.geog.udel.edu/~climate/html_pages/download.html
# raw data downloaded on: JUL/11/2019
# raw data archived at: https://web.archive.org/web/20200910184200/http://climate.geog.udel.edu/~climate/html_pages/Global2017/precip_2017.tar.gz
# raw data archived on: SEP/10/2020 


# obs: from data download hub [for both terrestrial air temperature and terrestrial precipitation]
#      All files available here for downloading have been "compressed" under Unix in order to save space. A single compressed file has ".Z" extension.
#      You may need to respecify the ".Z" extension when you save a compressed file. Some of our archives also have multiple files (such as time 
#      series) that are "tar"ed under Unix and have a ".tar" extension. As a result, files must be "untared" and/or "uncompressed" to return them to
#      their original ASCII format, before they may be used.



# RAW DATA INPUT
weather.temp <- WeatherInput(dir.input   = "data/raw2clean/geography/weather_uniDelaware/input",
                             weather.var = "air_temp",
                             year.start  = 2000,
                             year.end    = 2017)

weather.rain <- WeatherInput(dir.input   = "data/raw2clean/geography/weather_uniDelaware/input",
                             weather.var = "precip",
                             year.start  = 2000,
                             year.end    = 2017)



# DATA EXPLORATION [disabled for speed]
# class(weather.temp)
# summary(weather.temp)        # no missing
# lapply(weather.temp, class)  # all columns numeric/integer
# View(weather.temp)

# class(weather.rain)
# summary(weather.rain)        # no missing
# lapply(weather.rain, class)  # all columns numeric/integer
# View(weather.rain)





# DATASET CLEANUP AND PREP ---------------------------------------------------------------------------------------------------------------------------

weather.temp <- WeatherTreatment(weather.temp)
weather.rain <- WeatherTreatment(weather.rain)





# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# TEMPERATURE
label(weather.temp$coordy_long) <- "longitude (decimal degrees)"
label(weather.temp$coordx_lat)  <- "latitude (decimal degrees)"
label(weather.temp$year)        <- "year of reference"
label(weather.temp$month01)     <- "average temperature in JAN (degrees Celsius)"
label(weather.temp$month02)     <- "average temperature in FEB (degrees Celsius)"
label(weather.temp$month03)     <- "average temperature in MAR (degrees Celsius)"
label(weather.temp$month04)     <- "average temperature in APR (degrees Celsius)"
label(weather.temp$month05)     <- "average temperature in MAY (degrees Celsius)"
label(weather.temp$month06)     <- "average temperature in JUN (degrees Celsius)"
label(weather.temp$month07)     <- "average temperature in JUL (degrees Celsius)"
label(weather.temp$month08)     <- "average temperature in AUG (degrees Celsius)"
label(weather.temp$month09)     <- "average temperature in SEP (degrees Celsius)"
label(weather.temp$month10)     <- "average temperature in OCT (degrees Celsius)"
label(weather.temp$month11)     <- "average temperature in NOV (degrees Celsius)"
label(weather.temp$month12)     <- "average temperature in DEC (degrees Celsius)"



# PRECIPITATION
label(weather.rain$coordy_long) <- "longitude (decimal degrees)"
label(weather.rain$coordx_lat)  <- "latitude (decimal degrees)"
label(weather.rain$year)        <- "year of reference"
label(weather.rain$month01)     <- "total precipitation in JAN (mm)"
label(weather.rain$month02)     <- "total precipitation in FEB (mm)"
label(weather.rain$month03)     <- "total precipitation in MAR (mm)"
label(weather.rain$month04)     <- "total precipitation in APR (mm)"
label(weather.rain$month05)     <- "total precipitation in MAY (mm)"
label(weather.rain$month06)     <- "total precipitation in JUN (mm)"
label(weather.rain$month07)     <- "total precipitation in JUL (mm)"
label(weather.rain$month08)     <- "total precipitation in AUG (mm)"
label(weather.rain$month09)     <- "total precipitation in SEP (mm)"
label(weather.rain$month10)     <- "total precipitation in OCT (mm)"
label(weather.rain$month11)     <- "total precipitation in NOV (mm)"
label(weather.rain$month12)     <- "total precipitation in DEC (mm)"


# changes objects names for exportation
geo.global.weather.rain.df <- weather.rain
geo.global.weather.temp.df <- weather.temp



# POST-TREATMENT OVERVIEW 
# summary(weather.temp)
# View(weather.temp)
# summary(weather.rain)
# View(weather.rain)





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(geo.global.weather.temp.df,
     geo.global.weather.rain.df,
     file = file.path("data/raw2clean/geography/weather_uniDelaware/output","geo_global_weather_world_gridded_df.RData"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------