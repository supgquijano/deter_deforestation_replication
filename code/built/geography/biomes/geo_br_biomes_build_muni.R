
# > PROJECT INFO
# NAME: CENTRAL DATA REPOSITORY CONSTRUCTION - BRAZILIAN BIOMES
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: BUILD SPATIAL MUNICIPALITY-LEVEL ADMINISTRATIVE DIVISIONS FOR BRAZILIAN BIOMES
# AUTHOR: CLARISSA GANDOUR
#
# > EDIT DETAILS
# BY: CLARISSA GANDOUR
# ON: SEP/26/2021
#
# > NOTES
# 1: -





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------


# SOURCES
source("code/_functions/setup.R")
source(file.path("code/_functions/gis_geoprocessing.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# CLEAN DATA
# spatial Brazilian biomes
load(file = file.path("data/raw2clean/geography/biomes_ibge/output", "geo_br_biomes_spdf.Rdata"))

# spatial Brazilian municipalities
load(file = file.path("data/raw2clean/administrative/territorial_ibge/brazil/output/2007", "admin_br_territory_muni_2007_spdf.Rdata"))





# VARIABLE CONSTRUCTION ------------------------------------------------------------------------------------------------------------------------------

# MUNICIPALITIES BY BIOME [SPATIAL]
# spatial overlay
geo.br.biomes.muni.spdf <- raster::intersect(x = admin.br.muni.2007.spdf,
                                             y = geo.br.biomes.spdf)


# geometry check
geo.br.biomes.muni.spdf <- CondCleangeo(geo.br.biomes.muni.spdf)


# selection & order
colnames(geo.br.biomes.muni.spdf@data)


geo.br.biomes.muni.spdf@data <- geo.br.biomes.muni.spdf@data[, c("biome_name",
                                                                 "muni_code",
                                                                 "state_uf",
                                                                 "region_macro_name",
                                                                 "region_micro_code",
                                                                 "muni_area")]



# MUNICIPALITIES BY BIOME [INDICATOR]
# data selection
geo.br.biomes.munilevel.flags <- geo.br.biomes.muni.spdf@data

colnames(geo.br.biomes.munilevel.flags)

geo.br.biomes.munilevel.flags <- geo.br.biomes.munilevel.flags[, c("biome_name", "muni_code")]

# indicator construction
geo.br.biomes.munilevel.flags$d_biome_amazon         <- 0
geo.br.biomes.munilevel.flags$d_biome_caatinga       <- 0
geo.br.biomes.munilevel.flags$d_biome_cerrado        <- 0
geo.br.biomes.munilevel.flags$d_biome_pampa          <- 0
geo.br.biomes.munilevel.flags$d_biome_pantanal       <- 0
geo.br.biomes.munilevel.flags$d_biome_atlanticforest <- 0

geo.br.biomes.munilevel.flags$d_biome_amazon[geo.br.biomes.munilevel.flags$biome_name         == "Amazon"]          <- 1
geo.br.biomes.munilevel.flags$d_biome_caatinga[geo.br.biomes.munilevel.flags$biome_name       == "Caatinga"]        <- 1
geo.br.biomes.munilevel.flags$d_biome_cerrado[geo.br.biomes.munilevel.flags$biome_name        == "Cerrado"]         <- 1
geo.br.biomes.munilevel.flags$d_biome_pampa[geo.br.biomes.munilevel.flags$biome_name          == "Pampa"]           <- 1
geo.br.biomes.munilevel.flags$d_biome_pantanal[geo.br.biomes.munilevel.flags$biome_name       == "Pantanal"]        <- 1
geo.br.biomes.munilevel.flags$d_biome_atlanticforest[geo.br.biomes.munilevel.flags$biome_name == "Atlantic Forest"] <- 1

# build unique muni entry
colnames(geo.br.biomes.munilevel.flags)

geo.br.biomes.munilevel.flags <- geo.br.biomes.munilevel.flags[, !c("biome_name")]

geo.br.biomes.munilevel.flags <- within(geo.br.biomes.munilevel.flags,
                                        {d_biome_amazon         = ave(geo.br.biomes.munilevel.flags[[2]], muni_code, FUN = sum)})
geo.br.biomes.munilevel.flags <- within(geo.br.biomes.munilevel.flags,
                                        {d_biome_caatinga       = ave(geo.br.biomes.munilevel.flags[[3]], muni_code, FUN = sum)})
geo.br.biomes.munilevel.flags <- within(geo.br.biomes.munilevel.flags,
                                        {d_biome_cerrado        = ave(geo.br.biomes.munilevel.flags[[4]], muni_code, FUN = sum)})
geo.br.biomes.munilevel.flags <- within(geo.br.biomes.munilevel.flags,
                                        {d_biome_pampa          = ave(geo.br.biomes.munilevel.flags[[5]], muni_code, FUN = sum)})
geo.br.biomes.munilevel.flags <- within(geo.br.biomes.munilevel.flags,
                                        {d_biome_pantanal       = ave(geo.br.biomes.munilevel.flags[[6]], muni_code, FUN = sum)})
geo.br.biomes.munilevel.flags <- within(geo.br.biomes.munilevel.flags,
                                        {d_biome_atlanticforest = ave(geo.br.biomes.munilevel.flags[[7]], muni_code, FUN = sum)})

geo.br.biomes.munilevel.flags <- geo.br.biomes.munilevel.flags[!duplicated(geo.br.biomes.munilevel.flags$muni_code), ]





# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# LABELS
label(geo.br.biomes.munilevel.flags$d_biome_amazon)         <- "d=1 if muni (at least partially) in Amazon biome"
label(geo.br.biomes.munilevel.flags$d_biome_caatinga)       <- "d=1 if muni (at least partially) in Caatinga biome"
label(geo.br.biomes.munilevel.flags$d_biome_cerrado)        <- "d=1 if muni (at least partially) in Cerrado biome"
label(geo.br.biomes.munilevel.flags$d_biome_pampa)          <- "d=1 if muni (at least partially) in Pampa biome"
label(geo.br.biomes.munilevel.flags$d_biome_pantanal)       <- "d=1 if muni (at least partially) in Pantanal biome"
label(geo.br.biomes.munilevel.flags$d_biome_atlanticforest) <- "d=1 if muni (at least partially) in Atlantic Forest biome"


# change object name for exportation
geo.br.biomes.munilevel.flags.spdf <- geo.br.biomes.munilevel.flags



# POST-TREATMENT OVERVIEW
# summary(geo.br.biomes.muni.spdf)
# View(geo.br.biomes.muni.spdf@data)
# plot(geo.br.biomes.muni.spdf)

# summary(geo.br.biomes.munilevel.flags)
# View(geo.br.biomes.munilevel.flags)





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(geo.br.biomes.muni.spdf,
     geo.br.biomes.munilevel.flags.spdf,
     file = file.path("data/built/geography/biomes", "geo_br_biomes_built_muni_spdf.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------