
ExtractRasterCellsForPolygonsCPC <- function(fctn.rasterLayer, fctn.spdf, fctn.raster.layers.names = "", fctn.spdf.idcol = "", 
                                             fctn.return.path = "", fctn.temp.dir.path = "",  fctn.return.objname = "", 
                                             fctn.spdf.crs.original = "", fctn.file.output.report = "") {
  
  # EXTRACTS RASTER CELL VALUES FOR SPATIAL POLYGONS DATA FRAMES THAT SPATIALLY INTERSECT WITH RASTER LAYER - ADAPTED FOR CPCG
  #
  # ARGS:
  #   fctn.rasterLayer         = rasterLayer; usually with extension .tif
  #   fctn.spdf                = SpatialPolygonsDataFrame; spatial object to be rasterized
  #   fctn.raster.layers.names = defines raster layers names
  #   fctn.spdf.idcol          = character; SPDF column name containing unique polygon identifiers
  #   fctn.return.path         = path to folder to save output files
  #   fctn.temp.dir.path       = Directory path for temporary files
  #   fctn.return.objname      = character; object name for (returned) dbf
  #   fctn.spdf.crs.original   = character; spdf orginal proj4string
  #   fctn.file.output.report  = character; path to file where will be .txts to be written info about problematic outputs
  #  
  # RETURNS:
  #  R.data containing dataframe with cell-level raster information for polygons
  
  # PACKAGES
  require("sp")
  require("rgeos")
  require("raster")
  require("doParallel")
  require("doSNOW")
  require("foreach")
  require("data.table")
  
  
  
  # RASTER OPTIONS
  rasterOptions(tmpdir = fctn.temp.dir.path,
                timer  = F)
  
  tmpDir(create = T)
  
  
  
  # CHECK POINTS
  # crs
  if (identicalCRS(fctn.rasterLayer, fctn.spdf) == F) {
    fctn.spdf <- spTransform(x      = fctn.spdf,                          # SPDF can be reprojected without loss of info, whereas rasterLayer cannot
                             CRSobj = proj4string(fctn.rasterLayer))
  }
  
  
  # raster/polygon intersection
  aux.extentsIntersect = raster::intersect(x = extent(fctn.rasterLayer),
                                           y = extent(fctn.spdf))
  
  if (is.null(aux.extentsIntersect)) {                                    # if extents don't intersect at all, polygon/raster intersection have no   >
    return(NULL)                                                          # potential common areas
  }
  
  
  # number of polygons
  if (length(fctn.spdf) > 1) {
    stop("**ATTENTION: function currently not fit to rasterize multiple polygons at once!")
  }
  
  
  
  # RASTERIZATION [use of rasterize option 'mask = T' >> cells that spatially overlap with SpatialPolygons retain their values; others become NA]
  # prep
  raster.cropped = crop(x = fctn.rasterLayer,                                # crops raster to restrict cells to potential intersection candidates
                        y = extent(fctn.spdf))
  
  
  rasterized.spdf <- rasterize(x    = fctn.spdf,                             # transfers values associated with SpatialPolygons to raster cells
                               y    = raster.cropped[[1]],
                               mask = T)
  
  
  
  # if there is no intersect (all values are NA)
  # buffer strategy by 40km and 20km, the estimated further possible distance between a random point and any cell's centroid and its moiety, repectively. >
  # values obtained through calculation of half the diagonal of the largest cell possible (aprox. 110km x 110km, in the equator) considering that >
  # it would be the greatest distance that any continental point could be from a cell's centroid.
  if (all(is.na(values(rasterized.spdf)) == T)) {
    
    # ADD BUFFER STRATEGY - 20km
    
    fctn.spdf <- spTransform(fctn.spdf, fctn.spdf.crs.original)
    
    fctn.spdf.20km <- gBuffer(spgeom = fctn.spdf, width = 20000, byid = T)
    
    fctn.spdf.20km <- spTransform(fctn.spdf.20km, proj4string(fctn.rasterLayer))
    fctn.spdf      <- spTransform(fctn.spdf, proj4string(fctn.rasterLayer))
    
    raster.cropped = crop(x = fctn.rasterLayer,                            
                          y = extent(fctn.spdf.20km))
    
    rasterized.spdf <- rasterize(x    = fctn.spdf.20km,                        # transfers values associated with SpatialPolygons to raster cells
                                 y    = raster.cropped[[1]],
                                 mask = T)
    
    if (all(is.na(values(rasterized.spdf)) == T)) {
      
      # ADD BUFFER STRATEGY - 40km
      fctn.spdf <- spTransform(fctn.spdf, fctn.spdf.crs.original)
      
      fctn.spdf.40km <- gBuffer(spgeom = fctn.spdf, width = 40000, byid = T)
      
      fctn.spdf.40km <- spTransform(fctn.spdf.40km, proj4string(fctn.rasterLayer))
      fctn.spdf      <- spTransform(fctn.spdf, proj4string(fctn.rasterLayer))
      
      raster.cropped = crop(x = fctn.rasterLayer,                            
                            y = extent(fctn.spdf.40km))
      
      rasterized.spdf <- rasterize(x    = fctn.spdf.40km,                      # transfers values associated with SpatialPolygons to raster cells
                                   y    = raster.cropped[[1]],
                                   mask = T)
      
      if (all(is.na(values(rasterized.spdf)) == T)) {
        
        # ADD BUFFER STRATEGY - 60km [for especific problematic cases]
        if (file.exists(file.path(fctn.file.output.report, "output_muni60kmBuffer.txt")) == FALSE) {
          file.create(file.path(fctn.file.output.report, "output_muni60kmBuffer.txt"))
        }
        
        sink(file.path(fctn.file.output.report, "output_muni60kmBuffer.txt"), append = TRUE)
        
        print(paste0("buffer by 60km was necessary for muni with code: ", fctn.spdf@data[1,1], "; when processing the years: ", 
                     substr(fctn.return.objname, nchar(fctn.return.objname)-9, nchar(fctn.return.objname)-1), "; for '", 
                     substr(fctn.return.objname, 6, nchar(fctn.return.objname)-11), "'"))
        sink()
                                                                               
        
        fctn.spdf <- spTransform(fctn.spdf, fctn.spdf.crs.original)
        
        fctn.spdf.60km <- gBuffer(spgeom = fctn.spdf, width = 60000, byid = T)
        
        fctn.spdf.60km <- spTransform(fctn.spdf.60km, proj4string(fctn.rasterLayer))
        fctn.spdf      <- spTransform(fctn.spdf, proj4string(fctn.rasterLayer))
        
        raster.cropped = crop(x = fctn.rasterLayer,                            
                              y = extent(fctn.spdf.60km))
        
        rasterized.spdf <- rasterize(x    = fctn.spdf.60km,                      # transfers values associated with SpatialPolygons to raster cells
                                     y    = raster.cropped[[1]],
                                     mask = T)
        
        rasterized.spdf.list = foreach(i = 1:nlayers(raster.cropped),            # repeats procedure for each raster layer in parallelized form
                                       .packages = c("sp", "rgeos", "raster", "foreach", "rgdal", "rgeos", "data.table")) %do% {
                                         rasterize(x    = fctn.spdf.60km,
                                                   y    = raster.cropped[[i]],    # parallelization here occurs at *RASTER LAYER* level
                                                   mask = T)
                                       }
        
        rasterized.spdf <- stack(rasterized.spdf.list)                           # stacks layers
        
        names(rasterized.spdf) = fctn.raster.layers.names
      } else {
      
      rasterized.spdf.list = foreach(i = 1:nlayers(raster.cropped),            # repeats procedure for each raster layer in parallelized form
                                    .packages = c("sp", "rgeos", "raster", "foreach", "rgdal", "rgeos", "data.table")) %do% {
                                      rasterize(x    = fctn.spdf.40km,
                                                y    = raster.cropped[[i]],    # parallelization here occurs at *RASTER LAYER* level
                                                mask = T)
                                    }
      
      rasterized.spdf <- stack(rasterized.spdf.list)                           # stacks layers
      
      names(rasterized.spdf) = fctn.raster.layers.names
      }
      
    } else {
      
      rasterized.spdf.list = foreach(i = 1:nlayers(raster.cropped),            # repeats procedure for each raster layer in parallelized form
                                     .packages = c("sp", "rgeos", "raster", "foreach", "rgdal", "rgeos", "data.table")) %do% {
                                       rasterize(x    = fctn.spdf.20km,
                                                 y    = raster.cropped[[i]],   # parallelization here occurs at *RASTER LAYER* level
                                                 mask = T)
                                     }
      
      rasterized.spdf <- stack(rasterized.spdf.list)                           # stacks layers
      
      names(rasterized.spdf) = fctn.raster.layers.names
      
      
    }
    
    
    # if there is intersect
  } else {
    rasterized.spdf.list = foreach(i = 1:nlayers(raster.cropped),              # repeats procedure for each raster layer in parallelized form
                                   .packages = c("sp", "rgeos", "raster", "foreach", "rgdal", "rgeos", "data.table")) %do% {
                                     rasterize(x    = fctn.spdf,
                                               y    = raster.cropped[[i]],     # parallelization here occurs at *RASTER LAYER* level
                                               mask = T)
                                   }
    
    rasterized.spdf <- stack(rasterized.spdf.list)                             # stacks layers
    
    names(rasterized.spdf) = fctn.raster.layers.names
  }
  
  
  # DBF CONSTRUCTION
  # extraction
  rasterized.spdf.cells <- data.frame(rasterToPoints(rasterized.spdf))         # contains raster cell identifiers (centroid x/y coordinates) and values
  
  if (nrow(rasterized.spdf.cells) == 0) {
    if (file.exists(file.path(fctn.file.output.report, "output_muniEmptyDF.txt")) == FALSE) {
      file.create(file.path(fctn.file.output.report, "output_muniEmptyDF.txt"))
    }
    sink(file.path(fctn.file.output.report, "output_muniEmptyDF.txt"), append = TRUE)
    
    print(paste0("empty data frame after buffer strategy for the following muni: ", fctn.spdf@data[1, 1], "; when treating the years: ",
                 substr(fctn.return.objname, nchar(fctn.return.objname)-9, nchar(fctn.return.objname)-1), "; for '", 
                 substr(fctn.return.objname, 6, nchar(fctn.return.objname)-11), "'"))
    sink()
  }
  
  for (i in 3:ncol(rasterized.spdf.cells)) {
    setnames(rasterized.spdf.cells, old = colnames(rasterized.spdf.cells)[i], new = substr(colnames(rasterized.spdf.cells[i]), 2, 11))
  }
  
  
  rasterized.spdf.cells <- setDT(rasterized.spdf.cells)
  
  # unique polygon identifier
  spdf.polyg.id                 <- as.character(fctn.spdf@data[colnames(fctn.spdf@data) == fctn.spdf.idcol])
  rasterized.spdf.cells$poly_id <- spdf.polyg.id
  
  setnames(rasterized.spdf.cells, "poly_id", fctn.spdf.idcol)
  
  # remove columns
  rasterized.spdf.cells$x <- NULL
  rasterized.spdf.cells$y <- NULL
  
  # collapse data keeping only the average, each muni should have only one line
  rasterized.spdf.cells <- rasterized.spdf.cells[ , lapply(.SD, mean, na.rm = T), by = muni_code]
  
  if (length(grep(pattern = "precip.", x = fctn.return.objname, value = FALSE, ignore.case = TRUE)) == 1){  # through the future output name, identifies >
    # Melt the data.table so all values are in one column called "precipitatin".                           # if data is precipitation     
    rasterized.spdf.cells <- melt(rasterized.spdf.cells, id.vars = "muni_code", variable.name = "date", value.name = "precipitation")
      
    rasterized.spdf.cells$month <- substr(rasterized.spdf.cells$date, 6,7)
    rasterized.spdf.cells$year  <- substr(rasterized.spdf.cells$date, 1,4)
    rasterized.spdf.cells$date  <- NULL
    
    rasterized.spdf.cells <-  rasterized.spdf.cells[ , lapply(.SD, sum, na.rm = T), by = .(muni_code, month, year)]
      
    rasterized.spdf.cells$year_month <- paste0( rasterized.spdf.cells$year, "_",  rasterized.spdf.cells$month)
      
    rasterized.spdf.cells$month <- NULL
    rasterized.spdf.cells$year  <- NULL
    
    # Cast the data.table back into the original shape, and take the mean
    rasterized.spdf.cells  <- dcast(rasterized.spdf.cells, muni_code ~ year_month, value.var = "precipitation")
    
  } else {
    if (length(grep(pattern = "temp.", x = fctn.return.objname, value = FALSE, ignore.case = TRUE)) == 1) {  # through the future output name, identifies > 
      # Melt the data.table so all values are in one column called "value".                          # if data is temperature
      rasterized.spdf.cells <- melt(rasterized.spdf.cells, id.vars = "muni_code", variable.name = "date", value.name = "temperature")
      
      rasterized.spdf.cells$month <- substr(rasterized.spdf.cells$date, 6,7)
      rasterized.spdf.cells$year  <- substr(rasterized.spdf.cells$date, 1,4)
      rasterized.spdf.cells$date  <- NULL
      
      rasterized.spdf.cells <-  rasterized.spdf.cells[ , lapply(.SD, mean, na.rm = T), by = .(muni_code, month, year)]
      
      rasterized.spdf.cells$year_month <- paste0(rasterized.spdf.cells$year, "_",  rasterized.spdf.cells$month) 
      
      rasterized.spdf.cells$month <- NULL
      rasterized.spdf.cells$year  <- NULL
      
      # Cast the data.table back into the original shape, and take the mean
      rasterized.spdf.cells  <- dcast(rasterized.spdf.cells, muni_code ~ year_month, value.var = "temperature")
      
    } else {
      print("undefined climate variable. no specific data treatment done.")
    }
  }
  
  
  # EXPORT
  # prep
  return.obj <- paste0(fctn.return.objname, spdf.polyg.id)
  
  assign(x     = return.obj,
         value = rasterized.spdf.cells)
  
  return.file <- gsub(x = return.obj, pattern = "\\.", replacement = "_")
  
  # output writing
  save(list = return.obj, file = file.path(fctn.return.path, 
                                           paste0(return.file, ".Rdata")))
  
  rm(list = return.obj)
  
  gc()
  
  
  # CLEAN TEMP DIR
  showTmpFiles()
  removeTmpFiles(h = 1)
  
  

}



# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------