
# > PROJECT INFO
# NAME: CENTRAL DATA FUNCTIONS REPOSITORY CONSTRUCTION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: BUILD FUNCTIONS FOR POLYGON RASTERIZATION
# AUTHOR: HELENA ARRUDA; JOAO PEDRO
#
# > EDIT DETAILS
# BY: CLARISSA GANDOUR
# ON: SEP/27/2017





# CROP -----------------------------------------------------------------------------------------------------------------------------------------------

CropLargePolygons <- function(fctn.spdf, fctn.area.threshold, fctn.spdf.idcol) {

  # CROP LARGE POLYGONS FROM SPDF OBJECT INTO QUADRANT COMPONENTS
  #
  # ARGS
  #   fctn.spdf           = SpatialPolygonsDataFrame; typically containing large polygons
  #   fctn.area.threshold = numeric; maximum area cutoff for polygon crop, in sq km
  #   fctn.spdf.idcol     = character; SPDF column name containing unique polygon identifiers
  #
  # RETURNS
  #   SPDF object; polygons/entries below area threshold are unchanged; polygons/entries above threshold are dropped from output and replaced by     >
  #   corresponding quadrant polygons/entries
  #
  # OBS
  #   > performing column selection in SPDF *PRIOR* to using function is strongly recommended to avoid entry errors after quadrant aggregation
  #   > originally built to use prior to running 'ExtractRasterCellsForPolygons' function



  # PACKAGES
  require("sp")
  require("rgeos")
  require("raster")
  require("data.table")



  # AUXILIARY FUNCTIONS
  source(file.path(Sys.getenv("HOMEPATH"), "__code_config_local", "config_data_repo_user.R"))  # sets local dirs; sources config for shared data repo
  source(file.path(DIR.CODE.FUNCTIONS, "unit_conversion.R"))



  # CHECK POINTS
  # object class
  if (class(fctn.spdf) != "SpatialPolygonsDataFrame") {
    stop("**ATTENTION: 'fctn.spdf' is not of class SpatialPolygonsDataFrame!")
  }


  # projection [needed for area calculation]
  if (is.projected(fctn.spdf) == F) {
    stop("**ATTENTION: 'fctn.spdf' is not projected!")
  }



  # PREP
  # object class
  fctn.spdf@data <- data.table(fctn.spdf@data)


  # new auxiliary columns
  fctn.spdf@data[, crop_flag := 0]  # polygon above/below area threshold identifier
  fctn.spdf@data[, quadrant  := 0]  # quadrant identifier



  # AREA CALCULATION
  if (grepl("units=m", proj4string(fctn.spdf)) == T) {  # checks if projection is in meters for adequate unit conversion
    fctn.spdf@data$polyg_area <- gArea(fctn.spdf, byid = T) * convert.sqm.to.sqkm
  } else {
    stop("**ATTENTION: 'fctn.spdf' is not projected in meters!")
  }



  # CROP
  # polygon selection
  fctn.spdf@data <- fctn.spdf@data[polyg_area > fctn.area.threshold, crop_flag := 1]  # flags (==1) polygons above area threshold

  polyg.crop.yes <- fctn.spdf[ fctn.spdf@data$crop_flag == 1, ]                       # subsets columns that need treatment
  polyg.crop.no  <- fctn.spdf[!fctn.spdf@data$crop_flag == 1, ]                       # excludes polygs that will undergo treatment from original SPDF

  if ((length(polyg.crop.yes) + length(polyg.crop.no)) != length(fctn.spdf)) {        # checkpoint
    stop("**ATTENTION: polygons have been lost during crop selection!")
  }


  # polygon treatment [crop performed by select (large) polygon extent]
  for (i in seq_along(polyg.crop.yes)) {

    # prep
    extent.polyg <- as.matrix(extent(polyg.crop.yes[i, ]))                            # extracts extent from select (large) polygon

    xmin <- extent.polyg[1, 1]
    xmax <- extent.polyg[1, 2]
    ymin <- extent.polyg[2, 1]
    ymax <- extent.polyg[2, 2]

    xmed <- (xmax + xmin) / 2                                                         # calculates mid points for quadrant definition
    ymed <- (ymax + ymin) / 2

    new.extent.1 <- extent(xmin, xmed, ymin, ymed)                                    # defines quadrant extents
    new.extent.2 <- extent(xmed, xmax, ymin, ymed)
    new.extent.3 <- extent(xmin, xmed, ymed, ymax)
    new.extent.4 <- extent(xmed, xmax, ymed, ymax)


    # crop
    cropped.polyg1 <- crop(polyg.crop.yes[i, ], new.extent.1)                         # crops select (large) polygon into four quadrants
    cropped.polyg2 <- crop(polyg.crop.yes[i, ], new.extent.2)
    cropped.polyg3 <- crop(polyg.crop.yes[i, ], new.extent.3)
    cropped.polyg4 <- crop(polyg.crop.yes[i, ], new.extent.4)


    # quadrant identifiers
    if (!is.null(cropped.polyg1)) {                                                   # ids (indexes) quadrant
      cropped.polyg1@data$quadrant <- "1"                                             # null condition needed due to possibility of crop returning   >
    }                                                                                 # empty quadrant - depends on select (large) polygon shape
    if (!is.null(cropped.polyg2)) {
      cropped.polyg2@data$quadrant <- "2"
    }
    if (!is.null(cropped.polyg3)) {
      cropped.polyg3@data$quadrant <- "3"
    }
    if (!is.null(cropped.polyg4)) {
      cropped.polyg4@data$quadrant <- "4"
    }


    # cropped muni identifiers [annexes quadrant identifier to muni code]
    fctn.spdf.idcol.index <- which(colnames(polyg.crop.no@data) == fctn.spdf.idcol)   # selects position of id column in original SPDF

    polyg.crop.yes@data <- as.data.frame(polyg.crop.yes@data)                         # enables df manipulation to assign quadrant identifier

    if (!is.null(cropped.polyg1)) {
      cropped.polyg1@data[, fctn.spdf.idcol.index] <- paste0(polyg.crop.yes[i, ]@data[, fctn.spdf.idcol.index], "_", "1")
    }
    if (!is.null(cropped.polyg2)) {
      cropped.polyg2@data[, fctn.spdf.idcol.index] <- paste0(polyg.crop.yes[i, ]@data[, fctn.spdf.idcol.index], "_", "2")
    }
    if (!is.null(cropped.polyg3)) {
      cropped.polyg3@data[, fctn.spdf.idcol.index] <- paste0(polyg.crop.yes[i, ]@data[, fctn.spdf.idcol.index], "_", "3")
    }
    if (!is.null(cropped.polyg4)) {
      cropped.polyg4@data[, fctn.spdf.idcol.index] <- paste0(polyg.crop.yes[i, ]@data[, fctn.spdf.idcol.index], "_", "4")
    }


    # quadrant compilation
    cropped.polyg.list <- list(cropped.polyg1,
                               cropped.polyg2,
                               cropped.polyg3,
                               cropped.polyg4)

    aux.list.element.isnull <- lapply(cropped.polyg.list, is.null)                    # creates logical vector to locate non-null list elements
    cropped.polyg.list      <- cropped.polyg.list[aux.list.element.isnull == F]       # subsets to non-null quadrants

    for (j in seq_along(cropped.polyg.list)) {                                        # adds cropped polygons to layer of uncropped polygons
      polyg.crop.no <- rbind(polyg.crop.no,
                             cropped.polyg.list[[j]])
    }


    # environment cleanup
    rm(cropped.polyg1, cropped.polyg2, cropped.polyg3, cropped.polyg4)
  }


  # polygon area reassessment [as single crop might return quadrants containing polygons that still exceed area threshold]
  polyg.crop.no@data$polyg_area <- gArea(polyg.crop.no, byid = T) * convert.sqm.to.sqkm
  polyg.crop.no@data            <- polyg.crop.no@data[polyg_area < fctn.area.threshold, crop_flag := 0]  # unflags polygons that now meet condition

  if (sum(polyg.crop.no@data$crop_flag > 0)) {
    print("**ATTENTION: there are cropped polygon quadrants that remain above threshold area! Please run function over returned object.")
  }


  # RETURN
  polyg.crop.no@data$quadrant <- NULL                               # enables running function over returned object, if needed
  polyg.crop.no@data          <- as.data.frame(polyg.crop.no@data)

  return(polyg.crop.no)                                             # returns updated DF
}





