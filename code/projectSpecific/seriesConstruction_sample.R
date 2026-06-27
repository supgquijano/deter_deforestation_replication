
# > PROJECT INFO
# NAME: PROJECT DETERRING DEFORESTATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: CREATE SAMPLE
# AUTHOR: JOAO VEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/21/2020
#
# > NOTES
# -





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions", "setup.R"))
source(file.path("code/_functions", "unit_conversion.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# load biome limit shape
load(file.path("data/built/geography/biomes", "geo_br_biomes_built_muni_spdf.Rdata"))




# SAMPLE DEFINITION  ---------------------------------------------------------------------------------------------------------------------------------------

# PANEL DEFINITION 

# dplyr::selects the biome of interest
crossSection.sample.spdf <- geo.br.biomes.muni.spdf[geo.br.biomes.muni.spdf@data$biome_name == "Amazon",]

# extracts the data from the spdf and convert it to data.frame
sample.amazon <- base::as.data.frame(crossSection.sample.spdf@data)

# time frame
year <- c(2001:2016)

# dimensions for panel construction
muni.code <- rep(sample.amazon$muni_code,
                 each = length(year))
year      <- rep(year,
                 length(unique(sample.amazon$muni_code)))

# creates panel
series.sample <- data.frame(muni_code = muni.code, year)

# recover muni info from sample.amazon
series.sample <- merge(series.sample, sample.amazon, by = "muni_code")  

# keep only the columns of interest and change final object name
series.sample.df <- series.sample[, c("muni_code", "year", "muni_area")]
crossSection.sample.spdf <- crossSection.sample.spdf[, c("muni_code", "muni_area")]





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.sample.df, file = file.path("data/projectSpecific", "series_sample_df.Rdata"))

save(crossSection.sample.spdf, file = file.path("data/projectSpecific", "crossSection_sample_spdf.Rdata"))



# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------