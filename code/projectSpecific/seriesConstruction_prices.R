
# > PROJECT INFO
# NAME: PROJECT DETERRING DEFORESTATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: PRICES - VARIABLES CONSTRUCTION (PARANA AND WORLD BANK)
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

# AGRICULTURAL COMMODITY PRICES - PARANA
load(file.path("data/raw2clean/macro/commodities_seabpr/output", "macro_br_prices_commodities_df.Rdata"))

# AGRICULTURAL COMMODITY PRICES - WORLD (DEPRECATED)
#load(file.path("data/raw2clean/macro/commodities_worldbank/output", "macro_world_prices_commodities_df.Rdata"))
#rm(macro.world.prices.commodities.df)

# DEFLATOR (2000.01 = 100; BASED ON IPA-EP)
load(file.path("data/raw2clean/macro/deflator_fgv/output", "macro_br_prices_deflator_ipa_df.Rdata"))


# MUNICIPAL AGRICULTURAL PRODUCTION (PAM)
load(file.path("data/raw2clean/agriculture/pam_ibge/output", "ag_br_pam_5crops_df.Rdata"))


# MUNICIPAL LIVESTOCK SURVEY (PPM)
load(file.path("data/raw2clean/agriculture/ppm_ibge/output", "ag_br_ppm_livestock_all_df.Rdata"))


# BRAZILIAN MUNICIPALITIES
load(file.path("data/raw2clean/administrative/territorial_ibge/brazil/output/2007", "admin_br_territory_muni_2007_df.Rdata"))


# PANEL SAMPLE
load(file.path("data/projectSpecific", "series_sample_df.Rdata"))



# PRICES REAL -----------------------------------------------------------------------------------------------------------------------------------

# MEAN REAL PRICES - PARANA
prices.brazil.real <- 
  macro.br.prices.commodities.df %>% 
  left_join(macro.br.prices.deflator.ipa.df, by = c("year", "month")) %>% # merge prices and deflator
  mutate(price_r_rice      = (price_rice/deflator_2000_01) * (1000/50)) %>% # real price, unit standardization to 1t
  mutate(price_r_cassava   = price_cassava/deflator_2000_01) %>% # real price
  mutate(price_r_corn      = (price_corn/deflator_2000_01) * (1000/60)) %>% # real price, unit standardization to 1t
  mutate(price_r_soybean   = (price_soybean/deflator_2000_01) * (1000/60)) %>% # real price, unit standardization to 1t
  mutate(price_r_sugarcane = price_sugarcane/deflator_2000_01) %>% # real price
  mutate(price_r_cattle    = price_cattle/deflator_2000_01) %>% # real price
  dplyr::select(year, month, starts_with("price_r_")) %>% 
  mutate(semester = if_else(month <= 7, 1, 2)) %>% # create semester indicator
  dplyr::group_by(year, semester) %>% # defines the level of interest as year + semester
  dplyr::summarise(price_r_br_mean_sem_rice      = mean(price_r_rice, na.rm = T), # mean semester real price
            price_r_br_mean_sem_cassava   = mean(price_r_cassava, na.rm = T), 
            price_r_br_mean_sem_corn      = mean(price_r_corn, na.rm = T), 
            price_r_br_mean_sem_soybean   = mean(price_r_soybean, na.rm = T),
            price_r_br_mean_sem_sugarcane = mean(price_r_sugarcane, na.rm = T),
            price_r_br_mean_sem_cattle    = mean(price_r_cattle, na.rm = T)) %>% 
  dplyr::ungroup() %>% 
  dplyr::group_by(year) %>% 
  dplyr::mutate(price_r_br_mean_ann_cattle = mean(price_r_br_mean_sem_cattle, na.rm = T)) %>% # mean annual real price
  dplyr::mutate(price_r_br_mean_ann_sugarcane = mean(price_r_br_mean_sem_sugarcane, na.rm = T)) %>% 
  dplyr::mutate(price_r_br_mean_ann_corn = mean(price_r_br_mean_sem_corn, na.rm = T)) %>% 
  dplyr::mutate(price_r_br_mean_ann_soybean = mean(price_r_br_mean_sem_soybean, na.rm = T)) %>% 
  dplyr::mutate(price_r_br_mean_ann_cassava = mean(price_r_br_mean_sem_cassava, na.rm = T)) %>% 
  dplyr::mutate(price_r_br_mean_ann_rice = mean(price_r_br_mean_sem_rice, na.rm = T)) %>%   
  dplyr::ungroup() %>% 
  dplyr::select(year, semester, starts_with("price_r_br_mean")) %>% 
  unique() %>% 
  mutate(year = as.numeric(year))

# dplyr::select row with baseline info (year 2000 for first and second semesters)
aux.baseline.1 <- 
  prices.brazil.real %>% 
  filter(year == 2000, semester == 1)  
 
