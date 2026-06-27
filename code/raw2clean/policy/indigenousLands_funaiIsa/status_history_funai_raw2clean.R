
# > PROJECT INFO
# NAME: DATABASE CONSTRUCTION - BRAZILIAN INDIGENOUS LANDS
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT FUNAIS'S DATASET ON INDIGENOUS LAND STATUS HISTORY
# AUTHOR: (ADAPTED FROM) PEDRO PEIXOTO
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/18/2020
#
# > NOTES






# SETUP ---------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions/setup.R"))
source(file.path("code/_functions/string.R"))
source(file.path("code/raw2clean/policy/indigenousLands_funaiIsa", "functions_project_specific.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT ----------------------------------------------------------------------------------------------------------------------------------------

# METADATA
#
#  DEMARCATION STATUS HISTORY - FUNAI DATABASE
# file: 'Documentos_TI.csv'
# content: demarcation status history for select indigenous lands (.csv file)
# source: Brazilian National Native Foundation (FUNAI)
# available at: direct requirement from Jose Antonio de Sa (Coordenador-Geral de Geoprocessamento, Diretoria de Protecao Territorial / FUNAI)
# raw data downloaded on: MAR/18/2016
# archived at: https://web.archive.org/web/20200918123106/http://geoserver.funai.gov.br/geoserver/Funai/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=Funai%3Avw_geo_ti_documentos_sii_sirgas2000&outputFormat=csv (this link was not available at the time of download)
# raw data archived on: SEP/18/2020



# DATA INPUT
status.history.funai <- read.csv2(file.path("data/raw2clean/policy/indigenousLands_funaiIsa/input", 'Documentos_TI.csv'))  # raw data on demarcation status history



# DATA EXPLORATION
summary(status.history.funai)  # contains NAs
#View(status.history.funai)    # disabled for speed





# DATASET CLEANUP AND PREP --------------------------------------------------------------------------------------------------------------------------

# COLUMN CLEANUP
# class
lapply(status.history.funai, class)

status.history.funai$terrai_codigo     <- as.character(status.history.funai$terrai_codigo)
status.history.funai$terrai_nome       <- as.character(status.history.funai$terrai_nome)

status.history.funai$data_em_estudo    <- as.Date(status.history.funai$data_em_estudo,    format = "%Y-%m-%d")
status.history.funai$data_delimitada   <- as.Date(status.history.funai$data_delimitada,   format = "%Y-%m-%d")
status.history.funai$data_declarada    <- as.Date(status.history.funai$data_declarada,    format = "%Y-%m-%d")
status.history.funai$data_homologada   <- as.Date(status.history.funai$data_homologada,   format = "%Y-%m-%d")
status.history.funai$data_regularizada <- as.Date(status.history.funai$data_regularizada, format = "%Y-%m-%d")


# subset
cols.keep <- c("terrai_codigo", "terrai_nome", "municipio_nome", "uf_sigla", "fase_ti", "modalidade_ti", "data_em_estudo", "data_delimitada",
               "data_declarada", "data_homologada", "data_regularizada")

status.history.funai <- status.history.funai[cols.keep]  # drops columns detailing status-specific legal documentation



# ROW CLEANUP
# original data contains an irreparable corrupt line entry, identified by name 'Matr. R-1-183, Lv. 2-B, Fl. 83/84v'
corrupt.line <- as.numeric(row.names(status.history.funai[status.history.funai$terrai_codigo == "Matr. R-1-183, Lv. 2-B, Fl. 83/84v", ]))


# subset
status.history.funai <- status.history.funai[-corrupt.line, ]



# LATIN CHARACTER TREATMENT
status.history.funai <- LatinCharacterConversion(status.history.funai, FROM_enc = "", TO_enc = "ASCII//TRANSLIT")



# TRANSLATION
# column names
names(status.history.funai)[names(status.history.funai) == "terrai_codigo"]     <- "IL_code"
names(status.history.funai)[names(status.history.funai) == "terrai_nome"]       <- "IL_name"
names(status.history.funai)[names(status.history.funai) == "municipio_nome"]    <- "muni_name"
names(status.history.funai)[names(status.history.funai) == "uf_sigla"]          <- "state_uf"
names(status.history.funai)[names(status.history.funai) == "fase_ti"]           <- "demarcation_status"
names(status.history.funai)[names(status.history.funai) == "modalidade_ti"]     <- "IL_type"
names(status.history.funai)[names(status.history.funai) == "data_em_estudo"]    <- "date_under_assessment"
names(status.history.funai)[names(status.history.funai) == "data_delimitada"]   <- "date_delimited"
names(status.history.funai)[names(status.history.funai) == "data_declarada"]    <- "date_declared"
names(status.history.funai)[names(status.history.funai) == "data_homologada"]   <- "date_approved"
names(status.history.funai)[names(status.history.funai) == "data_regularizada"] <- "date_regularized"


# column content
status.history.funai$demarcation_status <- StringTrim(status.history.funai$demarcation_status)
status.history.funai$IL_type            <- StringTrim(status.history.funai$IL_type)

status.history.funai$demarcation_status <- sub(pattern = "Em Estudo",      replacement = "under assessment", status.history.funai$demarcation_status)
status.history.funai$demarcation_status <- sub(pattern = "Delimitada",     replacement = "delimited",        status.history.funai$demarcation_status)
status.history.funai$demarcation_status <- sub(pattern = "Declarada",      replacement = "declared",         status.history.funai$demarcation_status)
status.history.funai$demarcation_status <- sub(pattern = "Homologada",     replacement = "approved",         status.history.funai$demarcation_status)
status.history.funai$demarcation_status <- sub(pattern = "Regularizada",   replacement = "regularized",      status.history.funai$demarcation_status)
status.history.funai$demarcation_status <- sub(pattern = "Encaminhada RI", replacement = "submitted as indigenous reserve",
                                                                                                             status.history.funai$demarcation_status)

status.history.funai$IL_type <- sub(pattern = "Dominial Indigena" ,        replacement = "indigenous dominium",    status.history.funai$IL_type)
status.history.funai$IL_type <- sub(pattern = "Interditada" ,              replacement = "interdicted",            status.history.funai$IL_type)
status.history.funai$IL_type <- sub(pattern = "Reserva Indigena" ,         replacement = "indigenous reserve",     status.history.funai$IL_type)
status.history.funai$IL_type <- sub(pattern = "Tradicionalmente ocupada" , replacement = "traditionally occupied", status.history.funai$IL_type)

status.history.funai$demarcation_status <- as.factor(status.history.funai$demarcation_status)
status.history.funai$IL_type            <- as.factor(status.history.funai$IL_type)





# POST-TREATMENT OVERVIEW  --------------------------------------------------------------------------------------------------------------------------

summary(status.history.funai)
# View(status.history.funai)  # disabled for speed





# EXPORT --------------------------------------------------------------------------------------------------------------------------------------------

save(status.history.funai, file = file.path("data/raw2clean/policy/indigenousLands_funaiIsa/output", "temp_status_history_funai.RData"))





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------