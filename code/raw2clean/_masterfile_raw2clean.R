
# > PROJECT INFO
# NAME: DETERRING DEFORESTATION IN THE AMAZON: ENVIRONMENTAL MONITORING AND LAW ENFORCEMENTE - CODE AND DATA REPLICATION ARCHIVE
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: MASTER FILE TO RUN ALL SCRIPTS IN THE RAW2CLEAN FOLDER
# AUTHOR: JOAO VIEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: OCT/20/2020
#
# > NOTES
# TIME OF PROCESSING: 14 days




# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# script to setup the additional libraries necessary to this project
source("code/_functions/setup.R")

# starts clock for raw2clean masterfile
tic("_masterfile_raw2clean.R")





# SCRIPTS --------------------------------------------------------------------------------------------------------------------------------------------

# ADMINISTRATIVE FOLDER

# BRAZILIAN MUNICIPALITIES DIVISION (2007)
# TIME OF PROCESSING: 30 seconds
# OBS: 
tic("admin_br_territory_2007_raw2clean.R")
source("code/raw2clean/administrative/territorial_ibge/admin_br_territory_2007_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# LEGAL AMAZON DIVISION
# TIME OF PROCESSING: 2 seconds
# OBS: 
tic("admin_la_territory_raw2clean.R")
source("code/raw2clean/administrative/territorial_ibge/admin_la_territory_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())



# AGRICULTURE FOLDER

# MUNICPAL CROP PRODUCTION - SELECTED CROPS (PAM)
# TIME OF PROCESSING: 8 seconds
# OBS: 
tic("br_pam_crops_raw2clean.R")
source("code/raw2clean/agriculture/pam_ibge/br_pam_crops_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# MUNICIPAL CROP PRODUCTION - TOTAL PRODUCTION (PAM)
# TIME OF PROCESSING: 1 second
# OBS: 
tic("br_pam_all_crops_total_raw2clean.R")
source("code/raw2clean/agriculture/pam_ibge/br_pam_all_crops_total_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# MUNICIPAL LIVESTROCK SURVEY (PPM)
# TIME OF PROCESSING: 3 seconds
# OBS: 
tic("br_ppm_livestock_raw2clean.R")
source("code/raw2clean/agriculture/pPm_ibge/br_ppm_livestock_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())



# GEOGRAPHY FOLDER

# BRAZILIAN BIOMES DIVISION
# TIME OF PROCESSING: 2 seconds
# OBS: 
tic("geo_br_biomes_raw2clean.R")
source("code/raw2clean/geography/biomes_ibge/geo_br_biomes_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# CLOUD COVER (TERRA/MODIS)
# TIME OF PROCESSING: 3 minutes
# OBS: 
tic("cloud_raw2clean.R")
source("code/raw2clean/geography/cloud_nasa/cloud_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# CPCG PRECIPITATION AND TEMPERATURE
# TIME OF PROCESSING: 6 days
# OBS:
tic("geography_br_weather_CPCG_raw2clean.R")
source("code/raw2clean/geography/weather_CPCG/geography_br_weather_CPCG_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# PRECIPITATION NCEP-DOE REANALYSIS 2
# TIME OF PROCESSING: 1 hour
# OBS: 
tic("geo_br_weather_reanalysis_raw2clean.R")
source("code/raw2clean/geography/weather_ncepDoeReanalysis/geo_br_weather_reanalysis_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# TERRESTRIAL AIR TEMPERATURE AND PRECIPITATION (V 5.01)
# TIME OF PROCESSING: 1 minute
# OBS: 
tic("weather_raw2clean")
source("code/raw2clean/geography/weather_uniDelaware/weather_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())



# LAND COVER FOLDER

# DETER ALERTS
# TIME OF PROCESSING: 7 minutes
# OBS: 
tic("deter_raw2clean_alerts.R")
source("code/raw2clean/land_cover/deter_inpe/deter_raw2clean_alerts.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# DETER CLOUDS
# TIME OF PROCESSING: 7 days
# OBS:
tic("deter_raw2clean_clouds.R")
source("code/raw2clean/land_cover/deter_inpe/deter_raw2clean_clouds.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())

# PRODES LEGAL AMAZON LAND COVER
# TIME OF PROCESSING: 1 second
# OBS: 
tic("prodes_muni_raw2clean.R")
source("code/raw2clean/land_cover/prodes_inpe/municipality_level/prodes_muni_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())



# MACRO FOLDER

# AGRICULTURAL COMMODITY PRICES (SEAB-PR)
# TIME OF PROCESSING: 1 second
# OBS: 
tic("br_prices_commodities_raw2clean.R")
source("code/raw2clean/macro/commodities_seabpr/br_prices_commodities_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# DEFLATOR INDEX (IPA EP DI)
# TIME OF PROCESSING: 1 second
# OBS: 
tic("br_deflator_ipa_raw2clean.R")
source("code/raw2clean/macro/deflator_fgv/br_deflator_ipa_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())



# POLICY FOLDER

# ENVIRONMENTAL SANCTIONS (FINES)
# TIME OF PROCESSING: 6 seconds
# OBS: 
tic("policy_la_fines_raw2clean.R")
source("code/raw2clean/policy/fines_ibama/policy_la_fines_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# PRIORITY MUNICIPALITIES - RAW BUILD
# TIME OF PROCESSING: 1 second
# OBS: 
tic("policy_la_prioritymuni_rawBuild.R")
source("code/raw2clean/policy/priorityMuni_mma/policy_la_prioritymuni_rawBuild.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())

# PRIORITY MUNICIPALITIES - RAW2CLEAN
# TIME OF PROCESSING: 1 second
# OBS: 
tic("policy_la_prioritymuni_raw2clean.R")
source("code/raw2clean/policy/priorityMuni_mma/policy_la_prioritymuni_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# BRAZILIAN PROTECTED AREAS 
# TIME OF PROCESSING: 1 minute
# OBS: 
tic("br_pa_raw2clean.R")
source("code/raw2clean/policy/protectedAreas_mma/br_pa_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# BRAZILIAN INDIGENOUS LANDS
# TIME OF PROCESSING: 22 seconds
# OBS: 
tic("_masterfile_indigenousLands_funaiIsa.R")
source("code/raw2clean/policy/indigenousLands_funaiIsa/_masterfile_indigenousLands_funaiIsa.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())



# stops clock for raw2clean masterfile
toc()





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------