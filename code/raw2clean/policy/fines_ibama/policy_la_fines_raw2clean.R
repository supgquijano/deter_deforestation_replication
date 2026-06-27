
# > PROJECT INFO
# NAME: CENTRAL DATA REPOSITORY CONSTRUCTION - LAW ENFORCEMENT [ENVIRONMENTAL FINES]
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT RAW DATA
# AUTHOR: DIEGO MENEZES & JOAO VIEIRA
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




# DATA INPUT: ---------------------------------------------------------------------------------------------------------------------------------------

# METADATA
#
# ENVIRONMENTAL SANCTIONS (FINES)
# files: original 'amaz_legal_infracao_ambiental_original.xls' was multitab Excel document; converted to multiple csv files via Excel export
# content: history of issued environmental fines (.xls file); Brazilian Legal Amazon (extent); 2000-2015 (period of reference)
# source: Brazilian Institute for the Environment and Renewable Natural Resources (IBAMA)
# available: upon request via e-SIC (Sistema Eletronico do Servico de Informacao ao Cidadao) [https://esic.cgu.gov.br/sistema/site/index.html]
# raw data received on: MAY/2016 
# obs: raw data sent by mail in physical media (to Christiane Szerman, CPI Research Assistant, who placed the data request at e-SIC)
#
# INSTRUCTIONS FOR DOWNLOAD (at the time the method explained below was not available)
# 1) insert the url "https://servicos.ibama.gov.br/ctf/publico/areasembargadas/ConsultaPublicaAreasEmbargadas.php" on a mozila firefox browser (this method does not work using google chrome) 
# 2) select "Autuações Ambientais" in "Consulta Pública"
# 3) Select "Todos" in "Tipo de Infração"
# 4) For each year of input data (YYYY = 2000 through 2015):
#	4.1) fill "Período de *" with "01/01/YYYY" 
#	4.2) fill "até" with "31/12/YYYY"
#	4.3) click on the green button "Exportar Planilha" (right-bottom corner)
# obs: the .R scripts provided will need to be adapted due to format differences between both ways of obtaining the data but the original .R files can be used as reference 


# CSV INPUT

# environmental violation fines brazilian legal amazon
# automates input of individual csv files
incoming.csv.files <- list.files(path = "data/raw2clean/policy/fines_ibama/input", pattern = "*.csv", 
                                 full.names = T)  # lists all csv files in data input directory
legamaz.all.fines  <- lapply(setNames(incoming.csv.files, make.names(gsub("*.csv$", "", incoming.csv.files))), read.csv2)



# AUXILIARY INPUT

# brazilian municipalities
load(file = file.path("data/raw2clean/administrative/territorial_ibge/brazil/output/2007", "admin_br_territory_muni_2007_df.Rdata"))



# DATA EXPLORATION

# View(legamaz.all.fines[[1]])
# view(admin.br.muni)





# DATASET CLEANUP AND PREP: -------------------------------------------------------------------------------------------------------------------------

# MERGE

# uses 'rbind' instead of 'merge' because I have the same columns in different csv tabs
# each tab has the continuation of the data in the previous one
for (i in 2:length(legamaz.all.fines)) {

  legamaz.all.fines[[1]] <- rbind(legamaz.all.fines[[1]], legamaz.all.fines[[i]])

}

legamaz.all.fines.merged <- legamaz.all.fines[[1]]



# COLUMN CLEANUP

# transformes data.frame to data.table
setDT(legamaz.all.fines.merged)

# removes useless columns
useless.columns <-  c("X", "VALOR_AUTO_FORMATADO", "DES_TIPO_LEGISLACAO","ARTIGO",   # "DES_TIPO_LEGISLACAO" needed to be dropped because of an error> 
                      "PARAGRAFO", "COM_ARTIGO", "COM_PARAGRAFO")                    # on the input database, it was mixed in multiple rows 
legamaz.all.fines.merged <- legamaz.all.fines.merged[, (useless.columns) := NULL]


