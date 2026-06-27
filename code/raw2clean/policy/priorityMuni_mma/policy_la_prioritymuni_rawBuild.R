
# > PROJECT INFO
# NAME: CENTRAL DATA REPOSITORY CONSTRUCTION - AMAZON DEFORESTATION PRIORITY MUNICIPALITIES
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: BUILD DATASET FROM COLLECTED DATA
# AUTHOR: JOAO VIEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/17/2020
#
# > NOTES
# 1: -





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions/setup.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# AUXILIARY DATA
# administrative info for Legal Amazon [to merge with non-priority munis]
load(file = file.path("data/built/administrative/territorial/legal_amazon/",
                      paste0("admin_la_territory_built_muni_spdf", ".Rdata")))





# PREP -----------------------------------------------------------------------------------------------------------------------------------------------

# MUNI IDENTIFIER
# muni names [legal documentation stating muni entry/exit only contains muni names]
muni_name <- c("Labrea",
               "Boca do Acre",
               "Apui",
               "Manicore",
               "Novo Aripuana",
               "Amarante do Maranhao",
               "Grajau",
               "Peixoto de Azevedo",
               "Paranaita",
               "Nova Maringa",
               "Nova Bandeirantes",
               "Juina",
               "Gaucha do Norte",
               "Cotriguacu",
               "Colniza",
               "Aripuana",
               "Juara",
               "Sao Felix do Xingu",
               "Rondon do Para",
               "Novo Repartimento",
               "Novo Progresso",
               "Cumaru do Norte",
               "Altamira",
               "Pacaja",
               "Maraba",
               "Itupiranga",
               "Moju",
               "Senador Jose Porfirio",
               "Anapu",
               "Itaituba",
               "Portel",
               "Porto Velho",
               "Pimenta Bueno",
               "Nova Mamore",
               "Machadinho D'Oeste",
               "Buritis",
               "Candeias do Jamari",
               "Cujubim",
               "Mucajai",
               "Querencia",
               "Marcelandia",
               "Brasnorte",
               "Alta Floresta",
               "Feliz Natal",
               "Alto Boa Vista",
               "Claudia",
               "Confresa",
               "Nova Ubirata",
               "Porto dos Gauchos",
               "Santa Carmem",
               "Sao Felix do Araguaia",
               "Tapurah",
               "Vila Rica",
               "Ulianopolis",
               "Santana do Araguaia",
               "Paragominas",
               "Dom Eliseu",
               "Brasil Novo",
               "Tailandia",
               "Santa Maria das Barreiras")

policy.la.prioritymuni <- as.data.table(muni_name)

policy.la.prioritymuni$muni_name <- toupper(policy.la.prioritymuni$muni_name)

# muni code recovery
admin.la.muni.spdf@data <- admin.la.muni.spdf@data[, c("muni_name", "muni_code")]

policy.la.prioritymuni <- merge(x     = policy.la.prioritymuni,
                                y     = admin.la.muni.spdf,
                                all.x = T,
                                by    = "muni_name")  # visually cross-checked association across muni name/code



# DATA FRAME STRUCTURE
policy.la.prioritymuni$date_entry <- as.character(NA)  # just NA returns column of class logical
policy.la.prioritymuni$date_exit  <- as.character(NA)



# ENVIRONMENT CLEANUP
rm(admin.la.muni.spdf,
   muni_name)





# DATA CONSTRUCTION ----------------------------------------------------------------------------------------------------------------------------------

# PRIORITY ENTRY/EXIST DATES [calendar year]
aux.date.entry.2008        <- "24/01/2008"
aux.date.entry.2009        <- "25/03/2009"
aux.date.entry.2011        <- "25/05/2011"
aux.date.entry.2012        <- "03/10/2012"
aux.date.entry.2017        <- "13/09/2017"

aux.date.exit.2010         <- "25/03/2010"
aux.date.exit.2011         <- "25/04/2011"
aux.date.exit.2012.port187 <- "17/06/2012"
aux.date.exit.2012.port324 <- "03/10/2012"
aux.date.exit.2013         <- "11/10/2013"
aux.date.exit.2017         <- "13/09/2017"



