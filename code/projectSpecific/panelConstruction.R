# > PROJECT INFO
# NAME: PROJECT DETERRING DEFORESTATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: MERGE ALL BUILT VARS WITH PANEL SAMPLE
# AUTHOR: JOAO VIEIRA
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



# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

load(file = file.path("data/projectSpecific", "series_sample_df.Rdata"))
load(file = file.path("data/projectSpecific", "series_prodes.Rdata"))
load(file = file.path("data/projectSpecific", "series_fines.Rdata"))
load(file = file.path("data/projectSpecific", "series_deterClouds.Rdata"))
load(file = file.path("data/projectSpecific", "series_weatherRain.Rdata"))
load(file = file.path("data/projectSpecific", "series_weatherTemp.Rdata"))
load(file = file.path("data/projectSpecific", "series_pricesBrazil.Rdata"))
load(file = file.path("data/projectSpecific", "series_priorityMuni.Rdata"))
load(file = file.path("data/projectSpecific", "series_protectedTerritory.Rdata"))
load(file = file.path("data/projectSpecific", "series_weatherTempCPCG.Rdata"))
load(file = file.path("data/projectSpecific", "series_weatherRainCPCG.Rdata"))
load(file = file.path("data/projectSpecific", "series_weatherRainReanalysis.Rdata"))
load(file = file.path("data/projectSpecific", "series_nasaClouds.Rdata"))





# DATA MERGE ----------------------------------------------------------------------------------------------------------------------------------------

# DATA PREP
series.sample.df$year              <- as.numeric(series.sample.df$year)
series.deterClouds$year            <- as.numeric(series.deterClouds$year)
series.fines$year                  <- as.numeric(series.fines$year)
series.pricesBrazil$year           <- as.numeric(series.pricesBrazil$year)
series.prodes$year                 <- as.numeric(series.prodes$year)
series.weatherRain$year            <- as.numeric(series.weatherRain$year)
series.weatherTemp$year            <- as.numeric(series.weatherTemp$year)
series.priorityMuni$year           <- as.numeric(series.priorityMuni$year)
series.protectedTerritory$year     <- as.numeric(series.protectedTerritory$year)
series.weatherRainCPCG$year        <- as.numeric(series.weatherRainCPCG$year)
series.weatherTempCPCG$year        <- as.numeric(series.weatherTempCPCG$year)
series.weatherRainReanalysis$year  <- as.numeric(series.weatherRainReanalysis$year)
series.nasaClouds$year             <- as.numeric(series.nasaClouds$year)


series.sample.df$muni_code              <- as.numeric(series.sample.df$muni_code)
series.deterClouds$muni_code            <- as.numeric(series.deterClouds$muni_code)
series.fines$muni_code                  <- as.numeric(series.fines$muni_code)
series.pricesBrazil$muni_code           <- as.numeric(series.pricesBrazil$muni_code)
series.prodes$muni_code                 <- as.numeric(series.prodes$muni_code)
series.weatherRain$muni_code            <- as.numeric(series.weatherRain$muni_code)
series.weatherTemp$muni_code            <- as.numeric(series.weatherTemp$muni_code)
series.priorityMuni$muni_code           <- as.numeric(series.priorityMuni$muni_code)
series.protectedTerritory$muni_code     <- as.numeric(series.protectedTerritory$muni_code)
series.weatherRainCPCG$muni_code        <- as.numeric(series.weatherRainCPCG$muni_code)
series.weatherTempCPCG$muni_code        <- as.numeric(series.weatherTempCPCG$muni_code)
series.weatherRainReanalysis$muni_code  <- as.numeric(series.weatherRainReanalysis$muni_code)
series.nasaClouds$muni_code             <- as.numeric(series.nasaClouds$muni_code)



