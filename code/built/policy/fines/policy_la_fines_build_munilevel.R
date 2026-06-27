# > PROJECT INFO
# TITLE: DATABASE CONSTRUCTION - LAW ENFORCEMENT FINES
# LEAD: CLARISSA GANDOUR
# 
# > THIS SCRIPT
# AIM: USE THE CLEAN DATA TO BUILD AN AGREGGATED ONE BY MUNI LEVEL PER MONTH AND PER PRODES YEAR
# AUTHOR: JOAO VIEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/21/2020
#
# > NOTES
# 1: -





# SETUP --------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES 
source("code/_functions/setup.R")



# LIBRARIES
# called in the setup.R script





# DATA INPUT ---------------------------------------------------------------------------------------------------------------------------------------

# CLEAN DATA

# Environmental Violation Fines Brazilian Legal Amazon
load(file = file.path("data/raw2clean/policy/fines_ibama/output", "policy_la_fines_df.Rdata"))





# DATA SET CONSTRUCTION ------------------------------------------------------------------------------------------------------------------------------

# PREPARATION

# removes useless column
useless.columns <- c("fine_sanction_serie")  
policy.la.fines.df <- policy.la.fines.df[, (useless.columns) := NULL]



# AGREGGATION

# aggregates the fines by muni level per month

# aggregates fine_sanction_value by muni, date and type of violation, also includes the number of fines that have been agreggated   
fines.muni.level.per.month <- policy.la.fines.df[, .(sum_fine_sanction_value_month = sum(fine_sanction_value), number_of_fines_month = .N),
                                                       by = .(muni_code, violation, fine_sanction_month,  fine_sanction_year, state_uf)] 
                                                           

# aggregates the fines by muni level per deforestation year

# maintains only flora of the types of violation
setkey(policy.la.fines.df, violation)
policy.la.fines.df <- policy.la.fines.df["Flora"]  # returns all the rows where the key column has the value "Flora"

# creates PRODES year column (PRODES year T goes from 01/AUG/T-1 to 31/JUL/T)
policy.la.fines.df <- policy.la.fines.df[, .(year_prodes = if (fine_sanction_month < 8) fine_sanction_year 
                                                     else                         fine_sanction_year + 1),  
                                                     by = .(muni_code, state_uf, violation,  fine_sanction_month, 
                                                            fine_sanction_year, fine_sanction_value, fine_sanction_code)]


# agreggates fine_sanction_value by muni and prodes year, also includes the number of fines that have been agreggated
fines.muni.flora.yearprodes <- policy.la.fines.df[, .(sum_fine_sanction_value_year_prodes = sum(fine_sanction_value), 
                                                            number_of_fines_year_prodes = .N), 
                                                        by = .(muni_code, year_prodes, state_uf)]





# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# LABELS

# labels fines.muni.level.per.month    
label(fines.muni.level.per.month$muni_code)                     <- "municipality code (7-digit, IBGE)"
label(fines.muni.level.per.month$violation)                     <- "type of violation"
label(fines.muni.level.per.month$fine_sanction_month)           <- "refers to issue month"
label(fines.muni.level.per.month$fine_sanction_year)            <- "refers to issue year" 
label(fines.muni.level.per.month$state_uf)                      <- "state name (abbreviation)"
label(fines.muni.level.per.month$sum_fine_sanction_value_month) <- "sum of all fines per muni in a month by type of violation"
label(fines.muni.level.per.month$number_of_fines_month)         <- "number of fines per muni in a month by type of violation" 
  
# labels fines.muni.flora.yearprodes
label(fines.muni.flora.yearprodes$muni_code)                           <- "municipality code (7-digit, IBGE)"
label(fines.muni.flora.yearprodes$year_prodes)                         <- "PRODES year (AUG/01/t-1 through JUL/31/t)"
label(fines.muni.flora.yearprodes$state_uf)                            <- "state name (abbreviation)"
label(fines.muni.flora.yearprodes$sum_fine_sanction_value_year_prodes) <- "sum of all Flora fines per muni in a PRODES year"
label(fines.muni.flora.yearprodes$number_of_fines_year_prodes)         <- "number of Flora fines per muni in a PRODES year"
  
# change object names for exportation
policy.la.fines.muni.level.per.month.df <- fines.muni.level.per.month
policy.la.fines.muni.flora.yearprodes.df <- fines.muni.flora.yearprodes



# POST-TREATMENT OVERVIEW
#summary(fines.muni.flora.yearprodes)                         
#summary(fines.muni.level.per.month)  

#View(fines.muni.flora.yearprodes)
#View(fines.muni.level.per.month)





# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(policy.la.fines.muni.level.per.month.df, policy.la.fines.muni.flora.yearprodes.df, 
     file = file.path("data/built/policy/fines", "policy_la_fines_built_munilevel_df.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------