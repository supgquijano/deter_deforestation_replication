
# > PROJECT INFO
# NAME: CENTRAL DATA REPOSITORY CONSTRUCTION - AMAZON DEFORESTATION PRIORITY MUNICIPALITIES
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: CLEAN RAW (CONSTRUCTED) DATA
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

# METADATA
# 
# PRIORITY MUNICIPALITIES (LEGAL AMAZON DEFORESTATION)
# files: original data only available in pdf ('MMA_muni_priority.pdf' and 'MMA_muni_monitored.pdf'); dataset built in R script 
# content: list of Legal Amazon priority municipalities with entry/exit dates and legal documentation (.pdf files); Brazilian Legal Amazon (extent); >
#          2017 (year of reference)
# source: Brazilian Ministry of the Environment (MMA)
# available at: http://combateaodesmatamento.mma.gov.br/images/conteudo/lista_municipios_prioritarios_AML_2017.pdf
# raw data collected on: JAN/08/2018
# web archived at: https://web.archive.org/web/20200915211728/http://combateaodesmatamento.mma.gov.br/images/conteudo/lista_municipios_prioritarios_AML_2017.pdf
# archived on: SEP/15/2020

# RAW DATA 
load(file = file.path("data/raw2clean/policy/priorityMuni_mma/output",
                      paste0("policy_la_prioritymuni_raw", ".Rdata")))



# AUXILIARY DATA
# spatial Legal Amazon municipal division
load(file = file.path("data/built/administrative/territorial/legal_amazon",
                      paste0("admin_la_territory_built_muni_spdf", ".Rdata")))

# administrative info for Legal Amazon limit
load(file = file.path("data/raw2clean/administrative/territorial_ibge/legal_amazon/output", "admin_la_territory_sp.Rdata"))





# DATA CONSTRUCTION ----------------------------------------------------------------------------------------------------------------------------------

# MERGE WITH LEGAL AMAZON MUNIS [2007]

# 2007
admin.la.muni.spdf@data <- admin.la.muni.spdf@data[, c("muni_code",
                                                       "muni_name")]

policy.la.prioritymuni.2007 <- merge(x    = admin.la.muni.spdf,
                                     y    = policy.la.prioritymuni,
                                     by   = c("muni_code", "muni_name"),
                                     sort = T,
                                     all  = T)

policy.la.prioritymuni.2007@data <- as.data.table(policy.la.prioritymuni.2007@data)

# auxliary object to automatize the cleaning process for 2007 and 2015
aux.year <- c("2007")

