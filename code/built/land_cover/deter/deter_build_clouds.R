
# > PROJECT INFO
# TITLE: CENTRAL DATA REPOSITORY CONSTRUCTION - DETER (REAL-TIME DETECTION OF LEGAL AMAZON DEFORESTATION & DEGRADATION)
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: CLEAN RAW DATA - CLOUDS
# AUTHOR: JOAO VEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/21/2020
#
# > NOTES
# 1: TIME-CONSUMING SCRIPT





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source("code/_functions/setup.R")
source(file.path("code/_functions/gis_crs.R"))
source(file.path("code/_functions/gis_geoprocessing.R"))
source(file.path("code/_functions/unit_conversion.R"))



# LIBRARIES
# called in the setup.R script




# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# RAW DATA
# input automated in dataset cleanup and prep section



# AUXILIARY DATA
# Legal Amazon limits
list.files(path = "data/built/administrative/territorial/legal_amazon")
load(file = file.path("data/built/administrative/territorial/legal_amazon", paste0("admin_la_territory_built_muni_spdf", ".Rdata")))

# DETER clouds 
load(file = file.path("data/raw2clean/land_cover/deter_inpe/output", paste0("deter_clouds_sp", ".Rdata")))





# DATASET MANIPULATION ---------------------------------------------------------------------------------------------------------------------------

# AUXILIARY OBJECTS
aux.years  <- c("2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")  # no cloud data for 2004
aux.months <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")


# change object name and select columns of interest 
policy.la.deter.built.clouds.coverage <- admin.la.muni.spdf[, c("muni_code", "muni_area")]


for (y in seq_along(aux.years)) {
  
  # gets one year of cloud data
  clouds <- get(paste0("policy.la.deter.clouds.", aux.years[[y]], ".sp"))
  
  for (m in seq_along(aux.months)) {
    
    # intersect munis with clouds
    intersect.clouds.muni <- raster::intersect(policy.la.deter.built.clouds.coverage, clouds[[m]])
    
    # calculates share of cloud coverage
    intersect.clouds.muni@data$share_cloud_coverage <- (gArea(intersect.clouds.muni, byid = T) * convert.sqm.to.ha) / intersect.clouds.muni$muni_area 
    
    # select columns of interest
    intersect.clouds.muni@data <- intersect.clouds.muni@data[, c("muni_code", "share_cloud_coverage")]
    
    # change column name to include month and year info
    setnames(x = intersect.clouds.muni@data, old =  "share_cloud_coverage", paste0("share_cloud_coverage_", aux.years[y], "_", aux.months[m]))
    
    # add new column with the cloud coverage share on month m and year y
    policy.la.deter.built.clouds.coverage <- merge(policy.la.deter.built.clouds.coverage, 
                                                   intersect.clouds.muni@data, 
                                                   all.x = T,
                                                   by = "muni_code")
  }
  
}

# extracts the data.frame and converts to data.table
policy.la.deter.built.clouds.coverage.df <- setDT(policy.la.deter.built.clouds.coverage@data)

# transforms NAs to 0s, NAs are created on the merge process when there is no cloud coverage on the muni
policy.la.deter.built.clouds.coverage.df[is.na(policy.la.deter.built.clouds.coverage.df)] <- 0

# removes column
policy.la.deter.built.clouds.coverage.df$muni_area <- NULL

# reshape from wide to long
panel.policy.la.deter.built.clouds.coverage.df <-  melt(policy.la.deter.built.clouds.coverage.df, id.vars = "muni_code")

# separates varaible column into year and month, then removes it
panel.policy.la.deter.built.clouds.coverage.df$month <- substr(panel.policy.la.deter.built.clouds.coverage.df$variable, 27, 28)
panel.policy.la.deter.built.clouds.coverage.df$year <- substr(panel.policy.la.deter.built.clouds.coverage.df$variable, 22, 25)
panel.policy.la.deter.built.clouds.coverage.df$variable <- NULL

