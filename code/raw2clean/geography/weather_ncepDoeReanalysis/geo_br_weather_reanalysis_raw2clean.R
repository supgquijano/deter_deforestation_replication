
# > PROJECT INFO
# NAME: CENTRAL DATA REPOSITORY CONSTRUCTION - PRECIPITATION REANALYSIS
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT RAW DATA
# AUTHOR: JOAO VEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/17/2020 
#
# > NOTES
# 1: -





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions/setup.R"))
source(file.path("code/_functions/", "gis_crs.R"))
source(file.path("code/_functions/", "gis_raster.R"))
source(file.path("code/_functions/", "unit_conversion.R"))
source(file.path("code/raw2clean/geography/weather_ncepDoeReanalysis/function_ExtractCellsForPolygonsReanalysis.R"))
source(file.path("code/raw2clean/geography/weather_ncepDoeReanalysis/function_parallel_process_raster2points.R"))


# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# METADATA
#
# NCEP-DOE Reanalysis 2
# file: pr_wtr.eatm.mon.mean
# content: mean monthly precipitation; lat(90°S; 90°N); lon(0°E; 357.5°E) (extent); monthly (frequency); JAN/01/1979 through MAR/31/2019
# source:  NOAA, National Centers for Environmental Prediction (NCEP) provided by NOAA-PSL
# available at: https://psl.noaa.gov/data/gridded/data.ncep.reanalysis2.surface.html
# raw data downloaded on: APR/24/2019
# raw data archived at: https://web.archive.org/web/20200910180228/ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis2.derived/surface/pr_wtr.eatm.mon.mean.nc
# raw data archived on: SEP/10/2020 
# CRS: LongLat (coordinate system), WGS84(datum), not projected



# load muni shapes
load("data/raw2clean/administrative/territorial_ibge/brazil/output/2007/admin_br_territory_muni_2007_spdf.Rdata")  # most recent admin muni data available >





# DATA PREP ------------------------------------------------------------------------------------------------------------------------------------------

# load raster
raster.brick <- brick(file.path("data/raw2clean/geography/weather_ncepDoeReanalysis/input", "pr_wtr.eatm.mon.mean.nc"), crs = "+proj=longlat +datum=WGS84 +no_defs")

# transforms 0 : 360 lon to -180 : 180
raster.brick <- rotate(raster.brick)

# transform rasterBrick to rasterBrickTimeSeries
raster.brick <- rts(raster.brick, ymd_hms(raster.brick@z$`Date/time`))

# subset rasterBrick to the deter period 2006-2016
raster.brick <- subset(raster.brick, "2006-01-01 01:06:28 UTC/2016-12-01 01:06:28 UTC")
  
# transform rasterBrickTimeSeries back to rasterBrick
raster.brick <- raster.brick@raster

# adjust layer names to contain year and month information only (yyyy.mm)
names(raster.brick) <- str_sub(names(raster.brick), start = 2, end = 8)
  
# apply parallel function
raster2points(raster.stack  = raster.brick,
              muni.list     = admin.br.muni.2007.spdf,
              folder.name   = "data/raw2clean/geography/weather_ncepDoeReanalysis/output",
              raster.name   = str_sub(names(raster.brick), start = 2, end = 8),
              temp.dir.path = "data/_temp/raster",
              spdf.crs.original = proj4string(admin.br.muni.2007.spdf),
              free.cores    = 2,
              return.objname = "geo.br.weather.reanalysis")
  




# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------