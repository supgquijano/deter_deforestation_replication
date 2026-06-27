
# > PROJECT INFO
# TITLE: CENTRAL DATA REPOSITORY CONSTRUCTION - DETER (REAL-TIME DETECTION OF LEGAL AMAZON DEFORESTATION & DEGRADATION)
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: CLEAN RAW DATA - CLOUDS
# AUTHOR: JOAO VEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIA
# ON: SEP/17/2020
#
# > NOTES
# 1: TIME-CONSUMING SCRIPT





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
# DETER [DETECCAO DO DESMATAMENTO EM TEMPO REAL] - CLOUDS
# content: cloud coverage (spatial polygons data frame); Brazilian Legal Amazon (extent); monthly (frequency -- data generated daily, but made       >
#          publicly available as monthly aggregates); MAY/2004 through present (period of reference -- but incomplete records for 2004/2005)
# source: Brazilian Institute for Space Research (INPE) 
# available at: http://www1.dpi.inpe.br/obt/deter/dados/
# raw data downloaded on: JUN/07/2016 (clouds); AUG/16/2017 (alerts) [2004 through 2015 data]; FEB/21/2018 (clouds and alerts) [2016 data]
# web archive link: https://web.archive.org/web/20200203030335/http://www.obt.inpe.br/OBT/assuntos/programas/amazonia/deter/deter (main page only)
# CRS: varies over time -- clarified with INPE (see documentation for details)
#   > 2006 through 2010:         LongLat (coordinate system), SAD69 (datum),         not projected   [SAD69longlat]
#   > 2011 through JUL/2015:     LongLat (coordinate system), SAD69_pre96BR (datum), not projected   [SAD69longlat_pre96BR]
#   > AUG/2015 through DEC/2016: LongLat (coordinate system), SIRGAS2000 (datum),    not projected   [SIRGAS2000longlat]
#
#
# obs: manual edits to input directory
#   > JUL/2010 data duplicated in original source (under names 'nuvem' and 'nuvens') -- excluded folder named 'nuvem' for consistency with other 2010 cloud directories
#   > changed layer names for MAR/2009 and MAR/2010 from MAR¢O to MARCO
#   > corrected typo in NOV/2008 folder name -- originally named 2009, but in 2008 online data repository
#   > corrected typo in DEC/2012 folder name -- _sjp (instead of _shp) in online data repository
#   > corrected capitalization mismatch across dbf/shp/shx file names for alert layers (several occurrences throughout)
#   > manually deleted "surplus" downladed data: (i) spr and tif files in 2004/2005 and (ii) extra layers in SEP/2011 alert 
#   > manually corrected layer name for JAN/2016 from "props" to "pol"
#
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



# AUXILIARY DATA
# Legal Amazon limits
load(file = file.path("data/raw2clean/administrative/territorial_ibge/legal_amazon/output", paste0("admin_la_territory_sp", ".Rdata")))





# DATASET CLEANUP AND PREP ---------------------------------------------------------------------------------------------------------------------------

# AUXILIARY OBJECTS
aux.deter.years <- c("2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")  # no cloud data for 2004
aux.months      <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")