# MUNI/DATE ASSOCIATION
# munis that HAVE NOT left the priority list since entry
if (any(policy.la.prioritymuni[,"muni_name"] == "LABREA")) {
  policy.la.prioritymuni[muni_name  == "LABREA",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "BOCA DO ACRE")) {
  policy.la.prioritymuni[muni_name  == "BOCA DO ACRE",
                         date_entry := aux.date.entry.2011]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "APUI")) {
  policy.la.prioritymuni[muni_name  == "APUI",
                         date_entry := aux.date.entry.2017]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "MANICORE")) {
  policy.la.prioritymuni[muni_name == "MANICORE",
                         date_entry := aux.date.entry.2017]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "NOVO ARIPUANA")) {
  policy.la.prioritymuni[muni_name  == "NOVO ARIPUANA",
                         date_entry := aux.date.entry.2017]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "AMARANTE DO MARANHAO")) {
  policy.la.prioritymuni[muni_name  == "AMARANTE DO MARANHAO",
                         date_entry := aux.date.entry.2009]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "GRAJAU")) {
  policy.la.prioritymuni[muni_name  == "GRAJAU",
                         date_entry := aux.date.entry.2011]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "PEIXOTO DE AZEVEDO")) {
  policy.la.prioritymuni[muni_name  == "PEIXOTO DE AZEVEDO",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "PARANAITA")) {
  policy.la.prioritymuni[muni_name  == "PARANAITA",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "NOVA MARINGA")) {
  policy.la.prioritymuni[muni_name  == "NOVA MARINGA",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "NOVA BANDEIRANTES")) {
  policy.la.prioritymuni[muni_name  == "NOVA BANDEIRANTES",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "JUINA")) {
  policy.la.prioritymuni[muni_name  == "JUINA",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "GAUCHA DO NORTE")) {
  policy.la.prioritymuni[muni_name  == "GAUCHA DO NORTE",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "COTRIGUACU")) {
  policy.la.prioritymuni[muni_name  == "COTRIGUACU",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "COLNIZA")) {
  policy.la.prioritymuni[muni_name  == "COLNIZA",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "ARIPUANA")) {
  policy.la.prioritymuni[muni_name  == "ARIPUANA",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "JUARA")) {
  policy.la.prioritymuni[muni_name  == "JUARA",
                         date_entry := aux.date.entry.2009]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "SAO FELIX DO XINGU")) {
  policy.la.prioritymuni[muni_name  == "SAO FELIX DO XINGU",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "RONDON DO PARA")) {
  policy.la.prioritymuni[muni_name  == "RONDON DO PARA",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "NOVO REPARTIMENTO")) {
  policy.la.prioritymuni[muni_name  == "NOVO REPARTIMENTO",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "NOVO PROGRESSO")) {
  policy.la.prioritymuni[muni_name  == "NOVO PROGRESSO",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "CUMARU DO NORTE")) {
  policy.la.prioritymuni[muni_name  == "CUMARU DO NORTE",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "ALTAMIRA")) {
  policy.la.prioritymuni[muni_name  == "ALTAMIRA",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "PACAJA")) {
  policy.la.prioritymuni[muni_name  == "PACAJA",
                         date_entry := aux.date.entry.2009]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "MARABA")) {
  policy.la.prioritymuni[muni_name  == "MARABA",
                         date_entry := aux.date.entry.2009]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "ITUPIRANGA")) {
  policy.la.prioritymuni[muni_name  == "ITUPIRANGA",
                         date_entry := aux.date.entry.2009]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "MOJU")) {
  policy.la.prioritymuni[muni_name  == "MOJU",
                         date_entry := aux.date.entry.2011]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "SENADOR JOSE PORFIRIO")) {
  policy.la.prioritymuni[muni_name  == "SENADOR JOSE PORFIRIO",
                         date_entry := aux.date.entry.2012]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "ANAPU")) {
  policy.la.prioritymuni[muni_name  == "ANAPU",
                         date_entry := aux.date.entry.2012]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "ITAITUBA")) {
  policy.la.prioritymuni[muni_name  == "ITAITUBA",
                         date_entry := aux.date.entry.2017]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "PORTEL")) {
  policy.la.prioritymuni[muni_name  == "PORTEL",
                         date_entry := aux.date.entry.2017]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "PORTO VELHO")) {
  policy.la.prioritymuni[muni_name  == "PORTO VELHO",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "PIMENTA BUENO")) {
  policy.la.prioritymuni[muni_name  == "PIMENTA BUENO",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "NOVA MAMORE")) {
  policy.la.prioritymuni[muni_name  == "NOVA MAMORE",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "MACHADINHO D'OESTE")) {
  policy.la.prioritymuni[muni_name  == "MACHADINHO D'OESTE",
                         date_entry := aux.date.entry.2008]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "BURITIS")) {
  policy.la.prioritymuni[muni_name  == "BURITIS",
                         date_entry := aux.date.entry.2017]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "CANDEIAS DO JAMARI")) {
  policy.la.prioritymuni[muni_name  == "CANDEIAS DO JAMARI",
                         date_entry := aux.date.entry.2017]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "CUJUBIM")) {
  policy.la.prioritymuni[muni_name  == "CUJUBIM",
                         date_entry := aux.date.entry.2017]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "MUCAJAI")) {
  policy.la.prioritymuni[muni_name  == "MUCAJAI",
                         date_entry := aux.date.entry.2009]
}


