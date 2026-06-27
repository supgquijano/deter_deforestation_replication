
# > PROJECT INFO
# NAME: CENTRAL DATA REPOSITORY CONSTRUCTION - BRAZILIAN BIOMES
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT RAW DATA
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
source(file.path("code/_functions/unit_conversion.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# METADATA
#
# BRAZILIAN BIOMES
# files: shapefile (original layer name 'bioma')
# content: biome perimeter (polygons data frame); Brazil (extent); not dated
# source: Brazilian Ministry of the Environment (MMA) and Brazilian Institute for Geography and Statistics (IBGE)
# available at: http://mapas.mma.gov.br/i3geo/datadownload.htm
# raw data downloaded on: JAN/26/2016
# web archived at: not able to archive any of the download links
# CRS: undocumented & missing proj4string - *likely* LongLat (coordinate system), SAD69 (datum), not projected
# INSTRUCTIONS FOR DOWNLOAD
# Use the following links to download the shp, shx and dbf files that compose the shapefile and save them together in the input folder
# 1) shp - http://mapas.mma.gov.br/ms_tmp/bioma.shp
# 2) shx - http://mapas.mma.gov.br/ms_tmp/bioma.shx
# 3) dbf - http://mapas.mma.gov.br/ms_tmp/bioma.dbf




# SHAPEFILE INPUT
geo.br.biomes <- readOGR(dsn   = "data/raw2clean/geography/biomes_ibge/input",
                         layer = "bioma")



# DATA EXPLORATION [disabled for speed]
# summary(geo.br.biomes)    # yields missing proj4string - coordinates suggest LongLat (unprojected)
# View(geo.br.biomes@data)
# plot(geo.br.biomes)





# DATASET CLEANUP AND PREP ---------------------------------------------------------------------------------------------------------------------------

# CRS ATTRIBUTION
proj4string(geo.br.biomes) <- CRSUnprojected("SAD69longlat")  # assigns SAD69 LongLat as (assumed) CRS attribute - assumption based on commonly used >
                                                              # CRS for Brazilian georeferenced data from MMA


# PROJECTION
geo.br.biomes <- spTransform(x      = geo.br.biomes,
                             CRSobj = CRS(CRSProjected("SAD69polyconic")))  # projects onto SAD69 Polyconic in meters



# COLUMN CLEANUP
# names
colnames(geo.br.biomes@data)
colnames(geo.br.biomes@data)[which(colnames(geo.br.biomes@data) == "CD_LEGEN1")] <- "biome_name"


# variable selection
geo.br.biomes@data <- geo.br.biomes@data[c("biome_name")]


# class
lapply(geo.br.biomes@data, class)
geo.br.biomes@data$biome_name <- as.character(geo.br.biomes@data$biome_name)



# TRANSLATION
# 'grepl' used to avoid encoding trouble with latin characters
geo.br.biomes@data$biome_name[which(grepl(pattern = "AMAZ",     x = geo.br.biomes@data$biome_name))] <- "Amazon"
geo.br.biomes@data$biome_name[which(grepl(pattern = "CAATINGA", x = geo.br.biomes@data$biome_name))] <- "Caatinga"
geo.br.biomes@data$biome_name[which(grepl(pattern = "CERRADO",  x = geo.br.biomes@data$biome_name))] <- "Cerrado"
geo.br.biomes@data$biome_name[which(grepl(pattern = "PAMPA",    x = geo.br.biomes@data$biome_name))] <- "Pampa"
geo.br.biomes@data$biome_name[which(grepl(pattern = "PANTANAL", x = geo.br.biomes@data$biome_name))] <- "Pantanal"
geo.br.biomes@data$biome_name[which(grepl(pattern = "MATA",     x = geo.br.biomes@data$biome_name))] <- "Atlantic Forest"



# GEOMETRY CLEANUP [via 'cleangeo' package]
geo.br.biomes <- CondCleangeo(layer = geo.br.biomes)





# VARIABLE CONSTRUCTION ------------------------------------------------------------------------------------------------------------------------------

# BIOME AREA
aux.biome.area     <- gArea(spgeom = geo.br.biomes,  # calculates polygon areas in sq m (from proj4string definition)
                            byid   = T)
geo.br.biomes@data <- cbind(geo.br.biomes@data,
                            aux.biome.area)

colnames(geo.br.biomes@data)[which(names(geo.br.biomes@data) == "aux.biome.area")] <- "biome_area"

geo.br.biomes@data$biome_area <- geo.br.biomes@data$biome_area * convert.sqm.to.ha  # converts from sq m to ha





# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# LABELS
label(geo.br.biomes@data$biome_name) <- "biome name"
label(geo.br.biomes@data$biome_area) <- "biome area (ha, calc from sp data)"


# change object name for exportation
geo.br.biomes.spdf <- geo.br.biomes



# POST-TREATMENT OVERVIEW
# summary(geo.br.biomes)
# View(geo.br.biomes@data)
# plot(geo.br.biomes)





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(geo.br.biomes.spdf,
     file = file.path("data/raw2clean/geography/biomes_ibge/output", "geo_br_biomes_spdf.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------