# > PROJECT INFO
# NAME: PROJECT DETERRING DEFORESTATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: MERGE ALL BUILT VARS WITH PANEL SAMPLE - MONTHLY
# AUTHOR: JOAO VIEIRA
#
# > EDIT DETAILS
# BY: CLARISSA GANDOUR
# ON: NOV/28/2021
#
# > NOTES
# -




# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions", "setup.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

load(file = file.path("data/projectSpecific", "seriesConstruction_sample_monthly_df.Rdata"))
load(file = file.path("data/projectSpecific", "seriesConstruction_prodes.Rdata"))
load(file = file.path("data/projectSpecific", "seriesConstruction_fines_monthly.Rdata"))
load(file = file.path("data/projectSpecific", "seriesConstruction_deterClouds_monthly.Rdata"))
load(file = file.path("data/projectSpecific", "seriesConstruction_weatherRain_monthly.Rdata"))
load(file = file.path("data/projectSpecific", "seriesConstruction_weatherTemp_monthly.Rdata"))
load(file = file.path("data/projectSpecific", "seriesConstruction_pricesBrazil_monthly.Rdata"))
load(file = file.path("data/projectSpecific", "seriesConstruction_nasaClouds_monthly.Rdata"))





# DATA MERGE ----------------------------------------------------------------------------------------------------------------------------------------

# DATA PREP

# fixed prodes year column
series.prodes$year_prodes <- series.prodes$year
series.prodes$year <- NULL

# adjust class to merge
series.sample.monthly.df$year    <- as.numeric(series.sample.monthly.df$year)
series.deterClouds.monthly$year  <- as.numeric(series.deterClouds.monthly$year)
series.fines.monthly$year        <- as.numeric(series.fines.monthly$year)
series.pricesBrazil.monthly$year <- as.numeric(series.pricesBrazil.monthly$year)
series.weatherRain.monthly$year  <- as.numeric(series.weatherRain.monthly$year)
series.weatherTemp.monthly$year  <- as.numeric(series.weatherTemp.monthly$year)
series.nasaClouds.monthly$year   <- as.numeric(series.nasaClouds.monthly$year)

series.sample.monthly.df$year_prodes    <- as.numeric(series.sample.monthly.df$year_prodes)
series.deterClouds.monthly$year_prodes  <- as.numeric(series.deterClouds.monthly$year_prodes)
series.fines.monthly$year_prodes        <- as.numeric(series.fines.monthly$year_prodes)
series.prodes$year_prodes               <- as.numeric(series.prodes$year_prodes)
series.weatherRain.monthly$year_prodes  <- as.numeric(series.weatherRain.monthly$year_prodes)
series.weatherTemp.monthly$year_prodes  <- as.numeric(series.weatherTemp.monthly$year_prodes)
series.nasaClouds.monthly$year_prodes   <- as.numeric(series.nasaClouds.monthly$year_prodes)

series.sample.monthly.df$month    <- as.numeric(series.sample.monthly.df$month)
series.deterClouds.monthly$month  <- as.numeric(series.deterClouds.monthly$month)
series.fines.monthly$month        <- as.numeric(series.fines.monthly$month)
series.pricesBrazil.monthly$month <- as.numeric(series.pricesBrazil.monthly$month)
series.weatherRain.monthly$month  <- as.numeric(series.weatherRain.monthly$month)
series.weatherTemp.monthly$month  <- as.numeric(series.weatherTemp.monthly$month)
series.nasaClouds.monthly$month   <- as.numeric(series.nasaClouds.monthly$month)

series.sample.monthly.df$muni_code    <- as.numeric(series.sample.monthly.df$muni_code)
series.deterClouds.monthly$muni_code  <- as.numeric(series.deterClouds.monthly$muni_code)
series.fines.monthly$muni_code        <- as.numeric(series.fines.monthly$muni_code)
series.pricesBrazil.monthly$muni_code <- as.numeric(series.pricesBrazil.monthly$muni_code)
series.prodes$muni_code               <- as.numeric(series.prodes$muni_code)
series.weatherRain.monthly$muni_code  <- as.numeric(series.weatherRain.monthly$muni_code)
series.weatherTemp.monthly$muni_code  <- as.numeric(series.weatherTemp.monthly$muni_code)
series.nasaClouds.monthly$muni_code   <- as.numeric(series.nasaClouds.monthly$muni_code)

