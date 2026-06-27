
# -- packages -----------------------------------------------------------------
library(data.table)
library(doParallel)
library(doSNOW)
library(foreach)
library(raster)
library(rgdal)
library(rgeos)


# -- functions ----------------------------------------------------------------
source(file.path("code/raw2clean/geography/weather_CPCG", "_functions_forParallelProcessing.R"))

raster2points <- function(raster.stack, muni.list, raster.name, folder.name = "", temp.dir.path = "", free.cores = 1,  return.objname = "", 
                          spdf.crs.original = "", spdf.idcol = "", file.output.report = "") {
  
  # Apply ExtractCellsForPolygonsMapCPC in a parallel way.
  #
  # ARGS:
  #   raster.stack:       Stack with desired rasters;
  #   muni.list:          Dataframe with desired munis
  #   folder.name:        Name of the folder to save the output
  #   temp.dir.path:      Directory path for temporary files
  #   free.cores:         Number of cores it will not use on proccess
  #   file.output.report: Character; path to file where will be .txts to be written info about problematic outputs

  
  # -- PARALLEL OPS ---------------------------------------------------------
  
  
  # detect number of cores for possible use
  nCores <- detectCores()
  # build core clusters for parallelization
  cl <- makeCluster(nCores - free.cores)
  # activate clusters
  registerDoSNOW(cl)
  
  
  # apply parallized function to crop all rasters files by all munis
  foreach(i = seq_along(muni.list),
          .packages = c('raster', 'rgdal', 'rgeos', 'foreach', 'data.table')) %dopar% {
            source(file.path("code/raw2clean/geography/weather_CPCG", "_functions_forParallelProcessing.R"))
            ExtractRasterCellsForPolygonsCPC(fctn.rasterLayer         = raster.stack,
                                             fctn.spdf                = muni.list[i, ],
                                             fctn.raster.layers.names = raster.name,
                                             fctn.spdf.idcol          = spdf.idcol,
                                             fctn.return.path         = folder.name,
                                             fctn.temp.dir.path       = temp.dir.path,
                                             fctn.return.objname      = return.objname,
                                             fctn.spdf.crs.original   = spdf.crs.original,
                                             fctn.file.output.report  = file.output.report)
            
          }
  
  
  stopCluster(cl)
  gc()
  
}