# renames columns in English
setnames(legamaz.all.fines.merged, "TIPO_INFRACAO"    , "violation")
setnames(legamaz.all.fines.merged, "DATA_AUTUACAO"    , "fine_sanction_date")
setnames(legamaz.all.fines.merged, "SIG_UF"           , "state_uf")
setnames(legamaz.all.fines.merged, "NOM_MUNICIPIO"    , "muni_name")
setnames(legamaz.all.fines.merged, "NUM_AUTO_INFRACAO", "fine_sanction_code")
setnames(legamaz.all.fines.merged, "SER_AUTO_INFRACAO", "fine_sanction_serie")
setnames(legamaz.all.fines.merged, "VALOR_AUTO"       , "fine_sanction_value")


# changes the encoding to remove the accents 
legamaz.all.fines.merged$violation <- iconv(legamaz.all.fines.merged$violation, from = "latin1", to = "ASCII//TRANSLIT")

# exludes rows with duplicated fines,> 
# fines are certainly duplicated because there are multiple rows with the same sanction_code which should be unique
legamaz.all.fines.merged <- unique(legamaz.all.fines.merged, by = "fine_sanction_code")

# there were two negatives sanction_values for mucajai and brasileia that should be positive, checking the original data base for brasileia> 
# and assuming typo error for mucajai, the original data for these fines can be checked on the documentation 
legamaz.all.fines.merged$fine_sanction_value <- abs(legamaz.all.fines.merged$fine_sanction_value) 


# excludes the hours from the column 'fine_sanction_date'
legamaz.all.fines.merged <- legamaz.all.fines.merged[, fine_sanction_date:=as.character(fine_sanction_date)] # 'strsplit' just work when its>
                                                                                                              # argument has mode character 
legamaz.all.fines.merged$fine_sanction_date = lapply(strsplit(legamaz.all.fines.merged$fine_sanction_date, split=" "), "[", 1)  # splits keeping only> 
                                                                                                                                # the date

# extracts month and year from the column 'fine_sanction_date'
legamaz.all.fines.merged$fine_sanction_month <- substr(legamaz.all.fines.merged$fine_sanction_date,4,5)
legamaz.all.fines.merged$fine_sanction_year  <- substr(legamaz.all.fines.merged$fine_sanction_date,7,10)


# finding the municipalities names that requires adjustments
admin.br.muni.2007.df           <- admin.br.muni.2007.df[, c("state_uf", "muni_name", "muni_code")]  # extracting only the necessary info> 
admin.br.muni.2007.df$muni_name <- toupper(admin.br.muni.2007.df$muni_name)                          # for comparison and merging

mismatch.muni.name <- legamaz.all.fines.merged[!(legamaz.all.fines.merged$muni_name 
                                                 %in% admin.br.muni.2007.df$muni_name)]  # use View(mismatch.muni.name) to> 
                                                                                         # see which muni_names needs adjustments

# it's necessary making some adjustments in municipalities names so the 'matching' in the function merge below can work better
legamaz.all.fines.merged$muni_name <- as.character(legamaz.all.fines.merged$muni_name)  # 'gsub' just work when its argument has mode character

legamaz.all.fines.merged$muni_name <- gsub(pattern = "GOVERNADOR EDSON LOBAO", replacement = "GOVERNADOR EDISON LOBAO",
                                           x = legamaz.all.fines.merged$muni_name)

legamaz.all.fines.merged$muni_name <- gsub(pattern = "SAO LUIZ DO ANUAA", replacement = "SAO LUIZ",
                                           x = legamaz.all.fines.merged$muni_name)

legamaz.all.fines.merged$muni_name <- gsub(pattern = "COUTO DE MAGALHAES", replacement = "COUTO MAGALHAES",
                                           x = legamaz.all.fines.merged$muni_name)

# 'MOJUI DOS CAMPOS' was recently emancipated from 'SANTAREM' -- see documentation
# however, there is no code for this new municipality in the file "br_municipalities_2007.Rdata" yet, so will consider it as being 'SANTAREM'
legamaz.all.fines.merged$muni_name <- gsub(pattern = "MOJUI DOS CAMPOS", replacement = "SANTAREM",
                                           x = legamaz.all.fines.merged$muni_name)

# includes municipalies code
legamaz.all.fines.merged <- merge(legamaz.all.fines.merged, admin.br.muni.2007.df, all.x = T, by = c("muni_name", "state_uf"))


# treats municipality code with 'NA'
# there is only one municipality whose name does not exist; the municipality 'RORAIMA'
# as this municipality does not exist neither does its code and that is why I am going to exclude it
legamaz.all.fines.merged <- legamaz.all.fines.merged[!(legamaz.all.fines.merged$muni_name == "RORAIMA"), ]


