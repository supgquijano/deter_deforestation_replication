
# > PROJECT INFO
# NAME: DETERRING DEFORESTATION IN THE AMAZON: ENVIRONMENTAL MONITORING AND LAW ENFORCEMENTE - CODE AND DATA REPLICATION ARCHIVE
#
# > THIS SCRIPT
# AIM: CALCULATE SHARE OF TROPICAL FOREST AREA IN THE LEGAL AMAZON BUT OUTSIDE THE AMAZON BIOME
#
# > NOTES
# CODE GENERATES NO OUTPUT, ONLY REPORTS AN IN-TEXT NUMBER - PRINTED IN CONSOLE FOR REFERENCE



# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# LIBRARIES
source(file.path("./code/_functions", "setup.R"))





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# PRODES 
load("./data/raw2clean/land_cover/prodes_inpe/municipality_level/output/landcover_la_prodes_munilevel_df.Rdata")


# BIOMES
load("./data/built/geography/biomes/geo_br_biomes_built_muni_spdf.Rdata")


# LEGAL AMAZON
load("./data/raw2clean/administrative/territorial_ibge/legal_amazon/output/admin_la_territory_sp.Rdata")





# # DATA MANIPULATION  ---------------------------------------------------------------------------------------------------------------------------------

# # restrict biomes to the legal amazon area
geo.br.biomes.muni.spdf@data <- as.data.frame(geo.br.biomes.muni.spdf@data)
biomeMuni.laz                <- crop(geo.br.biomes.muni.spdf, admin.la.sp)

# remove municipalities in the Amazon biome
biomeMuni.laz.nonAmz <- biomeMuni.laz[biomeMuni.laz@data$biome_name != "Amazon", ]

# calculate total area of biomes outside the Amazon biome and inside the legal amazon
biomeArea.laz.nonAmz <- gArea(biomeMuni.laz.nonAmz)*0.00001 # convert to sq km

# select variable of interest from prodes (forest area 2004)
landcover.la.prodes.munilevel.wide.df <- landcover.la.prodes.munilevel.wide.df[, c("muni_code", "prodes_forest.2004")]

# remove munis from the Amazon biome
landcover.la.prodes.munilevel.wide.df <- landcover.la.prodes.munilevel.wide.df[landcover.la.prodes.munilevel.wide.df$muni_code %in% unique(biomeMuni.laz.nonAmz$muni_code), ]

# calculate total area of tropical forest of munis in biomes outside the Amazon
forestArea.laz.nonAmz <- sum(landcover.la.prodes.munilevel.wide.df$prodes_forest.2004)

# calculate percentage of forest area from the total area of biomes in the legal amazon outside the Amazon biome
stat.output <- (forestArea.laz.nonAmz/biomeArea.laz.nonAmz)*100
print(stat.output)




# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------