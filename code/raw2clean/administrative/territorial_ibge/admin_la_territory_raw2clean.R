
# > PROJECT INFO
# NAME: CENTRAL DATA REPOSITORY CONSTRUCTION - BRAZILIAN LEGAL AMAZON ADMINISTRATIVE DIVISIONS
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT RAW DATA [PERIMETER]
# AUTHOR: CLARISSA GANDOUR
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/17/2020
#
# > NOTES
# 1: -





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------


# SOURCES
source(file.path("code/_functions/setup.R"))
source(file.path("code/_functions/gis_crs.R"))
source(file.path("code/_functions/gis_geoprocessing.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# RAW DATA
# BRAZILIAN LEGAL AMAZON
# file: shapefile (original layer name 'AMAZONIA_LEGAL_LIMITE')
# content: Legal Amazon perimeter (polygons data frame), multi-state geopolitical division of Brazil (extent), not dated
# source: Brazilian Institute for the Environment and Renewable Natural Resources (IBAMA)
# available at: http://siscom.ibama.gov.br/shapes/ (not working anymore use archive) 
# raw data downloaded on: FEB/01/2013
# web archived at: https://web.archive.org/web/20120721033244/http://siscom.ibama.gov.br/shapes//AMAZONIA_LEGAL_LIMITE.zip
# raw data archived on: JUL/21/2012 (same version of the downloaded date)
# CRS: LongLat (coordinate system - from shapefile proj4string), SAD69 (datum), not projected
#
# obs: Legal Amazon municipalities obtained from municipality boundaries

admin.la.sp <- readOGR(dsn = "data/raw2clean/administrative/territorial_ibge/legal_amazon/input", layer = "AMAZONIA_LEGAL_LIMITE")



# DATA EXPLORATION [disabled for speed]
# summary(admin.la.sp)  # yields unprojected SAD69longlat as document; details from proj4string specification: post-96, not BR-specific
# View(admin.la.sp)     # empty data frame
# plot(admin.la.sp)





# DATASET CLEANUP AND PREP ---------------------------------------------------------------------------------------------------------------------------

# CLASS
admin.la.sp <- SpatialPolygons(Srl = as.list(admin.la.sp@polygons),         # as df is empty, converts to simpler SpatialPolygons
                            proj4string = CRS(proj4string(admin.la.sp)))



# PROJECTION
admin.la.sp <- spTransform(x      = admin.la.sp,
                        CRSobj = CRS(CRSProjected(CRSproj = "SAD69polyconic")))  # projects onto SAD69polyconic (in m)



# GEOMETRY CLEANUP
admin.la.sp <- CondCleangeo(admin.la.sp)





# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# POST-TREATMENT OVERVIEW
# summary(admin.la.sp)
# plot(admin.la.sp)
# aux.crop <- drawExtent()  # comparison with hand-drawn 'extent(aux.crop)' indicates extent of sp object not wasteful





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(admin.la.sp,
     file = file.path("data/raw2clean/administrative/territorial_ibge/legal_amazon/output", "admin_la_territory_sp.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------