# munis that HAVE left the priority list since entry
if (any(policy.la.prioritymuni[,"muni_name"] == "QUERENCIA")) {
  policy.la.prioritymuni[muni_name == "QUERENCIA", date_entry := aux.date.entry.2008]
  policy.la.prioritymuni[muni_name == "QUERENCIA", date_exit  := aux.date.exit.2011 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "MARCELANDIA")) {
  policy.la.prioritymuni[muni_name == "MARCELANDIA", date_entry := aux.date.entry.2008]
  policy.la.prioritymuni[muni_name == "MARCELANDIA", date_exit  := aux.date.exit.2013 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "BRASNORTE")) {
  policy.la.prioritymuni[muni_name == "BRASNORTE", date_entry := aux.date.entry.2008]
  policy.la.prioritymuni[muni_name == "BRASNORTE", date_exit  := aux.date.exit.2013 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "ALTA FLORESTA")) {
  policy.la.prioritymuni[muni_name == "ALTA FLORESTA", date_entry := aux.date.entry.2008       ]
  policy.la.prioritymuni[muni_name == "ALTA FLORESTA", date_exit  := aux.date.exit.2012.port187]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "FELIZ NATAL")) {
  policy.la.prioritymuni[muni_name == "FELIZ NATAL", date_entry := aux.date.entry.2009]
  policy.la.prioritymuni[muni_name == "FELIZ NATAL", date_exit  := aux.date.exit.2013 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "ALTO BOA VISTA")) {
  policy.la.prioritymuni[muni_name == "ALTO BOA VISTA", date_entry := aux.date.entry.2011]
  policy.la.prioritymuni[muni_name == "ALTO BOA VISTA", date_exit  := aux.date.exit.2017 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "CLAUDIA")) {
  policy.la.prioritymuni[muni_name == "CLAUDIA", date_entry := aux.date.entry.2011]
  policy.la.prioritymuni[muni_name == "CLAUDIA", date_exit  := aux.date.exit.2017 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "CONFRESA")) {
  policy.la.prioritymuni[muni_name == "CONFRESA", date_entry := aux.date.entry.2008]
  policy.la.prioritymuni[muni_name == "CONFRESA", date_exit  := aux.date.exit.2017 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "NOVA UBIRATA")) {
  policy.la.prioritymuni[muni_name == "NOVA UBIRATA", date_entry := aux.date.entry.2008]
  policy.la.prioritymuni[muni_name == "NOVA UBIRATA", date_exit  := aux.date.exit.2017 ]
}
if (any(policy.la.prioritymuni[,"muni_name"] == "PORTO DOS GAUCHOS")) {
  policy.la.prioritymuni[muni_name == "PORTO DOS GAUCHOS", date_entry := aux.date.entry.2008]
  policy.la.prioritymuni[muni_name == "PORTO DOS GAUCHOS", date_exit  := aux.date.exit.2017 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "SANTA CARMEM")) {
  policy.la.prioritymuni[muni_name == "SANTA CARMEM", date_entry := aux.date.entry.2011]
  policy.la.prioritymuni[muni_name == "SANTA CARMEM", date_exit  := aux.date.exit.2017 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "SAO FELIX DO ARAGUAIA")) {
  policy.la.prioritymuni[muni_name == "SAO FELIX DO ARAGUAIA", date_entry := aux.date.entry.2008]
  policy.la.prioritymuni[muni_name == "SAO FELIX DO ARAGUAIA", date_exit  := aux.date.exit.2017 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "TAPURAH")) {
  policy.la.prioritymuni[muni_name == "TAPURAH", date_entry := aux.date.entry.2011]
  policy.la.prioritymuni[muni_name == "TAPURAH", date_exit  := aux.date.exit.2017 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "VILA RICA")) {
  policy.la.prioritymuni[muni_name == "VILA RICA", date_entry := aux.date.entry.2008]
  policy.la.prioritymuni[muni_name == "VILA RICA", date_exit  := aux.date.exit.2017 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "ULIANOPOLIS")) {
  policy.la.prioritymuni[muni_name == "ULIANOPOLIS", date_entry := aux.date.entry.2008       ]
  policy.la.prioritymuni[muni_name == "ULIANOPOLIS", date_exit  := aux.date.exit.2012.port324]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "SANTANA DO ARAGUAIA")) {
  policy.la.prioritymuni[muni_name == "SANTANA DO ARAGUAIA", date_entry := aux.date.entry.2008       ]
  policy.la.prioritymuni[muni_name == "SANTANA DO ARAGUAIA", date_exit  := aux.date.exit.2012.port187]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "PARAGOMINAS")) {
  policy.la.prioritymuni[muni_name == "PARAGOMINAS", date_entry := aux.date.entry.2008]
  policy.la.prioritymuni[muni_name == "PARAGOMINAS", date_exit  := aux.date.exit.2010 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "DOM ELISEU")) {
  policy.la.prioritymuni[muni_name == "DOM ELISEU", date_entry := aux.date.entry.2008       ]
  policy.la.prioritymuni[muni_name == "DOM ELISEU", date_exit  := aux.date.exit.2012.port324]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "BRASIL NOVO")) {
  policy.la.prioritymuni[muni_name == "BRASIL NOVO", date_entry := aux.date.entry.2008]
  policy.la.prioritymuni[muni_name == "BRASIL NOVO", date_exit  := aux.date.exit.2013 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "TAILANDIA")) {
  policy.la.prioritymuni[muni_name == "TAILANDIA", date_entry := aux.date.entry.2009]
  policy.la.prioritymuni[muni_name == "TAILANDIA", date_exit  := aux.date.exit.2013 ]
}

