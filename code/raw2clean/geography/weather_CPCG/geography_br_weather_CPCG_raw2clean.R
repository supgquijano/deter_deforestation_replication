
# > PROJECT INFO
# NAME: CENTRAL DATA REPOSITORY CONSTRUCTION - CPCG [CLIMATIC DATA, DAILY PRECIPITATION AND TEMPERATURE]
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT RAW DATA
# AUTHOR: TOMAS DO VALLE
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/17/2020
#
# > NOTES
# 1: extracted, for each municipality, cell-level spatial average prior to working out monthly average/total
# 2: function raster2points despite working properly will return warnings " this does not look like an appropriate object for this function" refering>
#    to function rotate applied to rasters read from netcdf files. the function returns the object with the correct expected changes.






# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions/setup.R"))
source(file.path("code/_functions", "gis_crs.R"))
source(file.path("code/_functions", "gis_raster.R"))
source(file.path("code/raw2clean/geography/weather_CPCG", "_functions_forParallelProcessing.R"))
source(file.path("code/raw2clean/geography/weather_CPCG", "_functions.R"))


# LIBRARIES
# called in the setup.R script





# DATA INPUT------------------------------------------------------------------------------------------------------------------------------------------

# METADATA
#
# CPC GLOBAL UNIFIED PRECICIPATION (CPCG Precipitation)
# files: netCDF files with pattern CPCG_precipitation_"YEAR1_YEAR2", where "YEAR1_YEAR2" assumes the following values: "2003_2006", "2007_2010", "2011_2014", "2015_2016"; original files renamed in order to organize arquives chronologically
# content: precipitation registered on a daily basis; lat(45°S; 15°N); lon(260°E; 330°E) (extent); daily (frequency); JAN/01/2003 through DEC/31/2016
# source:  National Oceanic and Atmospheric Administration, Climate Prediction Center (NOAA-CPC) provided by Physical Sciences Laboratory (NOAA-PSL) 
# available at: https://psl.noaa.gov/cgi-bin/db_search/DBSearch.pl?Dataset=CPC+Global+Precipitation&Statistic=Total&Variable=Precipitation&group=0&submit=Search
# raw data downloaded on: MAY/17/2018
# web archived at: https://web.archive.org/web/20200910170401/https://psl.noaa.gov/data/gridded/data.cpc.globalprecip.html (main page only - for download see instructions below)
# web archived on: SEP/10/2020
# CRS: LongLat (coordinate system), WGS84(datum), not projected
#
# INSTRUCTIONS FOR DOWNLOAD - same process for each "CPCG_precipitation_YEAR1_YEAR2" file
# 1) insert the link (https://psl.noaa.gov/cgi-bin/db_search/DBSearch.pl?Dataset=CPC+Global+Precipitation&Statistic=Total&Variable=Precipitation&group=0&submit=Search) on a browser
# 2) click on "Make plot or subset"
# 3) Set Axis Dimensions: lat(45°S; 15°N); lon(260°E; 330°E)
# 4) Set time range. Example for "2003_2006": (Begin: 2003/JAN/1 - End: 2006/DEC/31). Do the same for each combination of "YEAR1_YEAR2" described above
# 5) Select Output options: "Create a subset without making a plot"
# 6) Click on "Create Plot or Subset of Data"
# 7) Click on "FTP a copy of the file"
# 8) Save file in the input folder using the file pattern mentioned above
#
#
#
# CPC GLOBAL TEMPERATURE (CPCG Temperature - Maximum)
# files: pattern CPCG_temperature_max_"YEAR1_YEAR2", where "YEAR1_YEAR2" assumes the following values: "2003_2006", "2007_2010", "2011_2014", "2015_2016"; original files renamed in order to organize arquives chronologically
# content: maximum temperature registered on a daily basis; lat(45°S; 15°N); lon(260°E; 330°E) (extent); daily (frequency); JAN/01/1979 through DEC/31/2016
# source:  National Oceanic and Atmospheric Administration, Climate Prediction Center (NOAA-CPC) provided by Physical Sciences Laboratory (NOAA-PSL) 
# available at: https://psl.noaa.gov/cgi-bin/db_search/DBSearch.pl?Dataset=CPC+Global+Temperature&Statistic=Maximum&Variable=Maximum+Temperature&group=0&submit=Search
# raw data downloaded on: MAY/17/2018
# web archived at: https://web.archive.org/web/20200910172109/https://psl.noaa.gov/data/gridded/data.cpc.globaltemp.html (main page only - for download see instructions below)
# web archived on: SEP/10/2020
# CRS: LongLat (coordinate system), WGS84(datum), not projected
#
# INSTRUCTIONS FOR DOWNLOAD - same process for each "CPCG_temperature_max_YEAR1_YEAR2" file
# 1) insert the link (https://psl.noaa.gov/cgi-bin/db_search/DBSearch.pl?Dataset=CPC+Global+Temperature&Statistic=Maximum&Variable=Maximum+Temperature&group=0&submit=Search) on a browser
# 2) click on "Make plot or subset"
# 3) Set Axis Dimensions: lat(45°S; 15°N); lon(260°E; 330°E)
# 4) Set time range. Example for "2003_2006": (Begin: 2003/JAN/1 - End: 2006/DEC/31). Do the same for each combination of "YEAR1_YEAR2" described above
# 5) Select Output options: "Create a subset without making a plot"
# 6) Click on "Create Plot or Subset of Data"
# 7) Click on "FTP a copy of the file"
# 8) Save file in the input folder using the file pattern mentioned above
#
#
#
# CPC GLOBAL TEMPERATURE (CPCG Temperature - minimum)
# files: pattern CPCG_temperature_min_"YEAR1_YEAR2", where "YEAR1_YEAR2" assumes the following values: "2003_2006", "2007_2010", "2011_2014", "2015_2016"; original files renamed in order to organize arquives chronologically
# content: minimum temperature registered on a daily basis; lat(45°S; 15°N); lon(260°E; 330°E) (extent); daily (frequency); JAN/01/1979 through DEC/31/2016
# source: National Oceanic and Atmospheric Administration, Climate Prediction Center (NOAA-CPC) provided by Physical Sciences Laboratory (NOAA-PSL) 
# available at: https://psl.noaa.gov/cgi-bin/db_search/DBSearch.pl?Dataset=CPC+Global+Temperature&Statistic=Minimum&Variable=Minimum+Temperature&group=0&submit=Search 
# raw data downloaded on: JUN/11/2018
# web archived at: https://web.archive.org/web/20200910172109/https://psl.noaa.gov/data/gridded/data.cpc.globaltemp.html (main page only - for download see instructions below)
# web archived on: SEP/10/2020
# CRS: LongLat (coordinate system), WGS84(datum), not projected
#
# INSTRUCTIONS FOR DOWNLOAD - same process for each "CPCG_temperature_min_YEAR1_YEAR2" file
# 1) insert the link (https://psl.noaa.gov/cgi-bin/db_search/DBSearch.pl?Dataset=CPC+Global+Temperature&Statistic=Minimum&Variable=Minimum+Temperature&group=0&submit=Search) on a browser
# 2) click on "Make plot or subset"
# 3) Set Axis Dimensions: lat(45°S; 15°N); lon(260°E; 330°E)
# 4) Set time range. Example for "2003_2006": (Begin: 2003/JAN/1 - End: 2006/DEC/31). Do the same for each combination of "YEAR1_YEAR2" described above
# 5) Select Output options: "Create a subset without making a plot"
# 6) Click on "Create Plot or Subset of Data"
# 7) Click on "FTP a copy of the file"
# 8) Save file in the input folder using the file pattern mentioned above



