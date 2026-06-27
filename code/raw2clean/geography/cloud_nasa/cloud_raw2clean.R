
# > PROJECT INFO
# NAME: CENTRAL DATA REPOSITORY CONSTRUCTION - CLOUD FRACTION (1 MONTH - TERRA/MODIS) 
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT RAW DATA
# AUTHOR: JOAO VIEIRA
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





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# METADATA
#
# CLOUD FRACTION (1 MONTH - TERRA/MODIS) - MODIS Atmosphere L3 Monthly Product (V 6.01)
# files: multiple netCDF files links for download on filesForDownload.txt (by month)
# content: monthly-mean cloud fraction interpolated to a 1 by 1 degree grid resolution;
#          monthly for AUG/2000 through JUL/2016  (frequency/date)
# source:  Platnick, King and Hubanks (2017) - NASA MODIS Adaptive Processing System provided by NASA Earth Data Giovanni
# available at: https://giovanni.gsfc.nasa.gov/giovanni/#service=MpAn&starttime=2000-08-01T00:00:00Z&endtime=2016-07-31T23:59:59Z&bbox=-75.94,-34.45,31.64,7.73&data=MOD08_M3_6_1_Cloud_Fraction_Mean_Mean&dataKeyword=cloud%20fraction
# raw data downloaded on: JUL/21/2020
# web archived at: dx.doi.org/10.5067/MODIS/MOD08_M3.061 (documentation page only)
# web archive retrieved on: SEP/23/2020
# METHOD USED TO OBTAIN THE DATA:
# 1) created a log in on NASA Earth Data
# 2) used the parameters specified at https://giovanni.gsfc.nasa.gov/giovanni/#service=MpAn&starttime=2000-08-01T00:00:00Z&endtime=2016-07-31T23:59:59Z&bbox=-75.94,-34.45,31.64,7.73&data=MOD08_M3_6_1_Cloud_Fraction_Mean_Mean&dataKeyword=cloud%20fraction
# 3) clicked on "Plot Data"
# 4) downloaded url list for each month and saved as "filesForDownload.txt"
# 5) manually downloaded each file using the links provided in "filesForDownload.txt"


# RAW DATA INPUT
# list all tiff files
aux.file.names <- list.files("data/raw2clean/geography/cloud_nasa/input", 
                             full.names = T,
                             pattern = "^g4.subsetted.MOD08_M3_6_1_Cloud_Fraction_Mean_Mean.\\d{8}.75W_34S_31W_7N.nc")
# read all files into a raster stack
raster.stack <- stack(aux.file.names)


# spatial municipality data
load(file = file.path("data/raw2clean/administrative/territorial_ibge/brazil/output/2007", "admin_br_territory_muni_2007_spdf.Rdata"))





# DATASET CONSTRUCTION ---------------------------------------------------------------------------------------------------------------------------------------

# transform "99999" values to NAs
values(raster.stack)[values(raster.stack) == 99999] = NA

# transform municipalities data to raster crs
admin.br.muni.2007.spdf <- spTransform(admin.br.muni.2007.spdf, proj4string(raster.stack))

# crop raster to relevant area
raster.stack <- crop(raster.stack, admin.br.muni.2007.spdf)

# change raster layer names
aux.years <- c(2001:2015)
aux.months <- c(1:12)
aux.complete.years <- expand.grid(aux.years, aux.months) %>% arrange(Var1, Var2) %>% unite(col = time) %>% pull(time)
names(raster.stack) <- c("2000_8", "2000_9", "2000_10", "2000_11", "2000_12",
                         aux.complete.years,
                         "2016_1", "2016_2", "2016_3", "2016_4", "2016_5", "2016_6", "2016_7")

# extract raster info and add to the spdf
admin.br.muni.2007.spdf <- raster::extract(raster.stack, admin.br.muni.2007.spdf, fun = mean, na.rm = TRUE, sp = TRUE)

# extract df from spdf
cloud.cover.muni <- admin.br.muni.2007.spdf@data

# remove old objects
rm(admin.br.muni.2007.spdf, raster.stack)

# transform data into a panel
cloud.cover.muni <-
  cloud.cover.muni %>% 
  dplyr::select(-muni_name, -muni_area, -muni_centroid_coordx, -muni_centroid_coordy,
                -starts_with("state"), -starts_with("region")) %>% 
  gather(time, cloud_cover, -muni_code) %>% 
  mutate(year = as.numeric(substr(time, 2, 5)),
         month = as.numeric(substr(time, 7,8))) %>% 
  dplyr::select(muni_code, year, month, cloud_cover)

  


# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# LABELS
label(cloud.cover.muni$muni_code)       <- "municipality code 7-digit IBGE"
label(cloud.cover.muni$month)           <- "month of reference"
label(cloud.cover.muni$year)            <- "year of reference"
label(cloud.cover.muni$cloud_cover)     <- "average cloud cover (share)"



# changes objects names for exportation
geo.brl.cloudCoverMuni.df <- cloud.cover.muni



# POST-TREATMENT OVERVIEW 
# summary(geo.brl.cloudCoverMuni.df)
# View(geo.brl.cloudCoverMuni.df)





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(geo.brl.cloudCoverMuni.df,
     file = file.path("data/raw2clean/geography/cloud_nasa/output","geo_brl_cloudCoverMuni_df.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------