# orders and sorts columns
legamaz.all.fines.merged <- legamaz.all.fines.merged[, muni_name := NULL]  # after including muni codes, muni names are no longer necessary

setcolorder(legamaz.all.fines.merged, c("muni_code", "state_uf", "violation", "fine_sanction_date", "fine_sanction_month",
                                        "fine_sanction_year", "fine_sanction_code", "fine_sanction_serie", "fine_sanction_value"))


# changes column classes

# changes the class of fine_sanction_date from character to date
legamaz.all.fines.merged$fine_sanction_date <- gsub(' ', '', legamaz.all.fines.merged$fine_sanction_date)  # as.Date doesn't work with sep = " "
legamaz.all.fines.merged$fine_sanction_date <- as.Date(legamaz.all.fines.merged$fine_sanction_date, 
                                                       format = "%d/%m/%Y")                                # converts to date with "YYYY-dd-mm" format 

# changes the class of violation from factor to character
legamaz.all.fines.merged <- legamaz.all.fines.merged[, violation:=as.character(violation)]

# changes the class of month and year from character to numeric
legamaz.all.fines.merged <- legamaz.all.fines.merged[, fine_sanction_month:=as.numeric(fine_sanction_month)]
legamaz.all.fines.merged <- legamaz.all.fines.merged[, fine_sanction_year:=as.numeric(fine_sanction_year)]


# translates types of violation to English
legamaz.all.fines.merged$violation <- gsub(pattern = "Pesca", replacement = "Fishing",
                                           x = legamaz.all.fines.merged$violation)

legamaz.all.fines.merged$violation <- gsub(pattern = "Controle ambiental", replacement = "Environmental control",
                                           x = legamaz.all.fines.merged$violation)

legamaz.all.fines.merged$violation <- gsub(pattern = "Cadastro Tecnico Federal", replacement = "Federal Technical Registration", 
                                           x = legamaz.all.fines.merged$violation)

legamaz.all.fines.merged$violation <- gsub(pattern = "Ecossistema", replacement = "Ecosystem",
                                           x = legamaz.all.fines.merged$violation)

legamaz.all.fines.merged$violation <- gsub(pattern = "Outras", replacement = "Others",
                                           x = legamaz.all.fines.merged$violation)

legamaz.all.fines.merged$violation <- gsub(pattern = "Unidades de conservacao", replacement = "Conservation units", 
                                           x = legamaz.all.fines.merged$violation)

legamaz.all.fines.merged$violation <- gsub(pattern = "Ordenamento urbano e Contr. patrim.", replacement = "Urban planning and patrimonial Control",
                                           x = legamaz.all.fines.merged$violation)

legamaz.all.fines.merged$violation <- gsub(pattern = "Org. Gen. Modific. e Biopirataria", replacement = "Genetically Modified Organism and Biopiracy",
                                           x = legamaz.all.fines.merged$violation)


# orders rows by fine_sanction_date
legamaz.all.fines.merged <- legamaz.all.fines.merged[order(fine_sanction_date)]





# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# LABELS 
label(legamaz.all.fines.merged$muni_code)           <- "municipality code (7-digit, IBGE)" 
label(legamaz.all.fines.merged$state_uf)            <- "state name (abbreviation)"
label(legamaz.all.fines.merged$violation)           <- "type of violation"
label(legamaz.all.fines.merged$fine_sanction_date)  <- "refers to issue date with format yyyy/mm/dd" 
label(legamaz.all.fines.merged$fine_sanction_month) <- "refers to issue month"  
label(legamaz.all.fines.merged$fine_sanction_year)  <- "refers to issue year"
label(legamaz.all.fines.merged$fine_sanction_code)  <- "sanction code"
label(legamaz.all.fines.merged$fine_sanction_serie) <- "sanction serie"
label(legamaz.all.fines.merged$fine_sanction_value) <- "refers to issue value"


# change object name for exportation  
policy.la.fines.df <- legamaz.all.fines.merged



# POST-TREATMENT OVERVIEW
#summary(legamaz.all.fines.merged)
#View(legamaz.all.fines.merged)





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(policy.la.fines.df,
     file = file.path("data/raw2clean/policy/fines_ibama/output", "policy_la_fines_df.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------