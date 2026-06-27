
# > PROJECT INFO
# NAME: DETERRING DEFORESTATION IN THE AMAZON: ENVIRONMENTAL MONITORING AND LAW ENFORCEMENTE - CODE AND DATA REPLICATION ARCHIVE
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: MASTER FILE TO RUN ALL R SCRIPTS IN THE RAW2CLEAN, BUILD, PROJECT SPECIFIC, AND ANALYSIS FOLDERS
# AUTHOR: JOAO VIEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: NOV/05/2020
#
# > NOTES
# TIME OF PROCESSING: 22 days




# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# script to setup the additional libraries necessary to this project
source("code/_functions/setup.R")

# starts clock for R masterfile
tic("_MASTERFILE.R")





# SCRIPTS --------------------------------------------------------------------------------------------------------------------------------------------

# RAW2CLEAN MASTERFILE
# TIME OF PROCESSING: 14 days
# OBS:
tic("masterfile_raw2clean.R")
source("code/raw2clean/_masterfile_raw2clean.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())



# BUILD MASTERFILE
# TIME OF PROCESSING: 7 days
# OBS:
tic("masterfile_build.R")
source("code/built/_masterfile_build.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())




# PROJECT SPECIFIC MASTERFILE
# TIME OF PROCESSING: 4 hours
# OBS:
tic("masterfile_projectSpecific.R")
source("code/projectSpecific/_masterfile_projectSpecific.R", encoding = "UTF-8")
toc()

# clean environment - free memory
rm(list = ls())
invisible(gc())



# # ANALYSIS MASTERFILE
# # TIME OF PROCESSING: 1 minute
# # OBS:
# tic("masterfile_analysis.R")
# source("code/analysis/_masterfile_analysis.R", encoding = "UTF-8")
# toc()
# 
# # clean environment - free memory
# rm(list = ls())
# invisible(gc())
# 
# 
# # stops clock for for R masterfile
# toc()





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------