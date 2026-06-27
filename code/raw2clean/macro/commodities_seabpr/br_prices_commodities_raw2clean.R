
# > PROJECT INFO
# TITLE: DATABASE CONSTRUCTION - AGRICULTURAL COMMODITY PRICES (NOMINAL)
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT RAW AGRICULTURAL COMMODITY PRICES
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
# AGRICULTURAL COMMODITY PRICES
# content: product-specific price data (historical series); Parana (extent); state (level); monthly as of 1990 (frequency)
# source:  Agriculture and Supply Secretariat of the State of Parana (SEAB-PR)
# available at: http://www.ipeadata.gov.br
# raw data downloaded on: APR/16/2019
# archive at: https://web.archive.org/web/20200915184800/http://www.ipeadata.gov.br/Default.aspx (main page only)
# web archived on: SEP/15/2020
#
# obs: select products
# average price received by producer - rice - 50kg - PR (arroz em casca)
# average price received by producer - sugarcane - 1t - PR
# average price received by producer - cassava - 1t - PR
# average price received by producer - corn - 60kg - PR
# average price received by producer - soybean - 60kg - PR
# average price received by producer - cattle - arroba - PR (boi gordo) 
#
# obs: originally downloaded as xlsx from Ipeadata but saved as csv
#
# INSTRUCTIONS FOR DOWNLOAD
# 1) insert the url "http://www.ipeadata.gov.br" on the browser
# 2) insert "SEAB-PR arroz em casca" on the "Search:" area then check the box with "Preço médio - recebido pelo agricultor - arroz (em casca) - 50 kg - PR"
# 3) insert "SEAB-PR cana" on the "Search:" area then check the box with "Preço médio - recebido pelo agricultor - cana-de-açúcar - tonelada - PR"
# 4) insert "SEAB-PR mandioca" on the "Search:" area then check the box with "Preço médio - recebido pelo agricultor - mandioca - tonelada - PR"
# 5) insert "SEAB-PR milho" on the "Search:" area then check the box with "Preço médio - recebido pelo agricultor - milho - 60 kg - PR"
# 6) insert "SEAB-PR soja" on the "Search:" area then check the box with "Preço médio - recebido pelo agricultor - soja - 60 kg - PR"
# 7) insert "SEAB-PR boi gordo" on the "Search:" area then check the box with "Preço médio - recebido pelo agricultor - boi gordo - arroba - PR"
# 8) click on "export in CSV (;)" (on the upper right corner) and save the .csv file in the input folder


# CSV INPUT
commodity.prices.df <- read.csv2(file.path("data/raw2clean/macro/commodities_seabpr/input", "commodities - crop and cattle.csv"))



# DATA EXPLORATION
summary(commodity.prices.df)
# View(commodity.prices.df)





# DATASET CLEANUP AND PREP --------------------------------------------------------------------------------------------------------------------------

# COLUMN CLEANUP
# reports column names
names(commodity.prices.df)

# remove unnecessary column
commodity.prices.df <- commodity.prices.df[, -8]

# renames columns
old.names <- names(commodity.prices.df)
new.names <- c("date","price_rice","price_cattle","price_sugarcane","price_cassava","price_corn","price_soybean")
setnames(commodity.prices.df, old = old.names, new = new.names)


# checks column classes
lapply(commodity.prices.df, class)


# sets column classes
commodity.prices.df$date <- as.character(commodity.prices.df$date)


# splits date into month and year
commodity.prices.df$year  <- as.integer(substr(commodity.prices.df$date,1,4))
commodity.prices.df$month <- as.integer(substr(commodity.prices.df$date,6,7))


# selects & orders columns
commodity.prices.df <- commodity.prices.df[c("year", "month", "price_cattle", "price_cassava", "price_corn", "price_rice", "price_soybean",
                                             "price_sugarcane")]


# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# LABELS
label(commodity.prices.df$year)            <- "year"
label(commodity.prices.df$month)           <- "month"
label(commodity.prices.df$price_cattle)    <- "price (nominal), average received by producer - cattle (1@; PR)"
label(commodity.prices.df$price_cassava)   <- "price (nominal), average received by producer - cassava (1t; PR)"
label(commodity.prices.df$price_corn)      <- "price (nominal), average received by producer - corn (60kg; PR)"
label(commodity.prices.df$price_rice)      <- "price (nominal), average received by producer - rice (50kg; PR)"
label(commodity.prices.df$price_soybean)   <- "price (nominal), average received by producer - soybean (60kg; PR"
label(commodity.prices.df$price_sugarcane) <- "price (nominal), average received by producer - sugarcane (1t; PR)"


# change object name for exportation
macro.br.prices.commodities.df <- commodity.prices.df



# POST-TREATMENT OVERVIEW  
summary(macro.br.prices.commodities.df)
# View(macro.br.prices.commodities.df)  # disabled for speed





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(macro.br.prices.commodities.df, 
     file = file.path("data/raw2clean/macro/commodities_seabpr/output", "macro_br_prices_commodities_df.Rdata"))





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------