# MERGE
panelMonthly.fromR <-
series.sample.monthly.df %>%
  left_join(series.deterClouds.monthly,  by = c("muni_code", "month", "year", "year_prodes")) %>%
  left_join(series.fines.monthly,        by = c("muni_code", "month", "year", "year_prodes")) %>%
  left_join(series.pricesBrazil.monthly, by = c("muni_code", "month", "year")) %>%
  left_join(series.prodes ,              by = c("muni_code", "year_prodes")) %>%
  left_join(series.weatherRain.monthly , by = c("muni_code", "month", "year", "year_prodes")) %>%
  left_join(series.weatherTemp.monthly , by = c("muni_code", "month", "year", "year_prodes")) %>%
  left_join(series.nasaClouds.monthly,   by = c("muni_code", "month", "year", "year_prodes")) %>%
  mutate(fine_count                   = replace_na(fine_count, 0)) %>%
  mutate(fine_sum_sanction_value      = replace_na(fine_sum_sanction_value, 0)) %>%
  dplyr::rename(fines_count                  = fine_count,
         fines_value                  = fine_sum_sanction_value, # dplyr::rename all vars to obey stata limits
         deter_cloud                  = deterCloud_share,
         nasa_cloud                   = nasaCloud_share,
         priceWgtNdx_brzl_m_cattle       = price_r_br_windex_mon_cattle,
         priceWgtNdx_brzl_m_sugar        = price_r_br_windex_mon_sugarcane,
         priceWgtNdx_brzl_m_corn         = price_r_br_windex_mon_corn,
         priceWgtNdx_brzl_m_soybean      = price_r_br_windex_mon_soybean,
         priceWgtNdx_brzl_m_cassava      = price_r_br_windex_mon_cassava,
         priceWgtNdx_brzl_m_rice         = price_r_br_windex_mon_rice,
         prodes_deforest              = prodes_deforest_increment,
         prodes_nonobs                = prodes_nonobserved_area,
         prodes_cloud                 = prodes_cloud_coverage,
         weather_rain                 = weatherRain_total,
         weather_temp                 = weatherTemp_mean,
         prodes03_deforest            = prodes_def_inc_2003,
         prodes03_forest              = prodes_forest_share_2003,
         prodes03_cleared             = prodes_deforest_share_2003) %>%
  dplyr::select(muni_code, month, year, year_prodes, muni_area, deter_cloud, nasa_cloud,
                starts_with("fines"), starts_with("price"), starts_with("prodes"), starts_with("weather")) %>%
  group_by(muni_code, month, year, year_prodes) %>%
  slice(1)

rm(list = ls(pattern = "series."))




# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# check colnames order
colnames(panelMonthly.fromR)


# LABELS
var.labels = c(muni_code                   = "municipality IBGE code (7-digit)",
               month                       = "month of reference",
               year                        = "year of reference",
               year_prodes                 = "PRODES year",
               muni_area                   = "municipal area (ha, calc from sp data under SAD69polyconic)",
               deter_cloud                 = "DETER cloud coverage (share of municipal area; month)",
               nasa_cloud                  =  "NASA cloud coverage (share of municipal area; month)",
               fines_count                 = "number of flora-related fines (count; month)",
               fines_value                 = "value of flora-related fines (BRL; month)",
               priceWgtNdx_brzl_m_cattle      = "real price index, beef cattle (calendar month)",
               priceWgtNdx_brzl_m_rice        = "real price index, rice (month)",
               priceWgtNdx_brzl_m_corn        = "real price index, corn (month)",
               priceWgtNdx_brzl_m_soybean     = "real price index, soybean (month)",
               priceWgtNdx_brzl_m_cassava     = "real price index, cassava (month)",
               priceWgtNdx_brzl_m_sugar       = "real price index, sugarcane (calendar month)",
               prodes_deforest             = "increment in deforested area (sq km; PRODES year)",
               prodes_nonobs               = "area blocked from view during remote sensing (sq km; PRODES year)",
               prodes_cloud                = "area covered by clouds during remote sensing (sq km; PRODES year)",
               prodes03_deforest           = "[xsection] 2003 increment in deforested area (sq km)",
               prodes03_forest             = "[xsection] 2003 forest cover (share of municipal area)",
               prodes03_cleared            = "[xsection] 2003 cleared area (share of municipal area)",
               weather_rain                = "total precipitation (Uni Delaware) (mm; PRODES year)",
               weather_temp                = "average temperature (Uni Delaware) (degrees Celsius; PRODES year)")

label(panelMonthly.fromR) = lapply(names(var.labels), function(x) label(panelMonthly.fromR[,x]) = var.labels[x])




# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(panelMonthly.fromR,
     file = file.path("data/projectSpecific", "panelMonthly_fromR.Rdata"))


write_dta(panelMonthly.fromR,
          path = file.path("data/projectSpecific", "panelMonthly_fromR.dta"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------