# RAW DATA
# data input inside processing due to memory allocation

# ADMIN INPUT 
load("data/raw2clean/administrative/territorial_ibge/brazil/output/2007/admin_br_territory_muni_2007_spdf.Rdata")  # most recent admin muni data available >
                                                                                                             # repository



# DATA PROCESSING-------------------------------------------------------------------------------------------------------------------------------------
# run time: aprox 3h per year for each variable

# AUX VARIABLE
aux.year.interval        <- c("2003_2006", "2007_2010", "2011_2014", 
                              "2015_2016")  # format according to input files indentification



# PREP AUXILIAR DATA
admin.br.muni.2007.spdf@data <- base::as.data.frame(admin.br.muni.2007.spdf@data)
admin.br.muni.2007.spdf      <- admin.br.muni.2007.spdf[admin.br.muni.2007.spdf$muni_code !=  2605459, ]  # excludes fernando de noronha too far away>
                                                                                                          # from the coast

for (y in seq_along(aux.year.interval)) {

  # CLOCK START
  time.start.1 <- Sys.time()
  
  
  
  # CLIMATE DATA INPUT
  # precipitation data
  aux.raster.path.precip   <- paste0("data/raw2clean/geography/weather_CPCG/input", "/GPCG_precipitation_", aux.year.interval[[y]], 
                                     ".nc")
  nc.data.precip           <- brick(aux.raster.path.precip)
  rm(aux.raster.path.precip)
  
  
  # temperature data
  
  # maximum temperature
  aux.raster.path.temp.max <- paste0("data/raw2clean/geography/weather_CPCG/input", "/CPCG_temperature_max_", aux.year.interval[[y]], 
                                     ".nc")
  nc.data.temp.max         <- brick(aux.raster.path.temp.max)
  rm(aux.raster.path.temp.max)
  
  # minimum temperature
  aux.raster.path.temp.min <- paste0("data/raw2clean/geography/weather_CPCG/input", "/CPCG_temperature_min_", aux.year.interval[[y]], 
                                     ".nc")
  nc.data.temp.min         <- brick(aux.raster.path.temp.min)
  rm(aux.raster.path.temp.min)
  
  
  # transforms 0 : 360 lon to -180 : 180
  nc.data.precip   <- rotate(nc.data.precip)
  nc.data.temp.max <- rotate(nc.data.temp.max)
  nc.data.temp.min <- rotate(nc.data.temp.min)
  
  
  # DATA PARALLEL TREATMENT 
  #aux variables
  aux.folder.name              <- "data/raw2clean/geography/weather_CPCG/output"
  aux.return.objname.precip    <- paste0("CPCG.precip.", aux.year.interval[[y]], ".")
  aux.return.objname.temp.max  <- paste0("CPCG.temp.max.", aux.year.interval[[y]], ".")
  aux.return.objname.temp.min  <- paste0("CPCG.temp.min.", aux.year.interval[[y]], ".")
  aux.temp.dir.path            <- file.path("data/_temp/raster")
  aux.file.output.report       <- "data/raw2clean/geography/weather_CPCG/documentation"
  
  # CLOCK START
  time.start.2 <- Sys.time()
  
  
  # precipitation data
  raster2points(raster.stack       = nc.data.precip,
                muni.list          = admin.br.muni.2007.spdf,
                folder.name        = aux.folder.name,
                raster.name        = substr(names(nc.data.precip), 2, 11),
                temp.dir.path      = aux.temp.dir.path,
                free.cores         = 1,
                return.objname     = aux.return.objname.precip,
                spdf.crs.original  = proj4string(admin.br.muni.2007.spdf),
                spdf.idcol         = "muni_code",
                file.output.report = aux.file.output.report)
  
  
  
  # ENVIRONMENT CLEANUP
  rm("aux.return.objname.precip", "nc.data.precip")
  gc()
  
  
  
  # CLOCK STOP
  time.end.2 <- Sys.time()
  
  
  
  # CONSOLE OUTPUT
  print(paste0("** data treatment of CPCG precipitation for ", aux.year.interval[[y]], " started at ", time.start.2, " and finished at ", time.end.2))
  
  
  
  # CLOCK START
  time.start.3 <- Sys.time()
  
  
  # temperature data
  
  
  # maximum temperature
  raster2points(raster.stack       = nc.data.temp.max,
                muni.list          = admin.br.muni.2007.spdf,
                folder.name        = aux.folder.name,
                raster.name        = substr(names(nc.data.temp.max), 2, 11),
                temp.dir.path      = aux.temp.dir.path,
                free.cores         = 1,
                return.objname     = aux.return.objname.temp.max,
                spdf.crs.original  = proj4string(admin.br.muni.2007.spdf),
                spdf.idcol         = "muni_code",
                file.output.report = aux.file.output.report)
  
  
  
  # ENVIRONMENT CLEANUP
  rm("aux.return.objname.temp.max", "nc.data.temp.max")
  gc()
  
  
  
  # CLOCK STOP
  time.end.3 <- Sys.time()
  
  
  
  # CONSOLE OUTPUT
  print(paste0("** data treatment of CPCG max temperature for ", aux.year.interval[[y]], " started at ", time.start.3, " and finished at ", time.end.3))
  

  
  # CLOCK START
  time.start.4 <- Sys.time()
  
  
  # minimum temperature
  raster2points(raster.stack       = nc.data.temp.min,
                muni.list          = admin.br.muni.2007.spdf,
                folder.name        = aux.folder.name,
                raster.name        = substr(names(nc.data.temp.min), 2, 11),
                temp.dir.path      = aux.temp.dir.path,
                free.cores         = 1,
                return.objname     = aux.return.objname.temp.min,
                spdf.crs.original  = proj4string(admin.br.muni.2007.spdf),
                spdf.idcol         = "muni_code",
                file.output.report = aux.file.output.report)
  
  
  
  # ENVIRONMENT CLEANUP
  rm("aux.return.objname.temp.min", "nc.data.temp.min")
  gc()
  
  
  
  # CLOCK STOP
  time.end.4 <- Sys.time()
  
  
  
  # CONSOLE OUTPUT
  print(paste0("** data treatment of CPCG min temperature for ", aux.year.interval[[y]], " started at ", time.start.4, " and finished at ", time.end.4))
  
  
  
  # CLOCK STOP
  time.end.1 <- Sys.time()
  
  
  
  # CONSOLE OUTPUT
  print(paste0("** data treatment of CPCG - temperature and precipitation - for ", aux.year.interval[[y]], " started at ", time.start.1, 
               " and finished at ", time.end.1))
 
  
  }
  


