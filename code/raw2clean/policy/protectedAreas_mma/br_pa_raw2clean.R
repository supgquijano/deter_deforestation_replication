
# > PROJECT INFO
# NAME: DATABASE CONSTRUCTION - BRAZILIAN PROTECTED AREAS
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT RAW SHAPEFILE
# AUTHOR: PEDRO PEIXOTO
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/17/2020
#
# > NOTES
# 1: -





# SETUP ---------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions/setup.R"))
source(file.path("code/_functions", "gis_crs.R"))
source(file.path("code/_functions", "gis_read_write.R"))
source(file.path("code/_functions", "string.R"))
source(file.path("code/_functions", "gis_geoprocessing.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT ----------------------------------------------------------------------------------------------------------------------------------------

# METADATA
#
# BRAZILIAN PROTECTED AREAS
# content: protected areas ["unidades de conservacao"] (polygons data frame), Brazil (extent), 2012 (year of reference)
# source: Brazilian National Registry for Conservation Units (CNUC), Brazilian Ministry of the Environment (MMA)
# available at: http://mapas.mma.gov.br/i3geo/datadownload.htm#
# raw data downloaded on: MAR/11/2016
# web archived at: not able to archive any of the download links
# CRS: undocumented & missing proj4string - *likely* LongLat (coordinate system), SAD69 (datum), not projected
# INSTRUCTIONS FOR DOWNLOAD
# Use the following links to download the shp, shx and dbf files that compose the shapefile and save them together in the input folder
# 1) shp - http://mapas.mma.gov.br/ms_tmp/ucstodas.shp
# 2) shx - http://mapas.mma.gov.br/ms_tmp/ucstodas.shx
# 3) dbf - http://mapas.mma.gov.br/ms_tmp/ucstodas.dbf


# SHAPEFILE INPUT
protected.areas <- ReadShape("data/raw2clean/policy/protectedAreas_mma/input")

# AUXILIARY DATA INPUT
# Legal Amazon
load(file = file.path("data/raw2clean/administrative/territorial_ibge/legal_amazon/output", "admin_la_territory_sp.Rdata"))



# DATA EXPLORATION - disabled for speed
# summary(protected.areas)
# View(protected.areas@data)
# plot(protected.areas)





# DATASET CLEANUP AND PREP --------------------------------------------------------------------------------------------------------------------------

# CRS ATTRIBUTION
proj4string(protected.areas) <- CRSUnprojected("SAD69longlat_BR")  # assigns SAD69 LongLat as CRS attribute



# PROJECTION
protected.areas <- spTransform(x = protected.areas, CRSobj = CRS(CRSProjected("SAD69polyconic")))  # projects onto SAD69 Polyconic



# MISSING
protected.areas@data[which(is.na(protected.areas@data$GRUPO4)), ]  # ids observations with missing types (currently 'GRUPO4')

protected.areas@data$GRUPO4[636]  = "PI"  # see data documentation for legislation supporting data input
protected.areas@data$GRUPO4[1343] = "US"  # see data documentation for legislation supporting data input



# COLUMN CLEANUP
colnames(protected.areas@data)  # reports column names; ID_WCMC is protected area id at World Database on Protected Areas (WDPA)


# renames columns considering 10-character shapefile column name limitation (? not needed, only relevant when saving output as .shp )
names(protected.areas@data)[which(names(protected.areas@data) == "ID_UC0")]    <- "PA_code"
names(protected.areas@data)[which(names(protected.areas@data) == "NOME_UC1")]  <- "PA_name"
names(protected.areas@data)[which(names(protected.areas@data) == "CATEGORI3")] <- "PA_category"
names(protected.areas@data)[which(names(protected.areas@data) == "GRUPO4")]    <- "PA_type"
names(protected.areas@data)[which(names(protected.areas@data) == "ESFERA5")]   <- "PA_jurisdiction"
names(protected.areas@data)[which(names(protected.areas@data) == "ANO_CRIA6")] <- "year_creation"
names(protected.areas@data)[which(names(protected.areas@data) == "QUALIDAD8")] <- "polygon_quality"
names(protected.areas@data)[which(names(protected.areas@data) == "ATO_LEGA9")] <- "legal_act"


# selects & orders columns
protected.areas@data <- protected.areas@data[c("PA_code",
                                               "PA_name",
                                               "PA_jurisdiction",
                                               "PA_type",
                                               "PA_category",
                                               "year_creation",
                                               "polygon_quality",
                                               "legal_act")]


# checks column classes
lapply(protected.areas@data, class)


# sets column classes
# uses as.numeric(as.character(f)) to transform factor to its original numeric values (as.numeric applied to factor does not recover factor levels)
col.character <- c("PA_code", "year_creation", "PA_name", "legal_act")
protected.areas@data[, col.character] <- lapply(protected.areas@data[, col.character], as.character)
col.integer <- c("PA_code", "year_creation")
protected.areas@data[, col.integer] <- lapply(protected.areas@data[, col.integer], as.integer)

# NAs induced by coercion due to non-integer content of year_creation cells - inspection shows that these are two incorrectly recorded entries
protected.areas@data[is.na(protected.areas@data$year_creation), c("year_creation", "legal_act")]
protected.areas@data$year_creation[30]  = 1998  # inputs 'year_creation' date based on 'legal_act' date
protected.areas@data$year_creation[342] = 2013  # inputs 'year_creation' date based on 'legal_act' date



# LATIN CHARACTER TREATMENT
protected.areas <- LatinCharacterConversionSp(protected.areas, FROM_enc = "", TO_enc = "ASCII//TRANSLIT")



# TRANSLATION
# removes redundant explanation of 'polygon_quality' classification
protected.areas@data$polygon_quality <- sub(pattern = " \\(.*\\)\\.",         # redundancy stated between brackets
                                            replacement = "",
                                            protected.areas$polygon_quality)


# translates from PT to EN
protected.areas@data$PA_type         <- sub(pattern = "US", replacement = "SU", protected.areas@data$PA_type)  # sustainable use
protected.areas@data$PA_type         <- sub(pattern = "PI", replacement = "FP", protected.areas@data$PA_type)  # full protection

protected.areas@data$PA_jurisdiction <- sub(pattern = "estadual", replacement = "state", protected.areas@data$PA_jurisdiction)  # other categories
                                                                                                                                # identical in PT/EN

protected.areas@data$polygon_quality <- sub(pattern = "Aproximado",  replacement = "approximate", protected.areas@data$polygon_quality)
protected.areas@data$polygon_quality <- sub(pattern = "Correto",     replacement = "correct",     protected.areas@data$polygon_quality)
protected.areas@data$polygon_quality <- sub(pattern = "Esquematico", replacement = "schematic",   protected.areas@data$polygon_quality)


# sets class for factors that became characters during translation
col.factor <- c("PA_type", "PA_jurisdiction", "polygon_quality")
protected.areas@data[, col.factor] <- lapply(protected.areas@data[, col.factor], as.factor)





# VARIABLE CONSTRUCTION -----------------------------------------------------------------------------------------------------------------------------

# PRODES YEAR-BASED PROTECTION STATUS
# PRODES year t defined as period from AUG/01/t-1 through JUL/31/t

# extracts protection date from 'legal_act' info
year_creation.aux <- regmatches(protected.areas@data$legal_act,
                                regexpr(pattern = "[0-9]{2}/[0-9]{2}/[0-9]{4}", protected.areas@data$legal_act))  # yields character vector
year_creation.aux <- as.Date(year_creation.aux, format = "%d/%m/%Y")  # format refers to original data; output in 'yyyy-mm-dd' format


# calculates PRODES year of creation based on month of creation
year_prodes_protection <- as.numeric()
year_prodes_protection <- data.frame(year_prodes_protection)

for (i in 1:nrow(protected.areas@data)) {
  if (as.numeric(format(year_creation.aux[i], '%m')) <= 7) {
    year_prodes_protection[i, 1] <- as.numeric(format(year_creation.aux[i], '%Y'))
  } else {
    year_prodes_protection[i, 1] <- as.numeric(format(year_creation.aux[i], '%Y')) + 1
  }
}


# adds protection date vector to data frame
protected.areas@data <- cbind(protected.areas@data, year_prodes_protection)





# COLUMN CLEANUP
colnames(protected.areas@data)  # reports column names


# orders columns
protected.areas@data <- protected.areas@data[c("PA_code",
                                               "PA_name",
                                               "PA_jurisdiction",
                                               "PA_type",
                                               "PA_category",
                                               "year_creation",
                                               "year_prodes_protection",
                                               "polygon_quality",
                                               "legal_act")]



# GEOMETRY CLEANUP [via 'cleangeo' package]
# invalid geometry check
protected.areas <- CondCleangeo(protected.areas)



# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------


# change object name for exportation
policy.br.protected.territory.pa.spdf <- protected.areas



# layer separation by jurisdiction and type
policy.br.protected.territory.pa.fed.fp.spdf <- gBuffer(protected.areas[protected.areas$PA_jurisdiction == "federal"   & protected.areas$PA_type == "FP", ], 
                                                 byid = T, width = 0)
policy.br.protected.territory.pa.fed.su.spdf <- gBuffer(protected.areas[protected.areas$PA_jurisdiction == "federal"   & protected.areas$PA_type == "SU", ], 
                                                 byid = T, width = 0)
policy.br.protected.territory.pa.sta.fp.spdf <- gBuffer(protected.areas[protected.areas$PA_jurisdiction == "state"     & protected.areas$PA_type == "FP", ], 
                                                 byid = T, width = 0)
policy.br.protected.territory.pa.sta.su.spdf <- gBuffer(protected.areas[protected.areas$PA_jurisdiction == "state"     & protected.areas$PA_type == "SU", ], 
                                                 byid = T, width = 0)
policy.br.protected.territory.pa.mun.fp.spdf <- gBuffer(protected.areas[protected.areas$PA_jurisdiction == "municipal" & protected.areas$PA_type == "FP", ], 
                                                 byid = T, width = 0)
policy.br.protected.territory.pa.mun.su.spdf <- gBuffer(protected.areas[protected.areas$PA_jurisdiction == "municipal" & protected.areas$PA_type == "SU", ], 
                                                 byid = T, width = 0)



# POST-TREATMENT OVERVIEW  
# summary(protected.areas)    # no indication of fully missing row
# View(protected.areas@data)
# plot(protected.areas)





# EXPORT --------------------------------------------------------------------------------------------------------------------------------------------

# workspace export
save(policy.br.protected.territory.pa.spdf,
     policy.br.protected.territory.pa.fed.fp.spdf,
     policy.br.protected.territory.pa.fed.su.spdf,
     policy.br.protected.territory.pa.sta.fp.spdf,
     policy.br.protected.territory.pa.sta.su.spdf,
     policy.br.protected.territory.pa.mun.fp.spdf,
     policy.br.protected.territory.pa.mun.su.spdf,
     file = file.path("data/raw2clean/policy/protectedAreas_mma/output", "policy_br_protected_territory_pa_spdf.RData"))





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------