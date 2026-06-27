
# > PROJECT INFO
# TITLE: DATABASE CONSTRUCTION - MUNICIPAL CROP PRODUCTION (PAM)
# LEAD: CLARISSA GANDOUR
# 
# > THIS SCRIPT
# AIM: READ AND CLEAN PAM TOTALS FOR ALL CROPS
# AUTHOR: JOAO VIEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/17/2020
#
# > NOTES
# -




# SETUP ---------------------------------------------------------------------------------------------------------------------------------------------


# SOURCES
source(file.path("code/_functions/setup.R"))




# LIBRARIES
# called in the setup.R script






# DATA INPUT ----------------------------------------------------------------------------------------------------------------------------------------

# METADATA
#
# MUNICIPAL CROP PRODUCTION (PRODUCAO AGRICOLA MUNICIPAL - PAM)
# content: total production data (historical series); Brazil (extent); municipality (level); 2000-2017 (period of reference);  
# annual (frequency)
# files: pattern "pam_total_00_17"
# source: Brazilian Institute for Geography and Statistics (IBGE)
# available at: https://sidra.ibge.gov.br/tabela/5457
# raw data downloaded on: MAY/13/2019 (2000-2017)
# web archived at: not able to archive because the data source needs to prepare it before)
#
# INSTRUCTIONS FOR DOWNLOAD
# 1) Use the following link: "https://sidra.ibge.gov.br/tabela/5457#/n6/all/v/214,215,216,8331/p/2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017/c782/0/l/,c782+v,t+p"
# 2) Do not change any of the pre-selected options and click on download
# 3) Fill the pop-up 
# 3.1) Nome do arquivo: "pam_total_00_17"
# 3.2) Formato: CSV (US)
# 3.3) Check two boxes "Exibir códigos de territórios" and "Exibir nomes de territórios"
# 3.4) Select "A Posteriori (até 3.000.000 valores)" option
# 3.5) Fill the box "Digite e-mails separados por vírgula" with your email to be notified when the file is ready to be downloaded; example: "email1@hotmail.com,email2@gmail.com"
# 3.6) Press Download

# CSV INPUT
ag.br.pam.all.crops <- read_csv(file = file.path("data/raw2clean/agriculture/pam_ibge/input", "pam_total_00_17.csv"), 
                                             skip = 4, na = "...", skip_empty_rows = T, 
                                col_names = c("muni_code", "year", "planted_area_all_crops", "havested_area_all_crops", 
                                              "produced_quantity_all_crops", "production_value_all_crops"),
                                col_types = cols(planted_area_all_crops = col_character(),
                                                 havested_area_all_crops = col_character(),
                                                 production_value_all_crops = col_character()))



# DATASET CLEANUP AND PREP --------------------------------------------------------------------------------------------------------------------------

ag.br.pam.all.crops <-
  ag.br.pam.all.crops %>% 
  mutate(planted_area_all_crops = as.numeric(recode(planted_area_all_crops, "-" = "0")),
         havested_area_all_crops = as.numeric(recode(havested_area_all_crops, "-" = "0")),
         production_value_all_crops = as.numeric(recode(production_value_all_crops, "-" = "0"))) %>% # convert "-" to 0s - see documentation "notes_IBGE_missing"
  dplyr::select(-produced_quantity_all_crops) %>% 
  filter_all(any_vars(!is.na(.)))






# EXPORT --------------------------------------------------------------------------------------------------------------------------------------------

save(ag.br.pam.all.crops, file = file.path("data/raw2clean/agriculture/pam_ibge/output", "ag_br_pam_all_crops.Rdata"))





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------
