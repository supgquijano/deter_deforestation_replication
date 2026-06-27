
# > PROJECT INFO
# NAME: CENTRAL DATA REPOSITORY CONSTRUCTION - BRAZILIAN ADMINISTRATIVE DIVISIONS
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT RAW DATA [MUNICIPALITIES]
# AUTHOR: CLARISSA GANDOUR
#
# > EDIT DETAILS
# BY: CLARISSA GANDOUR
# ON: SEP/18/2021
#
# > NOTES
# 1: -





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions/setup.R"))
source(file.path("code/_functions/gis_crs.R"))
source(file.path("code/_functions/gis_geoprocessing.R"))
source(file.path("code/_functions/missing.R"))
source(file.path("code/_functions/string.R"))
source(file.path("code/_functions/unit_conversion.R"))



# LIBRARIES
# called in the setup.R script




# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# RAW DATA
# BRAZILIAN MUNICIPALITIES
# files: shapefile (original layer name '55mu2500gsd')
# content: municipal perimeter (polygons data frame); Brazil (extent); 2007 (year of reference)
# source: Brazilian Institute for Geography and Statistics (IBGE)
# available at: 
#  ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2007/escala_2500mil/proj_policonica_sad69/brasil/
# raw data downloaded on: MAR/29/2017
# web archived at: https://web.archive.org/web/20200908153308/ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2007/escala_2500mil/proj_policonica_sad69/brasil/55mu2500psd.zip
# raw data archived on: SEP/08/2020
# CRS: LongLat (coordinate system); SAD69 (datum) with UGGI 67 (ellipsoid); not projected
# obs:
# We have identified that IBGE documents data for two bodies of water in RS
# with the following muni codes: 4300001 & 4300002.

list.files(path = "data/raw2clean/administrative/territorial_ibge/brazil/input/2007")
admin.br.muni.2007 <- readOGR(dsn   = "data/raw2clean/administrative/territorial_ibge/brazil/input/2007",
                              layer = "55mu2500gsd")



# DATA EXPLORATION [disabled for speed]
# summary(admin.br.muni.2007)    # yields unprojected SAD69longlat as documented; details from proj4string specification: post-96, not BR-specific
# View(admin.br.muni.2007@data)
# plot(admin.br.muni.2007)





# DATASET CLEANUP AND PREP ---------------------------------------------------------------------------------------------------------------------------

# PROJECTION
admin.br.muni.2007 <- spTransform(x      = admin.br.muni.2007,
                                  CRSobj = CRS(CRSProjected(CRSproj = "SAD69polyconic")))  # project onto SAD69polyconic (in m)



# COLUMN CLEANUP
# names
colnames(admin.br.muni.2007@data)


# non-special character treatment [NOTE: section might be sensitive to R console encoding]
names(admin.br.muni.2007@data)[which(names(admin.br.muni.2007@data) == "GEOCODIG_M")] <- "muni_code"
names(admin.br.muni.2007@data)[which(names(admin.br.muni.2007@data) == "UF")]         <- "state_code"
names(admin.br.muni.2007@data)[which(names(admin.br.muni.2007@data) == "Sigla")]      <- "state_uf"
names(admin.br.muni.2007@data)[which(names(admin.br.muni.2007@data) == "Nome_Munic")] <- "muni_name"
names(admin.br.muni.2007@data)[which(names(admin.br.muni.2007@data) == "Região")]     <- "region_macro_name"
names(admin.br.muni.2007@data)[which(names(admin.br.muni.2007@data) == "Mesorregiã")] <- "region_meso_code"
names(admin.br.muni.2007@data)[which(names(admin.br.muni.2007@data) == "Nome_Meso")]  <- "region_meso_name"
names(admin.br.muni.2007@data)[which(names(admin.br.muni.2007@data) == "Microrregi")] <- "region_micro_code"
names(admin.br.muni.2007@data)[which(names(admin.br.muni.2007@data) == "Nome_Micro")] <- "region_micro_name"


# class
lapply(admin.br.muni.2007@data, class)

aux.col.numeric   <- c("muni_code")  # uses as.numeric(as.character(.)) to transform factor to its original numeric values (as.numeric applied to    >
aux.col.character <- c("muni_name")  # factor does not recover factor levels)

admin.br.muni.2007@data[, c(aux.col.numeric, aux.col.character)] <- lapply(X   = admin.br.muni.2007@data[, c(aux.col.numeric, aux.col.character)],
                                                                           FUN = as.character)
admin.br.muni.2007@data[,   aux.col.numeric]                     <- as.integer(admin.br.muni.2007@data[, aux.col.numeric])


