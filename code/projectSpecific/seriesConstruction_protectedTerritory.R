
# > PROJECT INFO
# NAME: PROJECT DETERRING DEFORESTATION
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: PROTECTED TERRITORY - VARIABLES CONSTRUCTION
# AUTHOR: JOAO VEIRA
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/22/2020
#
# > NOTES
# -



# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source(file.path("code/_functions", "setup.R"))
source(file.path("code/_functions", "gis_geoprocessing.R"))
source(file.path("code/_functions", "unit_conversion.R"))


# LIBRARIES
# called in the setup.R script





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# protected areas
load(file.path("data/raw2clean/policy/protectedAreas_mma/output", "policy_br_protected_territory_pa_spdf.Rdata"))

# indigenous lands
load(file.path("data/raw2clean/policy/indigenousLands_funaiIsa/output", "policy_br_protected_territory_indigenous_lands_spdf.Rdata"))

# sample spatial
load(file.path("data/projectSpecific", "crossSection_sample_spdf.Rdata"))



# DATA MANIPULATION ----------------------------------------------------------------------------------------------------------------------------------

# change object names
protected.areas <- policy.br.protected.territory.pa.spdf
indigenous.lands <- policy.br.protected.territory.indigenous.lands.spdf



# ENVIRONMENT CLEANUP
rm(list = ls(pattern = "pa."))
rm(policy.br.protected.territory.indigenous.lands.spdf)


# change column name
data.table::setnames(protected.areas@data, "year_prodes_protection", "year")
data.table::setnames(indigenous.lands@data, "year_prodes_protection", "year")


# dplyr::selects columns
protected.areas <- protected.areas[  , c("PA_code", "PA_name", "PA_type", "year")]
indigenous.lands <- indigenous.lands[, c("IL_code", "IL_name", "IL_type", "year")]



# TOPOLOGY CHECK
protected.areas <- gBuffer(protected.areas, byid = TRUE, width = 0.00001)
protected.areas <- CondCleangeo(protected.areas)

indigenous.lands <- gBuffer(indigenous.lands, byid = TRUE, width = 0.00001)
indigenous.lands <- CondCleangeo(indigenous.lands)

crossSection.sample.spdf <- gBuffer(crossSection.sample.spdf, byid = TRUE, width = 0)
crossSection.sample.spdf <- CondCleangeo(crossSection.sample.spdf)



# SAMPLE SUBSET
protected.areas  <- crop(protected.areas,  crossSection.sample.spdf)
indigenous.lands <- crop(indigenous.lands, crossSection.sample.spdf)



# AGGREGATION BY DATE & TYPE
protected.areas.fp.list.by.year <- list("protected.area.fp.2003" = gBuffer(protected.areas[protected.areas$year <= 2003 &
                                                                                             protected.areas$PA_type == "FP", ], byid = T, width = 0),
                                        "protected.area.fp.2006" = gBuffer(protected.areas[protected.areas$year <= 2006 &
                                                                                             protected.areas$PA_type == "FP", ], byid = T, width = 0),
                                        "protected.area.fp.2007" = gBuffer(protected.areas[protected.areas$year <= 2007 &
                                                                                             protected.areas$PA_type == "FP", ], byid = T, width = 0),
                                        "protected.area.fp.2008" = gBuffer(protected.areas[protected.areas$year <= 2008 &
                                                                                             protected.areas$PA_type == "FP", ], byid = T, width = 0),
                                        "protected.area.fp.2009" = gBuffer(protected.areas[protected.areas$year <= 2009 &
                                                                                             protected.areas$PA_type == "FP", ], byid = T, width = 0),
                                        "protected.area.fp.2010" = gBuffer(protected.areas[protected.areas$year <= 2010 &
                                                                                             protected.areas$PA_type == "FP", ], byid = T, width = 0),
                                        "protected.area.fp.2011" = gBuffer(protected.areas[protected.areas$year <= 2011 &
                                                                                             protected.areas$PA_type == "FP", ], byid = T, width = 0),
                                        "protected.area.fp.2012" = gBuffer(protected.areas[protected.areas$year <= 2012 &
                                                                                             protected.areas$PA_type == "FP", ], byid = T, width = 0),
                                        "protected.area.fp.2013" = gBuffer(protected.areas[protected.areas$year <= 2013 &
                                                                                             protected.areas$PA_type == "FP", ], byid = T, width = 0),
                                        "protected.area.fp.2014" = gBuffer(protected.areas[protected.areas$year <= 2014 &
                                                                                             protected.areas$PA_type == "FP", ], byid = T, width = 0),
                                        "protected.area.fp.2015" = gBuffer(protected.areas[protected.areas$year <= 2015 &
                                                                                             protected.areas$PA_type == "FP", ], byid = T, width = 0),
                                        "protected.area.fp.2016" = gBuffer(protected.areas[protected.areas$year <= 2015 &
                                                                                             protected.areas$PA_type == "FP", ], byid = T, width = 0))


