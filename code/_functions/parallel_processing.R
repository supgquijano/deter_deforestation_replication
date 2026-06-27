
# > PROJECT INFO
# NAME: FUNCTION REPOSITORY
# LEAD: TEAM EFFORT
#
# > THIS SCRIPT
# AIM: BUILD PARALLEL PROCESSING FUNCTIONS
# AUTHOR: CLARISSA GANDOUR
#
# > EDIT DETAILS
# BY:
# ON:
#
# > NOTES
# 1: -





# PARALLEL PROCESSING -------------------------------------------------------------------------------------------------------------------------------

ParallelProcessingOpen <- function(cluster.number) {

  # SETS PARALLEL PROCESSING SETINGS
  #
  # ARGS
  #   zip.parent.dir: parent directory containing zip files
  #   zip.pattern: zipped file extension
  #   unzip.sub.folders: if TRUE, unzips all 'zip.pattern' files from 'zip.parent.dir' internal subdirectories
  #   delete.zip: if TRUE, deletes original 'zip.pattern' files
  #
  # RETURN
  #   unzipped files

  require("doSNOW")

  clusters <- makeCluster(cluster.number)  # choose number of parallel processes
  registerDoSNOW(clusters)                 # registers clusters to ensure session uses parallel processing

  print("function uses 'doSNOW' parallel processing package")

  cross.check <- as.character(getDoParWorkers())  # checks requested number of clusters are in use
  print(paste0("session now using ", cross.check, " clusters"))
  print("remember to close clusters at session end using ParallelProcessingClose function")
}



ParallelProcessingClose <- function() {

  # CLOSES PARALLEL PROCESSING
  #
  # ARGS
  #   ---
  #
  # RETURN
  #   sequential processing session setting

  registerDoSEQ()  # restores sequential processing

  unregister <- function() {  # clears backend foreach settings
    env <- foreach:::.foreachGlobals
    rm(list = ls(name = env), pos = env)
  }
}





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------