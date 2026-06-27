
# > PROJECT INFO
# NAME: PROJECT DETERRING DEFORESTATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: PRICES - VARIABLES CONSTRUCTION (PARANA)
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


# DEFLATOR (2000.01 = 100; BASED ON IPA-EP)
load(file.path("data/raw2clean/macro/deflator_fgv/output", "macro_br_prices_deflator_ipa_df.Rdata"))


# MUNICIPAL AGRICULTURAL PRODUCTION (PAM)
load(file.path("data/raw2clean/agriculture/pam_ibge/output", "ag_br_pam_5crops_df.Rdata"))


# MUNICIPAL LIVESTOCK SURVEY (PPM)
load(file.path("data/raw2clean/agriculture/ppm_ibge/output", "ag_br_ppm_livestock_all_df.Rdata"))


# BRAZILIAN MUNICIPALITIES
load(file.path("data/raw2clean/administrative/territorial_ibge/brazil/output/2007", "admin_br_territory_muni_2007_df.Rdata"))


# PANEL SAMPLE
load(file.path("data/projectSpecific", "series_sample_monthly_df.Rdata"))



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
  group_by(year, month) %>% # defines the level of interest as year + month
  dplyr::summarise(price_r_br_mean_mon_rice      = mean(price_r_rice, na.rm = T), # mean month real price
            price_r_br_mean_mon_cassava   = mean(price_r_cassava, na.rm = T), 
            price_r_br_mean_mon_corn      = mean(price_r_corn, na.rm = T), 
            price_r_br_mean_mon_soybean   = mean(price_r_soybean, na.rm = T),
            price_r_br_mean_mon_sugarcane = mean(price_r_sugarcane, na.rm = T),
            price_r_br_mean_mon_cattle    = mean(price_r_cattle, na.rm = T)) %>% 
  ungroup() %>% 
  group_by(year) %>% 
  mutate(price_r_br_mean_ann_cattle = mean(price_r_br_mean_mon_cattle, na.rm = T)) %>% # mean annual real price
  mutate(price_r_br_mean_ann_sugarcane = mean(price_r_br_mean_mon_sugarcane, na.rm = T)) %>% 
  mutate(price_r_br_mean_ann_corn = mean(price_r_br_mean_mon_corn, na.rm = T)) %>% 
  mutate(price_r_br_mean_ann_soybean = mean(price_r_br_mean_mon_soybean, na.rm = T)) %>% 
  mutate(price_r_br_mean_ann_cassava = mean(price_r_br_mean_mon_cassava, na.rm = T)) %>% 
  mutate(price_r_br_mean_ann_rice = mean(price_r_br_mean_mon_rice, na.rm = T)) %>%   
  ungroup() %>% 
  dplyr::select(year, month, starts_with("price_r_br_mean")) %>% 
  unique()

# dplyr::select row with baseline info (year 2000 for first and second semesters)
aux.baseline.1 <- 
  prices.brazil.real %>% 
  filter(year == 2000, month == 1)  
 
aux.baseline.2 <- 
  prices.brazil.real %>% 
  filter(year == 2000, month == 2)  

aux.baseline.3 <- 
  prices.brazil.real %>% 
  filter(year == 2000, month == 3)  

aux.baseline.4 <- 
  prices.brazil.real %>% 
  filter(year == 2000, month == 4)  

aux.baseline.5 <- 
  prices.brazil.real %>% 
  filter(year == 2000, month == 5)  

aux.baseline.6 <- 
  prices.brazil.real %>% 
  filter(year == 2000, month == 6)  

aux.baseline.7 <- 
  prices.brazil.real %>% 
  filter(year == 2000, month == 7)  

aux.baseline.8 <- 
  prices.brazil.real %>% 
  filter(year == 2000, month == 8)  

aux.baseline.9 <- 
  prices.brazil.real %>% 
  filter(year == 2000, month == 9)  

aux.baseline.10 <- 
  prices.brazil.real %>% 
  filter(year == 2000, month == 10)  

aux.baseline.11 <- 
  prices.brazil.real %>% 
  filter(year == 2000, month == 11)  

aux.baseline.12 <- 
  prices.brazil.real %>% 
  filter(year == 2000, month == 12)  

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
  
  



# WEIGHTS --------------------------------------------------------------------------------------------------------------------------------------------

# column name fix to merge
ag.br.pam.5crops.df <- ag.br.pam.5crops.df %>%  dplyr::rename(muni_code = municipality_code)

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

