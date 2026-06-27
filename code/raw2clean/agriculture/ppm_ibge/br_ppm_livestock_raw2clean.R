
# > PROJECT INFO
# TITLE: DATABASE CONSTRUCTION - MUNICIPAL LIVESTOCK SURVEY (PPM)
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: READ, CONSOLIDATE AND STANDARDIZE RAW DATA FROM PPM FOR SELECT PRODUCTS
# AUTHOR: DIEGO MENEZES
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
# MUNICIPAL LIVESTOCK SURVEY (PESQUISA PECUARIA MUNICIPAL - PPM)
# content: livestock by types (content); Brazil (extent); municipality (level); yearly (frequency)
# source: Brazilian Institute for Geography and Statistics (IBGE)
# available at: https://sidra.ibge.gov.br/tabela/3939
# raw data downloaded on: MAR/03/2018 (2000-2016)
# web archived at: not able to archive because the data source needs to prepare it before
#
# INSTRUCTIONS FOR DOWNLOAD
# 1) Use the following link: https://sidra.ibge.gov.br/tabela/3939#/n6/all/v/all/p/2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016/c79/2670,2672,2675,2677,2680,2681,32794,32796/l/v,c79,t+p
# 2) Do not change any of the pre-selected options and click on download
# 3) Fill the pop-up 
# 3.1) Nome do arquivo: "ppm_livestock_all"
# 3.2) Formato: CSV (US)
# 3.3) Check box "Exibir códigos de territórios" 
# 3.4) Select "A Posteriori (até 3.000.000 valores)" option
# 3.5) Fill the box "Digite e-mails separados por vírgula" with your email to be notified when the file is ready to be downloaded; example: "email1@hotmail.com,email2@gmail.com"
# 3.6) Press Download
#
# obs:
# missing data:
# 720 rows with NAs in every column from 121 different municipalities.



# CSV INPUT
# col.names used to avoid using row.names = NULL, which interfered with column names
ppm.livestock.all <- read.csv2(file.path("data/raw2clean/agriculture/ppm_ibge/input", "ppm_livestock_all.csv"), header = F, skip = 4, 
                               col.names = c("muni_code", "year", "livestock_head_bovine", "livestock_head_buffalo","livestock_head_equine", 
                                             "livestock_head_pork",  "livestock_head_goat", "livestock_head_sheep", "livestock_head_gallinaceous", 
                                             "livestock_head_quail"))



# DATA EXPLORATION
# summary(ppm.livestock.all) # object is data frame
# View(ppm.livestock.all)    # disabled for speed





# DATASET CLEANUP AND PREP --------------------------------------------------------------------------------------------------------------------------

# DATA TRANSFORMATION
# transforms data frame to data table
setDT(ppm.livestock.all)



# ROW CLEANUP
# excludes last two lines of the data table, because it contains the source and some notes
ppm.livestock.all <- ppm.livestock.all[!c(.N, .N - 1, .N-2, .N-3, .N-4), ]



# COLUMN CLEANUP
# reports column names
names(ppm.livestock.all)

# checks columns classes
lapply(ppm.livestock.all, class)

# sets column classes
# transforms into character first because of missing data types treatment ("-")
# uses as.numeric(as.character(f)) to transform factor to its original numeric values (as.numeric applied to factor does not recover factor levels)
ppm.livestock.all <- ppm.livestock.all[, muni_code    := as.numeric(as.character(muni_code))]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_bovine       := as.character(livestock_head_bovine)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_buffalo      := as.character(livestock_head_buffalo)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_equine       := as.character(livestock_head_equine)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_pork         := as.character(livestock_head_pork)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_goat         := as.character(livestock_head_goat)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_sheep        := as.character(livestock_head_sheep)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_gallinaceous := as.character(livestock_head_gallinaceous)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_quail        := as.character(livestock_head_quail)]

# transforms "-" to 0s -- see documentation IBGE missing note
ppm.livestock.all$livestock_head_bovine       <- gsub(x = ppm.livestock.all$livestock_head_bovine,       pattern = "-", replacement = "0")
ppm.livestock.all$livestock_head_buffalo      <- gsub(x = ppm.livestock.all$livestock_head_buffalo,      pattern = "-", replacement = "0")
ppm.livestock.all$livestock_head_equine       <- gsub(x = ppm.livestock.all$livestock_head_equine,       pattern = "-", replacement = "0")
ppm.livestock.all$livestock_head_pork         <- gsub(x = ppm.livestock.all$livestock_head_pork,         pattern = "-", replacement = "0")
ppm.livestock.all$livestock_head_goat         <- gsub(x = ppm.livestock.all$livestock_head_goat,         pattern = "-", replacement = "0")
ppm.livestock.all$livestock_head_sheep        <- gsub(x = ppm.livestock.all$livestock_head_sheep,        pattern = "-", replacement = "0")
ppm.livestock.all$livestock_head_gallinaceous <- gsub(x = ppm.livestock.all$livestock_head_gallinaceous, pattern = "-", replacement = "0")
ppm.livestock.all$livestock_head_quail        <- gsub(x = ppm.livestock.all$livestock_head_quail,        pattern = "-", replacement = "0")

# sets column classes
# transforms character into numeric
ppm.livestock.all <- ppm.livestock.all[, livestock_head_bovine       := as.numeric(livestock_head_bovine)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_buffalo      := as.numeric(livestock_head_buffalo)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_equine       := as.numeric(livestock_head_equine)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_pork         := as.numeric(livestock_head_pork)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_goat         := as.numeric(livestock_head_goat)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_sheep        := as.numeric(livestock_head_sheep)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_gallinaceous := as.numeric(livestock_head_gallinaceous)]
ppm.livestock.all <- ppm.livestock.all[, livestock_head_quail        := as.numeric(livestock_head_quail)]





# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# LABELS
label(ppm.livestock.all$muni_code)                   <- "municipality code (7-digit, IBGE)"
label(ppm.livestock.all$year)                        <- "year of reference"
label(ppm.livestock.all$livestock_head_bovine)       <- "stock, quantity - bovine"
label(ppm.livestock.all$livestock_head_buffalo)      <- "stock, quantity - buffalo"
label(ppm.livestock.all$livestock_head_equine)       <- "stock, quantity - equine"
label(ppm.livestock.all$livestock_head_pork)         <- "stock, quantity - pork"
label(ppm.livestock.all$livestock_head_goat)         <- "stock, quantity - goat"
label(ppm.livestock.all$livestock_head_sheep)        <- "stock, quantity - sheep"
label(ppm.livestock.all$livestock_head_gallinaceous) <- "stock, quantity - gallinaceous"
label(ppm.livestock.all$livestock_head_quail)        <- "stock, quantity - quail"


# change object name
ag.br.ppm.livestock.all.df <- ppm.livestock.all



# POST-TREATMENT OVERVIEW 
# summary(ppm.livestock.all)  # no indication of fully missing row; NAs throughout
# View(ppm.livestock.all)    # disabled for speed





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(ag.br.ppm.livestock.all.df, file = file.path("data/raw2clean/agriculture/ppm_ibge/output", "ag_br_ppm_livestock_all_df.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------