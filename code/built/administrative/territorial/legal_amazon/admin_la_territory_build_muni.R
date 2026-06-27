
# > PROJECT INFO
# NAME: CENTRAL DATA REPOSITORY CONSTRUCTION - BRAZILIAN LEGAL AMAZON ADMINISTRATIVE DIVISIONS
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: BUILD SPATIAL MUNICIPALITY-LEVEL ADMINISTRATIVE DIVISIONS FOR LEGAL AMAZON
# AUTHOR: CLARISSA GANDOUR
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/21/2020
#
# > NOTES
# 1: -





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------


# SOURCES
source("code/_functions/setup.R")
source(file.path("code/_functions/gis_crs.R"))
source(file.path("code/_functions/gis_geoprocessing.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# CLEAN DATA
# spatial Brazilian Legal Amazon
load(file = file.path("data/raw2clean/administrative/territorial_ibge/legal_amazon/output", "admin_la_territory_sp.Rdata"))


# spatial Brazilian municipalities
list.files(path     = "data/raw2clean/administrative/territorial_ibge/brazil/output/2007")
load(file = file.path("data/raw2clean/administrative/territorial_ibge/brazil/output/2007", "admin_br_territory_muni_2007_spdf.Rdata"))





# VARIABLE CONSTRUCTION ------------------------------------------------------------------------------------------------------------------------------

# LEGAL AMAZON MUNICIPALITIES
# build
admin.la.muni.spdf <- raster::intersect(x = admin.br.muni.2007.spdf,
                                      y = admin.la.sp)


# error check: non-LA municipalities
summary(admin.la.muni.spdf@data$state_uf)  # suggests contamination by neighboring munis during intersect

admin.la.muni.spdf <- admin.la.muni.spdf[admin.la.muni.spdf@data$state_uf == "AC" |   # subsets to known LA states
                                         admin.la.muni.spdf@data$state_uf == "AM" |
                                         admin.la.muni.spdf@data$state_uf == "AP" |
                                         admin.la.muni.spdf@data$state_uf == "MA" |
                                         admin.la.muni.spdf@data$state_uf == "MT" |
                                         admin.la.muni.spdf@data$state_uf == "PA" |
                                         admin.la.muni.spdf@data$state_uf == "RO" |
                                         admin.la.muni.spdf@data$state_uf == "RR" |
                                         admin.la.muni.spdf@data$state_uf == "TO", ]



# GEOMETRY CLEANUP
admin.la.muni.spdf <- CondCleangeo(admin.la.muni.spdf)





# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# LABELS
# all imported from muni - no edits needed


# extracts data.frame from spdf and converts it to data.table
admin.la.muni.df <- setDT(admin.la.muni.spdf@data)



# POST-TREATMENT OVERVIEW
# summary(admin.la.muni.spdf)
# View(admin.la.muni.spdf@data)
# plot(admin.la.muni.spdf)
# aux.crop <- drawExtent()  # comparison with hand-drawn 'extent(aux.crop)' indicates extent of sp object not wasteful





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(admin.la.muni.spdf,
     file = file.path("data/built/administrative/territorial/legal_amazon", "admin_la_territory_built_muni_spdf.Rdata"))



# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------