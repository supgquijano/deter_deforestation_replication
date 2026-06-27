
# > PROJECT INFO
# NAME: PANEL FOR JULIANO - CPCG [CLIMATIC DATA, DAILY PRECIPITATION]
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: CREATE PANEL WITH CPCG DATA FOR BRAZIL; LEVEL: MUNI; JAN/2002 - MAY/2017
# AUTHOR: TOMAS DO VALLE
#
# > EDIT DETAILS
# BY: JOAO VIEIRA
# ON: SEP/21/2020
#
# > NOTES
# 1: -





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES
source("code/_functions/setup.R")
source(file.path("code/_functions/gis_crs.R"))
source(file.path("code/_functions/gis_raster.R"))


# LIBRARIES
# called in the setup.R script






# DATA INPUT------------------------------------------------------------------------------------------------------------------------------------------

# RAW DATA
# data input inside processing due to memory allocation

# ADMIN INPUT 
load("data/raw2clean/administrative/territorial_ibge/brazil/output/2007/admin_br_territory_muni_2007_spdf.Rdata")  




# DATA PROCESSING-------------------------------------------------------------------------------------------------------------------------------------
# run time: aprox 3h per year for each variable

# AUX OBJ
aux.file.sel      <- c("geo_br_weather_CPCG_precipitation_")  # file names
brazil.df         <- data.frame(matrix(NA, 5563, 169))
aux.folder.output <- "data/raw2clean/geography/weather_CPCG/output"
aux.folder.built  <- "data/built/geography/weather"


# subset
aux.year       <- c(2003:2016)
aux.month      <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")
aux.month.2018 <- c("01", "02", "03", "04", "05", "06", "07", "08")
subset.df      <- c("muni_code")

for (y in seq_along(aux.year)) {
  if (aux.year[[y]] != 2018) {
    for (i in seq_along(aux.month)) {
      aux.subset <- paste0(as.character(aux.year[[y]]), "_", aux.month[[i]])
      subset.df <- c(subset.df, aux.subset)
    }
  } else {
    for (i in seq_along(aux.month.2018)) {
      aux.subset <- paste0(as.character(aux.year[[y]]), "_", aux.month.2018[[i]])
      subset.df <- c(subset.df, aux.subset)
    }
  }
}

# partial cleanup
rm("aux.year", "aux.month", "aux.month.2018", "aux.subset")
gc()

# PREP AUXILIAR DATA
admin.br.muni.2007.spdf@data <- base::as.data.frame(admin.br.muni.2007.spdf@data)
admin.br.muni.2007.spdf      <- admin.br.muni.2007.spdf[admin.br.muni.2007.spdf$muni_code !=  2605459, ]  # excludes fernando de noronha too far away>
# from the coast
# PROCESSING

for (i in 1:nrow(admin.br.muni.2007.spdf@data)) {
  
  # select muni
  muni.code <- as.character(admin.br.muni.2007.spdf@data[i, 1])
  
  # load and merge intermediate outputs
  # precip
  muni.all.years.precip <- vector("list", length = 1)
  
  for (y in 1) {  # creating list of data frames which refer to treated municipality
    output.name <- paste0(aux.file.sel[[y]], muni.code,".Rdata")
    output.file <- load(paste0(aux.folder.output, "/", output.name))
    assign(x = paste0("muni.output.precip.", y), value = get(output.file))
    rm(list = "output.name", "output.file")
    rm(list = ls(pattern = "CPCG.precip."))
    muni.all.years.precip[[y]] <- get(paste0("muni.output.precip.", y))
  }
  
  muni.output.precip <- Reduce(function(...) merge(..., by = "muni_code"), muni.all.years.precip)  # combine list of data frames which refer to 
  # treated municipality in one data frame
  # partial cleanup                                                                                            
  rm(list = ls(pattern = "^muni.output.precip.[0-9]$"))
  rm(muni.all.years.precip)
  
  # partial clanup
  rm(list = ls(pattern = "^muni.output.[a-z][a-z][a-z]$"))
  
  # subset
  muni.output.precip <- base::as.data.frame(muni.output.precip)
  muni.output.precip <- muni.output.precip[subset.df]
  
  # register results 
  for (k in seq_along(muni.output.precip)) {
    brazil.df[i, k] <- muni.output.precip[1, k]
  } 
  
  # colnames
  colnames(brazil.df) <- colnames(muni.output.precip)
  
  # environmnet cleanup
  rm(muni.output.precip)
  
  # console output
  print(paste0("Finished Processing for ", i, " muni out of ", nrow(admin.br.muni.2007.spdf@data)))
  
  
}

# ENVIRONMENT CLEANUP
rm("subset.df", "admin.br.muni.2007.spdf", "aux.file.sel", "i", "k", "y", "muni.code")





# EXPORT PREP----------------------------------------------------------------------------------------------------------------------------------------- 


# RESHAPE 
# wide to long 
brazil.long.df <- reshape(brazil.df, 
                          direction = "long", 
                          varying = list(names(brazil.df)[2:169]),
                          times = names(brazil.df)[2:169],
                          v.names = "Value", 
                          idvar = "muni_code", 
                          timevar = "year")

# column prep
brazil.long.df$month        <- substr(x = brazil.long.df$year, start = 6, stop = 7) 
brazil.long.df$year         <- substr(x = brazil.long.df$year, start = 1, stop = 4)
colnames(brazil.long.df) <- c("muni_code","year", "precip", "month") 

# long to wide
brazil.long.df <- reshape(brazil.long.df,
                          direction = "wide",
                          idvar = c("muni_code", "year"),
                          timevar = "month",
                          sep = "_")

# fixing row names
row.names(brazil.long.df) <- 1:nrow(brazil.long.df)



# LABELS
label(brazil.long.df$muni_code) <- "municipality code (7-digit, IBGE)"
label(brazil.long.df$year)      <- "year of reference"
label(brazil.long.df$precip_01) <- "total precipitation for january (mm)"
label(brazil.long.df$precip_02) <- "total precipitation for february (mm)"
label(brazil.long.df$precip_03) <- "total precipitation for march (mm)"
label(brazil.long.df$precip_04) <- "total precipitation for april (mm)"
label(brazil.long.df$precip_05) <- "total precipitation for may (mm)"
label(brazil.long.df$precip_06) <- "total precipitation for for june (mm)"
label(brazil.long.df$precip_07) <- "total precipitation for july (mm)"
label(brazil.long.df$precip_08) <- "total precipitation for august (mm)"
label(brazil.long.df$precip_09) <- "total precipitation for september (mm)"
label(brazil.long.df$precip_10) <- "total precipitation for october (mm)"
label(brazil.long.df$precip_11) <- "total precipitation for november (mm)"
label(brazil.long.df$precip_12) <- "total precipitation for december (mm)"


# ASSIGN
return.obj <- "br.weather.CPCG.precipitation"

assign(x     = return.obj,
       value = brazil.long.df)

rm(brazil.long.df, brazil.df)

return.file <- gsub(x = return.obj, pattern = "\\.", replacement = "_")





# EXPORT----------------------------------------------------------------------------------------------------------------------------------------------

save(list = return.obj, file = file.path(aux.folder.built, 
                                         paste0(return.file, ".Rdata")))

# ENVIRONMENT CLEANUP
rm(list = return.obj)
rm(return.file, return.obj, aux.folder.output)

gc()





# END OF SCRIPT---------------------------------------------------------------------------------------------------------------------------------------