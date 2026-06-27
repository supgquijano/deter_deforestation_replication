
# > PROJECT INFO
# TITLE: CENTRAL DATA REPOSITORY CONSTRUCTION - DETER (REAL-TIME DETECTION OF LEGAL AMAZON DEFORESTATION & DEGRADATION)
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: CLEAN RAW DATA - ALERTS
# AUTHOR: JOAO VEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/17/2020
#
# > NOTES
# 1: SCRIPT WILL RETURN WARNING, DESPITE SUCCESSFUL RUN - REFERS TO 2011/OCT ALERTS SHAPEFILE, WHICH APPEARS TO CONTAIN NULL GEOMETRIES





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions/setup.R"))
source(file.path("code/_functions", "gis_crs.R"))
source(file.path("code/_functions", "gis_geoprocessing.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# METADATA
#
# DETER [DETECCAO DO DESMATAMENTO EM TEMPO REAL] - ALERTS
# content: deforestation/degradation hotspots (spatial polygons data frame); Brazilian Legal Amazon (extent); monthly (frequency -- data generated   >
#          daily, but made publicly available as monthly aggregates); MAY/2004 through present (period of reference -- but incomplete records for    >
#          2004/2005)
# source: Brazilian Institute for Space Research (INPE) 
# available at: http://www1.dpi.inpe.br/obt/deter/dados/
# raw data downloaded on: JUN/07/2016 (clouds); AUG/16/2017 (alerts) [2004 through 2015 data]; FEB/21/2018 (clouds and alerts) [2016 data]
# web archive link: https://web.archive.org/web/20200203030335/http://www.obt.inpe.br/OBT/assuntos/programas/amazonia/deter/deter (main page only)
# CRS: varies over time -- clarified with INPE (see documentation for details)
#   > 2006 through 2010:         LongLat (coordinate system), SAD69 (datum),         not projected   [SAD69longlat]
#   > 2011 through JUL/2015:     LongLat (coordinate system), SAD69_pre96BR (datum), not projected   [SAD69longlat_pre96BR]
#   > AUG/2015 through DEC/2016: LongLat (coordinate system), SIRGAS2000 (datum),    not projected   [SIRGAS2000longlat]


# obs: manual edits to input directory
#   > JUL/2010 data duplicated in original source (under names 'nuvem' and 'nuvens') -- excluded folder named 'nuvem' for consistency with other 2010 cloud directories
#   > changed layer names for MAR/2009 and MAR/2010 from MAR¢O to MARCO
#   > corrected typo in NOV/2008 folder name -- originally named 2009, but in 2008 online data repository
#   > corrected typo in DEC/2012 folder name -- _sjp (instead of _shp) in online data repository
#   > corrected capitalization mismatch across dbf/shp/shx file names for alert layers (several occurrences throughout)
#   > manually deleted "surplus" downladed data: (i) spr and tif files in 2004/2005 and (ii) extra layers in SEP/2011 alert 
#   > manually corrected layer name for JAN/2016 from "props" to "pol"

# INSTRUCTIONS FOR DOWNLOAD (MANUALLY BUT IT IS POSSIBLE TO AUTOMATIZE)
# 1) insert the url "http://www1.dpi.inpe.br/obt/deter/dados/" on the browser
# 2) for each folder with pattern "YYYY" from 2004 through 2016:
#	2.0) create the same "YYYY" folder pattern inside "data\raw2clean\land_cover\deter_inpe\input" 
# 	2.1) enter in the folder
#	2.2) download each zip file with pattern "Deter_YYYYMM_shp.zip" and "Nuvem_YYYYMM_shp.zip" (or "Nuvens_YYYYMM_shp.zip")
#	2.3) unzip each downloaded folder
# 3) follow the instructions above for manual edits to input directory



# RAW DATA
# input automated in dataset cleanup and prep section





# DATASET CLEANUP AND PREP ---------------------------------------------------------------------------------------------------------------------------

# AUXILIARY OBJECTS
aux.deter.years <- c("2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")
aux.months      <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")



# CLEANUP AND PREP BY CALENDAR YEAR
for (y in seq_along(aux.deter.years)) {

  # DIR SELECTION
  select.deter.year <- aux.deter.years[y]
  dir.input.folders <- list.files(path        = file.path("data/raw2clean/land_cover/deter_inpe/input", select.deter.year),  # lists monthly folders for given year
                                  pattern     = "Deter",
                                  ignore.case = T)



  # PROCESSING
  dir.input.folder.index <- 1                                                    # starts folder index iterator

  for (m in seq_along(aux.months)) {

    # calendar month identification
    cal.month   <- aux.months[m]


    # folder date extraction
    folder.name <- dir.input.folders[dir.input.folder.index]                     # excludes non-standard part of folder name
    folder.date <- gsub(pattern     = "Deter_",
                         replacement = "",
                         x           = folder.name,
                         ignore.case = T)


    # error check
    if (dir.input.folder.index > length(dir.input.folders)) {                    # if directory index greater than number of folders...
      folder.date <- "string to force mismatch with cal.month"                   # assign string that forces mismatch with cal.month in next step
    }


    # folder type: data DOES NOT exist for given month [== full cloud coverage]
    if (substr(folder.date, start = 5, stop = 6) != cal.month) {                 # if calendar month does not match folder date...
      assign(x     = paste("deter.alerts", cal.month, sep = "."),                # ... assigns NULL to indicate no alerts issued (typically due to   >
             value = NULL)                                                       # full cloud coverage that month)

      next                                                                       # cycles through months while holding dir.input.folder.index fixed


    # folder type: data DOES     exist for given month [== partial cloud coverage]
    } else {

      # shapefile access
      file.names <- list.files(file.path("data/raw2clean/land_cover/deter_inpe/input", select.deter.year, folder.name))

      layer.names <- vector()
      for (l in seq_along(file.names)) {
        select.layer <- strsplit(x     = file.names,
                                 split = ".",                                    # splits layer names into pre/post file extension
                                 fixed = T)[[l]][1]                              # selects first (pre-split) component of l-th element
        layer.names  <- rbind(layer.names, select.layer)
      }
      layer.names <- as.vector(unique(layer.names))                              # excludes repeated names from extensions, preserves multiple layers


      # observation type: TWO layers for given month [rare occurrences]
      if (length(layer.names) > 1) {

        # layer input
        deter.alerts.month.half1 <- readOGR(dsn   = file.path("data/raw2clean/land_cover/deter_inpe/input", select.deter.year, folder.name),
                                            layer = layer.names[1])
        deter.alerts.month.half2 <- readOGR(dsn   = file.path("data/raw2clean/land_cover/deter_inpe/input", select.deter.year, folder.name),
                                            layer = layer.names[2])


        # CRS attribution [for shapefiles missing proj4string only; see documentation for details on CRS selection]
        if (select.deter.year > 2010) {
          if (is.na(proj4string(deter.alerts.month.half1))) {
            proj4string(deter.alerts.month.half1) <- CRSUnprojected(CRSunproj = "SAD69longlat_pre96BR")
          }
          if (is.na(proj4string(deter.alerts.month.half2))) {
            proj4string(deter.alerts.month.half2) <- CRSUnprojected(CRSunproj = "SAD69longlat_pre96BR")
          }
        } else {
          if (is.na(proj4string(deter.alerts.month.half1))) {
            proj4string(deter.alerts.month.half1) <- CRSUnprojected(CRSunproj = "SAD69longlat")
          }
          if (is.na(proj4string(deter.alerts.month.half2))) {
            proj4string(deter.alerts.month.half2) <- CRSUnprojected(CRSunproj = "SAD69longlat")
          }
        }


        # projection
        deter.alerts.month.half1 <- spTransform(deter.alerts.month.half1, CRSobj = CRSProjected(CRSproj = "SAD69polyconic"))
        deter.alerts.month.half2 <- spTransform(deter.alerts.month.half2, CRSobj = CRSProjected(CRSproj = "SAD69polyconic"))


        # topology fix [via bufferByLittle instead of cleangeo due to intersection errors]
        deter.alerts.month.half1 <- gBuffer(spgeom = deter.alerts.month.half1,
                                            byid   = T,
                                            width  = 0.01)                       # CRS in meters > buffer width == 0.01m
        deter.alerts.month.half2 <- gBuffer(spgeom = deter.alerts.month.half2,
                                            byid   = T,
                                            width  = 0.01)                       # CRS in meters > buffer width == 0.01m

        # union
        deter.alerts.month <- gUnion(spgeom1 = deter.alerts.month.half1,
                                     spgeom2 = deter.alerts.month.half2)


        # polygon dissolve
        deter.alerts.month <- gUnaryUnion(deter.alerts.month)                    # individual polygon holds no relevant data


        # topology check
        if (select.deter.year == "2008" && cal.month == "06") {                  # addresses only layer that returned error in CondCleangeo
          deter.alerts.month <- gBuffer(spgeom = deter.alerts.month,             # reasons for error still unknown, but additional bufferByZero fixes>
                                        byid   = TRUE,                           # it
                                        width  = 0)
        }
        deter.alerts.month <- CondCleangeo(deter.alerts.month)


        # environment cleanup
        rm(deter.alerts.month.half1, deter.alerts.month.half2)


      # observation type: ONE layer for given month
      } else {

        # layer input
        deter.alerts.month <- readOGR(dsn   = file.path("data/raw2clean/land_cover/deter_inpe/input", select.deter.year, folder.name),
                                      layer = layer.names)


        # CRS attribution [for shapefiles missing proj4string only; see documentation for details on CRS selection]
        if (select.deter.year > 2010) {
          if (is.na(proj4string(deter.alerts.month))) {
            proj4string(deter.alerts.month) <- CRSUnprojected(CRSunproj = "SAD69longlat_pre96BR")
          }
        } else {
          if (is.na(proj4string(deter.alerts.month))) {
            proj4string(deter.alerts.month) <- CRSUnprojected(CRSunproj = "SAD69longlat")
          }
        }


        # projection
        deter.alerts.month <- spTransform(deter.alerts.month, CRSobj = CRSProjected(CRSproj = "SAD69polyconic"))


        # topology fix [via bufferByZero instead of cleangeo due to errors]
        deter.alerts.month <- gBuffer(spgeom = deter.alerts.month,
                                      byid   = T,
                                      width  = 0)


        # polygon extraction
        deter.alerts.month <- as.SpatialPolygons.PolygonsList(Srl         = deter.alerts.month@polygons,
                                                              proj4string = deter.alerts.month@proj4string)


        # polygon dissolve
        deter.alerts.month <- gUnaryUnion(deter.alerts.month)                    # individual polygon holds no relevant data


        # topology check
        if (select.deter.year == "2008" && cal.month == "06") {                  # addresses only layer that returned error in CondCleangeo
           deter.alerts.month <- gBuffer(spgeom = deter.alerts.month,            # reasons for error still unknown, but additional bufferByZero fixes>
                                         byid   = TRUE,                          # it
                                         width  = 0)
        }
        deter.alerts.month <- CondCleangeo(deter.alerts.month)
      }                                                                          # closes if/else condition referring to number of layers
    }                                                                            # closes if/else condition referring to existence of data


    # object identification
    assign(x     = paste("deter.alerts", cal.month, sep = "."),
           value = deter.alerts.month)


    # environment cleanup
    rm(deter.alerts.month)


    # iteration
    dir.input.folder.index = dir.input.folder.index + 1                          # loops folder index iterator
  }                                                                              # closes month loop


  # annual compilation
  deter.alerts.year <- list("JAN" = deter.alerts.01,
                            "FEB" = deter.alerts.02,
                            "MAR" = deter.alerts.03,
                            "APR" = deter.alerts.04,
                            "MAY" = deter.alerts.05,
                            "JUN" = deter.alerts.06,
                            "JUL" = deter.alerts.07,
                            "AUG" = deter.alerts.08,
                            "SEP" = deter.alerts.09,
                            "OCT" = deter.alerts.10,
                            "NOV" = deter.alerts.11,
                            "DEC" = deter.alerts.12)



  # EXPORT PREP
  aux.name <- paste("policy.la.deter.alerts", select.deter.year, "sp", sep = ".")      # needed for export
  assign(x     = aux.name,
         value = deter.alerts.year)



  # INTERMEDIARY EXPORT
  #save(list = aux.name,                                                          # list argument needed to export by ref to object name
  #     file = file.path(FindPath("deter", output = T), paste0("policy_la_deter_alerts", select.deter.year, ".Rdata")))



  # ENVIRONMENT CLEANUP
  rm(deter.alerts.year, aux.name)
}                                                                                # closes year loop

save(policy.la.deter.alerts.2004.sp,
     policy.la.deter.alerts.2005.sp,
     policy.la.deter.alerts.2006.sp,
     policy.la.deter.alerts.2007.sp,
     policy.la.deter.alerts.2008.sp,
     policy.la.deter.alerts.2009.sp,
     policy.la.deter.alerts.2010.sp,
     policy.la.deter.alerts.2011.sp,
     policy.la.deter.alerts.2012.sp,
     policy.la.deter.alerts.2013.sp,
     policy.la.deter.alerts.2014.sp,
     policy.la.deter.alerts.2015.sp,
     policy.la.deter.alerts.2016.sp,
     file = file.path("data/raw2clean/land_cover/deter_inpe/output", "deter_alerts_sp.Rdata"))




# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------