# MERGE
panel.fromR <-
series.sample.df %>%
  dplyr::left_join(series.deterClouds,             by = c("muni_code", "year")) %>%
  dplyr::left_join(series.fines,                   by = c("muni_code", "year")) %>%
  dplyr::left_join(series.pricesBrazil,            by = c("muni_code", "year")) %>%
  dplyr::left_join(series.prodes ,                 by = c("muni_code", "year")) %>%
  dplyr::left_join(series.weatherRain ,            by = c("muni_code", "year")) %>%
  dplyr::left_join(series.weatherTemp ,            by = c("muni_code", "year")) %>%
  dplyr::left_join(series.priorityMuni ,           by = c("muni_code", "year")) %>%
  dplyr::left_join(series.protectedTerritory ,     by = c("muni_code", "year")) %>%
  dplyr::left_join(series.weatherRainCPCG ,        by = c("muni_code", "year")) %>%
  dplyr::left_join(series.weatherTempCPCG ,        by = c("muni_code", "year")) %>%
  dplyr::left_join(series.weatherRainReanalysis ,  by = c("muni_code", "year")) %>%
  dplyr::left_join(series.nasaClouds,              by = c("muni_code", "year")) %>%
  dplyr::mutate(fine_count                   = replace_na(fine_count, 0)) %>%
  dplyr::mutate(d_priority                   = replace_na(d_priority, 0)) %>%
  dplyr::mutate(fine_sum_sanction_value      = replace_na(fine_sum_sanction_value, 0)) %>%
  dplyr::rename(fines_count                  = fine_count,
         fines_value                  = fine_sum_sanction_value, # dplyr::rename all vars to obey stata limits
         deter_cloud                  = deterCloud_share,
         nasa_cloud                   = nasaCloud_share,
         priceNdx_brzl_y_cattle       = price_r_br_index_ann_cattle,
         priceNdx_brzl_y_sugar        = price_r_br_index_ann_sugarcane,
         priceNdx_brzl_y_corn         = price_r_br_index_ann_corn,
         priceNdx_brzl_y_soybean      = price_r_br_index_ann_soybean,
         priceNdx_brzl_y_cassava      = price_r_br_index_ann_cassava,
         priceNdx_brzl_y_rice         = price_r_br_index_ann_rice,
         priceWgtNdx_brzl_s1_cattle   = price_r_br_windex_sem_cattle_1,
         priceWgtNdx_brzl_s1_sugar    = price_r_br_windex_sem_sugarcane_1,
         priceWgtNdx_brzl_s1_corn     = price_r_br_windex_sem_corn_1,
         priceWgtNdx_brzl_s1_soybean  = price_r_br_windex_sem_soybean_1,
         priceWgtNdx_brzl_s1_cassava  = price_r_br_windex_sem_cassava_1,
         priceWgtNdx_brzl_s1_rice     = price_r_br_windex_sem_rice_1,
         priceWgtNdx_brzl_s2_cattle   = price_r_br_windex_sem_cattle_2,
         priceWgtNdx_brzl_s2_sugar    = price_r_br_windex_sem_sugarcane_2,
         priceWgtNdx_brzl_s2_corn     = price_r_br_windex_sem_corn_2,
         priceWgtNdx_brzl_s2_soybean  = price_r_br_windex_sem_soybean_2,
         priceWgtNdx_brzl_s2_cassava  = price_r_br_windex_sem_cassava_2,
         priceWgtNdx_brzl_s2_rice     = price_r_br_windex_sem_rice_2,
         prodes_deforest              = prodes_deforest_increment,
         prodes_nonobs                = prodes_nonobserved_area,
         prodes_cloud                 = prodes_cloud_coverage,
         weather_rain                 = weatherRain_total,
         weather_temp                 = weatherTemp_mean,
         weather_rain_CPCG            = weatherRainCPCG_total,
         weather_temp_CPCG            = weatherTempCPCG_mean,
         weather_rain_Reanalysis      = weatherRainReanalysis_total,
         prodes03_deforest            = prodes_def_inc_2003,
         prodes03_forest              = prodes_forest_share_2003,
         prodes03_cleared             = prodes_deforest_share_2003,
         d_priorityMuni               = d_priority,
         protection                   = share_protArea) %>%
  dplyr::select(muni_code, year, muni_area, deter_cloud, nasa_cloud,
                starts_with("fines"), starts_with("price"), starts_with("prodes"), starts_with("weather"),
                d_priorityMuni, protection) %>%
  group_by(muni_code, year) %>%
  slice(1)

