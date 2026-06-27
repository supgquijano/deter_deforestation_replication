
# > PROJECT INFO
# NAME: DATABASE CONSTRUCTION - BRAZILIAN INDIGENOUS LANDS
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT ISA'S SCRAPPED DATASET ON INDIGENOUS LAND STATUS HISTORY
# AUTHOR: (ADAPTED FROM) PEDRO PEIXOTO
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/18/2020
#
# > NOTES
# 1. THIS SCRIPT'S OUTPUT IS NOT MEANT TO REPLACE FUNAI'S STATUS HISTORY DATA. RATHER, IT IS BUILT TO COMPLEMENT MISSING DATA AND ADDRESS
#    IRREGULARRITIES (DUPLICATE ENTRIES REFERING TO DIFFERENT PROCEEDINGS FOR THE SAME AREA) IN FUNAI DATA. RAW FUNAI DATA CONTAIN NO INDICATION, NOR
#    METADATA, THAT ALLOWS THESE ISSUES TO BE ADDRESSED WITHOUT RESORTING TO AN ALTERNATIVE SOURCE FOR STATUS HISTORY.





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
# DEMARCATION STATUS HISTORY - ISA DATABASE
# file: 'status_history_isa_scrapped.RData'
# content: demarcation status history for indigenous lands (.RData file created via data scrapping of ISA's website)
# source: Socio-Environmental Institute (ISA)
# available at: http://ti.socioambiental.org/
# raw data downloaded on: APR/29/2016
# web archive link: "https://web.archive.org/web/20200716121054/https://terrasindigenas.org.br/" (main page only)
# archived on: SEP/28/2020
#
# OBS: originally used web scrapping script to get the "Histórico jurídico" from each Indigenous Land and required installation of phantom JS - see "status_history_isa_scrapping.R" for more details
#
# INSTRUCTIONS FOR (MANUAL) DOWNLOAD
# 1) insert the url "http://ti.socioambiental.org/" on the browser
# 2) click on "Acesse o Painel"
# 3) click on "Lista"
# 4) for each indigenous lands of interest:
#	4.1) click on the link in the column "Nome"
#	4.2) go to the "Histórico jurídico" section
#	4.3) click on "Exportar para CSV"
#	4.4) save the file on "input/data_scrapping/output"
# OBS: this method will require an adaption of the data input section in "code/raw2clean/policy/indigenousLands_funaiIsa/status_history_isa_raw2clean.R" script



# DATA INPUT 
load(file.path("data/raw2clean/policy/indigenousLands_funaiIsa/input/data_scrapping/output", 
               "status_history_isa_scrapped.RData"))
status.history.isa <- tables


# DATA EXPLORATION
#class(status.history.isa)              # scrapped data are stored in large list where each element is composed of:
#summary(status.history.isa[[1]])       #   [1] a character containing the name of the IL, and
#summary(status.history.isa[[1]][[2]])  #   [2] a data frame containing IL status history
#View(status.history.isa[[1]])         # disabled for speed





# DATASET CLEANUP AND PREP --------------------------------------------------------------------------------------------------------------------------

# LATIN CHARACTER TREATMENT
status.history.isa <- lapply(status.history.isa, DiacriticRemoval)



# PROTECTION DATE SELECTION

# IMPORTANT DISCLAIMER: ProtectionDateIdentifier selects ILs in only two stages of demarcartion (delimited and approved), plus indigenous reserves
# (IRs). Protection status of indigenous reserves is the subject of debate (see data documentation for details) - in this project, lands that have
# been submitted as IRs are NOT considered protected; lands that have completed the administrative process of submission and are regularized as IRs
# (which is FUNAI's way of classifying IRs) ARE considered protected. Because ISA does has a different terminology for IRs, ProtectionDateIdentifier
# function preserves info on lands that are marked as 'reserved'. These lands will be inspected in the FUNAI+ISA merged database.

protection.date.isa <- ldply(.data = status.history.isa,                        # ldply applies function to each element of a list and combines
                             .fun = ProtectionDateIdentifier, dates = "first")  # results into df

# new object exploration
#class(protection.date.isa)
#summary(protection.date.isa)
lapply(protection.date.isa, class)



# COLUMN CLEANUP
# string trims
protection.date.isa$IL_name <- StringTrim(protection.date.isa$IL_name)





# POST-TREATMENT OVERVIEW  --------------------------------------------------------------------------------------------------------------------------

summary(protection.date.isa)
# View(protection.date.isa)  # disabled for speed





# EXPORT --------------------------------------------------------------------------------------------------------------------------------------------

save(protection.date.isa, file = file.path("data/raw2clean/policy/indigenousLands_funaiIsa/output", "temp_status_history_isa.RData"))





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------