# CLOCK START
time.start.5 <- Sys.time()
  


# COMBINING OUTPUTS
# precipitation data
nCores <- detectCores()

# build core clusters for parallelization
cl <- makeCluster(nCores - 1)

# activate clusters
registerDoSNOW(cl)

# apply parallized function 

foreach(i = seq_along(admin.br.muni.2007.spdf),
        .packages = c('raster', 'rgdal', 'rgeos', 'foreach', 'data.table')) %dopar% {
          source(file.path("code/raw2clean/geography/weather_CPCG", "_functions.R"))
          CombineMuniDF(fctn.muni.code      = as.character(admin.br.muni.2007.spdf@data[i, 1]),
                        fctn.variable       = "precip",
                        fctn.year.interval  = aux.year.interval,
                        fctn.folder.name    = aux.folder.name,
                        fctn.return.objname = "geo.br.weather.CPCG.precipitation")
        }


stopCluster(cl)
gc()



# CLOCK STOP
time.end.5 <- Sys.time()



# CONSOLE OUTPUT
print(paste0("** final precipitation outputs for all 5569 municipalities started at ", time.start.5, " and finished at ", time.end.5))



# CLOCK START
time.start.6 <- Sys.time()

# temperature data


# maximum temperature
nCores <- detectCores()

# build core clusters for parallelization
cl <- makeCluster(nCores - 1)