aux.baseline.2 <- 
  prices.brazil.real %>% 
  filter(year == 2000, semester == 2)  

# construct annual index prices (baseline 2000)
prices.brazil.real <-
  prices.brazil.real %>% 
  mutate(price_r_br_index_ann_cattle    = (price_r_br_mean_ann_cattle/aux.baseline.1$price_r_br_mean_ann_cattle) * 100) %>% 
  mutate(price_r_br_index_ann_sugarcane = (price_r_br_mean_ann_sugarcane/aux.baseline.1$price_r_br_mean_ann_sugarcane) * 100) %>% 
  mutate(price_r_br_index_ann_corn      = (price_r_br_mean_ann_corn/aux.baseline.1$price_r_br_mean_ann_corn) * 100) %>% 
  mutate(price_r_br_index_ann_soybean   = (price_r_br_mean_ann_soybean/aux.baseline.1$price_r_br_mean_ann_soybean) * 100) %>% 
  mutate(price_r_br_index_ann_cassava   = (price_r_br_mean_ann_cassava/aux.baseline.1$price_r_br_mean_ann_cassava) * 100) %>% 
  mutate(price_r_br_index_ann_rice      = (price_r_br_mean_ann_rice/aux.baseline.1$price_r_br_mean_ann_rice) * 100) %>% 
  dplyr::select(-starts_with("price_r_br_mean_ann"))
  
  
# MEAN REAL PRICES - WORLD BANK (DEPRECATED)
# prices.world.real <- 
#   panel.macro.world.prices.commodities.df %>% 
#   dplyr::rename(price_r_rice      = `Rice, Thailand, 5%, $/mt, real 2010$`) %>%  
#   dplyr::rename(price_r_corn      = `Maize, $/mt, real 2010$`) %>% 
#   dplyr::rename(price_r_soybean   = `Soybeans, $/mt, real 2010$`) %>% 
#   mutate(price_r_sugarcane = `Sugar, world, $/kg, real 2010$` * 1000) %>% # unit standardization to 1t
#   mutate(price_r_cattle    = `Meat, beef, $/kg, real 2010$` * 1000) %>% # unit standardization to 1t
#   mutate(year = as.numeric(as.character(year))) %>% 
#   dplyr::select(year, starts_with("price_r_")) 


# WEIGHTS --------------------------------------------------------------------------------------------------------------------------------------------

# column name fix to merge
ag.br.pam.5crops.df <- ag.br.pam.5crops.df %>%  dplyr::rename(muni_code = municipality_code) %>% mutate(muni_code = as.numeric(muni_code))
ag.br.ppm.livestock.all.df <- ag.br.ppm.livestock.all.df %>% mutate(muni_code = as.numeric(muni_code), year = as.numeric(year))

weights <-
  admin.br.muni.2007.df %>% 
  mutate(muni_code = as.numeric(muni_code)) %>% # change column class
  left_join(ag.br.pam.5crops.df, by = c("muni_code")) %>% # merge admin with pam
  mutate(year = as.numeric(year)) %>% # change column class
  left_join(ag.br.ppm.livestock.all.df, by = c("muni_code", "year")) %>% # merge with ppm
  replace(is.na(.), 0) %>% # replace all NAs with 0s
  mutate(weight_cassava = planted_area_cassava/muni_area) %>% # calculate the weights (share of muni_area destined to crop x)
  mutate(weight_corn = planted_area_corn/muni_area) %>% 
  mutate(weight_rice = planted_area_rice/muni_area) %>% 
  mutate(weight_soybean = planted_area_soybean/muni_area) %>% 
  mutate(weight_sugarcane = planted_area_sugarcane/muni_area) %>% 
  mutate(weight_cattle = livestock_head_bovine/muni_area) %>% # convert muni area from ha to sqkm
  filter(year %in% c(2004, 2005)) %>% # dplyr::select years of interest
  group_by(muni_code) %>% 
  dplyr::summarise(weight_mean0405_cassava   = mean(weight_cassava, na.rm = T), # calculate average weight for the 2004-2005 period
            weight_mean0405_corn      = mean(weight_corn, na.rm = T), 
            weight_mean0405_rice      = mean(weight_rice, na.rm = T), 
            weight_mean0405_soybean   = mean(weight_soybean, na.rm = T),
            weight_mean0405_sugarcane = mean(weight_sugarcane, na.rm = T),
            weight_mean0405_cattle    = mean(weight_cattle, na.rm = T)) 
  
  
# clean environment
rm(admin.br.muni.2007.df, ag.br.pam.5crops.df, ag.br.ppm.livestock.all.df, macro.br.prices.commodities.df, macro.br.prices.deflator.ipa.df)


# PRICES REAL WEIGHTED -------------------------------------------------------------------------------------------------------------------------------

