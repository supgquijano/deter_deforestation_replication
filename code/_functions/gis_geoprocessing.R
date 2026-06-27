
# > PROJECT INFO
# NAME: FUNCTION REPOSITORY
# LEAD: TEAM EFFORT
#
# > THIS SCRIPT
# AIM: BUILD COMMON GEOPROCESSING FUNCTIONS FOR SPATIAL OBJECTS
# AUTHOR: CLARISSA GANDOUR
#
# > EDIT DETAILS
# BY: CLARISSA GANDOUR
# ON: MAY/13/2017
#
# > NOTES
# 1: -




# UNION ---------------------------------------------------------------------------------------------------------------------------------------------

MultipleLayerUnion <- function(layer.list) {

    # COMBINES MULTIPLE LAYERS (IN LIST) INTO SINGLE LAYER
    #
    # ARGS
    #   layer.list: list of SpatialPolygons (layers)
    #
    # RETURNS
    #   union.output: single SpatialPolygons layer

    union.output <- layer.list[[1]]
    counter      <- 2  # determines starting element of layer.list

    while (counter <= length(layer.list)) {
        union.output <- gUnion(union.output, layer.list[[counter]])
        counter      <- counter + 1
    }

    return = union.output
}


# CONDITIONAL CLEANGEO ------------------------------------------------------------------------------------------------------------------------------

CondCleangeo <- function(layer, cleangeo_strategy="BUFFER") {

  # VERIFIES GEOMETRY PROBLEMS AND FIXES IT IF NEEDED. (saves time in case it is not needed)
  # Strategy Default: "BUFFER", alternative option: "POLYGONATION"
  #
  # ARGS
  #   layer: Spatial Object
  #
  # RETURNS
  #   SpatialPolygon without geometry irregularities (if successful, otherwise, negative feedback is given)

  # GEOMETRY CLEANUP [via 'cleangeo' package]
  require("cleangeo")                                     # makes sure package is loaded into workspace



  # ERROR CHECKING
  # checks if it is projected
  if ((is.projected(layer) == FALSE) | is.na(proj4string(layer))) {  # outputs are different for the same object in case it is or not projected
    stop("*** Object needs to be projected before CondCleangeo")     #  (recheck needed!)
  }


  # invalid geometry check
  layer.report        <- clgeo_CollectionReport(layer)    # collects info regarding geometry problems
  test.diff <- length(layer.report$valid) - sum(layer.report$valid)
  if (test.diff == 0){
    message("No geometry irregularities found")
  }
  if (test.diff > 0) {
    # runs cleangeo function if necessary
    layer <- clgeo_Clean(layer, strategy = cleangeo_strategy)

    # checks if cleangeo was successful
    layer.report        <- clgeo_CollectionReport(layer)    # collects info regarding geometry problems
    test.diff <- length(layer.report$valid) - sum(layer.report$valid)
    if (test.diff == 0){
      message("Cleangeo fix successful: No geometry irregularities found")
    }
    if (test.diff > 0) {
      message("Cleangeo was not able to fix geometry")
    }
  }

  return(layer)
}

CondCleangeoSf <- function(layer, cleangeo_strategy="BUFFER") {
 
 # VERIFIES GEOMETRY PROBLEMS AND FIXES IT IF NEEDED. (saves time in case it is not needed)
 # Strategy Default: "BUFFER", alternative option: "POLYGONATION"
 #
 # ARGS
 #   layer: Sf Object
 #
 # RETURNS
 #   Sf Data Frame without geometry irregularities (if successful, otherwise, negative feedback is given)
 
 # GEOMETRY CLEANUP [via 'cleangeo' package]
 require("cleangeo")                                     # makes sure package is loaded into workspace
 require("sp")
 require("sjmisc")
 
 
 # ERROR CHECKING
 # checks if it is projected
 if ((is_empty(grep(x = as.character(st_crs(layer)[length(st_crs(layer))]), 
           pattern = "+proj=longlat", value = F)) == FALSE) | 
      all(is.na(st_crs(layer)[length(st_crs(layer))]))) {  # outputs are different for the same object in case it is or not projected
  stop("*** Object needs to be projected before CondCleangeo")     #  (recheck needed!)
 }
 
 # transform to sp object
 layer        <- as(layer, "Spatial") 
 
 # invalid geometry check
 layer.report <- clgeo_CollectionReport(layer)    # collects info regarding geometry problems
 test.diff    <- length(layer.report$valid) - sum(layer.report$valid)
 if (test.diff == 0){
  message("No geometry irregularities found")
 }
 if (test.diff > 0) {
  # runs cleangeo function if necessary
  layer <- clgeo_Clean(layer, strategy = cleangeo_strategy)
  
  # checks if cleangeo was successful
  layer.report        <- clgeo_CollectionReport(layer)    # collects info regarding geometry problems
  test.diff <- length(layer.report$valid) - sum(layer.report$valid)
  if (test.diff == 0){
   message("Cleangeo fix successful: No geometry irregularities found")
  }
  if (test.diff > 0) {
   message("Cleangeo was not able to fix geometry")
  }
 }
 
 layer <- st_as_sf(layer)
 return(layer)
}