protected.areas.su.list.by.year <- list("protected.area.su.2003" = gBuffer(protected.areas[protected.areas$year <= 2003 &
                                                                                             protected.areas$PA_type == "SU", ], byid = T, width = 0),
                                        "protected.area.su.2006" = gBuffer(protected.areas[protected.areas$year <= 2006 &
                                                                                             protected.areas$PA_type == "SU", ], byid = T, width = 0),
                                        "protected.area.su.2007" = gBuffer(protected.areas[protected.areas$year <= 2007 &
                                                                                             protected.areas$PA_type == "SU", ], byid = T, width = 0),
                                        "protected.area.su.2008" = gBuffer(protected.areas[protected.areas$year <= 2008 &
                                                                                             protected.areas$PA_type == "SU", ], byid = T, width = 0),
                                        "protected.area.su.2009" = gBuffer(protected.areas[protected.areas$year <= 2009 &
                                                                                             protected.areas$PA_type == "SU", ], byid = T, width = 0),
                                        "protected.area.su.2010" = gBuffer(protected.areas[protected.areas$year <= 2010 &
                                                                                             protected.areas$PA_type == "SU", ], byid = T, width = 0),
                                        "protected.area.su.2011" = gBuffer(protected.areas[protected.areas$year <= 2011 &
                                                                                             protected.areas$PA_type == "SU", ], byid = T, width = 0),
                                        "protected.area.su.2012" = gBuffer(protected.areas[protected.areas$year <= 2012 &
                                                                                             protected.areas$PA_type == "SU", ], byid = T, width = 0),
                                        "protected.area.su.2013" = gBuffer(protected.areas[protected.areas$year <= 2013 &
                                                                                            protected.areas$PA_type == "SU", ], byid = T, width = 0),
                                        "protected.area.su.2014" = gBuffer(protected.areas[protected.areas$year <= 2014 &
                                                                                             protected.areas$PA_type == "SU", ], byid = T, width = 0),
                                        "protected.area.su.2015" = gBuffer(protected.areas[protected.areas$year <= 2015 &
                                                                                             protected.areas$PA_type == "SU", ], byid = T, width = 0),
                                        "protected.area.su.2016" = gBuffer(protected.areas[protected.areas$year <= 2016 &
                                                                                             protected.areas$PA_type == "SU", ], byid = T, width = 0))



# indigenous lands
indigenous.lands@data$year <- as.numeric(indigenous.lands@data$year)
indigenous.lands@data["year"][is.na(indigenous.lands@data["year"])] <- 1999  # assigns conservative (early) protection year to missing

indigenous.lands.list <- list("il.2003" = gBuffer(indigenous.lands[indigenous.lands$year <= 2003, ], byid = T, width = 0),
                              "il.2006" = gBuffer(indigenous.lands[indigenous.lands$year <= 2006, ], byid = T, width = 0),
                              "il.2007" = gBuffer(indigenous.lands[indigenous.lands$year <= 2007, ], byid = T, width = 0),
                              "il.2008" = gBuffer(indigenous.lands[indigenous.lands$year <= 2008, ], byid = T, width = 0),
                              "il.2009" = gBuffer(indigenous.lands[indigenous.lands$year <= 2009, ], byid = T, width = 0),
                              "il.2010" = gBuffer(indigenous.lands[indigenous.lands$year <= 2010, ], byid = T, width = 0),
                              "il.2011" = gBuffer(indigenous.lands[indigenous.lands$year <= 2011, ], byid = T, width = 0),
                              "il.2012" = gBuffer(indigenous.lands[indigenous.lands$year <= 2012, ], byid = T, width = 0),
                              "il.2013" = gBuffer(indigenous.lands[indigenous.lands$year <= 2013, ], byid = T, width = 0),
                              "il.2014" = gBuffer(indigenous.lands[indigenous.lands$year <= 2014, ], byid = T, width = 0),
                              "il.2015" = gBuffer(indigenous.lands[indigenous.lands$year <= 2015, ], byid = T, width = 0),
                              "il.2016" = gBuffer(indigenous.lands[indigenous.lands$year <= 2016, ], byid = T, width = 0))




# VAR CONSTRUCTION -----------------------------------------------------------------------------------------------------------------------------------