#-----------------------------------------------------------------------------------------------------------------------------------------------------
CombineMuniDF <- function(fctn.muni.code, fctn.variable, fctn.year.interval = "", fctn.folder.name = "", fctn.return.objname = "") {
  
  # Combines Resultant DFs for a municipality
  #
  # ARGS:
  #   fctn.muni.code:     IBGE 7-Digit code for treated municipality
  #   fctn.year interval: character; contais data year intervals according to input files
  #   fctn.folder.name:   Name of the folder to load the intermediate output
  #   fctn.variable:      Indicate climatic variable treated. Possible values: "precip", "temp.min" and "temp.max"
  #   fctn.return.objname      = character; object name for (returned) dbf
  
  #
  # RETURNS:
  #   R.data file for the muni uniting every monthly observations allong all years
  #
  # obs.1: saves outputs and deletes files. The files deleted might need to be changed according to usage.
  # obs.2: file.paths when loading might need adjustment according to usage.

  if (fctn.variable != "precip" && fctn.variable != "temp.min" && fctn.variable != "temp.max" ){
    stop("** ATENTION: must select climatic variable. Possible values for fctn.variable are 'precip', 'temp.min' and 'temp.max'. Data was not processed.")
  } else {

    if (fctn.variable == "precip") {
      
      muni.all.years <- vector("list", length = length(fctn.year.interval))
      
      for (y in seq_along(fctn.year.interval)) {  # creating list of data frames which refer to treated municipality
        output.name <- paste0("CPCG_precip_", fctn.year.interval[[y]], "_", fctn.muni.code,".Rdata")
        output.file <- load(paste0(fctn.folder.name, "/", output.name))
        assign(x = paste0("muni.output.", y), value = get(output.file))
        rm(list = "output.name", "output.file")
        rm(list = ls(pattern = "^CPCG_precip_"))
        muni.all.years[[y]] <- get(paste0("muni.output.", y))
      }
      
      muni.output.final <- Reduce(function(...) merge(..., by = "muni_code"), muni.all.years)  # combine list of data frames which refer to treated 
                                                                                               # municipality in one data frame     
      
      # deleting intermediate outputs
      for (y in seq_along(fctn.year.interval)) {
        aux.path <- file.path("data/raw2clean/geography/weather_CPCG/output", paste0("CPCG_precip_", fctn.year.interval[[y]], "_", 
                           fctn.muni.code, ".Rdata"))
        file.remove(aux.path)
      }
    }
    
    if (fctn.variable == "temp.min") {
      
      muni.all.years <- vector("list", length = length(fctn.year.interval))
      
      for (y in seq_along(fctn.year.interval)) {  # creating list of data frames which refer to treated municipality
        output.name <- paste0("CPCG_temp_min_", fctn.year.interval[[y]], "_", fctn.muni.code,".Rdata")
        output.file <- load(paste0(fctn.folder.name, "/", output.name))
        assign(x = paste0("muni.output.", y), value = get(output.file))
        rm(list = "output.name", "output.file")
        rm(list = ls(pattern = "^CPCG_temp_min_"))
        muni.all.years[[y]] <- get(paste0("muni.output.", y))
      }
      
      muni.output.final <- Reduce(function(...) merge(..., by = "muni_code"), muni.all.years)  # combine list of data frames which refer to 
                                                                                               # treated municipality in one data frame      
      # deleting intermediate outputs
      for (y in seq_along(fctn.year.interval)) {
        aux.path <- file.path("data/raw2clean/geography/weather_CPCG/output", paste0("CPCG_temp_min_", fctn.year.interval[[y]], "_", 
                           fctn.muni.code, ".Rdata"))
        file.remove(aux.path)
      }
    }
    
    if (fctn.variable == "temp.max") {
      
      muni.all.years <- vector("list", length = length(fctn.year.interval))
      
      for (y in seq_along(fctn.year.interval)) {  # creating list of data frames which refer to treated municipality
        output.name <- paste0("CPCG_temp_max_", fctn.year.interval[[y]], "_", fctn.muni.code,".Rdata")
        output.file <- load(paste0(fctn.folder.name, "/", output.name))
        assign(x = paste0("muni.output.", y), value = get(output.file))
        rm(list = "output.name", "output.file")
        rm(list = ls(pattern = "^CPCG_temp_max_"))
        muni.all.years[[y]] <- get(paste0("muni.output.", y))
      }
      
      muni.output.final <- Reduce(function(...) merge(..., by = "muni_code"), muni.all.years)  # combine list of data frames which refer to 
                                                                                               # treated municipality in one data frame      
      # deleting intermediate outputs
      for (y in seq_along(fctn.year.interval)) {
        aux.path <- file.path("data/raw2clean/geography/weather_CPCG/output", paste0("CPCG_temp_max_", fctn.year.interval[[y]], "_", 
                                                                                                        fctn.muni.code, ".Rdata"))
        file.remove(aux.path)
      }
    }
  }
  
  # assigning result
  return.obj <- paste(fctn.return.objname, fctn.muni.code,  sep = ".")
  
  assign(x = return.obj,
         value = muni.output.final)
  
  # export
  return.file <- gsub(x = return.obj, pattern = "\\.", replacement = "_")
  
  save(list = return.obj, 
       file = file.path(aux.folder.name, paste0(return.file, ".Rdata")))
  
  # environment cleanup
  rm(list = "muni.all.years", "aux.path", "return.obj", "return.file")
  rm(list = ls(pattern = "muni.output.[0-9]"))
  rm(list = ls(pattern = "muni,output.[0-9][0-9]"))
  gc()
  
  
}

