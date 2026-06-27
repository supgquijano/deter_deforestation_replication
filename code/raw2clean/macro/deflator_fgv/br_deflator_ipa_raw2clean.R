
# > PROJECT INFO
# TITLE: DATABASE CONSTRUCTION - PRICE DEFLATOR
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT RAW PRICE DEFLATOR AND ADOPT 2000.01 AS NEW BASELINE
# AUTHOR: DIEGO MENEZES
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/17/2020
#
# > NOTES
# -





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions/setup.R"))




# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# METADATA
#
# IPA EP DI - INDEX
# content: IPA EP (historical series); Aug. 1994 = 100 (baseline); monthly as of 1944 (frequency)
# source: Fundacao Getulio Vargas, Conjuntura Economica - IGP (FGV/Conj. Econ. - IGP)
# available at: http://www.ipeadata.gov.br
# raw data downloaded on: APR/17/19
# archive at: https://web.archive.org/web/20200915184800/http://www.ipeadata.gov.br/Default.aspx (main page only)
# web archived on: SEP/15/2020
#
# INSTRUCTIONS FOR DOWNLOAD
# 1) insert the url "http://www.ipeadata.gov.br" on the browser
# 2) insert "IPA EP FGV" on the "Search:" area then check the box with "Nome: IPA-DI - geral - índice (ago. 1994 = 100)" and "Freq.: Mensal"
# 3) click on "export in CSV (;)" (on the upper right corner) and save the .csv file in the input folder



# CSV INPUT
deflator.df <- read.csv2(file.path("data/raw2clean/macro/deflator_fgv/input", "ipa_ep_di_indice.csv"))



# DATA EXPLORATION
summary(deflator.df)
# View(deflator.df)





# DATASET CLEANUP AND PREP ---------------------------------------------------------------------------------------------------------------------------

# COLUMN CLEANUP
# reports column names
names(deflator.df)

# remove unnecessary column 
deflator.df <- deflator.df[, -3]

# renames columns
old.names <- names(deflator.df)
new.names <- c("date","IPA_aug94")
setnames(deflator.df, old = old.names, new = new.names)


# sets column classess
lapply(deflator.df, class)
deflator.df$date <- as.character(deflator.df$date)


# splits date into month and year
deflator.df$year  <- as.integer(substr(deflator.df$date,1,4))
deflator.df$month <- as.integer(substr(deflator.df$date,6,7))


# sets 2000.01 as new baseline
base.year                    <- deflator.df$date %in% "2000.01"  # %in% is binary operator for match
deflator.df$deflator_2000_01 <- deflator.df$IPA_aug94 / deflator.df$IPA_aug94[base.year]


# selects & orders columns
deflator.df <- deflator.df[c("year", "month", "deflator_2000_01")]


# removes years pre-1990
deflator.df <- deflator.df[!(deflator.df$year < 1990), ]





# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# LABELS
label(deflator.df$year) <- "year"
label(deflator.df$month) <- "month"
label(deflator.df$deflator_2000_01) <- "deflator (IPA-EP; 2000.01 = 1)"


# change object name for exportation
macro.br.prices.deflator.ipa.df <- deflator.df



# POST-TREATMENT OVERVIEW  
# summary(deflator.df)
# View(deflator.df)  # disabled for speed





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(macro.br.prices.deflator.ipa.df, file = file.path("data/raw2clean/macro/deflator_fgv/output", "macro_br_prices_deflator_ipa_df.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------