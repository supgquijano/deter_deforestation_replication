
# > PROJECT INFO
# NAME: DATABASE CONSTRUCTION - BRAZILIAN INDIGENOUS LANDS
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: MASTERFILE TO CLEAN FUNAI INDIGENOUS LANDS SHAPEFILE, ADD STATUS HISTORY, DO WEB SCRAPPING ON ISA'S WEBSITE TO COMPLEMENT STATUS HISTORY, MERGE INFORMATION AND CREATES PROTECTION ONSET COLUMN 
# AUTHOR: JOAO VIEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/18/2020
#
# > NOTES



# FUNAI SHAPEFILE
# cleans raw shapefile
source("code/raw2clean/policy/indigenousLands_funaiIsa/br_il_georef_raw2clean.R", encoding = "UTF-8")

# clean environment
rm(list = ls())



# FUNAI STATUS HISTORY
# cleans funai status history csv
source("code/raw2clean/policy/indigenousLands_funaiIsa/status_history_funai_raw2clean.R", encoding = "UTF-8")

# clean environment
rm(list = ls())



# ISA STATUS HISTORY
# clean scrapped dataset with status history
source("code/raw2clean/policy/indigenousLands_funaiIsa/status_history_isa_raw2clean.R", encoding = "UTF-8")

# clean environment
rm(list = ls())



# MERGE FUNAI SHAPEFILE, STATUS HISTORY AND ISA STATUS HISTORY
# merge funai shapefile with demarcation status histories from funai and isa
source("code/raw2clean/policy/indigenousLands_funaiIsa/merge.R", encoding = "UTF-8")

# clean environment
rm(list = ls())



# CREATES PROTECTION ONSET VARIABLE
# determine protection onset date for indigenous lands
source("code/raw2clean/policy/indigenousLands_funaiIsa/protection_onset.R", encoding = "UTF-8")

# clean environment
rm(list = ls())





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------