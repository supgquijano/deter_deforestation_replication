
# > PROJECT INFO
# NAME: PROJECT DETERRING DEFORESTATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: CREATE SAMPLE MONTHLY PANEL
# AUTHOR: JOAO VEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/22/2020
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
month <- c(1:12)

series.sample.monthly <- 
  expand.grid(month, year) %>%
  unite("time") 

series.sample.monthly <-
  expand.grid(series.sample.monthly$time, sample.amazon$muni_code) %>% 
  tidyr::separate("Var1", c("month", "year")) %>% 
  dplyr::rename(muni_code = "Var2") %>% 
  mutate_all(.funs = as.numeric) %>% 
  mutate(year_prodes = if_else(month < 8, year, year + 1)) %>%  # create year prodes column  
  arrange(muni_code, year, month)


# recover muni info from sample.amazon
series.sample.monthly <- merge(series.sample.monthly, sample.amazon, by = "muni_code")  

# keep only the columns of interest and change final object name
series.sample.monthly.df <- series.sample.monthly[, c("muni_code", "month", "year", "year_prodes", "muni_area")]





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.sample.monthly.df, file = file.path("data/projectSpecific", "series_sample_monthly_df.Rdata"))



# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------