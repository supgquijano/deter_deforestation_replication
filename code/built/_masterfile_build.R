
# > PROJECT INFO
# NAME: DETERRING DEFORESTATION IN THE AMAZON: ENVIRONMENTAL MONITORING AND LAW ENFORCEMENTE - CODE AND DATA REPLICATION ARCHIVE
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: MASTERFILE TO RUN ALL SCRIPTS IN THE BUILT FOLDER
# AUTHOR: JOAO VIEIRA
# 
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: OCT/27/2020
#
# > NOTES
# TIME OF PROCESSING: 7 days




# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# script to setup the additional libraries necessary to this project
source("code/_functions/setup.R")

# starts clock for build masterfile
tic("_masterfile_build.R")





# SCRIPTS --------------------------------------------------------------------------------------------------------------------------------------------

# ADMINISTRATIVE FOLDER

# MUNICIPALITIES IN THE LEGAL AMAZON 
# TIME OF PROCESSING: 1 minute
# OBS: 
tic("admin_la_territory_build_muni.R")
source("code/built/administrative/territorial/legal_amazon/admin_la_territory_build_muni.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())



# GEOGRAPHY FOLDER

# BRAZILIAN BIOMES INFORMATION FOR EACH MUNICIPALITY
# TIME OF PROCESSING: 11 minutes
# OBS: 
tic("geo_br_biomes_build_muni.R")
source("code/built/geography/biomes/geo_br_biomes_build_muni.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# CPCG PRECIPITATION INFORMATION FOR EACH MUNICIPALITY
# TIME OF PROCESSING: 5 minutes
# OBS: 
tic("geography_br_weather_CPCG_build_precipitation.R")
source("code/built/geography/weather/geography_br_weather_CPCG_build_precipitation.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# CPCG TEMPERATURE  INFORMATION FOR EACH MUNICIPALITY
# TIME OF PROCESSING: 50 minutes
# OBS: 
tic("geography_br_weather_CPCG_build_temperature.R")
source("code/built/geography/weather/geography_br_weather_CPCG_build_temperature.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# PRECIPITATION NCEP-DOE REANALYSIS 2  INFORMATION FOR EACH MUNICIPALITY
# TIME OF PROCESSING: 15 seconds
# OBS: 
tic("geo_br_weather_reanalysis_build.R")
source("code/built/geography/weather/geo_br_weather_reanalysis_build.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# TERRESTRIAL AIR TEMPERATURE AND PRECIPITATION (V 5.01) INFORMATION FOR EACH MUNICIPALITY
# TIME OF PROCESSING: 7 minutes
# OBS: 
tic("weather_build_spatial_brmuni.R")
source("code/built/geography/weather/weather_build_spatial_brmuni.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())



# LAND COVER FOLDER

# DETER CLOUDS INFORMATION FOR EACH MUNICIPALITY
# TIME OF PROCESSING: 7 days
# OBS:
tic("deter_build_clouds.R")
source("code/built/land_cover/deter/deter_build_clouds.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())



# POLICY FOLDER

# ENVIRONMENTAL SANCTIONS (FINES)
# TIME OF PROCESSING: 4 seconds
# OBS: 
tic("policy_la_fines_build_munilevel.R")
source("code/built/policy/fines/policy_la_fines_build_munilevel.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())




# stops clock for build masterfile
toc()





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------