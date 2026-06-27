
ExtractRasterCellsForPolygonsReanalysis <- function(fctn.rasterLayer, fctn.spdf, fctn.raster.layers.names = "", fctn.spdf.idcol = "", 
                                                   fctn.return.folder = "", fctn.temp.dir.path = "",  fctn.return.objname = "",
                                                   fctn.spdf.crs.original = "") {
  
    # EXTRACTS RASTER CELL VALUES FOR SPATIAL POLYGONS DATA FRAMES THAT SPATIALLY INTERSECT WITH RASTER LAYER - ADAPTED FOR MAPBIOMAS
    #
    # ARGS:
    #   fctn.rasterLayer         = rasterLayer; usually with extension .tif
    #   fctn.spdf                = SpatialPolygonsDataFrame; spatial object to be rasterized
    #   fctn.raster.layers.names = defines raster layers names
    #   fctn.spdf.idcol          = character; SPDF column name containing unique polygon identifiers
    #   fctn.return.folder       = folder to save output files
    #   fctn.temp.dir.path       = Directory path for temporary files
    #   fctn.return.objname      = character; object name for (returned) dbf
    #  
    # RETURNS:
    #  .RData containing dataframe with cell-level raster information for polygons
  
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
    raster.cropped = crop(x = fctn.rasterLayer,                             # crops raster to restrict cells to potential intersection candidates
                          y = extent(fctn.spdf))
    
    
    rasterized.spdf <- rasterize(x    = fctn.spdf,                             # transfers values associated with SpatialPolygons to raster cells
                                 y    = raster.cropped[[1]],
                                 mask = T)
    
    
    
    # if there is no intersect (all values are NA)
    # buffer strategy by 40km and 20km, the estimated further possible distance between a random point and any cell's centroid and its moiety, repectively. >
    # values obtained through calculation of half the diagonal of the largest cell possible (aprox. 110km x 110km, in the equator) considering that >
    # it would be the greatest distance that any continental point could be from a cell's centroid.
    if (all(is.na(values(rasterized.spdf)) == T)) {
      
      # ADD BUFFER STRATEGY - 40km
      
      fctn.spdf <- spTransform(fctn.spdf, fctn.spdf.crs.original)
      
      fctn.spdf.50km <- gBuffer(spgeom = fctn.spdf, width = 50000, byid = T)
      
      fctn.spdf.50km <- spTransform(fctn.spdf.50km, proj4string(fctn.rasterLayer))
      fctn.spdf      <- spTransform(fctn.spdf, proj4string(fctn.rasterLayer))
      
      raster.cropped = crop(x = fctn.rasterLayer,                            
                            y = extent(fctn.spdf.50km))
      
      rasterized.spdf <- rasterize(x    = fctn.spdf.50km,                        # transfers values associated with SpatialPolygons to raster cells
                                   y    = raster.cropped[[1]],
                                   mask = T)
      
      if (all(is.na(values(rasterized.spdf)) == T)) {
        
        # ADD BUFFER STRATEGY - 100km
        fctn.spdf <- spTransform(fctn.spdf, fctn.spdf.crs.original)
        
        fctn.spdf.100km <- gBuffer(spgeom = fctn.spdf, width = 100000, byid = T)
        
        fctn.spdf.100km <- spTransform(fctn.spdf.100km, proj4string(fctn.rasterLayer))
        fctn.spdf      <- spTransform(fctn.spdf, proj4string(fctn.rasterLayer))
        
        raster.cropped = crop(x = fctn.rasterLayer,                            
                              y = extent(fctn.spdf.100km))
        
        rasterized.spdf <- rasterize(x    = fctn.spdf.100km,                      # transfers values associated with SpatialPolygons to raster cells
                                     y    = raster.cropped[[1]],
                                     mask = T)
        
        if (all(is.na(values(rasterized.spdf)) == T)) {
          
          # ADD BUFFER STRATEGY - 150km
          fctn.spdf <- spTransform(fctn.spdf, fctn.spdf.crs.original)
          
          fctn.spdf.150km <- gBuffer(spgeom = fctn.spdf, width = 150000, byid = T)
          
          fctn.spdf.150km <- spTransform(fctn.spdf.150km, proj4string(fctn.rasterLayer))
          fctn.spdf      <- spTransform(fctn.spdf, proj4string(fctn.rasterLayer))
          
          raster.cropped = crop(x = fctn.rasterLayer,                            
                                y = extent(fctn.spdf.150km))
          
          rasterized.spdf <- rasterize(x    = fctn.spdf.150km,                      # transfers values associated with SpatialPolygons to raster cells
                                       y    = raster.cropped[[1]],
                                       mask = T)
        
        if (all(is.na(values(rasterized.spdf)) == T)) {
          
          # ADD BUFFER STRATEGY - 200km 
          fctn.spdf <- spTransform(fctn.spdf, fctn.spdf.crs.original)
          
          fctn.spdf.200km <- gBuffer(spgeom = fctn.spdf, width = 200000, byid = T)
          
          fctn.spdf.200km <- spTransform(fctn.spdf.200km, proj4string(fctn.rasterLayer))
          fctn.spdf      <- spTransform(fctn.spdf, proj4string(fctn.rasterLayer))
          
          raster.cropped = crop(x = fctn.rasterLayer,                            
                                y = extent(fctn.spdf.200km))
          
          rasterized.spdf <- rasterize(x    = fctn.spdf.200km,                      # transfers values associated with SpatialPolygons to raster cells
                                       y    = raster.cropped[[1]],
                                       mask = T)
          
          rasterized.spdf.list = foreach(i = 1:nlayers(raster.cropped),            # repeats procedure for each raster layer in parallelized form
                                         .packages = c("sp", "rgeos", "raster", "foreach", "rgdal", "rgeos", "data.table")) %do% {
                                           rasterize(x    = fctn.spdf.200km,
                                                     y    = raster.cropped[[i]],    # parallelization here occurs at *RASTER LAYER* level
                                                     mask = T)
                                         }
          
          rasterized.spdf <- stack(rasterized.spdf.list)                           # stacks layers
          
          names(rasterized.spdf) = fctn.raster.layers.names
          
        } else {
          
          rasterized.spdf.list = foreach(i = 1:nlayers(raster.cropped),            # repeats procedure for each raster layer in parallelized form
                                         .packages = c("sp", "rgeos", "raster", "foreach", "rgdal", "rgeos", "data.table")) %do% {
                                           rasterize(x    = fctn.spdf.150km,
                                                     y    = raster.cropped[[i]],    # parallelization here occurs at *RASTER LAYER* level
                                                     mask = T)
                                         }
          
          rasterized.spdf <- stack(rasterized.spdf.list)                           # stacks layers
          
          names(rasterized.spdf) = fctn.raster.layers.names
        }
          
        } else {
          
          rasterized.spdf.list = foreach(i = 1:nlayers(raster.cropped),            # repeats procedure for each raster layer in parallelized form
                                         .packages = c("sp", "rgeos", "raster", "foreach", "rgdal", "rgeos", "data.table")) %do% {
                                           rasterize(x    = fctn.spdf.100km,
                                                     y    = raster.cropped[[i]],    # parallelization here occurs at *RASTER LAYER* level
                                                     mask = T)
                                         }
          
          rasterized.spdf <- stack(rasterized.spdf.list)                           # stacks layers
          
          names(rasterized.spdf) = fctn.raster.layers.names
        }
        
      } else {
        
        rasterized.spdf.list = foreach(i = 1:nlayers(raster.cropped),            # repeats procedure for each raster layer in parallelized form
                                       .packages = c("sp", "rgeos", "raster", "foreach", "rgdal", "rgeos", "data.table")) %do% {
                                         rasterize(x    = fctn.spdf.50km,
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
    rasterized.spdf.cells <- data.table(rasterToPoints(rasterized.spdf))    # contains raster cell identifiers (centroid x/y coordinates) and values
    
    
    # unique polygon identifier
    spdf.polyg.id                 <- fctn.spdf@data$muni_code
    rasterized.spdf.cells$poly_id <- spdf.polyg.id
    
    
    # column names
    setnames(rasterized.spdf.cells, 'x', 'lon')
    setnames(rasterized.spdf.cells, 'y', 'lat')
    
    
    
    # EXPORT
    # prep
    return.obj <- paste(fctn.return.objname, spdf.polyg.id,  sep = ".")
    
    assign(x     = return.obj,
           value = rasterized.spdf.cells)
    
    return.file <- gsub(x = return.obj, pattern = "\\.", replacement = "_")
    
    # output writing
    save(list = return.obj, file = file.path(fctn.return.folder, 
                                             paste0(return.file, ".Rdata")))
    
    rm(list = return.obj)
    
    gc()
    
    
    # CLEAN TEMP DIR
    showTmpFiles()
    removeTmpFiles(h = 1)
    
    
    
}





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------