# CLEANUP AND PREP BY CALENDAR YEAR
for (y in seq_along(aux.deter.years)) {

  # DIR SELECTION
  select.deter.year <- aux.deter.years[y]
  dir.input.folders <- list.files(path     = file.path("data/raw2clean/land_cover/deter_inpe/input", select.deter.year),  # lists all clouds layers for given year
                                  pattern  = "Nuv")



  # PROCESSING
  dir.input.folder.index <- 1                                                    # starts folder index iterator

  for (m in seq_along(aux.months)) {

    # calendar month identification
    cal.month   <- aux.months[m]


    # folder date extraction
    folder.name <- dir.input.folders[dir.input.folder.index]
    folder.date <- gsub(pattern = "Nuvens_", replacement = "", x = folder.name)  # excludes non-standard part of folder name - addresses two possible>
    folder.date <- gsub(pattern = "Nuvem_",  replacement = "", x = folder.date)  # (existing) variations of folder nomenclature


    # error check
    if (dir.input.folder.index > length(dir.input.folders)) {                    # if directory index greater than number of folders...
      folder.date <- "string to force mismatch with cal.month"                   # assign string that forces mismatch with cal.month in next step
    }


    # folder type: data DOES NOT exist for given month [== full cloud coverage]
    if (substr(folder.date, start = 5, stop = 6) != cal.month) {                 # if calendar month does not match folder date...
      assign(x     = paste("deter.clouds", cal.month, sep = "."),                # ... assings LA limits as cloud polygon to spatially capture full  >
             value = SpatialPolygons(Srl         = admin.la.sp@polygons,            # cloud coverage (as per INPE's orientation - see documentation)
                                     proj4string = admin.la.sp@proj4string))
      next                                                                       # cycles through months while holding dir.input.folder.index fixed


    # folder type: data DOES exist for given month [== partial cloud coverage]
    } else {

      # shapefile access
      file.names  <- list.files(file.path("data/raw2clean/land_cover/deter_inpe/input", select.deter.year, folder.name))

      layer.names <- vector()
      for (l in seq_along(file.names)) {
        select.layer <- strsplit(x     = file.names,
                                 split = ".",                                    # splits layer names into pre/post file extension
                                 fixed = T)[[l]][1]                              # selects first (pre-split) component of l-th element
        layer.names  <- rbind(layer.names, select.layer)
      }
      layer.names <- as.vector(unique(layer.names))                              # excludes repeated names from extensions, preserves multiple layers
      layer.names <- layer.names[grep(pattern = "pol", x = layer.names)]         # preserves only polygon layers (due to existence of 'props' files)


      # observation type: TWO layers for given month [common throughout sample]
      if (length(layer.names) > 1) {

        # layer input
        deter.clouds.month.half1 <- readOGR(dsn   = file.path("data/raw2clean/land_cover/deter_inpe/input", select.deter.year, folder.name),
                                            layer = layer.names[1])
        deter.clouds.month.half2 <- readOGR(dsn   = file.path("data/raw2clean/land_cover/deter_inpe/input", select.deter.year, folder.name),
                                            layer = layer.names[2])


        # CRS attribution [for shapefiles missing proj4string only; see documentation for details on CRS selection]
        if (select.deter.year > 2010) {
          if (is.na(proj4string(deter.clouds.month.half1))) {
            proj4string(deter.clouds.month.half1) <- CRSUnprojected(CRSunproj = "SAD69longlat_pre96BR")
          }
          if (is.na(proj4string(deter.clouds.month.half2))) {
            proj4string(deter.clouds.month.half2) <- CRSUnprojected(CRSunproj = "SAD69longlat_pre96BR")
          }
        } else {
          if (is.na(proj4string(deter.clouds.month.half1))) {
            proj4string(deter.clouds.month.half1) <- CRSUnprojected(CRSunproj = "SAD69longlat")
          }
          if (is.na(proj4string(deter.clouds.month.half2))) {
            proj4string(deter.clouds.month.half2) <- CRSUnprojected(CRSunproj = "SAD69longlat")
          }
        }


        # projection
        deter.clouds.month.half1 <- spTransform(deter.clouds.month.half1, CRSobj = CRSProjected(CRSproj = "SAD69polyconic"))
        deter.clouds.month.half2 <- spTransform(deter.clouds.month.half2, CRSobj = CRSProjected(CRSproj = "SAD69polyconic"))


        # topology fix [via bufferByLittle instead of cleangeo due to intersection errors]
        deter.clouds.month.half1 <- gBuffer(spgeom = deter.clouds.month.half1,
                                            byid   = T,
                                            width  = 0.01)                        # CRS in meters > buffer width == 0.01m
        deter.clouds.month.half2 <- gBuffer(spgeom = deter.clouds.month.half2,
                                            byid   = T,
                                            width  = 0.01)                        # CRS in meters > buffer width == 0.01m

        # intersection
        deter.clouds.month <- IntersectPolygonsThatOverlap(arg.layer1 = deter.clouds.month.half1,
                                                           arg.layer2 = deter.clouds.month.half2)


        # environment cleanup
        rm(deter.clouds.month.half1, deter.clouds.month.half2)


      # observation type: ONE layer for given month
      } else {

        # layer input
        deter.clouds.month <- readOGR(dsn   = file.path("data/raw2clean/land_cover/deter_inpe/input", select.deter.year, folder.name),
                                      layer = layer.names)


        # CRS attribution [for shapefiles missing proj4string only; see documentation for details on CRS selection]
        if (select.deter.year > 2010) {
          if (is.na(proj4string(deter.clouds.month))) {
            proj4string(deter.clouds.month) <- CRSUnprojected(CRSunproj = "SAD69longlat_pre96BR")
          }
        } else {
          if (is.na(proj4string(deter.clouds.month))) {
            proj4string(deter.clouds.month) <- CRSUnprojected(CRSunproj = "SAD69longlat")
          }
        }


        # projection
        deter.clouds.month <- spTransform(deter.clouds.month, CRSobj = CRSProjected(CRSproj = "SAD69polyconic"))


        # topology fix [via bufferByLittle instead of cleangeo for consistency with procedure for months that have multiple layers]
        deter.clouds.month <- gBuffer(spgeom = deter.clouds.month,
                                      byid   = T,
                                      width  = 0.01)                              # CRS in meters > buffer width == 0.01m


        # polygon extraction
        deter.clouds.month <- as.SpatialPolygons.PolygonsList(Srl         = deter.clouds.month@polygons,
                                                              proj4string = deter.clouds.month@proj4string)
      }                                                                          # closes if/else condition referring to number of layers
    }                                                                            # closes if/else condition referring to existence of data


    # object identification
    assign(x     = paste("deter.clouds", cal.month, sep = "."),                  # assigns select month to object
           value = deter.clouds.month)


    # environment cleanup
    rm(deter.clouds.month)


    # iteration
    dir.input.folder.index = dir.input.folder.index + 1                          # loops folder index iterator
  }


  # annual compilation
  deter.clouds.year <- list("JAN" = deter.clouds.01,                             # combines monthly polygons into list
                            "FEB" = deter.clouds.02,
                            "MAR" = deter.clouds.03,
                            "APR" = deter.clouds.04,
                            "MAY" = deter.clouds.05,
                            "JUN" = deter.clouds.06,
                            "JUL" = deter.clouds.07,
                            "AUG" = deter.clouds.08,
                            "SEP" = deter.clouds.09,
                            "OCT" = deter.clouds.10,
                            "NOV" = deter.clouds.11,
                            "DEC" = deter.clouds.12)


  # polygon dissolve
  deter.clouds.year <- lapply(deter.clouds.year, gUnaryUnion)


  # topology fix
  deter.clouds.year <- lapply(deter.clouds.year, CondCleangeo)



  # EXPORT PREP
  aux.name <- paste("policy.la.deter.clouds", select.deter.year, "sp", sep = ".")      # needed for export
  assign(x     = aux.name,
         value = deter.clouds.year)



  # INTERMEDIARY EXPORT
  #save(list = aux.name,                                                          # list argument needed to export by ref to object name
       #file = file.path(FindPath("deter", output = T), paste0("policy_la_deter_clouds", select.deter.year, ".Rdata")))



  # ENVIRONMENT CLEANUP
  rm(deter.clouds.year, aux.name)
}                                                                                # closes year loop

save(policy.la.deter.clouds.2005.sp,
     policy.la.deter.clouds.2006.sp,
     policy.la.deter.clouds.2007.sp,
     policy.la.deter.clouds.2008.sp,
     policy.la.deter.clouds.2009.sp,
     policy.la.deter.clouds.2010.sp,
     policy.la.deter.clouds.2011.sp,
     policy.la.deter.clouds.2012.sp,
     policy.la.deter.clouds.2013.sp,
     policy.la.deter.clouds.2014.sp,
     policy.la.deter.clouds.2015.sp,
     policy.la.deter.clouds.2016.sp,
     file = file.path("data/raw2clean/land_cover/deter_inpe/output", "deter_clouds_sp.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------