
# > PROJECT INFO
# NAME: DETERRING DEFORESTATION IN THE AMAZON: ENVIRONMENTAL MONITORING AND LAW ENFORCEMENTE - CODE AND DATA REPLICATION ARCHIVE
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: MASTERFILE TO RUN ALL R SCRIPTS IN THE PROJECT SPECIFIC FOLDER
# AUTHOR: JOAO VIEIRA
# 
# > EDIT DETAILS
# BY: CLARISSA GANDOUR
# ON: NOV/28/2021
#
# > NOTES
# TIME OF PROCESSING: 3 hours




# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# script to setup the additional libraries necessary to this project
source("code/_functions/setup.R")

# starts clock for projectSpecific masterfile
tic("_masterfile_projectSpecific.R")





# SCRIPTS --------------------------------------------------------------------------------------------------------------------------------------------

# ANNUAL PANEL FOR ANALYSIS CONSTRUCTION

# SAMPLE CONSTRUCTION
# TIME OF PROCESSING: 1 second
# OBS: 
tic("seriesConstruction_sample.R")
source("code/projectSpecific/seriesConstruction_sample.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# PRODES DEFORESTATION VARIABLE CONSTRUCTION
# TIME OF PROCESSING: 1 second
# OBS: 
tic("seriesConstruction_prodesDeforestation.R")
source("code/projectSpecific/seriesConstruction_prodesDeforestation.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# FINES VARIABLE CONSTRUCTION
# TIME OF PROCESSING: 1 second
# OBS: 
tic("seriesConstruction_fines.R")
source("code/projectSpecific/seriesConstruction_fines.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# DETER CLOUDS VARIABLE CONSTRUCTION
# TIME OF PROCESSING: 1 second
# OBS: 
tic("seriesConstruction_deterClouds.R")
source("code/projectSpecific/seriesConstruction_deterClouds.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# WEATHER ALTERNATIVE REANALYSIS VARIABLE CONSTRUCTION
# TIME OF PROCESSING: 6 minutes
# OBS: 
tic("seriesConstruction_weatherAltReanalysis.R")
source("code/projectSpecific/seriesConstruction_weatherAltReanalysis.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# WEATHER ALTERNATIVE CPCG VARIABLE CONSTRUCTION
# TIME OF PROCESSING: 4 seconds
# OBS: 
tic("seriesConstruction_weatherAltCPCG.R")
source("code/projectSpecific/seriesConstruction_weatherAltCPCG.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# WEATHER MAIN VARIABLE (TERRESTRIAL AIR TEMPERATURE AND PRECIPITATION (V 5.01)) CONSTRUCTION
# TIME OF PROCESSING: 4 seconds
# OBS: 
tic("seriesConstruction_weather.R")
source("code/projectSpecific/seriesConstruction_weather.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# PROTECTED TERRITORY VARIABLE CONSTRUCTION
# TIME OF PROCESSING: 3 hours
# OBS: 
tic("seriesConstruction_protectedTerritory.R")
source("code/projectSpecific/seriesConstruction_protectedTerritory.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# PRIORITY MUNICIPALITIES VARIABLE CONSTRUCTION
# TIME OF PROCESSING: 1 second
# OBS: 
tic("seriesConstruction_priorityMuni.R")
source("code/projectSpecific/seriesConstruction_priorityMuni.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# WEIGHTED COMMODTIY PRICES VARIABLE CONSTRUCTION
# TIME OF PROCESSING: 10 seconds
# OBS: 
tic("seriesConstruction_prices.R")
source("code/projectSpecific/seriesConstruction_prices.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())


# NASA CLOUDS VARIABLE CONSTRUCTION
# TIME OF PROCESSING: 6 minutes
# OBS: 
tic("seriesConstruction_nasaClouds.R")
source("code/projectSpecific/seriesConstruction_nasaClouds.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())



# PANEL CONSTRUCTION - MERGE ALL VARIABLES
# TIME OF PROCESSING: 2 seconds
# OBS: 
tic("panelConstruction.R")
source("code/projectSpecific/panelConstruction.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())





# SCRIPTS --------------------------------------------------------------------------------------------------------------------------------------------

# MONHTLY PANEL FOR ANALYSIS CONSTRUCTION

# SAMPLE CONSTRUCTION
source("code/projectSpecific/seriesConstruction_sample_monthly.R", encoding = "UTF-8")

# clean environment - free memory
rm(list = ls())
invisible(gc())



# FINES VARIABLE CONSTRUCTION
source("code/projectSpecific/seriesConstruction_fines_monthly.R", encoding = "UTF-8")

# clean environment - free memory
rm(list = ls())
invisible(gc())


# DETER CLOUDS VARIABLE CONSTRUCTION
source("code/projectSpecific/seriesConstruction_deterClouds_monthly.R", encoding = "UTF-8")

# clean environment - free memory
rm(list = ls())
invisible(gc())



# WEATHER MAIN VARIABLE (TERRESTRIAL AIR TEMPERATURE AND PRECIPITATION (V 5.01)) CONSTRUCTION
source("code/projectSpecific/seriesConstruction_weather_monthly.R", encoding = "UTF-8")

# clean environment - free memory
rm(list = ls())
invisible(gc())



# WEIGHTED COMMODTIY PRICES VARIABLE CONSTRUCTION
source("code/projectSpecific/seriesConstruction_prices_monthly.R", encoding = "UTF-8")

# clean environment - free memory
rm(list = ls())
invisible(gc())



# NASA CLOUDS VARIABLE CONSTRUCTION
source("code/projectSpecific/seriesConstruction_nasaClouds_monthly.R", encoding = "UTF-8")

# clean environment - free memory
rm(list = ls())
invisible(gc())



# MONHTLY PANEL CONSTRUCTION - MERGE ALL VARIABLES
source("code/projectSpecific/panelConstruction_monthly.R", encoding = "UTF-8")

# clean environment - free memory
rm(list = ls())
invisible(gc())





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------