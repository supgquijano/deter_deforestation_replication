
# > PROJECT INFO
# NAME: CENTRAL DATA REPOSITORY CONSTRUCTION - GRIDDED TERRESTRIAL AIR TEMPERATURE AND TERRESTRIAL PRECIPITATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: BUILD SPATIAL WEATHER DATA FOR WORLD AND BRAZILIAN MUNICIPALITIES
# AUTHOR: CLARISSA GANDOUR
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/21/2020
#
# > NOTES
# -





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source("code/_functions/setup.R")
source(file.path("code/_functions/gis_crs.R"))
source(file.path("code/_functions/logical.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# TREATED DATA
# gridded weather data
load(file = file.path("data/raw2clean/geography/weather_uniDelaware/output", "geo_global_weather_world_gridded_df.RData"))

# spatial municipality data
load(file = file.path("data/raw2clean/administrative/territorial_ibge/brazil/output/2007", "admin_br_territory_muni_2007_spdf.Rdata"))





# FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------

IntersectMuniWeatherGrid <- function(weather.var) {

  # INTERSECTS MUNICIPALITY SHAPEFILE WITH WEATHER GRID
  #
  # ARGS
  #   weather.var: string indicating 'temperature' or 'precipitation' treatment
  #
  # RETURNS
  #   spatial object (SpatialPointsDataFrame) with all grid nodes that intersect municipalities - note municipality list in output data frame only   >
  #   contains municipalities that intersect with at least one grid node [treatment of municipalities that intersect with no grid nodes performed    >
  #   separately]
  #
  # OBS
  #   /!\ setting adequate output obj name is left to user


  # function objects
  if        (weather.var == "temperature") {
    fctn.input <- weather.temp.sp
  } else if (weather.var == "precipitation") {
    fctn.input <- weather.rain.sp
  }


  # intersection between weather grids and municipalities
  if (identicalCRS(fctn.input, admin.br.muni.WGS84) == T) {                              # intersects using unproj WGS84 for consistency with grid
    fctn.return <- intersect(x = crop(x = fctn.input, y = extent(admin.br.muni.WGS84)),  # crops to muni extent for speed
                             y = admin.br.muni.WGS84)
  }


  # muni code and weather variable selection
  fctn.return <- fctn.return[, c(217, 1:216)]


  # function output
  return(fctn.return)
  rm(fctn.input)
}



AggWeatherVarsInterAtMuni <- function(weather.var) {

  # CONSTRUCTS AGGREGATE (MUNI-LEVEL) WEATHER VARIABLES FROM INTERSECTED GRID NODES FOR MUNICIPALITIES THAT INTERSECT WITH AT LEAST ONE GRID NODE
  #
  # ARGS
  #   weather.var: string indicating 'temperature' or 'precipitation' treatment
  #
  # RETURNS
  #   data frame containing unique municipality entries with constructed aggregate (muni-level) weather variables
  #     obs. only addresses municipalities that intersect with at least one weather grid node
  #     obs. constructed weather variable for temperature is average temperature across intersected grid nodes and for precipitation is total        >
  #     precipitation across intersected grid nodes
  #
  # OBS
  #   /!\ iteration functionality hinges on preserved row order throughout iterations due to use of 'cbind'
  #   /!\ temperature and precipitation operations differ in function
  #   /!\ setting adequate output obj name is left to user


  # TEMPERATURE
  if (weather.var == "temperature") {

    # function objects
    fctn.input    <- weather.temp.munibr@data
    fctn.output   <- fctn.input[, which(names(fctn.input) == "muni_code"), drop = F]    # starts output obj with data frame of munis                 >
                                                                                        # intersecting with at least one grid node

    # weather variable construction: average temperature across intersected grid nodes
    for (mmyy in 2:ncol(fctn.input)) {
      fctn.aux    <- fctn.input[, c(1, mmyy)]                                                            # selects single month/year per iteration
      fctn.aux    <- within(fctn.aux,
                            {avg = ave(fctn.aux[[2]], muni_code, FUN = mean)})                           # averages mmyy entries by muni code group

      fctn.temp   <- round(fctn.aux[, which(colnames(fctn.aux) == "avg"), drop = F], digits = 1)         # subsets calculated weather variable
      names(fctn.temp)[which(names(fctn.temp) == "avg")] <- paste0("muni_avgtemp_", names(fctn.aux[2]))  # renames based on mmyy

      fctn.output <- cbind(fctn.output, fctn.temp)                                                       # iteratively binds across selected mmyy
    }


  # PRECIPITATION
  } else if (weather.var == "precipitation") {

    # function objects
    fctn.input    <- weather.rain.munibr@data
    fctn.output   <- fctn.input[, which(names(fctn.input) == "muni_code"), drop = F]                     # starts output obj with data frame of munis>
                                                                                                         # intersecting with at least one grid node

    # weather variable construction: total precipitation across intersected grid nodes
    for (mmyy in 2:ncol(fctn.input)) {
      fctn.aux    <- fctn.input[, c(1, mmyy)]                                                            # selects single month/year per iteration
      fctn.aux    <- within(fctn.aux,
                            {tot = ave(fctn.aux[[2]], muni_code, FUN = sum)})                            # sums mmyy entries by muni code group

      fctn.temp   <- round(fctn.aux[, which(colnames(fctn.aux) == "tot"), drop = F], digits = 1)         # subsets calculated weather variable
      names(fctn.temp)[which(names(fctn.temp) == "tot")] <- paste0("muni_totrain_", names(fctn.aux[2]))  # renames based on mmyy

      fctn.output <- cbind(fctn.output, fctn.temp)                                                       # iteratively binds across selected mmyy
    }
  }


  # duplicate entry treatment
  fctn.output <- unique(x = fctn.output)


  # function output
  return(fctn.output)
  rm(fctn.input, fctn.output, fctn.aux, fctn.temp)
}



Intersect30kmBufferMuniWeatherGrid <- function(weather.var) {

  # IDENTIFIES MUNICIPALITIES THAT DO NOT INTERSECT WITH ANY WEATHER GRID NODES, BUT WHOSE 30KM BUFFER INTERSECTS WITH AT LEAST ONE WEATHER GRID NODE
  #
  # ARGS
  #   weather.var: string indicating 'temperature' or 'precipitation' treatment
  #
  # RETURNS
  #   spatial object (SpatialPointsDataFrame) with all grid nodes that intersect 30km buffers around municipalities that do not intersect with any   >
  #   weather grid nodes
  #
  # OBS
  #   /!\ setting adequate output obj name is left to user


  # function objects
  fctn.muni.all <- admin.br.muni.2007.spdf@data[, c("muni_code"), drop = F]

  if        (weather.var == "temperature") {
    fctn.weather.sp     <- weather.temp.sp
    fctn.muni.gridinter <- weather.temp.munibr
  } else if (weather.var == "precipitation") {
    fctn.weather.sp     <- weather.rain.sp
    fctn.muni.gridinter <- weather.rain.munibr
  }


  # identification of municipalities that do not intersect with any weather grid nodes [henceforth 'nogrid munis']
  fctn.nointer    <- merge(x = fctn.muni.all,                                                     # merges all munis with those that intersect grid  >
                           y = fctn.muni.gridinter,                                               # nodes to identify gaps
                           by = "muni_code",
                           all = T)
  fctn.nointer    <- fctn.nointer[!complete.cases(fctn.nointer), ]                                # subsets to nogrid munis
  fctn.nointer    <- fctn.nointer[, c("muni_code"), drop = F]                                     # keep only nogrid muni codes

  fctn.selectrows <- fctn.muni.all$muni_code %in% fctn.nointer$muni_code                          # locates nogrid munis in full muni data frame
  fctn.nointer.sp <- admin.br.muni.2007.spdf[fctn.selectrows, ]                                   # subsets spatial object to nogrid munis           >
                                                                                                  # [/!\ note that operation yields shapefile in     >
                                                                                                  # projSAD69 to enable buffer creation below
  # intersection between weather grids and constructed 30-km buffer around nogrid municipalities
  fctn.nointer.sp.buffer <- gBuffer(spgeom = fctn.nointer.sp,
                                    byid   = T,
                                    width  = 30000)                                              # 30km is approx half the distance between grid nodes

  fctn.nointer.sp.buffer.WGS84 <- spTransform(x      = fctn.nointer.sp.buffer,
                                              CRSobj = CRS(CRSUnprojected(CRSunproj = "WGS84longlat")))

  fctn.30kmbuf.inter <- intersect(x = crop(x = fctn.weather.sp, y = extent(-83, -22, -43, 15)),  # extends extent (by 10 decimal degrees all around) >
                                  y = fctn.nointer.sp.buffer.WGS84)                              # to enable intersection with nodes outside Brazil


  # muni code and weather variable selection
  fctn.30kmbuf.inter@data <- fctn.30kmbuf.inter@data[, c(217, 1:216)]                            # selects only muni code and weather variables


  # function output
  return(fctn.30kmbuf.inter)
  rm(fctn.muni.all, fctn.weather.sp, fctn.muni.gridinter)
}



AggWeatherVarsInterAt30kmMuni <- function(weather.var) {

  # CONSTRUCTS AGGREGATE (MUNI-LEVEL) WEATHER VARIABLES FROM INTERSECTED GRID NODES FOR 30KM BUFFER AROUND NOGRID MUNICIPALITIES
  #
  # ARGS
  #   weather.var: string indicating 'temperature' or 'precipitation' treatment
  #
  # RETURNS
  #   data frame containing unique municipality entries with constructed aggregate (muni-level) weather variables
  #     obs. only addresses municipalities that do not intersect with any weather grid node and whose 30km buffer intersects with at least one       >
  #     weather grid node
  #     obs. constructed weather variable for temperature is average temperature across intersected grid nodes and for precipitation is total        >
  #     precipitation across intersected grid nodes
  #
  # OBS
  #   /!\ iteration functionality hinges on preserved row order throughout iterations due to use of 'cbind'
  #   /!\ temperature and precipitation operations differ in function
  #   /!\ setting adequate output obj name is left to user


  # TEMPERATURE
  if (weather.var == "temperature") {

    # function objects
    fctn.input    <- weather.temp.muninogrid@data
    fctn.output   <- fctn.input[, c("muni_code"), drop = F]                                              # starts output obj with data frame of      >
                                                                                                         # nogrid munis whose 30km buffer intersects >
                                                                                                         # with at least one grid node
    # weather variable construction: average temperature across intersected grid nodes
    for (mmyy in 2:ncol(fctn.input)) {
      fctn.aux    <- fctn.input[, c(1, mmyy)]                                                            # selects single month/year per iteration
      fctn.aux    <- within(fctn.aux,
                            {avg = ave(fctn.aux[[2]], muni_code, FUN = mean)})                           # averages mmyy entries by muni code group

      fctn.temp   <- round(fctn.aux[, which(colnames(fctn.aux) == "avg"), drop = F], digits = 1)         # subsets calculated weather variable
      names(fctn.temp)[which(names(fctn.temp) == "avg")] <- paste0("muni_avgtemp_", names(fctn.aux[2]))  # renames based on mmyy

      fctn.output <- cbind(fctn.output, fctn.temp)                                                       # iteratively binds across selected mmyy
    }


    # PRECIPITATION
  } else if (weather.var == "precipitation") {

    # function objects
    fctn.input  <- weather.rain.muninogrid@data
    fctn.output <- fctn.input[, c("muni_code"), drop = F]                                                # starts output obj with data frame of      >
                                                                                                         # nogrid munis whose 30km buffer intersects >
                                                                                                         # with at least one grid node
    # weather variable construction: total precipitation across intersected grid nodes
    for (mmyy in 2:ncol(fctn.input)) {
      fctn.aux    <- fctn.input[, c(1, mmyy)]                                                            # selects single month/year per iteration
      fctn.aux    <- within(fctn.aux,
                            {tot = ave(fctn.aux[[2]], muni_code, FUN = mean)})                            # sums mmyy entries by muni code group

      fctn.temp   <- round(fctn.aux[, which(colnames(fctn.aux) == "tot"), drop = F], digits = 1)         # subsets calculated weather variable
      names(fctn.temp)[which(names(fctn.temp) == "tot")] <- paste0("muni_totrain_", names(fctn.aux[2]))  # renames based on mmyy

      fctn.output <- cbind(fctn.output, fctn.temp)                                                       # iteratively binds across selected mmyy
    }
  }


  # duplicate entry treatment
  fctn.output <- unique(x = fctn.output)


  # function output
  return(fctn.output)
  rm(fctn.input, fctn.output, fctn.aux, fctn.temp)
}



Intersect60kmBufferMuniWeatherGrid <- function(weather.var) {

  # IDENTIFIES MUNICIPALITIES THAT DO NOT INTERSECT WITH ANY WEATHER GRID NODES AND WHOSE 30KM BUFFER ALSO DO NOT INTERSECT WITH ANY WEATHER GRID    >
  # NODES; INTERSECTS 60KM BUFFER AROUND THEM WITH WEATHER GRID
  #
  # ARGS
  #   weather.var: string indicating 'temperature' or 'precipitation' treatment
  #
  # RETURNS
  #   spatial object (SpatialPointsDataFrame) with all grid nodes that intersect 60km buffers around municipalities that do not intersect with any   >
  #   weather grid nodes and whose 30km buffers also do not intersect with any weather grid nodes
  #
  # OBS
  #   /!\ setting adequate output obj name is left to user


  # function objects
  fctn.muni.all         <- admin.br.muni.2007.spdf@data[, c("muni_code"), drop = F]

  if        (weather.var == "temperature") {
    fctn.weather.sp     <- weather.temp.sp
    fctn.muni.gridinter <- weather.temp.munibr
    fctn.nogrid.inter   <- weather.temp.muninogrid.agg[, c("muni_code"), drop = F]
  } else if (weather.var == "precipitation") {
    fctn.weather.sp     <- weather.rain.sp
    fctn.muni.gridinter <- weather.rain.munibr
    fctn.nogrid.inter   <- weather.rain.muninogrid.agg[, c("muni_code"), drop = F]
  }


  # identification of nogrid municipalities [repeated from previous function]
  fctn.nogrid <- merge(x = fctn.muni.all,                                                        # merges all munis with those that intersect grid   >
                       y = fctn.muni.gridinter,                                                  # nodes to identify gaps
                       by = "muni_code",
                       all = T)
  fctn.nogrid <- fctn.nogrid[!complete.cases(fctn.nogrid), ]                                     # subsets to nogrid munis
  fctn.nogrid <- fctn.nogrid[, c("muni_code"), drop = F]                                         # keep only nogrid muni codes


  # identification of nogrid municipalities whose 30km buffer does not intersect with any weather grid nodes [henceforth 'nogrid no30km' munis]
  fctn.nogrid.inter$aux <- "30km buffer grid"

  fctn.nogrid.no30km <- merge(x = fctn.nogrid,                                                   # merges all no grid munis with those whose 30km    >
                              y = fctn.nogrid.inter,                                             # buffer intersects with at least one grid node
                              by = "muni_code",
                              all = T)
  fctn.nogrid.no30km <- fctn.nogrid.no30km[!complete.cases(fctn.nogrid.no30km), ]                # subsets to nogrid no30km
  fctn.nogrid.no30km <- fctn.nogrid.no30km[, c("muni_code"), drop = F]

  fctn.selectrows       <- fctn.muni.all$muni_code %in% fctn.nogrid.no30km$muni_code
  fctn.nogrid.no30km.sp <- admin.br.muni.2007.spdf[fctn.selectrows, ]                            # all nogrid no30km munis are coastal - makes sense >
                                                                                                 # considering grid is for terrestrial variables only

  # intersection between weather grids and constructed 60-km buffer around nogrid no30km municipalities
  fctn.nogrid.no30km.sp.buffer      <- gBuffer(spgeom = fctn.nogrid.no30km.sp,
                                               byid   = T,
                                               width  = 60000)                                   # 60km is twice original 30km buffer

  fctn.nogrid.no30km.sp.buffer.WGS84 <- spTransform(x      = fctn.nogrid.no30km.sp.buffer,
                                                    CRSobj = CRS(CRSUnprojected(CRSunproj = "WGS84longlat")))

  fctn.60kmbuf.inter <- intersect(x = crop(x = fctn.weather.sp, y = extent(-83, -22, -43, 15)),  # extends extent (by 10 decimal degrees all around) >
                                  y = fctn.nogrid.no30km.sp.buffer.WGS84)                        # to enable intersection with nodes outside Brazil


  # muni code and weather variable selection
  fctn.60kmbuf.inter@data <- fctn.60kmbuf.inter@data[, c(217, 1:216)]                            # selects only muni code and weather variables


  # function output
  return(fctn.60kmbuf.inter)
}



AggWeatherVarsInterAt60kmMuni <- function(weather.var) {

  # CONSTRUCTS AGGREGATE (MUNI-LEVEL) WEATHER VARIABLES FROM INTERSECTED GRID NODES FOR 60-KM BUFFER AROUND NOGRID NO30KM MUNICIPALITIES
  #
  # ARGS
  #   weather.var: string indicating 'temperature' or 'precipitation' treatment
  #
  # RETURNS
  #   data frame containing unique municipality entries with constructed aggregate (muni-level) weather variables
  #     obs. only addresses municipalities that do not intersect with any weather grid node and whose 30km buffer also does not intersect with at    >
  #     least one weather grid node, but whose 60km buffer intersects with at least one weather grid node
  #     obs. constructed weather variable for temperature is average temperature across intersected grid nodes and for precipitation is total        >
  #     precipitation across intersected grid nodes
  #
  # OBS
  #   /!\ iteration functionality hinges on preserved row order throughout iterations due to use of 'cbind'
  #   /!\ temperature and precipitation operations differ in function
  #   /!\ setting adequate output obj name is left to user


  # TEMPERATURE
  if (weather.var == "temperature") {

    # function objects
    fctn.input  <- weather.temp.muninogrid.no30km@data
    fctn.output <- fctn.input[, c("muni_code"), drop = F]                                                # starts output obj with data frame of      >
                                                                                                         # nogrid no30km munis whose 60km buffer     >
                                                                                                         # intersects with at least one grid node
    # weather variable construction: average temperature across intersected grid nodes
    for (mmyy in 2:ncol(fctn.input)) {
      fctn.aux    <- fctn.input[, c(1, mmyy)]                                                            # selects single month/year per iteration
      fctn.aux    <- within(fctn.aux,
                            {avg = ave(fctn.aux[[2]], muni_code, FUN = mean)})                           # averages mmyy entries by muni code group

      fctn.temp   <- round(fctn.aux[, which(colnames(fctn.aux) == "avg"), drop = F], digits = 1)         # subsets calculated weather variable
      names(fctn.temp)[which(names(fctn.temp) == "avg")] <- paste0("muni_avgtemp_", names(fctn.aux[2]))  # renames based on mmyy

      fctn.output <- cbind(fctn.output, fctn.temp)                                                       # iteratively binds across selected mmyy
    }


  # PRECIPITATION
  } else if (weather.var == "precipitation") {

    # function objects
    fctn.input  <- weather.rain.muninogrid.no30km@data
    fctn.output <- fctn.input[, c("muni_code"), drop = F]                                                # starts output obj with data frame of      >
                                                                                                         # nogrid no30km munis whose 60km buffer     >
                                                                                                         # intersects with at least one grid node
    # weather variable construction: total precipitation across intersected grid nodes
    for (mmyy in 2:ncol(fctn.input)) {
      fctn.aux    <- fctn.input[, c(1, mmyy)]                                                            # selects single month/year per iteration
      fctn.aux    <- within(fctn.aux,
                            {tot = ave(fctn.aux[[2]], muni_code, FUN = mean)})                            # sums mmyy entries by muni code group

      fctn.temp   <- round(fctn.aux[, which(colnames(fctn.aux) == "tot"), drop = F], digits = 1)         # subsets calculated weather variable
      names(fctn.temp)[which(names(fctn.temp) == "tot")] <- paste0("muni_totrain_", names(fctn.aux[2]))  # renames based on mmyy

      fctn.output <- cbind(fctn.output, fctn.temp)                                                       # iteratively binds across selected mmyy
    }
  }


  # duplicate entry treatment
  fctn.output <- unique(x = fctn.output)


  # function output
  return(fctn.output)
  rm(fctn.input, fctn.output, fctn.aux, fctn.temp)
}



AggWeatherVarsRowBind <- function(weather.var) {

  # COMBINES ROW FROM MULTIPLE ROUNDS OF AGGREGATE WEATHER VARIABLE CONSTRUCTION
  #
  # ARGS
  #   weather.var: string indicating 'temperature' or 'precipitation' treatment
  #
  # RETURNS
  #   municipality-level data frame with constructed aggregate weather variables
  #
  # OBS
  #   /!\ setting adequate output obj name is left to user


  # function objects
  if        (weather.var == "temperature") {
    fctn.muni          <- weather.temp.munibr.agg
    fctn.nogrid        <- weather.temp.muninogrid.agg
    fctn.nogrid.no30km <- weather.temp.muninogrid.no30km.agg
  } else if (weather.var == "precipitation") {
    fctn.muni          <- weather.rain.munibr.agg
    fctn.nogrid        <- weather.rain.muninogrid.agg
    fctn.nogrid.no30km <- weather.rain.muninogrid.no30km.agg
  }


  # municipality join
  fctn.output <- rbind(fctn.muni, fctn.nogrid, fctn.nogrid.no30km)  # joins rows, as each input data frame contains unique municipalities


  # function output
  return(fctn.output)
  rm(fctn.muni, fctn.nogrid, fctn.nogrid.no30km)
}





# DATASET PREPARATION --------------------------------------------------------------------------------------------------------------------------------

# gridded data reshape
weather.temp.wide <- reshape(data      = geo.global.weather.temp.df,                 # from documentation: if direction = "wide" and no 'v.names' arguments are >
                             v.names   = NULL,                            # supplied, it is assumed that all variables except idvar and timevar are  >
                             timevar   = "year",                          # time-varying - all expanded into multiple variables in wide format
                             idvar     = c("coordy_long", "coordx_lat"),
                             direction = "wide",
                             sep       = "_")

weather.rain.wide <- reshape(data      = geo.global.weather.rain.df,
                             v.names   = NULL,
                             timevar   = "year",
                             idvar     = c("coordy_long", "coordx_lat"),
                             direction = "wide",
                             sep       = "_")


# CRS compatibility
# /!\ gridded data has no explicit indication of CRS - assumed to be *unprojected WGS84* due to:
#     (i)  use of decimal degrees (lat/long) in original data > suggests unprojected GCS, and
#     (ii) global nature of data                              > WGS84 is most commonly used datum for global spatial data
# /!\ intersect will be performed using unprojected objects (instead of projected objects, as is commonly done) - the regularity of the weather grid >
#     at the unprojected CRS (0.5 x 0.5 degrees) motivated this decision
admin.br.muni.WGS84 <- spTransform(x      = admin.br.muni.2007.spdf,
                                   CRSobj = CRS(CRSUnprojected(CRSunproj = "WGS84longlat")))



# ENVIRONMENT CLEANUP
rm(geo.global.weather.temp.df, geo.global.weather.rain.df)





# SPATIAL DATA CONSTRUCTION --------------------------------------------------------------------------------------------------------------------------

# SPATIAL ATTRIBUTION
weather.temp.sp <- SpatialPointsDataFrame(coords      = weather.temp.wide[1:2],
                                          data        = weather.temp.wide[3:218],
                                          proj4string = CRS(CRSUnprojected(CRSunproj = "WGS84longlat")))

weather.rain.sp <- SpatialPointsDataFrame(coords      = weather.rain.wide[1:2],
                                          data        = weather.rain.wide[3:218],
                                          proj4string = CRS(CRSUnprojected(CRSunproj = "WGS84longlat")))



# MUNI/WEATHER GRID: INTERSECTION WITH AT LEAST ONE GRID NODE
# /!\ output only contains municipalities that intersect with at least one weather grid node

# step 1: intersection municipalities and weather grids
weather.temp.munibr     <- IntersectMuniWeatherGrid(weather.var = "temperature")
weather.rain.munibr     <- IntersectMuniWeatherGrid(weather.var = "precipitation")


# step 2: construction of aggregate (muni-level) weather variables from intersected nodes
weather.temp.munibr.agg <- AggWeatherVarsInterAtMuni(weather.var = "temperature")
weather.rain.munibr.agg <- AggWeatherVarsInterAtMuni(weather.var = "precipitation")


# /!\ 1,469 municipalities intersect with at least one weather grid node
#     4,095 municipalities do not intersect with at least one weather grid node



# MUNI/WEATHER GRID: NO INTERSECTION WITH ANY GRID NODES
# /!\ output only contains municipalities that DO NOT intersect with any weather grid nodes

# step 1: identification of municipalities that do not intersect with any weather grid nodes ('nogrid munis') and intersection of 30-km buffer around>
# them with weather grids
weather.temp.muninogrid     <- Intersect30kmBufferMuniWeatherGrid(weather.var = "temperature")
weather.rain.muninogrid     <- Intersect30kmBufferMuniWeatherGrid(weather.var = "precipitation")


# step 2: construction of aggregate (muni-level) weather variables from intersected nodes (with 30km buffer)
weather.temp.muninogrid.agg <- AggWeatherVarsInterAt30kmMuni(weather.var = "temperature")
weather.rain.muninogrid.agg <- AggWeatherVarsInterAt30kmMuni(weather.var = "precipitation")


# /!\ 1,469 municipalities intersect with at least one weather grid node
#     4,046 municipalities do not intersect with at least one weather grid node, but their 30km buffer does
#        49 municipalities do not intersect with at least one weather grid node, nor do their 30km buffer


# step 3: identification of nogrid municipalities whose 30-km buffer also yield no intersection and intersection of 60-km buffer around them with    >
# weather grids
weather.temp.muninogrid.no30km     <- Intersect60kmBufferMuniWeatherGrid(weather.var = "temperature")
weather.rain.muninogrid.no30km     <- Intersect60kmBufferMuniWeatherGrid(weather.var = "precipitation")


# step 4: construction of aggregate (muni-level) weather variables from intersected nodes (with 60km buffer)
weather.temp.muninogrid.no30km.agg <- AggWeatherVarsInterAt60kmMuni(weather.var = "temperature")
weather.rain.muninogrid.no30km.agg <- AggWeatherVarsInterAt60kmMuni(weather.var = "precipitation")


# /!\ 1,469 municipalities intersect with at least one weather grid node
#     4,046 municipalities do not intersect with at least one weather grid node, but their 30km buffer does
#        48 municipalities do not intersect with at least one weather grid node, nor do their 30km buffer, but their 60km buffer does
#         1 municipality does not intersect with at least one weather grid node, nor do its 30km and 60km buffers



# FULL DATASET FOR MUNICIPALITIES AND AGGREGATE WEATHER DATA
# aggregate weather variables data frame
weather.temp.munilevel <- AggWeatherVarsRowBind(weather.var = "temperature")
weather.rain.munilevel <- AggWeatherVarsRowBind(weather.var = "precipitation")


# spatial data
weather.temp.munilevel.sp      <- admin.br.muni.2007.spdf
weather.temp.munilevel.sp@data <- merge(x = admin.br.muni.2007.spdf@data,
                                        y = weather.temp.munilevel,
                                        by = "muni_code",
                                        all = T)

colnames(weather.temp.munilevel.sp@data)
weather.temp.munilevel.sp@data <- weather.temp.munilevel.sp@data[, c(1:4, 10, 13:228)]  # subsets key muni info and aggregate weather variables


weather.rain.munilevel.sp      <- admin.br.muni.2007.spdf
weather.rain.munilevel.sp@data <- merge(x = admin.br.muni.2007.spdf@data,
                                        y = weather.rain.munilevel,
                                        by = "muni_code",
                                        all = T)

colnames(weather.rain.munilevel.sp@data)
weather.rain.munilevel.sp@data <- weather.rain.munilevel.sp@data[, c(1:4, 10, 13:228)]  # subsets key muni info and aggregate weather variables


# missing aggregate weather variable treatment
weather.temp.munilevel.sp@data[!complete.cases(weather.temp.munilevel.sp@data), ]  # displays NA rows; municipality missing weather info is Fernando >
weather.rain.munilevel.sp@data[!complete.cases(weather.rain.munilevel.sp@data), ]  # de Noronha - to be expected, considering it is a small island   >
                                                                                   # far from the coast of Brazil and, thus, unlikely to intersect   >
                                                                                   # with gridded terrestrial weather data

weather.temp.munilevel.sp <- weather.temp.munilevel.sp[complete.cases(weather.temp.munilevel.sp@data), ]  # removes Fernando de Noronha muni - not a >
weather.rain.munilevel.sp <- weather.rain.munilevel.sp[complete.cases(weather.rain.munilevel.sp@data), ]  # concern considering scale of island





# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# changes objects names for exportation
geo.global.weather.temp.muni2007.spdf <- weather.temp.munilevel.sp
geo.global.weather.rain.muni2007.spdf <- weather.rain.munilevel.sp


# POST-TREATMENT OVERVIEW 
# summary(weather.temp.munilevel.sp)
# View(weather.temp.munilevel.sp)
# plot(weather.temp.munilevel.sp)

# summary(weather.rain.munilevel.sp)
# View(weather.rain.munilevel.sp)
# plot(weather.rain.munilevel.sp)




# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(geo.global.weather.temp.muni2007.spdf,
     geo.global.weather.rain.muni2007.spdf,
     file = file.path("data/built/geography/weather","geo_global_weather_built_muni2007_2000th2017_spdf.RData"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------