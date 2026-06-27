
# > PROJECT INFO
# NAME: DATABASE CONSTRUCTION - BRAZILIAN INDIGENOUS LANDS
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: DETERMINE PROTECTION ONSET DATE FOR INDIGENOUS LANDS
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
source(file.path("code/raw2clean/policy/indigenousLands_funaiIsa", "functions_project_specific.R"))




# LIBRARIES
# called in the setup.R script





# DATA INPUT ----------------------------------------------------------------------------------------------------------------------------------------

# TREATED DATASETS
load(file.path("data/raw2clean/policy/indigenousLands_funaiIsa/output", "temp_br_il_georef_with_history.RData"))  # object 'indigenous.lands':             > 
                                                                                                            # IL shapefile containing combined FUNAI >
                                                                                                            # ISA demarcation status history



# CONTENT ORDER
indigenous.lands <- indigenous.lands[order(indigenous.lands@data$IL_name), ]





# VARIABLE CONSTRUCTION: PROTECTION DATE ------------------------------------------------------------------------------------------------------------

# CONSTRUCTION DETAILS
# 1. an area is first considered protected when DECLARED as an IL - ie. areas that are still UNDER ASSESSMENT or DELIMITED are *not* protected; areas
#    that are SUBMITTED AS INDIGENOUS RESERVE (all of which have missing FUNAI dates) are *not* considered protected - see documentation for details
#
# 2. EARLIST available (eligible) date is taken as the onset of protection
#
# 3. protection status is determined based on the PRODES calendar, where PRODES year t is defined as AUG/01/(t-1) through JUL/31/t
#
# 4. as noted in 'status_history_isa_raw2clean.R' subscript, because ISA has a different terminology for IRs, ProtectionDateIdentifier function
#    preserves info on lands that are marked as 'reserved' - these lands must be inspected in merged database prior to assignment of protection onset
#    date


# ISA DATA CHECK
# see 4th item in CONSTRUCTION DETAILS

# subsampling
isa.check <- indigenous.lands[which(is.na(indigenous.lands@data$date_declared) &            # restricts to observations missing FUNAI dates for
                                    is.na(indigenous.lands@data$date_approved) &            # demarcation process stages that are considered as
                                    is.na(indigenous.lands@data$date_regularized) == T), ]  # protected

isa.check <- isa.check[which(is.na(isa.check@data$date_reserved_isa) == F), ]  # restricts to observations with non-missing 'date_reserved_isa'


# investigation - commented for speed
# summary(isa.check)
# View(isa.check)

# from 28 areas with non-missing 'date_reserved_isa':
#   - 2 have non-missing info for either 'date_approved_isa' or 'date_declared_isa' (which will be captured in assigning protection onset)
#   - 18 are marked as 'regularized' in FUNAI dataset (only 1 of which has non-missing date_declared_isa); among these, no clear pattern emerges
#     across available dates... some areas with very early 'date_reserved_isa' have post-2000 'date_under_assessment', some areas have a later
#     'date_reserved_isa' than a 'date_under_assessment'
# ...considering the lack of consistency across status dates, project with adopt conservative stand and will *disregard 'date_reserved_isa' for
# calculation of protection onset date

rm(isa.check)



# CALCULATION OF PROTECTION ONSET AS CALENDAR DATE
date_protection_onset <- as.Date(NA)
date_protection_onset <- data.frame(date_protection_onset)

for (i in 1:nrow(indigenous.lands@data)) {
  date_protection_onset[i, 1] <- min(indigenous.lands@data$date_declared[i],      # selects earliest date across protection-granting demarcation
                                     indigenous.lands@data$date_approved[i],      # process stages
                                     indigenous.lands@data$date_regularized[i],
                                     indigenous.lands@data$date_declared_isa[i],
                                     indigenous.lands@data$date_approved_isa[i],
                                     na.rm = T)                                   # returns warnings regarding NA values (set as Inf in 'min()')
}



# CALCULATION OF PROTECTION ONSET AS PRODES YEAR
year_prodes_protection <- as.numeric()
year_prodes_protection <- data.frame(year_prodes_protection)

for (i in 1:nrow(indigenous.lands@data)) {
  if (is.infinite(date_protection_onset[i, 1]) == F) {
    if (as.numeric(format(date_protection_onset[i, 1], '%m')) <= 7) {
      year_prodes_protection[i, 1] <- as.numeric(format(date_protection_onset[i, 1], '%Y'))
    } else {
      year_prodes_protection[i, 1] <- as.numeric(format(date_protection_onset[i, 1], '%Y')) + 1
    }
  }
}



# DATASET JOIN
indigenous.lands@data <- cbind(indigenous.lands@data, date_protection_onset, year_prodes_protection)


# SEPARATION BY TERRACLASS YEAR

# load admin.la data
#load(file.path(FindPath(keywords = c("administrative", "legal_amazon"), output = T), "admin_la_territory_sp.Rdata") )


# intersection
#indigenous.lands.la <- raster::intersect(indigenous.lands, admin.la.sp)

#indigenous.lands.subset     <- indigenous.lands.la[!(is.na(indigenous.lands.la@data$year_prodes_protection)),]  # all lands that had "NA" as 
                                                                                                                # year_prodes_protection were 
                                                                                                                # considered existent prior to 2004
#indigenous.lands.la.bf.2004 <- gBuffer(indigenous.lands[is.na(indigenous.lands$year_prodes_protection) ==TRUE, ], byid = T, width = 0)
#indigenous.lands.la.2004    <- gBuffer(indigenous.lands.subset[indigenous.lands.subset$year_prodes_protection <= "2004", ], byid = T, width = 0)
#indigenous.lands.la.2008    <- gBuffer(indigenous.lands.subset[indigenous.lands.subset$year_prodes_protection <= "2008", ], byid = T, width = 0)
#indigenous.lands.la.2010    <- gBuffer(indigenous.lands.subset[indigenous.lands.subset$year_prodes_protection <= "2010", ], byid = T, width = 0)
#indigenous.lands.la.2012    <- gBuffer(indigenous.lands.subset[indigenous.lands.subset$year_prodes_protection <= "2012", ], byid = T, width = 0)
#indigenous.lands.la.2014    <- gBuffer(indigenous.lands.subset[indigenous.lands.subset$year_prodes_protection <= "2014", ], byid = T, width = 0)






# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# change object name for exportation
policy.br.protected.territory.indigenous.lands.spdf <- indigenous.lands




# POST-TREATMENT OVERVIEW  
# disabled for speed
# summary(indigenous.lands)      # missing protection date for 82 indigenous areas - some of which are in Legal Amazon (see plots)
# View(indigenous.lands@data)
# plot(indigenous.lands)
# plot(indigenous.lands[which(is.na(indigenous.lands@data$year_prodes_protection) == T), ], add = T, col = "red", border = "red")





# EXPORT --------------------------------------------------------------------------------------------------------------------------------------------

save(policy.br.protected.territory.indigenous.lands.spdf, 
     file = file.path("data/raw2clean/policy/indigenousLands_funaiIsa/output", "policy_br_protected_territory_indigenous_lands_spdf.RData"))





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------