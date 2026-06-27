
# > PROJECT INFO
# NAME: DETERRING DEFORESTATION IN THE AMAZON: ENVIRONMENTAL MONITORING AND LAW ENFORCEMENTE - CODE AND DATA REPLICATION ARCHIVE
#
# > THIS SCRIPT
# AIM: MASTER FILE TO RUN ALL R SCRIPTS IN THE ANALYSIS FOLDER
#
# > NOTES
# TIME OF PROCESSING: 1 minute




# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------
# script to setup the additional libraries necessary to this project
source("./code/_functions/setup.R")





# SCRIPTS --------------------------------------------------------------------------------------------------------------------------------------------

# GRAPHICS FOLDER

# CREATION OF MAPS FOR DETER CLOUDS AND ALERTS (FIGURE 2)
# TIME OF PROCESSING: 1 minute
# OBS: -
source("code/analysis/graphics/figure2_map_clouds_alerts.R", encoding = "UTF-8")

# clean environment - free memory
rm(list = ls())
invisible(gc())


# AIM: CREATION OF GRAPHICS FOR ENVIRONMENTAL FINES X DEFORESTATION ANNUAL TRENDS (FIGURE A.1) 
# TIME OF PROCESSING: 3 seconds
# OBS:
source("code/analysis/graphics/figureA1_gph_fines_deforest.R", encoding = "UTF-8")

# clean environment - free memory
rm(list = ls())
invisible(gc())



# STATS FOLDER

# AIM: CALCULATE SHARE OF PLANTED AREA
# TIME OF PROCESSING: 3 seconds
# OBS: -

# generate stats and output graph
source("./code/analysis/stats/supportStats_crops.R", encoding = "UTF-8")

# clean environment - free memory
rm(list = ls())
invisible(gc())



# AIM:CALCULATE SHARE OF TROPICAL FOREST AREA IN THE LEGAL AMAZON BUT OUTSIDE THE AMAZON BIOME
# TIME OF PROCESSING: 1 minute
# OBS: CODE GENERATES NO OUTPUT, ONLY REPORTS AN IN-TEXT NUMBER

# generate stats (no output)
source("code/analysis/stats/supportStats_forest_laz_nonBiome.R", encoding = "UTF-8")

# clean environment - free memory
rm(list = ls())
invisible(gc())





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------