# activate clusters
registerDoSNOW(cl)

# apply parallized function 

foreach(i = seq_along(admin.br.muni.2007.spdf),
        .packages = c('raster', 'rgdal', 'rgeos', 'foreach', 'data.table')) %dopar% {
          source(file.path("code/raw2clean/geography/weather_CPCG", "_functions.R"))
          CombineMuniDF(fctn.muni.code      = as.character(admin.br.muni.2007.spdf@data[i, 1]),
                        fctn.variable       = "temp.max",
                        fctn.year.interval  = aux.year.interval,
                        fctn.folder.name    = aux.folder.name,
                        fctn.return.objname = "geo.br.weather.CPCG.temp.max")
        }


stopCluster(cl)
gc()



# CLOCK STOP
time.end.6 <- Sys.time()



# CONSOLE OUTPUT
print(paste0("** final max temperature outputs for all 5569 municipalities started at ", time.start.6, " and finished at ", time.end.6))



# CLOCK START
time.start.7 <- Sys.time()

# temperature data


# minimum temperature
nCores <- detectCores()

# build core clusters for parallelization
cl <- makeCluster(nCores - 1)

# activate clusters
registerDoSNOW(cl)

# apply parallized function 

foreach(i = seq_along(admin.br.muni.2007.spdf),
        .packages = c('raster', 'rgdal', 'rgeos', 'foreach', 'data.table')) %dopar% {
          source(file.path("code/raw2clean/geography/weather_CPCG", "_functions.R"))
          CombineMuniDF(fctn.muni.code      = as.character(admin.br.muni.2007.spdf@data[i, 1]),
                        fctn.variable       = "temp.min",
                        fctn.year.interval  = aux.year.interval,
                        fctn.folder.name    = aux.folder.name,
                        fctn.return.objname = "geo.br.weather.CPCG.temp.min")
        }


stopCluster(cl)
gc()



# CLOCK STOP
time.end.7 <- Sys.time()



# CONSOLE OUTPUT
print(paste0("** final min temperature outputs for all 5569 municipalities started at ", time.start.7, " and finished at ", time.end.7))




# END OF SCRIPT-------------------------------------------------------------------------------------------------------------------------------------