rm(list = ls(pattern = "series."))




# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# check colnames order
colnames(panel.fromR)


# LABELS
var.labels = c(muni_code                   = "municipality IBGE code (7-digit)",
               year                        = "year of reference",
               muni_area                   = "municipal area (ha, calc from sp data under SAD69polyconic)",
               deter_cloud                 = "DETER cloud coverage (share of municipal area; PRODES year)",
               nasa_cloud                  =  "NASA cloud coverage (share of municipal area; PRODES year)",
               fines_count                 = "number of flora-related fines (count; PRODES year)",
               fines_value                 = "value of flora-related fines (BRL; PRODES year)",
               priceNdx_brzl_y_cattle      = "real price index, beef cattle (calendar year)",
               priceNdx_brzl_y_sugar       = "real price index, sugarcane (calendar year)",
               priceNdx_brzl_y_corn        = "real price index, corn (calendar year)",
               priceNdx_brzl_y_soybean     = "real price index, soybean (calendar year)",
               priceNdx_brzl_y_cassava     = "real price index, cassava (calendar year)",
               priceNdx_brzl_y_rice        = "real price index, rice (calendar year)",
               priceWgtNdx_brzl_s1_cattle  = "weighted real price index, beef cattle (sem1, calendar year)",
               priceWgtNdx_brzl_s1_sugar   = "weighted real price index, sugarcane (sem1, calendar year)",
               priceWgtNdx_brzl_s1_corn    = "weighted real price index, corn (sem1, calendar year)",
               priceWgtNdx_brzl_s1_soybean = "weighted real price index, soybean (sem1, calendar year)",
               priceWgtNdx_brzl_s1_cassava = "weighted real price index, cassava (sem1, calendar year)",
               priceWgtNdx_brzl_s1_rice    = "weighted real price index, rice (sem1, calendar year)",
               priceWgtNdx_brzl_s2_cattle  = "weighted real price index, beef cattle (sem2, calendar year)",
               priceWgtNdx_brzl_s2_sugar   = "weighted real price index, sugarcane (sem2, calendar year)",
               priceWgtNdx_brzl_s2_corn    = "weighted real price index, corn (sem2, calendar year)",
               priceWgtNdx_brzl_s2_soybean = "weighted real price index, soybean (sem2, calendar year)",
               priceWgtNdx_brzl_s2_cassava = "weighted real price index, cassava (sem2, calendar year)",
               priceWgtNdx_brzl_s2_rice    = "weighted real price index, rice (sem2, calendar year)",
               prodes_deforest             = "increment in deforested area (sq km; PRODES year)",
               prodes_nonobs               = "area blocked from view during remote sensing (sq km; PRODES year)",
               prodes_cloud                = "area covered by clouds during remote sensing (sq km; PRODES year)",
               prodes03_deforest           = "[xsection] 2003 increment in deforested area (sq km)",
               prodes03_forest             = "[xsection] 2003 forest cover (share of municipal area)",
               prodes03_cleared            = "[xsection] 2003 cleared area (share of municipal area)",
               weather_rain                = "total precipitation (Uni Delaware) (mm; PRODES year)",
               weather_temp                = "average temperature (Uni Delaware) (degrees Celsius; PRODES year)",
               weather_rain_CPCG           = "total precipitation (CPCG) (mm; PRODES year)",
               weather_temp_CPCG           = "average temperature (CPCG) (degrees Celsius; PRODES year)",
               weather_rain_Reanalysis     = "total precipitation (Reanalysis) (mm; PRODES year)",
               d_priorityMuni              = "d=1 if priority muni (PRODES year)",
               protection                  = "protected territory, PA or IL (share of municipal area, PRODES year)")

label(panel.fromR) = lapply(names(var.labels), function(x) label(panel.fromR[,x]) = var.labels[x])




# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(panel.fromR,
     file = file.path("data/projectSpecific", "panel_fromR.Rdata"))


write_dta(panel.fromR,
          path = file.path("data/projectSpecific", "panel_fromR.dta"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------