# RASTERIZATION --------------------------------------------------------------------------------------------------------------------------------------

ExtractRasterCellsForPolygons <- function(fctn.rasterLayer, fctn.spdf, fctn.spdf.idcol, fctn.return.objname, fctn.return.dir, fctn.return.filename) {

  # EXTRACTS RASTER CELL VALUES FOR SPATIAL POLYGONS DATA FRAMES THAT SPATIALLY INTERSECT WITH RASTER LAYER
  #
  # ARGS
  #   fctn.rasterLayer     = rasterLayer; usually with extension .tif
  #   fctn.spdf            = SpatialPolygonsDataFrame; spatial object to be rasterized
  #   fctn.spdf.idcol      = character; SPDF column name containing unique polygon identifiers
  #   fctn.return.objname  = character; object name for (returned) dbf
  #   fctn.return.dir      = directory to save output files
  #   fctn.return.filename = general file name to be used in output file
  #
  # RETURNS
  #   R.data containing dataframe with cell-level raster information for polygons
  #
  # OBS
  #   > current function setup uses default R function for rasterize
  #   > current function setup not adequate for treating multiple polygons [associated check point included] -- post-crop polygon identification will>
  #     not be executed correctly



  # PACKAGES
  require("sp")
  require("rgeos")
  require("raster")
  require("doParallel")
  require("doSNOW")
  require("foreach")
  require("data.table")



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


  # if single-layer raster...
  if (nlayers(raster.cropped) == 1) {
    rasterized.spdf <- rasterize(x    = fctn.spdf,                        # transfers values associated with SpatialPolygons to raster cells
                                 y    = raster.cropped,
                                 mask = T)


  # if multi-layer raster...
  } else {
    rasterized.spdf.list = foreach(i = 1:nlayers(raster.cropped),         # repeats procedure for each raster layer in parallelized form
                                    .packages = c("sp", "rgeos", "raster", "foreach")) %do% {
                            rasterize(x    = fctn.spdf,
                                      y    = raster.cropped[[i]],         # parallelization here occurs at *RASTER LAYER* level
                                      mask = T)
                            }

    rasterized.spdf <- stack(rasterized.spdf.list)                        # stacks layers
  }


  # layer names
  names(rasterized.spdf) <- names(raster.cropped)                         # layer names preserved through crop, but lost in rasterize



  # DBF CONSTRUCTION
  # extraction
  rasterized.spdf.cells <- data.table(rasterToPoints(rasterized.spdf))    # contains raster cell identifiers (centroid x/y coordinates) and values


  # unique polygon identifier
  spdf.polyg.id                 <- as.character(fctn.spdf@data[colnames(fctn.spdf@data) == fctn.spdf.idcol])
  rasterized.spdf.cells$poly_id <- spdf.polyg.id


  # column names
  setnames(rasterized.spdf.cells, 'x', 'lon')
  setnames(rasterized.spdf.cells, 'y', 'lat')



  # EXPORT
  # prep
  return.obj <- paste(fctn.return.objname, spdf.polyg.id, sep = ".")

  assign(x     = return.obj,
         value = rasterized.spdf.cells)


  # output writing
  save(list = return.obj,
       file = file.path(fctn.return.dir, paste0(fctn.return.filename, "_", spdf.polyg.id, ".RData")))
}





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------