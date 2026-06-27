
# > PROJECT INFO
# NAME: FUNCTION REPOSITORY
#
# > THIS SCRIPT
# AIM: SETUP SCRIPT TO BE SOURCED AT THE BEGGINING OF EVERY .R SCRIPT IN THIS PROJECT - SETUP LIBRARIES WITH CHECKPOINT TO ENSURE REPRODUCIBILITY
#
# > NOTES
# 1: -





# CHECKPOINT SETUP ----------------------------------------------------------------------------------------------------------------------------

# INSTAL CHECKPOINT LIBRARY (VERSION 0.4.8) - only needs to be done once per computer
if ("checkpoint" %in% rownames(installed.packages()) == FALSE) {
  install.packages("https://cran.r-project.org/src/contrib/Archive/checkpoint/checkpoint_0.4.8.tar.gz", repos = NULL, type="source")
}

if (installed.packages()["checkpoint", "Version"] != "0.4.8") {
  install.packages("https://cran.r-project.org/src/contrib/Archive/checkpoint/checkpoint_0.4.8.tar.gz", repos = NULL, type="source")
}

# calls checkpoint library (https://cran.r-project.org/web/packages/checkpoint/vignettes/checkpoint.html)
library(checkpoint)

# calls checkpoint function to detect and install the necessary libraries - only needs to be done once per R session
if(any(grepl(".checkpoint", .libPaths())) == FALSE) {
  # calls checkpoint function that creates a snapshot folder to install packages from the specified date, if your R version is not 3.6.1 this will give you an error and will not work. >
  # The best option is to download the 3.6.1 version (https://cran.r-project.org/bin/windows/base/old/3.6.1/) or change the argument to the version you are using, > 
  # however the latter is not guaranteed to work.
  checkpoint::checkpoint(R.version = "3.6.1", snapshotDate = "2019-12-01", checkpointLocation = getwd())
}





# PACKAGES -------------------------------------------------------------------------------------------------------------------------------------------

# list of R libraries used in the .R scripts of this project
library(plyr) # to use ldply function
library(tidyverse) # for data frame manipulation and visualization
library(sp) # for spatial data manipulation
library(rgdal) # for spatial data manipulation
library(rgeos) # for spatial data manipulation
library(cleangeo) # for topography issue fix
library(raster) # for spatial data manipulation
library(data.table) # for dataframe manipulation
library(ncdf4) # for cloud and weather spatial input
library(foreach) # for parallel processing
library(doParallel) # for parallel processing
library(doSNOW) # for parallel processing
library(rts) # for raster time series manipulation
library(lubridate) # for date manipulation
library(Hmisc) # for data frame labels
library(reshape) # to convert data frames from long to wide format and vice-versa
library(tictoc) # to report time of processing of the scripts
library(haven) # to export data in .dta format (stata)
library(spdep) # to identify spatial neighbors
library(expp) # to identify spatial neighbors
library(maptools)


# specify package for functions with name conflict
as.data.frame <- base::as.data.frame



# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------