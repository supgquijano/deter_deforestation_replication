
# > PROJECT INFO
# TITLE: DATABASE CONSTRUCTION - MUNICIPAL CROP PRODUCTION (PAM)
# LEAD: CLARISSA GANDOUR
# 
# > THIS SCRIPT
# AIM: READ, CONSOLIDATE AND STANDARDIZE RAW DATA FROM PAM FOR SELECT CROPS
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






# FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------
RemoveIBGENotes <- function(x) {  
  
  # REMOVES TYPICAL IBGE TABLE NOTES
  #
  # ARGS
  #   x: data.frame or data.table in which the removal of such notes is necessary
  #
  # RETURNS
  #   data.frame or data.table without the rows that consisted in such notes
  
  if (length (grep("Nota:", x[, 1], value = F)) == 1) {
    
    footnotes <- c(grep("Nota:", x[, 1], value = F), grep ("Fonte:", x[, 1], value = F))
  } else {
    
    footnotes <- c(grep("Fonte:", x[, 1], value = F))
  }
  
  return (x[-footnotes, ])
}

RenameEnglish <- function(x) {
  
  # RENAMES DATA.FRAME OR DATA.TABLE IN ENGLISH
  #
  # ARGS
  #   x: data.frame or data.table in which the names are written in portuguese
  #
  # RETURNS
  #   data.frame or data.table renamed in english
  
  setnames(x, old = "X",                                new = "municipality_code")
  setnames(x, old = "X.1",                              new =              "year")
  setnames(x, old = "Area.plantada..Hectares.",         new =      "planted_area")
  setnames(x, old = "Area.colhida..Hectares.",          new =    "harvested_area")
  setnames(x, old = "Quantidade.produzida..Toneladas.", new = "quantity_produced")
  setnames(x, old = "Valor.da.producao..Mil.Reais.",    new =  "value_production")
}

ExtractCode <- function(x) {
  
  # REMOVES MUNICIPALITIES NAMES, LEAVING OLNY IT'S CODES
  #
  # ARGS
  #   x: data.frame or data.table in which the municipality codes must be extracted
  #
  # RETURNS
  #   data.frame or data.table with "municipality_code" column composed only by the codes

  x$municipality_code <- substr(x$municipality_code, 1, 7)

  return(x)
}

RemoveSpecialNames <- function(x) {
  
  # SUBSTITUTES SPECIAL CHARACTERS IN COLUMN NAMES BY REGULAR CHARACTERS
  #
  # ARGS
  #   x: data.frame or data.table which contains column names with special characters
  #
  # RETURNS
  #   data.frame or data.table without special characters in column names
  
  names(x) <- gsub("À", "A", names(x))
  names(x) <- gsub("Á", "A", names(x))
  names(x) <- gsub("Ã", "A", names(x))
  names(x) <- gsub("Â", "A", names(x))
  names(x) <- gsub("È", "E", names(x))
  names(x) <- gsub("É", "E", names(x))
  names(x) <- gsub("Ê", "E", names(x))
  names(x) <- gsub("Ì", "I", names(x))
  names(x) <- gsub("Í", "I", names(x))
  names(x) <- gsub("Î", "I", names(x))
  names(x) <- gsub("Ò", "O", names(x))
  names(x) <- gsub("Ó", "O", names(x))
  names(x) <- gsub("Õ", "O", names(x))
  names(x) <- gsub("Ô", "O", names(x))
  names(x) <- gsub("Ù", "U", names(x))
  names(x) <- gsub("Ú", "U", names(x))
  names(x) <- gsub("Û", "U", names(x))
  names(x) <- gsub("Ç", "C", names(x)) 
  names(x) <- gsub("à", "a", names(x))
  names(x) <- gsub("á", "a", names(x))
  names(x) <- gsub("ã", "a", names(x))
  names(x) <- gsub("â", "a", names(x))
  names(x) <- gsub("è", "e", names(x))
  names(x) <- gsub("é", "e", names(x))
  names(x) <- gsub("ê", "e", names(x))
  names(x) <- gsub("ì", "i", names(x))
  names(x) <- gsub("í", "i", names(x))
  names(x) <- gsub("î", "i", names(x))
  names(x) <- gsub("ò", "o", names(x))
  names(x) <- gsub("ó", "o", names(x))
  names(x) <- gsub("õ", "o", names(x))
  names(x) <- gsub("ô", "o", names(x))
  names(x) <- gsub("ù", "u", names(x))
  names(x) <- gsub("ú", "u", names(x))
  names(x) <- gsub("û", "u", names(x))
  names(x) <- gsub("ç", "c", names(x))
  
  return(x)
}





