
# > PROJECT INFO
# NAME: DATABASE CONSTRUCTION - BRAZILIAN INDIGENOUS LANDS
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: MERGE FUNAI SHAPEFILE WITH DEMARCATION STATUS HISTORIES FROM FUNAI AND ISA
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
source(file.path("code/_functions/logical.R"))
source(file.path("code/raw2clean/policy/indigenousLands_funaiIsa", "functions_project_specific.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT ----------------------------------------------------------------------------------------------------------------------------------------

# TREATED DATASETS
load(file.path("data/raw2clean/policy/indigenousLands_funaiIsa/output", "temp_br_il_georef.RData"))          # object 'indigenous.lands.cleangeo':>
                                                                                                            # IL shapefile
load(file.path("data/raw2clean/policy/indigenousLands_funaiIsa/output", "temp_status_history_funai.RData"))  # object 'status.history.funai'     :> 
                                                                                                            # demarcation history by FUNAI
load(file.path("data/raw2clean/policy/indigenousLands_funaiIsa/output", "temp_status_history_isa.RData"))    # object 'protection.date.isa'      :> 
                                                                                                            # select demarcation dates by ISA



# AUXILIARY INPUT
# inspection reveals inconsistencies across names of indigenous lands in FUNAI's datasets and ISA's dataset; names must be standardized to enable
# merge across datasets -- FUNAI's spelling is chosen as reference
#   expansions of existing indigenous lands are identified via an additional '(under reassessment)' in 'names_right.txt' file
names.wrong <- read.table(file.path("data/raw2clean/policy/indigenousLands_funaiIsa/input", "names_wrong.txt"))  # list of misspelled/incomplete names in raw dataset
names.wrong <- as.character(names.wrong[[1]])

names.right <- read.table(file.path("data/raw2clean/policy/indigenousLands_funaiIsa/input", "names_right.txt"))  # list of correct names to be used for merging across datasets
names.right <- as.character(names.right[[1]])





# MERGE PREP ----------------------------------------------------------------------------------------------------------------------------------------

# MERGE VARIABLES CONSISTENCY CHECK
# column class
#summary(indigenous.lands@data)
#summary(status.history.funai)  # IL_code as character
#summary(protection.date.isa)   # IL_code not present in dataset

IdenticalMultipleArgs(class(indigenous.lands@data$IL_name), class(status.history.funai$IL_name), class(protection.date.isa$IL_name))  # returns T
IdenticalMultipleArgs(class(indigenous.lands@data$IL_code), class(status.history.funai$IL_code))                                      # returns F

status.history.funai$IL_code <- as.integer(status.history.funai$IL_code)


# leading/lagging/extra blank spaces
indigenous.lands@data$IL_name <- StringTrim(indigenous.lands@data$IL_name)
status.history.funai$IL_name  <- StringTrim(status.history.funai$IL_name)
protection.date.isa$IL_name   <- StringTrim(protection.date.isa$IL_name)





# MERGE FUNAI SHAPEFILE AND FUNAI STATUS HISTORY ----------------------------------------------------------------------------------------------------

# DUPLICATE ENTRIES
# IL_name and IL_code are the only dimensions in which duplicate entries matter for merging across datasets

# investigation
summary(duplicated(indigenous.lands@data$IL_name))
summary(duplicated(status.history.funai$IL_name))

summary(duplicated(indigenous.lands@data$IL_code))  # single occurrence of duplicate code
summary(duplicated(status.history.funai$IL_code))

# original data contains several duplicates of IL_names - upon inspection, these were identified as original ILs (first occurrence) and changes to
# existing ILs, typically expansions (second occurrence)
#   - duplicates' IL_code differ by a single digit - ex: 101 and 102 - with the expansion area always coded as the larger figure (ending in digit 2)
#   - all areas marked as "under reassessment" have IL_code ending in digit 2
#   - some ILs with codes ending in digit 2 do NOT have a duplicate entry with code ending in digit 1: this might suggest that these lands were once
#   changes to then-existing ILs, but have now been approved as the official areas
#   [DISCLAIMER: this is an interpretation based on dataset inspection, but it lacks official documentation that confirms it]
#
# ...due to multiple duplicates by IL_name in FUNAI dataset, IL_code set as primary match variable in merge


# duplicate columns treatment
#   some columns are common to both datasets, but will not be used for matching purposes during merge - these columns are preserved in base (merge x)
#   and dropped from added (merge y) dataset to avoid column duplication in resulting (merged) object
status.history.funai <- subset(status.history.funai, select = c(IL_code,
                                                                date_under_assessment,
                                                                date_delimited,
                                                                date_declared,
                                                                date_approved,
                                                                date_regularized))


# duplicate IL_code treatment
indigenous.lands@data[which(duplicated(indigenous.lands@data$IL_code) == T), ]
indigenous.lands@data[indigenous.lands@data$IL_code == 35101, ]  # row numbers: 89 and 374
#plot(indigenous.lands[89, ])                            # disabled for running via masterfile - polygons for different entries don't match; neither >
#plot(indigenous.lands[374, ], add = T, border = "red")  # documentation nor other datasets provide info to enable disambiguation

# single occurrence of duplicate IL_code must be addressed to enable correct merging
# without additional documentation to allow accurate polygon disambiguation, one of the polygons must be chosen at random to be discarded - this is >
# poor data handling practice, but is adopted here only because the IL at hand is in SP state and will not affect this (Amazon-focused) project
indigenous.lands <- indigenous.lands[-89, ]
summary(duplicated(indigenous.lands@data$IL_code))  # cross check



# ORDERING BY MATCH VARIABLE
indigenous.lands     <- indigenous.lands[order(indigenous.lands@data$IL_code, na.last = T), ]
status.history.funai <- status.history.funai[order(status.history.funai$IL_code, na.last = T), ]



# MERGE
# match variable: IL_code (other common variables/columns do not provide necessarily unique match)
indigenous.lands <- merge(x     = indigenous.lands,
                          y     = status.history.funai,
                          by.x  = c("IL_code"),
                          by.y  = c("IL_code"),
                          all.x = T,  # keeps rows from x that have no match in y
                          all.y = T)  # keeps rows from y that have no match in x

# resulting (merged) dataset contains all info on status history provided by FUNAI - existing gaps in IL demarcation status history will be filled
# based on ISA status history





# MERGE FUNAI SHAPEFILE AND ISA STATUS HISTORY ------------------------------------------------------------------------------------------------------

# DUPLICATE ENTRIES
# ISA dataset does not contain IL_code (data not available at website used for data scrapping) - must use IL_name as match variable. IL_name is thus
# the only dimension in which duplicate entries matter for merging across datasets

# investigation
summary(duplicated(indigenous.lands@data$IL_name))
summary(duplicated(protection.date.isa$IL_name))

indigenous.lands@data$IL_code[which(duplicated(indigenous.lands@data$IL_name) == T)]             # all duplicated entries have code ending in 2 and
indigenous.lands@data$under_reassessment[which(duplicated(indigenous.lands@data$IL_name) == T)]  # are undergoing reassesment (typically expansion)

protection.date.isa[which((duplicated(protection.date.isa$IL_name)) == T), ]  # single duplicate entry named 'Aripuana'
protection.date.isa[protection.date.isa$IL_name == "Aripuana", ]              # from ISA website: protection.date.isa[[34]][[2]] is indigenous LAND,
                                                                              # and protection.date.isa[[35]][[2]] is indigenous RESERVE


# duplicate IL_name treatment
# standardization across lands marked as "under reassesment" in ISA dataset
indigenous.lands@data$IL_name[indigenous.lands@data$IL_code == 4902]  <- "Bacurizinho (under reassessment)"
indigenous.lands@data$IL_name[indigenous.lands@data$IL_code == 5802]  <- "Barra Velha do Monte Pascoal (under reassessment)"
indigenous.lands@data$IL_name[indigenous.lands@data$IL_code == 18802] <- "Jaragua (under reassessment)"
indigenous.lands@data$IL_name[indigenous.lands@data$IL_code == 28802] <- "Menku (under reassessment)"
indigenous.lands@data$IL_name[indigenous.lands@data$IL_code == 32602] <- "Paquicamba (under reassessment)"
indigenous.lands@data$IL_name[indigenous.lands@data$IL_code == 36602] <- "Porquinhos dos Kanela Apanjekra (under reassessment)"
indigenous.lands@data$IL_name[indigenous.lands@data$IL_code == 40002] <- "Rio Negro Ocaia (under reassessment)"
indigenous.lands@data$IL_name[indigenous.lands@data$IL_code == 49902] <- "Xakriaba (under reassessment)"

summary(duplicated(indigenous.lands@data$IL_name))  # only 9 duplicated names remain, which ISA dataset does not mark as being under reassessment


# separation of unique and duplicated names
# 'duplicated()' returns index for first duplicated entry of a given occurrence - if data frame is ordered in ascending order by IL_name and then
# IL_code, object created via 'duplicated()' capture expansions (final code digit 2), as opposed to existing ILs (final code digit 1)
indigenous.lands.unique     <- indigenous.lands[!(duplicated(indigenous.lands@data$IL_name)), ]
indigenous.lands.duplicates <- indigenous.lands[duplicated(indigenous.lands@data$IL_name), ]

# base dataset (FUNAI shapefile) does not contain the indigenous RESERVE Aripuana - disregarded for merging purposes
protection.date.isa.unique <- protection.date.isa[rownames(protection.date.isa) != 35, ]



# NAME TREATMENT
# standardizes names in ISA dataset to match FUNAI nomenclature
for (i in seq_along(names.wrong)) {
  protection.date.isa.unique$IL_name <- sub(pattern     = names.wrong[i],
                                            replacement = names.right[i],
                                            x           = protection.date.isa.unique$IL_name,
                                            fixed       = TRUE)
}



# ORDERING BY MATCH VARIABLE
indigenous.lands.unique    <- indigenous.lands.unique[order(indigenous.lands.unique@data$IL_name), ]
protection.date.isa.unique <- protection.date.isa.unique[order(protection.date.isa.unique$IL_name), ]



# MERGE [UNIQUE DATASETS ONLY]
# match variable: IL_name (no other common variables/columns)
indigenous.lands.unique <- merge(x     = indigenous.lands.unique,
                                 y     = protection.date.isa.unique,
                                 by.x  = c("IL_name"),
                                 by.y  = c("IL_name"),
                                 all.x = T,  # keeps rows from x that have no match in y
                                 all.y = F)  # drop rows from y that have no match in x - ISA data used only to fill in gaps in FUNAI status history

# resulting (merged) dataset contains all info on status history provided by FUNAI and ISA (sample determined by ILs present in FUNAI shapefile)



# MERGE [DUPLICATE IL_NAME ENTRIES]
summary(indigenous.lands.duplicates)  # dates only available in FUNAI data set for assessment/delimitation/declaration


# spatial rbind prep - ensure unique row names for polygon indexation
ids.unique     <- row.names(indigenous.lands.unique@data)
ids.duplicates <- row.names(indigenous.lands.duplicates@data)

indigenous.lands.unique     <- spChFIDs(indigenous.lands.unique, paste("unique", ids.unique, sep = "."))
indigenous.lands.duplicates <- spChFIDs(indigenous.lands.duplicates, paste("duplicates", ids.duplicates, sep = "."))


# spatial rbind prep - ensure common column names
colnames(indigenous.lands.unique@data)
colnames(indigenous.lands.duplicates@data)  # missing columns for isa data

date_approved_isa <- as.Date(NA)
date_reserved_isa <- as.Date(NA)
date_declared_isa <- as.Date(NA)


dates.isa <- data.frame(date_declared_isa, date_approved_isa, date_reserved_isa)  # creates data frame to hold missing ISA dates in FUNAI duplicates

while (nrow(dates.isa) < nrow(indigenous.lands.duplicates@data)) {
  dates.isa <- rbind(dates.isa, NA)
}

row.names(dates.isa)        <- row.names(indigenous.lands.duplicates)           # ensures consistent row names for spatial column bind
indigenous.lands.duplicates <- spCbind(indigenous.lands.duplicates, dates.isa)  # adds empty (missing) columns for ISA dates


# spatial rbind
indigenous.lands <- spRbind(indigenous.lands.unique, indigenous.lands.duplicates)





# POST-TREATMENT OVERVIEW  --------------------------------------------------------------------------------------------------------------------------

# DISABLED FOR SPEED

# summary(indigenous.lands)
# View(indigenous.lands)
# plot(indigenous.lands)





# EXPORT --------------------------------------------------------------------------------------------------------------------------------------------

save(indigenous.lands, file = file.path("data/raw2clean/policy/indigenousLands_funaiIsa/output", "temp_br_il_georef_with_history.RData"))





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------