# create vector 
aux.years <- c("2003", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")

crossSection.sample.df <- crossSection.sample.spdf@data


# calculate share of protected area by muni by year
for (i in seq_along(aux.years)) {

  protected.areas.fp.list.by.year[[i]] <- gUnaryUnion(protected.areas.fp.list.by.year[[i]])
  
  protected.areas.fp.list.by.year[[i]] <- raster::intersect(protected.areas.fp.list.by.year[[i]], crossSection.sample.spdf)
  
  protected.areas.fp.list.by.year[[i]] <- st_as_sf(protected.areas.fp.list.by.year[[i]])

  protected.areas.fp.list.by.year[[i]]$protected_area <- unclass(st_area(protected.areas.fp.list.by.year[[i]], byid = T)) * convert.sqm.to.ha
  
  protected.areas.fp.list.by.year[[i]]$share_protArea_fp <- protected.areas.fp.list.by.year[[i]]$protected_area /
    protected.areas.fp.list.by.year[[i]]$muni_area

  protected.areas.fp.list.by.year[[i]] <- protected.areas.fp.list.by.year[[i]][, c("muni_code", "share_protArea_fp")]

  data.table::setnames(protected.areas.fp.list.by.year[[i]], "share_protArea_fp", paste0("share_protArea_fp_", aux.years[[i]]))
  
  protected.areas.fp.list.by.year[[i]] <- st_drop_geometry(protected.areas.fp.list.by.year[[i]])
  
  crossSection.sample.df <- merge(crossSection.sample.df, 
                protected.areas.fp.list.by.year[[i]], 
                all.x = T,
                by = "muni_code")

}

for (i in seq_along(aux.years)) {
  
  protected.areas.su.list.by.year[[i]] <- gUnaryUnion(protected.areas.su.list.by.year[[i]])
  
  protected.areas.su.list.by.year[[i]] <- raster::intersect(protected.areas.su.list.by.year[[i]], crossSection.sample.spdf)
  
  protected.areas.su.list.by.year[[i]] <- st_as_sf(protected.areas.su.list.by.year[[i]])
  
  protected.areas.su.list.by.year[[i]]$protected_area <- unclass(st_area(protected.areas.su.list.by.year[[i]], byid = T)) * convert.sqm.to.ha
  
  protected.areas.su.list.by.year[[i]]$share_protArea_su <- protected.areas.su.list.by.year[[i]]$protected_area /
    protected.areas.su.list.by.year[[i]]$muni_area
  
  protected.areas.su.list.by.year[[i]] <- protected.areas.su.list.by.year[[i]][, c("muni_code", "share_protArea_su")]
  
  data.table::setnames(protected.areas.su.list.by.year[[i]], "share_protArea_su", paste0("share_protArea_su_", aux.years[[i]]))
  
  protected.areas.su.list.by.year[[i]] <- st_drop_geometry(protected.areas.su.list.by.year[[i]])
  
  crossSection.sample.df <- merge(crossSection.sample.df, 
                            protected.areas.su.list.by.year[[i]], 
                            all.x = T,
                            by = "muni_code")
  
}

for (i in seq_along(aux.years)) {
  
  indigenous.lands.list[[i]] <- gUnaryUnion(indigenous.lands.list[[i]])
  
  indigenous.lands.list[[i]] <- raster::intersect(indigenous.lands.list[[i]], crossSection.sample.spdf)
  
  indigenous.lands.list[[i]] <- st_as_sf(indigenous.lands.list[[i]])
  
  indigenous.lands.list[[i]]$protected_area <- unclass(st_area(indigenous.lands.list[[i]], byid = T)) * convert.sqm.to.ha
  
  indigenous.lands.list[[i]]$share_protArea_il <- indigenous.lands.list[[i]]$protected_area /
    indigenous.lands.list[[i]]$muni_area
  
  indigenous.lands.list[[i]] <- indigenous.lands.list[[i]][, c("muni_code", "share_protArea_il")]
  
  data.table::setnames(indigenous.lands.list[[i]], "share_protArea_il", paste0("share_protArea_il_", aux.years[[i]]))
  
  indigenous.lands.list[[i]] <- st_drop_geometry(indigenous.lands.list[[i]])
  
  crossSection.sample.df <- merge(crossSection.sample.df, 
                            indigenous.lands.list[[i]], 
                            all.x = T,
                            by = "muni_code")
  
}

crossSection.sample.df$muni_area <- NULL

# transform from wide to long
series.protectedTerritory <- melt(crossSection.sample.df, id = "muni_code")

# caclulate yearly share of protected area
series.protectedTerritory <-
  series.protectedTerritory %>% 
  mutate(year = as.numeric(str_sub(variable, start = -4))) %>%  # keeps only the year number and convert it to numeric
  mutate(value = replace_na(value, 0)) %>% # replace NAs by 0s
  group_by(muni_code, year) %>% 
  dplyr::summarize(share_protArea = sum(value)) %>% # calculate total share of protected areas by year
  dplyr::select(muni_code, year, share_protArea) # select columns of interest

  



# EXPORT ---------------------------------------------------------------------------------------------------------------------------------------------

save(series.protectedTerritory, file = file.path("data/projectSpecific", "series_protectedTerritory.Rdata"))




# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------