# DATA INPUT ----------------------------------------------------------------------------------------------------------------------------------------

# METADATA
#
# MUNICIPAL CROP PRODUCTION (PRODUCAO AGRICOLA MUNICIPAL - PAM)
# content: crop-specific production data (historical series); Brazil (extent); municipality (level); 2000-2015 (period of reference);  
# annual (frequency)
# files: pattern "pam_crop_00_15"
# source: Brazilian Institute for Geography and Statistics (IBGE)
# available at: https://sidra.ibge.gov.br/tabela/1612
# raw data downloaded on: JUN/6/2017 (2000-2015)
# web archived at: not able to archive because the data source needs to prepare it before
#
# obs: 5 separated downloads - one for each crop - cassava, corn, rice, soybean and sugarcane - follow instructions below:
# INSTRUCTIONS FOR DOWNLOAD
# 1) Use each one of the 5 links provided below:
# 1.1) cassava - available at: https://sidra.ibge.gov.br/tabela/1612#/n6/all/v/109,214,215,216/p/2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015/c81/2708/l/,c81+v,t+p/cfg/cod,
# 1.2) corn - available at: https://sidra.ibge.gov.br/tabela/1612#/n6/all/v/109,214,215,216/p/2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015/c81/2711/l/,c81+v,t+p/cfg/cod,
# 1.3) rice - available at: https://sidra.ibge.gov.br/tabela/1612#/n6/all/v/109,214,215,216/p/2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015/c81/2692/l/,c81+v,t+p/cfg/cod,
# 1.4) soybean - available at: https://sidra.ibge.gov.br/tabela/1612#/n6/all/v/109,214,215,216/p/2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015/c81/2713/l/,c81+v,t+p/cfg/cod,
# 1.5) sugarcane - available at: https://sidra.ibge.gov.br/tabela/1612#/n6/all/v/109,214,215,216/p/2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015/c81/2696/l/,c81+v,t+p/cfg/cod,
# 2) Do not change any of the pre-selected options and click on download
# 3) Fill the pop-up 
# 3.1) Nome do arquivo: "pam_*insertCropName*_00_15"
# 3.2) Formato: CSV (US)
# 3.3) Check two boxes "Exibir códigos de territórios" and "Exibir nomes de territórios"
# 3.4) Select "A Posteriori (até 3.000.000 valores)" option
# 3.5) Fill the box "Digite e-mails separados por vírgula" with your email to be notified when the file is ready to be downloaded; example: "email1@hotmail.com,email2@gmail.com"
# 3.6) Press Download



# CSV INPUT
# automates input of individual (annual) csv files

incoming.csv.files <- list.files(path =  "data/raw2clean/agriculture/pam_ibge/input", pattern = "*15.csv")  # lists all csv files in data input directory

setwd("data/raw2clean/agriculture/pam_ibge/input")  # change of WD needed to point lapply to data input folder
pam.all.crops <- lapply(setNames(incoming.csv.files, make.names(gsub("*.csv$", "", incoming.csv.files))), function(x) read.csv2(x, skip = 3))



# DATA EXPLORATION

class(pam.all.crops) 
summary(pam.all.crops)         # object is a list of data frames
# View(pam.all.crops)          # column names indicate file of origin (ie. crop)

summary(pam.all.crops[[1]])    # crop-specific details
# View(pam.all.crops[[1]])     # selects specific crop for inspection





# DATASET CLEANUP AND PREP --------------------------------------------------------------------------------------------------------------------------

# ROW CLEANUP 

# excludes last two lines of the data tables, because they contain the source and some notes
pam.all.crops <- lapply(pam.all.crops, RemoveIBGENotes)



# DATA TRANSFORMATION

# transforms data frame to data table
pam.all.crops <- lapply(pam.all.crops, as.data.table)



# COLUMN CLEANUP

# removes special characters
pam.all.crops <- lapply(pam.all.crops, RemoveSpecialNames)

# reports column names
sapply(pam.all.crops, names)  # all data tables have same column names and order

# renames columns in english
pam.all.crops <- lapply(pam.all.crops, RenameEnglish)

# restricts municipality info to code (excludes name)
pam.all.crops <- lapply(pam.all.crops, ExtractCode)  

# checks columns classes
sapply(pam.all.crops, function(x) x<- x[, .(municipality_code = class(municipality_code), 
                                            year              =              class(year),
                                            planted_area      =      class(planted_area),
                                            harvested_area    =    class(harvested_area),
                                            quantity_produced = class(quantity_produced),
                                            value_production  =  class(value_production))])