# DROP SLIVERS  -------------------------------------------------------------------------------------------------------------------------------------


TreatSlivers <- function(drop, threshold, scale=getScale(), warn = T) {

  # TREAT SLIVERS THAT RESULT FROM TOPOLOGY OPERATIONS
  # A sliver is a polygon that results from any topology operation (dissolve, intersect) which area is equal or greater than precision (= 1/scale)
  # and smaller than the determined polyThreshold.
  #
  #
  # ARGS
  #   drop:      Logical
  #   threshold: Numerical (> 1/scale)
  #   scale:     Numerical (> 0)
  #   warn:      Logical
  #
  # RETURNS
  #   Rgeos settings for handling slivers

  setScale(scale)                     # default: scale = 1e+09 ; smallest scale available in R-3.4: 1e+15
  set_RGEOS_polyThreshold(threshold)  # default: threshold = 0.0
  set_RGEOS_dropSlivers(drop)         # drops slivers if drop = TRUE
  set_RGEOS_warnSlivers(warn)         # prints a warning for every sliver encountered during topology operations if warn = TRUE
                                      # objects reported in warnings are dropped if drop = TRUE

}


# PRESERVE DATAFRAME (AGGREGATED) IN DISSOLVE -------------------------------------------------------------------------------------------------------


KeepDFinDissolve <- function(layer, id.vars,  vars.to.aggregate, stat.function) {

  # FUNCTION TO REATTACH DATA FRAME IN AGGREGATED FORM TO DISSOLVED LAYER
  # The function also enables the use of more than one variable as categories identifier.
  #
  # ARGS:
  #   layer:              SpatialPolygonsDataFrame object
  #   id.vars:            vector of variables names in SPDF dataset to define dissolving and collapsing categories
  #   vars.to.aggregate:  vector of variables names to apply chosen statistical function in aggregation
  #   stat.function:      functions supported by 'aggregate' operation, from 'stat' package
  #
  # OUTPUT:
  #   SpatialPolygonsDataFrame - polygons aggregated by variables defined in id.vars, with associated data frame containing variables
  #                              specified in id.vars and vars.to.aggregate, the latter transformed by function specified in stat.function,
  #                              and aggregated by categories defined by variables in id.vars.

  # create variable that contains categories to dissolve SP and aggregate DF by
  id.vars.args                       <- c(layer@data[id.vars], sep = ";")
  layer$ids_for_dissolveandaggregate <- do.call(paste, id.vars.args)

  # AGGREGATE DATA FRAME

  # subset layer data.frame to contain only variables of interest (ids and the ones to be aggregated)
  make.subset <- c(id.vars, vars.to.aggregate, "ids_for_dissolveandaggregate")
  subset.df   <- layer@data[make.subset]

  # make sure variables to be aggregated are numeric
  subset.df[vars.to.aggregate]  <- data.frame(lapply(subset.df[vars.to.aggregate], as.numeric), stringsAsFactors = F)

  # aggregate
  layer.df <- aggregate(subset.df[vars.to.aggregate], by = as.list(subset.df[id.vars]), FUN = stat.function)

  # assign row names that will be compatible with the dissolved SpatialPolygon
  id.vars.args        <- c(layer.df[id.vars], sep=";")
  row.names(layer.df) <- do.call(paste, id.vars.args)

  # DISSOLVE LAYER

  layer <- gUnaryUnion(layer, id=layer$ids_for_dissolveandaggregate)

  # JOIN DISSOLVED LAYER WITH AGGREGATED DATA FRAME (row.names are compatible)

  layer <- SpatialPolygonsDataFrame(layer, layer.df)

  # Output
  return(layer)
}


# INTERSECT FOR LARGE AND HEAVY SPDF OBJECTS --------------------------------------------------------------------------------------------------------

# Functions 'IntersectOrCrop2Intersect' and 'Crop2Intersect' are interdependent

IntersectOrCrop2Intersect <- function(layer2intersect, layer2crop) {
  # Arguments
  #   layer2crop: layer that will determine coordinates thresholds to crop both layers
  #   layer2intersect : 2nd layer to be cropped and used for intersect
  # Requires
  #   Crop2Intersect function - both functions interact dynamically
  layer.output <- try(raster::intersect(layer2intersect, layer2crop))
  if(class(layer.output) != "try-error"){
    print("Objects intersected successfully without cropping.")
  }
  while (class(layer.output) == "try-error") {
    cat("Caught an error during Crop2Intersect, dividing object into 4 pieces to retry .\n")
    layer.output <- try(Crop2Intersect(layer2intersect, layer2crop, divideby = 2))
    if(class(layer.output) != "try-error"){
      print("Intersection by cropping successfully completed, object reassembled.")
    }
  }
  return(layer.output)
}

