
# > PROJECT INFO
# NAME: DATABASE CONSTRUCTION - BRAZILIAN INDIGENOUS LANDS
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT RAW SHAPEFILE
# AUTHOR: (ADAPTED FROM) PEDRO PEIXOTO
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/18/2020
#
# > NOTES






# SETUP ---------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions/setup.R"))
source(file.path("code/_functions/string.R"))
source(file.path("code/_functions/gis_crs.R"))
source(file.path("code/_functions/gis_geoprocessing.R"))
source(file.path("code/_functions/logical.R"))

source(file.path("code/raw2clean/policy/indigenousLands_funaiIsa", "functions_project_specific.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT ----------------------------------------------------------------------------------------------------------------------------------------

# METADATA
#
# BRAZILIAN INDIGENOUS LANDS
# file: 'ti_sirgas2000' shapefile package
# content: indigenous lands with active working groups or with remedied status (polygons data frame), Brazil (extent), historical through 2016 (year
#          of reference)
#          indigenous lands with no working groups assigned or pending proceedings (points data frame), Brazil (extent), historical through 2016
#          (year of reference)
# source: Brazilian National Native Foundation (FUNAI)
# available at: http://www.funai.gov.br/index.php/shape
# raw data downloaded on: MAR/18/2016
# archived at: https://web.archive.org/web/20200918122942/http://geoserver.funai.gov.br/geoserver/Funai/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=Funai%3Ati_sirgas&outputFormat=SHAPE-ZIP (this link was not available at the time of download)
# raw data archived on: SEP/18/2020
# CRS: LongLat(CRS - assumed, as metadata contains no CRS), SIRGAS2000 (datum), not projected



# SHAPEFILE INPUT
indigenous.lands <- readOGR(dsn = "data/raw2clean/policy/indigenousLands_funaiIsa/input", layer = "ti_sirgas2000")



# DATA EXPLORATION
# summary(indigenous.lands)      # yields missing proj4string; does not contain NAs in relevant categories
#View(indigenous.lands@data)  # disabled for speed
#plot(indigenous.lands)       # disabled for speed





# DATASET CLEANUP AND PREP --------------------------------------------------------------------------------------------------------------------------

# CRS ATTRIBUTION
proj4string(indigenous.lands) <- CRSUnprojected("SIRGAS2000longlat")  # assigns SIRGAS2000 LongLat as CRS attribute



# PROJECTION
indigenous.lands <- spTransform(x = indigenous.lands, CRSobj = CRS(CRSProjected("SAD69polyconic")))  # projects onto SAD69 Polyconic for consistency
                                                                                                     # with administrative shapefiles


# COLUMN CLEANUP
# column names
names(indigenous.lands@data)[names(indigenous.lands@data) == "gid"]        <- "id"
names(indigenous.lands@data)[names(indigenous.lands@data) == "terrai_cod"] <- "IL_code"
names(indigenous.lands@data)[names(indigenous.lands@data) == "terrai_nom"] <- "IL_name"
names(indigenous.lands@data)[names(indigenous.lands@data) == "etnia_nome"] <- "ethnicity"
names(indigenous.lands@data)[names(indigenous.lands@data) == "municipio_"] <- "muni_name"
names(indigenous.lands@data)[names(indigenous.lands@data) == "uf_sigla"]   <- "state_uf"
names(indigenous.lands@data)[names(indigenous.lands@data) == "superficie"] <- "surface"
names(indigenous.lands@data)[names(indigenous.lands@data) == "fase_ti"]    <- "demarcation_status"
names(indigenous.lands@data)[names(indigenous.lands@data) == "modalidade"] <- "IL_type"
names(indigenous.lands@data)[names(indigenous.lands@data) == "reestudo_t"] <- "under_reassessment"
names(indigenous.lands@data)[names(indigenous.lands@data) == "cr"]         <- "regional_coordination"


# column selection & order
indigenous.lands@data <- indigenous.lands@data[c("IL_code", "IL_name", "ethnicity", "muni_name", "state_uf", "demarcation_status",
                                                 "IL_type", "under_reassessment", "regional_coordination")]


# column classes
lapply(indigenous.lands@data, class)

indigenous.lands@data$IL_name <- as.character(indigenous.lands@data$IL_name)



# LATIN CHARACTER TREATMENT
indigenous.lands <- LatinCharacterConversionSp(indigenous.lands, FROM_enc = "", TO_enc = "ASCII//TRANSLIT")

# output check
(encoding.check <- grep(pattern = "?", x = indigenous.lands@data$ethnicity, fixed = T))  # character " ' " converts to "?"
indigenous.lands@data$ethnicity[encoding.check[1]]; indigenous.lands@data$ethnicity[encoding.check[2]]

indigenous.lands@data$ethnicity <- gsub(pattern = "?", replacement = "", x = indigenous.lands@data$ethnicity, fixed = T)



# TRANSLATION
# column content
summary(indigenous.lands)

indigenous.lands@data$demarcation_status <- StringTrim(indigenous.lands@data$demarcation_status)
indigenous.lands@data$IL_type            <- StringTrim(indigenous.lands@data$IL_type)
indigenous.lands@data$under_reassessment <- StringTrim(indigenous.lands@data$under_reassessment)

indigenous.lands@data$demarcation_status <- sub(pattern = "Em Estudo",    replacement = "under assessment", indigenous.lands@data$demarcation_status)
indigenous.lands@data$demarcation_status <- sub(pattern = "Delimitada",   replacement = "delimited",        indigenous.lands@data$demarcation_status)
indigenous.lands@data$demarcation_status <- sub(pattern = "Declarada",    replacement = "declared",         indigenous.lands@data$demarcation_status)
indigenous.lands@data$demarcation_status <- sub(pattern = "Homologada",   replacement = "approved",         indigenous.lands@data$demarcation_status)
indigenous.lands@data$demarcation_status <- sub(pattern = "Regularizada", replacement = "regularized",      indigenous.lands@data$demarcation_status)
indigenous.lands@data$demarcation_status <- sub(pattern = "Encaminhada RI",
                                                                          replacement = "submitted as indigenous reserve",
                                                                                                            indigenous.lands@data$demarcation_status)

indigenous.lands@data$IL_type <- sub(pattern = "Dominial Indigena" ,        replacement = "indigenous dominium",   indigenous.lands@data$IL_type)
indigenous.lands@data$IL_type <- sub(pattern = "Interditada" ,              replacement = "interdicted",           indigenous.lands@data$IL_type)
indigenous.lands@data$IL_type <- sub(pattern = "Reserva Indigena" ,         replacement = "indigenous reserve",    indigenous.lands@data$IL_type)
indigenous.lands@data$IL_type <- sub(pattern = "Tradicionalmente ocupada" , replacement = "traditionally occupied",indigenous.lands@data$IL_type)

indigenous.lands@data$under_reassessment <- sub(pattern = "Reestudo",  replacement = "yes", indigenous.lands@data$under_reassessment)

indigenous.lands@data$demarcation_status <- as.factor(indigenous.lands@data$demarcation_status)
indigenous.lands@data$IL_type            <- as.factor(indigenous.lands@data$IL_type)
indigenous.lands@data$under_reassessment <- as.factor(indigenous.lands@data$under_reassessment)



# GEOMETRY CLEANUP [via 'cleangeo' package]
# invalid geometry check
indigenous.lands <- CondCleangeo(indigenous.lands)





# POST-TREATMENT OVERVIEW  --------------------------------------------------------------------------------------------------------------------------

# summary(indigenous.lands)      # no indication of fully missing row
# View(indigenous.lands@data)  # disabled for speed
# plot(indigenous.lands)       # disabled for speed





# EXPORT --------------------------------------------------------------------------------------------------------------------------------------------

save(indigenous.lands, file = file.path("data/raw2clean/policy/indigenousLands_funaiIsa/output", "temp_br_il_georef.RData"))





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------