for (i in seq_along(aux.year)) {
  
  policy.la.prioritymuni <- get(paste0("policy.la.prioritymuni.", aux.year[i]))
  
  # PRODES YEAR CONSTRUCTION: ENTRY
  # /!\ classification criteria: PRODES year of entry is based on the municipality's month/year of entry as follows:
  #   > if month of entry is AUG/t-1 through JAN/t, PRODES year of entry is t,   as muni will     have been listed as priority for most (6m min) of    >
  #     PRODES year t
  #   > if month of entry is FEB/t   through JUL/t, PRODES year of entry is t+1, as muni will not have been listed as priority for most (6m min) of    >
  #     PRODES year t
  policy.la.prioritymuni@data$PRODES_year_entry <- NA
  
  policy.la.prioritymuni@data$PRODES_year_entry <- as.numeric(policy.la.prioritymuni@data$PRODES_year_entry)
  
  policy.la.prioritymuni@data[as.numeric(substr(date_entry, 6, 7)) >= 8 | as.numeric(substr(date_entry, 6, 7)) <= 12,
                              PRODES_year_entry := as.numeric(substr(date_entry, 1, 4)) + 1]
  
  policy.la.prioritymuni@data[as.numeric(substr(date_entry, 6, 7)) == 1,
                              PRODES_year_entry := as.numeric(substr(date_entry, 1, 4))]
  
  policy.la.prioritymuni@data[as.numeric(substr(date_entry, 6, 7)) >= 2 & as.numeric(substr(date_entry, 6, 7)) <= 7,
                              PRODES_year_entry := as.numeric(substr(date_entry, 1, 4)) + 1]
  
  
  
  # PRODES YEAR CONSTRUCTION: EXIT [where year of exit is defined as first year in which previously listed muni is NOT in priority list]
  # /!\ classification criteria: PRODES year of exit is based on the municipality's month/year of exit as follows:
  #   > if month of exit is AUG/t-1 through JAN/t, PRODES year of exit is t,   as muni will not have been listed as priority for most (6m min) of      >
  #     PRODES year t
  #   > if month of exit is FEB/t   through JUL/t, PRODES year of exit is t+1, as muni will     have been listed as priority for most (6m min) of      >
  #     PRODES year t
  policy.la.prioritymuni@data$PRODES_year_exit <- NA
  
  policy.la.prioritymuni@data$PRODES_year_exit <- as.numeric(policy.la.prioritymuni@data$PRODES_year_exit)
  
  policy.la.prioritymuni@data[as.numeric(substr(date_exit, 6, 7)) >= 8 | as.numeric(substr(date_exit, 6, 7)) <= 12,
                              PRODES_year_exit := as.numeric(substr(date_exit, 1, 4)) + 1]
  
  policy.la.prioritymuni@data[as.numeric(substr(date_exit, 6, 7)) == 1,
                              PRODES_year_exit := as.numeric(substr(date_exit, 1, 4))]
  
  policy.la.prioritymuni@data[as.numeric(substr(date_exit, 6, 7)) >= 2 & as.numeric(substr(date_exit, 6, 7)) <= 7,
                              PRODES_year_exit := as.numeric(substr(date_exit, 1, 4)) + 1]
  
  
  
  # PANEL SETUP
  # prep
  year <- c("2008":"2018")                        # time frame for available priority muni data
  
  
  
  
  colnames(policy.la.prioritymuni@data)           # dimensions for panel data table construction
  muni_code         <- rep(policy.la.prioritymuni@data$muni_code,
                           each = length(year))
  muni_name         <- rep(policy.la.prioritymuni@data$muni_name,
                           each = length(year))
  PRODES_year_entry <- rep(policy.la.prioritymuni@data$PRODES_year_entry,
                           each = length(year))
  PRODES_year_exit  <- rep(policy.la.prioritymuni@data$PRODES_year_exit,
                           each = length(year))
  year              <- rep(year,
                           length(unique(policy.la.prioritymuni@data$muni_code)))
  
  
  # panel merge
  policy.la.prioritymuni@data <- as.data.table(cbind(muni_code,
                                                     muni_name,
                                                     PRODES_year_entry,
                                                     PRODES_year_exit,
                                                     year))
  
  policy.la.prioritymuni@data$muni_code         <- as.numeric(policy.la.prioritymuni@data$muni_code)
  policy.la.prioritymuni@data$PRODES_year_entry <- as.numeric(policy.la.prioritymuni@data$PRODES_year_entry)
  policy.la.prioritymuni@data$PRODES_year_exit  <- as.numeric(policy.la.prioritymuni@data$PRODES_year_exit)
  policy.la.prioritymuni@data$year              <- as.numeric(policy.la.prioritymuni@data$year)
  
  
  
  
  
  # VARIABLE CONSTRUCTION: PRIORITY STATUS ANNUAL INDICATOR
  # /!\ classification criteria: d1_priorityMuni == 1 if year >= PRODES_year_entry and year < PRODES_year_exit, == 0 otherwise
  policy.la.prioritymuni@data$d1_priorityMuni <- NA
  policy.la.prioritymuni@data$d1_priorityMuni <- as.numeric(policy.la.prioritymuni@data$d1_priorityMuni)
  
  policy.la.prioritymuni@data[year >= PRODES_year_entry, d1_priorityMuni := 1]
  policy.la.prioritymuni@data[year >= PRODES_year_exit , d1_priorityMuni := 0]
  
  policy.la.prioritymuni@data[is.na(d1_priorityMuni), d1_priorityMuni := 0]  # sets indicator to 0 for munis that were never blacklisted
  
  
  
  
  
  # EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------
  
  # COLUMN CLEANUP
  # selection
  colnames(policy.la.prioritymuni@data)
  policy.la.prioritymuni@data <- policy.la.prioritymuni@data[, c("muni_code",
                                                                 "year",
                                                                 "d1_priorityMuni")]
  
  # sort
  policy.la.prioritymuni@data <- policy.la.prioritymuni@data[order(policy.la.prioritymuni@data[, "muni_code"]), ]
  
  
  
  # RESHAPE
  policy.la.prioritymuni@data <- reshape(data      = policy.la.prioritymuni@data,
                                         v.names   = "d1_priorityMuni",
                                         timevar   = "year",
                                         idvar     = "muni_code",
                                         direction = "wide",
                                         sep       = "_")
  
  
  # merge  data with spatial muni -- necessary to fix any mismatch after changing the data.frame
  if (aux.year[i] == "2007") {
    
    policy.la.prioritymuni <- merge(x    = admin.la.muni.spdf,
                                    y    = policy.la.prioritymuni@data,
                                    by   = c("muni_code"),
                                    sort = T,
                                    all  = T)
    
  } 
  
  
  
  
  # VARIABLE CONSTRUCTION: PRIORITY HISTORY
  policy.la.prioritymuni@data$d1_priorityEver <- 0  # indicator for munis that were priority at some point (even if no longer in list)
  
  policy.la.prioritymuni@data[d1_priorityMuni_2008 == 1 |
                                d1_priorityMuni_2009 == 1 |
                                d1_priorityMuni_2010 == 1 |
                                d1_priorityMuni_2011 == 1 |
                                d1_priorityMuni_2012 == 1 |
                                d1_priorityMuni_2013 == 1 |
                                d1_priorityMuni_2014 == 1 |
                                d1_priorityMuni_2015 == 1 |
                                d1_priorityMuni_2016 == 1 |
                                d1_priorityMuni_2017 == 1 |
                                d1_priorityMuni_2018 == 1,
                                d1_priorityEver      := 1]
  
  
  
  # NOMENCLATURE
  policy.la.prioritystatus <- policy.la.prioritymuni
  rm(policy.la.prioritymuni)
  
  
  
  # LABELS
  label(policy.la.prioritystatus@data$muni_code)            <- "municipality code (7-digit, IBGE)"
  label(policy.la.prioritystatus@data$d1_priorityMuni_2008) <- "d=1 if priority muni in 2008 (PRODES year)"
  label(policy.la.prioritystatus@data$d1_priorityMuni_2009) <- "d=1 if priority muni in 2009 (PRODES year)"
  label(policy.la.prioritystatus@data$d1_priorityMuni_2010) <- "d=1 if priority muni in 2010 (PRODES year)"
  label(policy.la.prioritystatus@data$d1_priorityMuni_2011) <- "d=1 if priority muni in 2011 (PRODES year)"
  label(policy.la.prioritystatus@data$d1_priorityMuni_2012) <- "d=1 if priority muni in 2012 (PRODES year)"
  label(policy.la.prioritystatus@data$d1_priorityMuni_2013) <- "d=1 if priority muni in 2013 (PRODES year)"
  label(policy.la.prioritystatus@data$d1_priorityMuni_2014) <- "d=1 if priority muni in 2014 (PRODES year)"
  label(policy.la.prioritystatus@data$d1_priorityMuni_2015) <- "d=1 if priority muni in 2015 (PRODES year)"
  label(policy.la.prioritystatus@data$d1_priorityMuni_2016) <- "d=1 if priority muni in 2016 (PRODES year)"
  label(policy.la.prioritystatus@data$d1_priorityMuni_2017) <- "d=1 if priority muni in 2017 (PRODES year)"
  label(policy.la.prioritystatus@data$d1_priorityMuni_2018) <- "d=1 if priority muni in 2018 (PRODES year)"
  label(policy.la.prioritystatus@data$d1_priorityEver)      <- "d=1 if priority muni at any point in time"
  
  
  
  # DF EXTRACTION
  policy.la.prioritystatus.df <- policy.la.prioritystatus@data
  
  
  
  # POST-TREATMENT OVERVIEW
  # summary(policy.la.prioritystatus)
  # View(policy.la.prioritystatus)
  
  assign(x     = paste0("policy.la.prioritystatus.", aux.year[i], ".spdf"),
         value = policy.la.prioritystatus)
  
  assign(x     = paste0("policy.la.prioritystatus.", aux.year[i], ".df"),
         value = policy.la.prioritystatus.df)
  
  rm(policy.la.prioritystatus)

  
}




# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(policy.la.prioritystatus.2007.df,
     file = file.path("data/raw2clean/policy/priorityMuni_mma/output",
                      paste0("policy_la_prioritymuni_2007_df", ".Rdata")))




# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------