if (any(policy.la.prioritymuni[,"muni_name"] == "SANTA MARIA DAS BARREIRAS")) {
  policy.la.prioritymuni[muni_name == "SANTA MARIA DAS BARREIRAS", date_entry := aux.date.entry.2008]
  policy.la.prioritymuni[muni_name == "SANTA MARIA DAS BARREIRAS", date_exit  := aux.date.exit.2017 ]
}

# COLUMN CLEANUP
# class
lapply(policy.la.prioritymuni, class)

policy.la.prioritymuni$muni_code  <- as.numeric(as.character(policy.la.prioritymuni$muni_code))
policy.la.prioritymuni$date_entry <- as.Date(policy.la.prioritymuni$date_entry, "%d/%m/%Y")
policy.la.prioritymuni$date_exit  <- as.Date(policy.la.prioritymuni$date_exit , "%d/%m/%Y")


# sort
policy.la.prioritymuni <- policy.la.prioritymuni[order(policy.la.prioritymuni[, "muni_code"]), ]





# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# LABELS
label(policy.la.prioritymuni$muni_name)  <- "municipality name"
label(policy.la.prioritymuni$muni_code)  <- "municipality code (7-digit, IBGE)"
label(policy.la.prioritymuni$date_entry) <- "date of entry (yyyy/mm/dd)"
label(policy.la.prioritymuni$date_exit)  <- "date of exit  (yyyy/mm/dd); NA if muni never left priority list (through DEC/2017)"



# POST-TREATMENT OVERVIEW
# summary(policy.la.prioritymuni)
# View(policy.la.prioritymuni)





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(policy.la.prioritymuni,
     file = file.path("data/raw2clean/policy/priorityMuni_mma/output",
                      paste0("policy_la_prioritymuni_raw", ".Rdata")))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------