Crop2Intersect <- function(layer2intersect, layer2crop, divideby) {
  # Arguments
  #   layer2crop: layer that will determine coordinates thresholds to crop both layers
  #   layer2intersect : 2nd layer to be cropped and used for intersect
  #   divideby : number of vertical and horizontal crops
  # Requires
  #   IncrementCrop2Intersect function - both functions interact dynamically
  extent.layer <- as.matrix(extent(layer2crop))
  xmin <- extent.layer[1,1]
  xmax <- extent.layer[1,2]
  ymin <- extent.layer[2,1]
  ymax <- extent.layer[2,2]

  n.crops = divideby^2                       #gives the total amount of 'pieces' to be cropped
  crop.vectors <- matrix(data = NA, nrow = n.crops, ncol = 4) #defines a matrix to put sets of coordinates that go into cropping
  for(y in 1:divideby){
    for(x in 1:divideby){
      # X rows - [,1] is minimum X and [,2] is maximum X to be used in crop
      crop.vectors[x+(y-1)*divideby,1] <- xmin + (x-1)*(xmax - xmin)/divideby
      crop.vectors[x+(y-1)*divideby,2] <- xmin + (x)*(xmax - xmin)/divideby
      # Y rows - [,3] is minimum Y and [,4] is maximum Y to be used in crop
      crop.vectors[x+(y-1)*divideby,3] <- ymin + (y-1)*(ymax - ymin)/divideby
      crop.vectors[x+(y-1)*divideby,4] <- ymin + (y)*(ymax - ymin)/divideby
    }
  }
  layer.parts.list <- list()
  for(i in 1:nrow(crop.vectors)){
    start <- Sys.time()
    layer.parts.list[[i]] <- IntersectOrCrop2Intersect(crop(layer2intersect, crop.vectors[i,]), crop(layer2crop, crop.vectors[i,]))
    print(paste(as.character(i), "/", as.character(nrow(crop.vectors)),
                "successfully intersected in",
                sep=" "))
    print(Sys.time() - start)
  }
  layer.reassembled <- do.call(rbind, layer.parts.list)
  return(layer.reassembled)
}





# INTERSECTION ---------------------------------------------------------------------------------------------------------------------------------------

IntersectPolygonsThatOverlap <- function(arg.layer1, arg.layer2) {

  # OPTIMIZES INTERSECTION BY TESTING FOR POLYGON OVERLAP FIRST
  #
  # ARGS
  #   arg.layer1: SpatialPolygons*, first  layer to be intersected
  #   arg.layer2: SpatialPolygons*, second layer to be intersected
  #
  # RETURNS
  #   SpatialPolygons of overlap area between argument layers


  # ERROR CHECK
  stopifnot(identicalCRS(arg.layer1, arg.layer2))



  # OVERLAP TEST
  temp1 <- gIntersects(arg.layer1, arg.layer2, byid = T, returnDense = F)  # creates a list of the length of arg.layer1; if element index is NULL,   >
  temp2 <- gIntersects(arg.layer2, arg.layer1, byid = T, returnDense = F)  # polygon does not intersect any arg.layer2 polygons



  # INTERSECTED POLYGON SELECTION
  for (list.element in 1:length(temp1)) {                                  # flags polygons in arg.layer1 to keep/drop based on overlap test
    if (temp1[list.element] != "NULL") {
      temp1[list.element] <- "KEEP"
    } else {
      temp1[list.element] <- "DROP"
    }
  }

  for (list.element in 1:length(temp2)) {                                  # flags polygons in arg.layer2 to keep/drop based on overlap test
    if (temp2[list.element] != "NULL") {
      temp2[list.element] <- "KEEP"
    } else {
      temp2[list.element] <- "DROP"
    }
  }

  intersect.matrix1 <- as.matrix(temp1)
  intersect.matrix2 <- as.matrix(temp2)

  layer1.subsetByIntersect <- arg.layer1[which(intersect.matrix1 == "KEEP"), ]
  layer2.subsetByIntersect <- arg.layer2[which(intersect.matrix2 == "KEEP"), ]



  # INTERSECTION
  intersection <- gIntersection(spgeom1 = layer1.subsetByIntersect,
                                       spgeom2 = layer2.subsetByIntersect,
                                       byid    = T)



  # RETURN
  return(intersection)
}





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------