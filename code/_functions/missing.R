
# > PROJECT INFO
# NAME: FUNCTION REPOSITORY
# LEAD: TEAM EFFORT
# 
# > THIS SCRIPT
# AIM: BUILD FUNCTIONS TO ADDRESS MISSING DATA ENTRIES IN BOTH SPATIAL AND NON-SPATIAL OBJECTS
# AUTHOR: CLARISSA GANDOUR
#
# > EDIT DETAILS
# BY: DIEGO MENEZES
# ON: DEC/12/18
#
# > NOTES
# 1: -





# DATA FRAMES ---------------------------------------------------------------------------------------------------------------------------------------

MissingIdColumns <- function(dataframe) {

  # IDENTIFIES COLUMNS CONTAINING MISSING DATA IN DATA FRAME
  #
  # ARGS
  #   dataframe: non-spatial DataFrame object
  # 
  # RETURNS
  #   column name for columns with at least one NA

  colnames(dataframe)[unlist(lapply(dataframe, function(x) any(is.na(x))))]
}



MissingAllColumnsAndRows <- function(dataframe) {
  
  # IDENTIFIES FULL NA/NaN COLUMNS AND ROWS IN DATA FRAME
  #
  # ARGS
  #   dataframe: non-spatial DataFrame object
  # 
  # RETURNS
  #   row names for rows having NA or NaN in all the columns
  #   column names for columns having NA or NaN in all the rows
  
  na.index     <- rowSums(is.na(dataframe)) == ncol(dataframe)
  missing.rows <- as.vector(row.names(dataframe)[na.index])
  cat("FULL NA/NaN ROWS: ", missing.rows, "\n")
  
  
  na.index     <- colSums(is.na(dataframe)) == nrow(dataframe)
  missing.cols <- as.vector(names(dataframe)[na.index])
  cat("FULL NA/NaN COLUMNS: ", missing.cols, "\n")
  
}




# SPATIAL OBJECTS -----------------------------------------------------------------------------------------------------------------------------------

MissingExcludeSp <- function(x, margin = 1) {

  # REMOVES NAs IN sp DataFrame OBJECT
  #
  # ARGS
  #   x:      sp spatial DataFrame object
  #   margin: remove rows (1) or columns (2) 
  # 
  # RETURNS
  #   spatial object with excluded rows/columns

  if (!inherits(x, "SpatialPointsDataFrame") & !inherits(x, "SpatialPolygonsDataFrame")) {
    stop("MUST BE sp SpatialPointsDataFrame OR SpatialPolygonsDataFrame CLASS OBJECT")  # returns error if object not spatial
  }

  na.index <- unique(as.data.frame(which(is.na(x@data), arr.ind = TRUE))[, margin])  # records margin index of NA occurrence

  if(margin == 1) {
    cat("DELETING ROWS: ", na.index, "\n")
	return(x[-na.index, ])  # excludes rows indexed by margin index
  }

  if(margin == 2) {
    cat("DELETING COLUMNS: ", na.index, "\n")
	return(x[, -na.index])  # excludes columns indexed by margin index
  }
}



MissingAllColumnsAndRowsSp <- function(x) {
  
  # IDENTIFIES FULL NA/NaN COLUMNS AND ROWS IN sp DataFrame OBJECT
  #
  # ARGS
  #   x:      sp spatial DataFrame object
  # 
  # RETURNS
  #   row names for rows having NA or NaN in all the columns
  #   column names for columns having NA or NaN in all the rows
  
  na.index     <- rowSums(is.na(x@data)) == ncol(x@data)
  missing.rows <- as.vector(row.names(x@data)[na.index])
  cat("FULL NA/NaN ROWS: ", missing.rows, "\n")
  
  
  na.index     <- colSums(is.na(x@data)) == nrow(x@data)
  missing.cols <- as.vector(names(x@data)[na.index])
  cat("FULL NA/NaN COLUMNS: ", missing.cols, "\n")
  
}





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------