# reshape from long to wide, each row represent one muni in one year
panel.policy.la.deter.built.clouds.coverage.df <- dcast(data = panel.policy.la.deter.built.clouds.coverage.df, formula = muni_code + year ~ month, value.var = "value")

# changes column names
setnames(x = panel.policy.la.deter.built.clouds.coverage.df, old = "01", new = "share_cloud_coverage_01")
setnames(x = panel.policy.la.deter.built.clouds.coverage.df, old = "02", new = "share_cloud_coverage_02")
setnames(x = panel.policy.la.deter.built.clouds.coverage.df, old = "03", new = "share_cloud_coverage_03")
setnames(x = panel.policy.la.deter.built.clouds.coverage.df, old = "04", new = "share_cloud_coverage_04")
setnames(x = panel.policy.la.deter.built.clouds.coverage.df, old = "05", new = "share_cloud_coverage_05")
setnames(x = panel.policy.la.deter.built.clouds.coverage.df, old = "06", new = "share_cloud_coverage_06")
setnames(x = panel.policy.la.deter.built.clouds.coverage.df, old = "07", new = "share_cloud_coverage_07")
setnames(x = panel.policy.la.deter.built.clouds.coverage.df, old = "08", new = "share_cloud_coverage_08")
setnames(x = panel.policy.la.deter.built.clouds.coverage.df, old = "09", new = "share_cloud_coverage_09")
setnames(x = panel.policy.la.deter.built.clouds.coverage.df, old = "10", new = "share_cloud_coverage_10")
setnames(x = panel.policy.la.deter.built.clouds.coverage.df, old = "11", new = "share_cloud_coverage_11")
setnames(x = panel.policy.la.deter.built.clouds.coverage.df, old = "12", new = "share_cloud_coverage_12")

# changes column class
panel.policy.la.deter.built.clouds.coverage.df$year <- as.numeric(panel.policy.la.deter.built.clouds.coverage.df$year)



# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# LABELS
label(panel.policy.la.deter.built.clouds.coverage.df$muni_code)               <- "municipality code (7-digit, IBGE)"
label(panel.policy.la.deter.built.clouds.coverage.df$year)                    <- "year of reference"
label(panel.policy.la.deter.built.clouds.coverage.df$share_cloud_coverage_01) <- "share of the muni cloud coverage in JAN"
label(panel.policy.la.deter.built.clouds.coverage.df$share_cloud_coverage_02) <- "share of the muni cloud coverage in FEB"
label(panel.policy.la.deter.built.clouds.coverage.df$share_cloud_coverage_03) <- "share of the muni cloud coverage in MAR"
label(panel.policy.la.deter.built.clouds.coverage.df$share_cloud_coverage_04) <- "share of the muni cloud coverage in APR"
label(panel.policy.la.deter.built.clouds.coverage.df$share_cloud_coverage_05) <- "share of the muni cloud coverage in MAY"
label(panel.policy.la.deter.built.clouds.coverage.df$share_cloud_coverage_06) <- "share of the muni cloud coverage in JUN"
label(panel.policy.la.deter.built.clouds.coverage.df$share_cloud_coverage_07) <- "share of the muni cloud coverage in JUL"
label(panel.policy.la.deter.built.clouds.coverage.df$share_cloud_coverage_08) <- "share of the muni cloud coverage in AUG"
label(panel.policy.la.deter.built.clouds.coverage.df$share_cloud_coverage_09) <- "share of the muni cloud coverage in SEP"
label(panel.policy.la.deter.built.clouds.coverage.df$share_cloud_coverage_10) <- "share of the muni cloud coverage in OCT"
label(panel.policy.la.deter.built.clouds.coverage.df$share_cloud_coverage_11) <- "share of the muni cloud coverage in NOV"
label(panel.policy.la.deter.built.clouds.coverage.df$share_cloud_coverage_12) <- "share of the muni cloud coverage in DEC"




# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(panel.policy.la.deter.built.clouds.coverage.df, 
     file = file.path("data/built/land_cover/deter", "policy_la_deter_built_clouds_coverage_panel_df.Rdata"))





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------