# transforms "-" to 0s -- see documentation IBGE missing note
pam.all.crops <- lapply(pam.all.crops, function(x) x<- x[, .(municipality_code = gsub("-", "0", municipality_code),
                                                             year              =              gsub("-", "0", year),
                                                             planted_area      =      gsub("-", "0", planted_area),
                                                             harvested_area    =    gsub("-", "0", harvested_area),
                                                             quantity_produced = gsub("-", "0", quantity_produced),
                                                             value_production  =  gsub("-", "0", value_production))])


# sets column classes
# uses as.numeric(as.character(f)) to transform factor to its original numeric values (as.numeric applied to factor does not recover factor levels)
pam.all.crops <- lapply(pam.all.crops, function(x) x<- x[, .(municipality_code =               as.numeric(municipality_code),
                                                             year              =                            as.numeric(year), 
                                                             planted_area      =      as.numeric(as.character(planted_area)),
                                                             harvested_area    =    as.numeric(as.character(harvested_area)),
                                                             quantity_produced = as.numeric(as.character(quantity_produced)),
                                                             value_production  =  as.numeric(as.character(value_production)))])


# adds crop names to production data
pam.crops.used <- c("cassava", "corn", "rice", "soybean", "sugarcane")

for (i in seq_along(pam.all.crops)) {
  for (j in seq_along(colnames(pam.all.crops[[i]]))) {
    if (colnames(pam.all.crops[[i]])[j] != "municipality_code" & colnames(pam.all.crops[[i]])[j] != "year") {
      colnames(pam.all.crops[[i]])[j] <- paste(colnames(pam.all.crops[[i]])[j], pam.crops.used[i], sep = "_")
    }
  }
} 



# MERGE

# combines crop-specific data frames to yield single dataframe for full panel
pam.all.crops.merged <- Reduce(function(x, y) {merge(x, y, all = T)}, pam.all.crops)  # Reduce used to apply binary function to more than two objects 


                                                                                                                       
# LABELS
label(pam.all.crops.merged$municipality_code)           <- "municipality code (7-digit, IBGE)"
label(pam.all.crops.merged$year)                        <- "year"

label(pam.all.crops.merged$planted_area_cassava)        <- "area, farmland - cassava (ha)"
label(pam.all.crops.merged$harvested_area_cassava)      <- "area, harvested - cassava (ha)"
label(pam.all.crops.merged$value_production_cassava)    <- "production, quantity - cassava (t)"
label(pam.all.crops.merged$quantity_produced_cassava)   <- "production, monetary value - cassava (BRL thousand)"

label(pam.all.crops.merged$planted_area_corn)           <- "area, farmland - corn (ha)"
label(pam.all.crops.merged$harvested_area_corn)         <- "area, harvested - corn (ha)"
label(pam.all.crops.merged$quantity_produced_corn)      <- "production, quantity - corn (t)"
label(pam.all.crops.merged$value_production_corn)       <- "production, monetary value - corn (BRL thousand)"

label(pam.all.crops.merged$planted_area_rice)           <- "area, farmland - rice (ha)"
label(pam.all.crops.merged$harvested_area_rice)         <- "area, harvested - rice (ha)"
label(pam.all.crops.merged$quantity_produced_rice)      <- "production, quantity - rice (t)"
label(pam.all.crops.merged$value_production_rice)       <- "production, monetary value - rice (BRL thousand)"

label(pam.all.crops.merged$planted_area_soybean)        <- "area, farmland - soybean (ha)"
label(pam.all.crops.merged$harvested_area_soybean)      <- "area, harvested - soybean (ha)"
label(pam.all.crops.merged$quantity_produced_soybean)   <- "production, quantity - soybean (t)"
label(pam.all.crops.merged$value_production_soybean)    <- "production, monetary value - soybean (BRL thousand)"

label(pam.all.crops.merged$planted_area_sugarcane)      <- "area, farmland - sugarcane (ha)"
label(pam.all.crops.merged$harvested_area_sugarcane)    <- "area, harvested - sugarcane (ha)"
label(pam.all.crops.merged$quantity_produced_sugarcane) <- "production, quantity - sugarcane (t)"
label(pam.all.crops.merged$value_production_sugarcane)  <- "production, monetary value - sugarcane (BRL thousand)"


# change object name
ag.br.pam.5crops.df <- pam.all.crops.merged



# POST-TREATMENT OVERVIEW  
# summary(pam.all.crops.merged) # no indication of fully missing row; no NAs
# View(pam.all.crops.merged)    # disabled for speed


# fix change in working dir  to go back to the project level
setwd("../../../../..")

# EXPORT --------------------------------------------------------------------------------------------------------------------------------------------

save(ag.br.pam.5crops.df, file = file.path("data/raw2clean/agriculture/pam_ibge/output", "ag_br_pam_5crops_df.Rdata"))





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------