# variable selection & order
admin.br.muni.2007@data <- admin.br.muni.2007@data[c("muni_code",
                                                     "muni_name",
                                                     "state_code",
                                                     "state_uf",
                                                     "region_macro_name",
                                                     "region_meso_code",
                                                     "region_meso_name",
                                                     "region_micro_code",
                                                     "region_micro_name")]



# LATIN CHARACTER TREATMENT
admin.br.muni.2007 <- LatinCharacterConversionSp(x        = admin.br.muni.2007,
                                                 FROM_enc = "UTF-8",
                                                 TO_enc   = "ASCII//TRANSLIT")



# LETTERS CAPITALIZATION
admin.br.muni.2007@data$muni_name <- toupper(admin.br.muni.2007@data$muni_name)



# MISSING TREATMENT
admin.br.muni.2007@data[!complete.cases(admin.br.muni.2007@data), ]  # displays NA rows -- both occurences are bodies of water in Rio Grande do Sul
                                                                     # code for visualization commented below

# plot(admin.br.muni.2007[which(admin.br.muni.2007@data$state_code == 43), ])
# plot(admin.br.muni.2007[which(admin.br.muni.2007@data$muni_code == 4300001), ], add = T, col = "blue")
# plot(admin.br.muni.2007[which(admin.br.muni.2007@data$muni_code == 4300002), ], add = T, col = "blue")

admin.br.muni.2007 <- MissingExcludeSp(admin.br.muni.2007, margin = 1)  # excludes lines with NAs



# GEOMETRY CLEANUP
admin.br.muni.2007 <- CondCleangeo(admin.br.muni.2007)





# VARIABLE CONSTRUCTION ------------------------------------------------------------------------------------------------------------------------------

# MUNICIPAL AREA
admin.br.muni.2007@data$muni_area <- (gArea(admin.br.muni.2007, byid = T) * convert.sqm.to.ha)   # calculates polygon areas in ha



# MUNICIPAL CENTROID
aux.muni.centroids      <- gCentroid(admin.br.muni.2007, byid = T)  # calculates polygon centroids (in projected coordinates, NOT latlong)
admin.br.muni.2007@data <- cbind(admin.br.muni.2007@data,
                                 aux.muni.centroids@coords)

colnames(admin.br.muni.2007@data)
names(admin.br.muni.2007@data)[which(names(admin.br.muni.2007@data) == "x")] <- "muni_centroid_coordx"
names(admin.br.muni.2007@data)[which(names(admin.br.muni.2007@data) == "y")] <- "muni_centroid_coordy"





# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# LABELS
label(admin.br.muni.2007@data$muni_code)            <- "municipality code (7-digit, IBGE)"
label(admin.br.muni.2007@data$muni_name)            <- "municipality name"
label(admin.br.muni.2007@data$state_code)           <- "state code (IBGE)"
label(admin.br.muni.2007@data$state_uf)             <- "state name (abbreviation)"
label(admin.br.muni.2007@data$region_macro_name)    <- "macroregion name"
label(admin.br.muni.2007@data$region_meso_code)     <- "mesoregion code (IBGE)"
label(admin.br.muni.2007@data$region_meso_name)     <- "mesoregion name"
label(admin.br.muni.2007@data$region_micro_code)    <- "microregion code (IBGE)"
label(admin.br.muni.2007@data$region_micro_name)    <- "microregion name"
label(admin.br.muni.2007@data$muni_area)            <- "municipal area (ha, calc from sp data under SAD69polyconic)"
label(admin.br.muni.2007@data$muni_centroid_coordx) <- "municipal centroid, x-coordinate under SAD69polyconic"
label(admin.br.muni.2007@data$muni_centroid_coordy) <- "municipal centroid, y-coordinate under SAD69polyconic"

# extracts the data.frame and transforms it to data.table
admin.br.muni.2007.df <- setDT(admin.br.muni.2007@data)

# change object name for exportation
admin.br.muni.2007.spdf <- admin.br.muni.2007


# POST-TREATMENT OVERVIEW
# summary(admin.br.muni.2007)
# View(admin.br.muni.2007@data)
# plot(admin.br.muni.2007)
# aux.crop <- drawExtent()  # comparison with hand-drawn 'extent(aux.crop)' indicates extent of sp object not wasteful





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(admin.br.muni.2007.spdf,
     file = file.path("data/raw2clean/administrative/territorial_ibge/brazil/output/2007", "admin_br_territory_muni_2007_spdf.Rdata"))


save(admin.br.muni.2007.df,
     file = file.path("data/raw2clean/administrative/territorial_ibge/brazil/output/2007", "admin_br_territory_muni_2007_df.Rdata"))




# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------