series.pricesBrazil.monthly <-
  series.sample.monthly.df %>% 
  left_join(prices.brazil.real, by = c("month", "year")) %>% # merge with prices info
  left_join(weights, by = "muni_code") %>% # merge with weights info
  dplyr::select(muni_code, year, month, starts_with("price_r_br_mean_mon_"), 
         starts_with("price_r_br_index_ann_"), starts_with("weight")) %>% # dplyr::select and order columns of interest
  mutate(price_r_br_windex_mon_cattle = case_when(month == 1 ~ ((price_r_br_mean_mon_cattle/aux.baseline.1$price_r_br_mean_mon_cattle) * 100) * weight_mean0405_cattle,
                                                  month == 2 ~ ((price_r_br_mean_mon_cattle/aux.baseline.2$price_r_br_mean_mon_cattle) * 100) * weight_mean0405_cattle,
                                                  month == 3 ~ ((price_r_br_mean_mon_cattle/aux.baseline.3$price_r_br_mean_mon_cattle) * 100) * weight_mean0405_cattle,
                                                  month == 4  ~ ((price_r_br_mean_mon_cattle/aux.baseline.4$price_r_br_mean_mon_cattle) * 100) * weight_mean0405_cattle,
                                                  month == 5 ~ ((price_r_br_mean_mon_cattle/aux.baseline.5$price_r_br_mean_mon_cattle) * 100) * weight_mean0405_cattle,
                                                  month == 6 ~ ((price_r_br_mean_mon_cattle/aux.baseline.6$price_r_br_mean_mon_cattle) * 100) * weight_mean0405_cattle,
                                                  month == 7 ~ ((price_r_br_mean_mon_cattle/aux.baseline.7$price_r_br_mean_mon_cattle) * 100) * weight_mean0405_cattle,
                                                  month == 8 ~ ((price_r_br_mean_mon_cattle/aux.baseline.8$price_r_br_mean_mon_cattle) * 100) * weight_mean0405_cattle,
                                                  month == 9 ~ ((price_r_br_mean_mon_cattle/aux.baseline.9$price_r_br_mean_mon_cattle) * 100) * weight_mean0405_cattle,
                                                  month == 10 ~ ((price_r_br_mean_mon_cattle/aux.baseline.10$price_r_br_mean_mon_cattle) * 100) * weight_mean0405_cattle,
                                                  month == 11 ~ ((price_r_br_mean_mon_cattle/aux.baseline.11$price_r_br_mean_mon_cattle) * 100) * weight_mean0405_cattle,
                                                  month == 12 ~ ((price_r_br_mean_mon_cattle/aux.baseline.12$price_r_br_mean_mon_cattle) * 100) * weight_mean0405_cattle)) %>% 
  mutate(price_r_br_windex_mon_rice = case_when(month == 1 ~ ((price_r_br_mean_mon_rice/aux.baseline.1$price_r_br_mean_mon_rice) * 100) * weight_mean0405_rice,
                                                  month == 2 ~ ((price_r_br_mean_mon_rice/aux.baseline.2$price_r_br_mean_mon_rice) * 100) * weight_mean0405_rice,
                                                  month == 3 ~ ((price_r_br_mean_mon_rice/aux.baseline.3$price_r_br_mean_mon_rice) * 100) * weight_mean0405_rice,
                                                  month == 4  ~ ((price_r_br_mean_mon_rice/aux.baseline.4$price_r_br_mean_mon_rice) * 100) * weight_mean0405_rice,
                                                  month == 5 ~ ((price_r_br_mean_mon_rice/aux.baseline.5$price_r_br_mean_mon_rice) * 100) * weight_mean0405_rice,
                                                  month == 6 ~ ((price_r_br_mean_mon_rice/aux.baseline.6$price_r_br_mean_mon_rice) * 100) * weight_mean0405_rice,
                                                  month == 7 ~ ((price_r_br_mean_mon_rice/aux.baseline.7$price_r_br_mean_mon_rice) * 100) * weight_mean0405_rice,
                                                  month == 8 ~ ((price_r_br_mean_mon_rice/aux.baseline.8$price_r_br_mean_mon_rice) * 100) * weight_mean0405_rice,
                                                  month == 9 ~ ((price_r_br_mean_mon_rice/aux.baseline.9$price_r_br_mean_mon_rice) * 100) * weight_mean0405_rice,
                                                  month == 10 ~ ((price_r_br_mean_mon_rice/aux.baseline.10$price_r_br_mean_mon_rice) * 100) * weight_mean0405_rice,
                                                  month == 11 ~ ((price_r_br_mean_mon_rice/aux.baseline.11$price_r_br_mean_mon_rice) * 100) * weight_mean0405_rice,
                                                  month == 12 ~ ((price_r_br_mean_mon_rice/aux.baseline.12$price_r_br_mean_mon_rice) * 100) * weight_mean0405_rice)) %>% 
  mutate(price_r_br_windex_mon_corn = case_when(month == 1 ~ ((price_r_br_mean_mon_corn/aux.baseline.1$price_r_br_mean_mon_corn) * 100) * weight_mean0405_corn,
                                                  month == 2 ~ ((price_r_br_mean_mon_corn/aux.baseline.2$price_r_br_mean_mon_corn) * 100) * weight_mean0405_corn,
                                                  month == 3 ~ ((price_r_br_mean_mon_corn/aux.baseline.3$price_r_br_mean_mon_corn) * 100) * weight_mean0405_corn,
                                                  month == 4  ~ ((price_r_br_mean_mon_corn/aux.baseline.4$price_r_br_mean_mon_corn) * 100) * weight_mean0405_corn,
                                                  month == 5 ~ ((price_r_br_mean_mon_corn/aux.baseline.5$price_r_br_mean_mon_corn) * 100) * weight_mean0405_corn,
                                                  month == 6 ~ ((price_r_br_mean_mon_corn/aux.baseline.6$price_r_br_mean_mon_corn) * 100) * weight_mean0405_corn,
                                                  month == 7 ~ ((price_r_br_mean_mon_corn/aux.baseline.7$price_r_br_mean_mon_corn) * 100) * weight_mean0405_corn,
                                                  month == 8 ~ ((price_r_br_mean_mon_corn/aux.baseline.8$price_r_br_mean_mon_corn) * 100) * weight_mean0405_corn,
                                                  month == 9 ~ ((price_r_br_mean_mon_corn/aux.baseline.9$price_r_br_mean_mon_corn) * 100) * weight_mean0405_corn,
                                                  month == 10 ~ ((price_r_br_mean_mon_corn/aux.baseline.10$price_r_br_mean_mon_corn) * 100) * weight_mean0405_corn,
                                                  month == 11 ~ ((price_r_br_mean_mon_corn/aux.baseline.11$price_r_br_mean_mon_corn) * 100) * weight_mean0405_corn,
                                                  month == 12 ~ ((price_r_br_mean_mon_corn/aux.baseline.12$price_r_br_mean_mon_corn) * 100) * weight_mean0405_corn)) %>% 
  mutate(price_r_br_windex_mon_soybean = case_when(month == 1 ~ ((price_r_br_mean_mon_soybean/aux.baseline.1$price_r_br_mean_mon_soybean) * 100) * weight_mean0405_soybean,
                                                  month == 2 ~ ((price_r_br_mean_mon_soybean/aux.baseline.2$price_r_br_mean_mon_soybean) * 100) * weight_mean0405_soybean,
                                                  month == 3 ~ ((price_r_br_mean_mon_soybean/aux.baseline.3$price_r_br_mean_mon_soybean) * 100) * weight_mean0405_soybean,
                                                  month == 4  ~ ((price_r_br_mean_mon_soybean/aux.baseline.4$price_r_br_mean_mon_soybean) * 100) * weight_mean0405_soybean,
                                                  month == 5 ~ ((price_r_br_mean_mon_soybean/aux.baseline.5$price_r_br_mean_mon_soybean) * 100) * weight_mean0405_soybean,
                                                  month == 6 ~ ((price_r_br_mean_mon_soybean/aux.baseline.6$price_r_br_mean_mon_soybean) * 100) * weight_mean0405_soybean,
                                                  month == 7 ~ ((price_r_br_mean_mon_soybean/aux.baseline.7$price_r_br_mean_mon_soybean) * 100) * weight_mean0405_soybean,
                                                  month == 8 ~ ((price_r_br_mean_mon_soybean/aux.baseline.8$price_r_br_mean_mon_soybean) * 100) * weight_mean0405_soybean,
                                                  month == 9 ~ ((price_r_br_mean_mon_soybean/aux.baseline.9$price_r_br_mean_mon_soybean) * 100) * weight_mean0405_soybean,
                                                  month == 10 ~ ((price_r_br_mean_mon_soybean/aux.baseline.10$price_r_br_mean_mon_soybean) * 100) * weight_mean0405_soybean,
                                                  month == 11 ~ ((price_r_br_mean_mon_soybean/aux.baseline.11$price_r_br_mean_mon_soybean) * 100) * weight_mean0405_soybean,
                                                  month == 12 ~ ((price_r_br_mean_mon_soybean/aux.baseline.12$price_r_br_mean_mon_soybean) * 100) * weight_mean0405_soybean)) %>% 
  mutate(price_r_br_windex_mon_cassava = case_when(month == 1 ~ ((price_r_br_mean_mon_cassava/aux.baseline.1$price_r_br_mean_mon_cassava) * 100) * weight_mean0405_cassava,
                                                  month == 2 ~ ((price_r_br_mean_mon_cassava/aux.baseline.2$price_r_br_mean_mon_cassava) * 100) * weight_mean0405_cassava,
                                                  month == 3 ~ ((price_r_br_mean_mon_cassava/aux.baseline.3$price_r_br_mean_mon_cassava) * 100) * weight_mean0405_cassava,
                                                  month == 4  ~ ((price_r_br_mean_mon_cassava/aux.baseline.4$price_r_br_mean_mon_cassava) * 100) * weight_mean0405_cassava,
                                                  month == 5 ~ ((price_r_br_mean_mon_cassava/aux.baseline.5$price_r_br_mean_mon_cassava) * 100) * weight_mean0405_cassava,
                                                  month == 6 ~ ((price_r_br_mean_mon_cassava/aux.baseline.6$price_r_br_mean_mon_cassava) * 100) * weight_mean0405_cassava,
                                                  month == 7 ~ ((price_r_br_mean_mon_cassava/aux.baseline.7$price_r_br_mean_mon_cassava) * 100) * weight_mean0405_cassava,
                                                  month == 8 ~ ((price_r_br_mean_mon_cassava/aux.baseline.8$price_r_br_mean_mon_cassava) * 100) * weight_mean0405_cassava,
                                                  month == 9 ~ ((price_r_br_mean_mon_cassava/aux.baseline.9$price_r_br_mean_mon_cassava) * 100) * weight_mean0405_cassava,
                                                  month == 10 ~ ((price_r_br_mean_mon_cassava/aux.baseline.10$price_r_br_mean_mon_cassava) * 100) * weight_mean0405_cassava,
                                                  month == 11 ~ ((price_r_br_mean_mon_cassava/aux.baseline.11$price_r_br_mean_mon_cassava) * 100) * weight_mean0405_cassava,
                                                  month == 12 ~ ((price_r_br_mean_mon_cassava/aux.baseline.12$price_r_br_mean_mon_cassava) * 100) * weight_mean0405_cassava)) %>% 
  mutate(price_r_br_windex_mon_sugarcane = case_when(month == 1 ~ ((price_r_br_mean_mon_sugarcane/aux.baseline.1$price_r_br_mean_mon_sugarcane) * 100) * weight_mean0405_sugarcane,
                                                  month == 2 ~ ((price_r_br_mean_mon_sugarcane/aux.baseline.2$price_r_br_mean_mon_sugarcane) * 100) * weight_mean0405_sugarcane,
                                                  month == 3 ~ ((price_r_br_mean_mon_sugarcane/aux.baseline.3$price_r_br_mean_mon_sugarcane) * 100) * weight_mean0405_sugarcane,
                                                  month == 4  ~ ((price_r_br_mean_mon_sugarcane/aux.baseline.4$price_r_br_mean_mon_sugarcane) * 100) * weight_mean0405_sugarcane,
                                                  month == 5 ~ ((price_r_br_mean_mon_sugarcane/aux.baseline.5$price_r_br_mean_mon_sugarcane) * 100) * weight_mean0405_sugarcane,
                                                  month == 6 ~ ((price_r_br_mean_mon_sugarcane/aux.baseline.6$price_r_br_mean_mon_sugarcane) * 100) * weight_mean0405_sugarcane,
                                                  month == 7 ~ ((price_r_br_mean_mon_sugarcane/aux.baseline.7$price_r_br_mean_mon_sugarcane) * 100) * weight_mean0405_sugarcane,
                                                  month == 8 ~ ((price_r_br_mean_mon_sugarcane/aux.baseline.8$price_r_br_mean_mon_sugarcane) * 100) * weight_mean0405_sugarcane,
                                                  month == 9 ~ ((price_r_br_mean_mon_sugarcane/aux.baseline.9$price_r_br_mean_mon_sugarcane) * 100) * weight_mean0405_sugarcane,
                                                  month == 10 ~ ((price_r_br_mean_mon_sugarcane/aux.baseline.10$price_r_br_mean_mon_sugarcane) * 100) * weight_mean0405_sugarcane,
                                                  month == 11 ~ ((price_r_br_mean_mon_sugarcane/aux.baseline.11$price_r_br_mean_mon_sugarcane) * 100) * weight_mean0405_sugarcane,
                                                  month == 12 ~ ((price_r_br_mean_mon_sugarcane/aux.baseline.12$price_r_br_mean_mon_sugarcane) * 100) * weight_mean0405_sugarcane)) %>% 
  dplyr::select(muni_code, month, year, starts_with("price_r_br_windex")) 

  




# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.pricesBrazil.monthly, file = file.path("data/projectSpecific", "series_pricesBrazil_monthly.Rdata"))






# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------