series.pricesBrazil <-
  series.sample.df %>% 
  left_join(prices.brazil.real, by = "year") %>% # merge with prices info
  left_join(weights, by = "muni_code") %>% # merge with weights info
  dplyr::select(muni_code, year, semester, starts_with("price_r_br_mean_sem_"), 
         starts_with("price_r_br_index_ann_"), starts_with("weight")) %>% # dplyr::select and order columns of interest
  gather(key = aux.var, value = value, starts_with("price_r_br_mean_sem_")) %>% 
  unite(col = aux.var.semester, aux.var, semester) %>%
  spread(aux.var.semester, value) %>% 
  mutate(price_r_br_windex_sem_cattle_1 = ((price_r_br_mean_sem_cattle_1/aux.baseline.1$price_r_br_mean_ann_cattle) * 100) * weight_mean0405_cattle) %>% # calculate prices weighted real
  mutate(price_r_br_windex_sem_sugarcane_1 = ((price_r_br_mean_sem_sugarcane_1/aux.baseline.1$price_r_br_mean_ann_sugarcane) * 100) * weight_mean0405_sugarcane) %>% 
  mutate(price_r_br_windex_sem_corn_1 = ((price_r_br_mean_sem_corn_1/aux.baseline.1$price_r_br_mean_ann_corn) * 100) * weight_mean0405_corn) %>%
  mutate(price_r_br_windex_sem_soybean_1 = ((price_r_br_mean_sem_soybean_1/aux.baseline.1$price_r_br_mean_ann_soybean) * 100) * weight_mean0405_soybean) %>%
  mutate(price_r_br_windex_sem_cassava_1 = ((price_r_br_mean_sem_cassava_1/aux.baseline.1$price_r_br_mean_ann_cassava) * 100) * weight_mean0405_cassava) %>%
  mutate(price_r_br_windex_sem_rice_1 = ((price_r_br_mean_sem_rice_1/aux.baseline.1$price_r_br_mean_ann_rice) * 100) * weight_mean0405_rice) %>%
  mutate(price_r_br_windex_sem_cattle_2 = ((price_r_br_mean_sem_cattle_2/aux.baseline.2$price_r_br_mean_ann_cattle) * 100) * weight_mean0405_cattle) %>% # calculate prices weighted real
  mutate(price_r_br_windex_sem_sugarcane_2 = ((price_r_br_mean_sem_sugarcane_2/aux.baseline.2$price_r_br_mean_ann_sugarcane) * 100) * weight_mean0405_sugarcane) %>% 
  mutate(price_r_br_windex_sem_corn_2 = ((price_r_br_mean_sem_corn_2/aux.baseline.2$price_r_br_mean_ann_corn) * 100) * weight_mean0405_corn) %>%
  mutate(price_r_br_windex_sem_soybean_2 = ((price_r_br_mean_sem_soybean_2/aux.baseline.2$price_r_br_mean_ann_soybean) * 100) * weight_mean0405_soybean) %>%
  mutate(price_r_br_windex_sem_cassava_2 = ((price_r_br_mean_sem_cassava_2/aux.baseline.2$price_r_br_mean_ann_cassava) * 100) * weight_mean0405_cassava) %>%
  mutate(price_r_br_windex_sem_rice_2 = ((price_r_br_mean_sem_rice_2/aux.baseline.2$price_r_br_mean_ann_rice) * 100) * weight_mean0405_rice) %>% 
  dplyr::select(muni_code, year, starts_with("price_r_br_index"), starts_with("price_r_br_windex"))
  

# DEPRECATED  
# series.pricesWorld <-
#   series.sample.df %>% 
#   left_join(prices.world.real, by = "year") %>% # merge with prices info
#   left_join(weights, by = "muni_code") %>% # merge with weights info
#   mutate(price_r_world_windex_ann_cattle = price_r_cattle * weight_mean0405_cattle) %>% # calculate prices weighted real
#   mutate(price_r_world_windex_ann_sugarcane = price_r_sugarcane * weight_mean0405_sugarcane) %>% 
#   mutate(price_r_world_windex_ann_corn = price_r_corn * weight_mean0405_corn) %>% 
#   mutate(price_r_world_windex_ann_soybean = price_r_soybean * weight_mean0405_soybean) %>% 
#   mutate(price_r_world_windex_ann_rice = price_r_rice * weight_mean0405_rice) %>% 
#   dplyr::select(muni_code, year, starts_with("price_r_world_windex")) # dplyr::select and order columns of interest
  
# clean environement
rm(aux.baseline.1, aux.baseline.2, prices.brazil.real,
   series.sample.df, weights)

   
   

# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.pricesBrazil, file = file.path("data/projectSpecific", "series_pricesBrazil.Rdata"))

# DEPRECATED
# save(series.pricesWorld, file = file.path("data/projectSpecific", "series_pricesWorld.Rdata"))

# clean environement
rm(series.pricesBrazil)



# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------