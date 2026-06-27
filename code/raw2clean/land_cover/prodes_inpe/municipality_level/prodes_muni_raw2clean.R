
# > PROJECT INFO
# NAME: DATABASE CONSTRUCTION - ANNUAL MUNICIPALITY-LEVEL AMAZON LAND COVER
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: TREAT RAW BRAZILIAN AMAZON LAND COVER DATA TO PROVIDE MUNICIPALITY-BY-YEAR PANEL
# AUTHOR: DIEGO MENEZES
#
# > EDIT DETAILS
# BY: JOAO VIEIA
# ON: SEP/17/2020
#
# > NOTES
# -





# SETUP ---------------------------------------------------------------------------------------------------------------------------------------------

# SOURCES:
source(file.path("code/_functions/setup.R"))
source(file.path("code/_functions", "string.R"))
source(file.path("code/_functions", "missing.R"))



# LIBRARIES
# called in the setup.R script





# DATA INPUT ----------------------------------------------------------------------------------------------------------------------------------------

# MUNICIPALITY-LEVEL LEGAL AMAZON LAND COVER
# content: land cover at the municipality level (aggregation), Legal Amazon (extent), yearly as of 2000 (frequency)
# source: Brazilian Institute for Space Research (INPE) 
# available at: http://www.dpi.inpe.br/prodesdigital/prodesmunicipal.php
# raw data downloaded on: JAN/15/2016 (SEP/15/2020)
# web archived at: 
# [2000] https://web.archive.org/web/20200915164422/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2000&estado=&ordem=DESMATAMENTO2000&type=tabela&output=txt
# [2001] https://web.archive.org/web/20200915164614/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2001&estado=&ordem=DESMATAMENTO2001&type=tabela&output=txt&
# [2002] https://web.archive.org/web/20200915164920/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2002&estado=&ordem=DESMATAMENTO2002&type=tabela&output=txt
# [2003] https://web.archive.org/web/20200915165014/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2003&estado=&ordem=DESMATAMENTO2003&type=tabela&output=txt
# [2004] https://web.archive.org/web/20200915165038/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2004&estado=&ordem=DESMATAMENTO2004&type=tabela&output=txt
# [2005] https://web.archive.org/web/20200915165211/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2005&estado=&ordem=DESMATAMENTO2005&type=tabela&output=txt
# [2006] https://web.archive.org/web/20200915165249/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2006&estado=&ordem=DESMATAMENTO2006&type=tabela&output=txt
# [2007] https://web.archive.org/web/20200915165303/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2007&estado=&ordem=DESMATAMENTO2007&type=tabela&output=txt
# [2008] https://web.archive.org/web/20200915165337/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2008&estado=&ordem=DESMATAMENTO2008&type=tabela&output=txt
# [2009] https://web.archive.org/web/20200915165353/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2009&estado=&ordem=DESMATAMENTO2009&type=tabela&output=txt
# [2010] https://web.archive.org/web/20200915165427/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2010&estado=&ordem=DESMATAMENTO2010&type=tabela&output=txt
# [2011] https://web.archive.org/web/20200915165439/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2011&estado=&ordem=DESMATAMENTO2011&type=tabela&output=txt
# [2012] https://web.archive.org/web/20200915165504/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2012&estado=&ordem=DESMATAMENTO2012&type=tabela&output=txt
# [2013] https://web.archive.org/web/20200915165526/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2013&estado=&ordem=DESMATAMENTO2013&type=tabela&output=txt
# [2014] https://web.archive.org/web/20200915165551/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2014&estado=&ordem=DESMATAMENTO2014&type=tabela&output=txt
# [2015] https://web.archive.org/web/20200915165615/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2015&estado=&ordem=DESMATAMENTO2015&type=tabela&output=txt
# [2016] https://web.archive.org/web/20200915165626/http://www.dpi.inpe.br/prodesdigital/tabelatxt.php?ano=2016&estado=&ordem=DESMATAMENTO2016&type=tabela&output=txt
# raw data archived on: SEP/15/2020
#
# obs: total PRODES category areas add up to more than municipal area in some cases

# list all .txt input files
incoming.txt.files <- list.files(path = "data/raw2clean/land_cover/prodes_inpe/municipality_level/input", 
                                 pattern = "*.txt",
                                full.names = T)

# load all .txt files into a list
prodes.muni.all.years <- lapply(incoming.txt.files, read.table, header=T, sep = ",", quote = "", row.names = NULL, stringsAsFactors = FALSE) 

# clean environment
rm(incoming.txt.files)



# DATA EXPLORATION
#summary(prodes.muni.all.years)    # object is a list of data frames
#class(prodes.muni.all.years)
#View(prodes.muni.all.years[[1]]) # select specific year for inspection





# DATASET CLEANUP AND PREP --------------------------------------------------------------------------------------------------------------------------

# COLUMN NAME TREATMENT
number.of.years <- length(prodes.muni.all.years)

# column name format 'IncrementoXXXXYYYY', where XXXX indicates year t-1 and YYYY indicates year t
for (i in 1:number.of.years) {
  invisible(lapply(names(prodes.muni.all.years[[i]]), # 'invisible' omits output from console
                   function(x) setnames(prodes.muni.all.years[[i]], x, gsub(paste0("Incremento", "[0-9]{8}"), "Incremento", x))))
}

for (i in 1:number.of.years) {
  names(prodes.muni.all.years[[i]])[which(names(prodes.muni.all.years[[i]]) == "Incremento")] <- paste0("Incremento", 2000 + (i - 1))
}



# TOTAL PRODES AREA CROSS-CHECK
# PRODES categories (forest, nonforest, deforestation, hidrography, cloud, residue, nonobserved) are mutually exclusive, so areas should add up to
# 100%... but don't when using original by-cateogry area data
# original data does NOT contain information on 'residue' PRODES category

for (i in seq_along(prodes.muni.all.years)) {
  prodes.muni.all.years[[i]]$sum_check <- round((prodes.muni.all.years[[i]]$Desmatado
                                                 + prodes.muni.all.years[[i]]$Floresta
                                                 + prodes.muni.all.years[[i]]$Nuvem
                                                 + prodes.muni.all.years[[i]]$NaoObservado
                                                 + prodes.muni.all.years[[i]]$NaoFloresta
                                                 + prodes.muni.all.years[[i]]$Hidrografia) / (prodes.muni.all.years[[i]]$AreaKm2), 2) * 100

  prodes.muni.all.years[[i]]$Diff      <- round(prodes.muni.all.years[[i]]$sum_check - prodes.muni.all.years[[i]]$Soma, 2)
}


my.difflist <- foreach(i = 1:number.of.years, .combine = data.frame) %do% {
  count(prodes.muni.all.years[[i]], "Diff")  # reports difference between calculated and informed (original) total PRODES areas
}
# yields max difference of 1pp, indicating share values above 100% are not an error in original 'Soma' column



# PANEL MERGE

# column cleanup
for (i in 1:number.of.years) {
  prodes.muni.all.years[[i]] <- subset(prodes.muni.all.years[[i]], select = -c(Nr, Lat, Long, Latgms, Longms, Soma, sum_check, Diff))
}


# environment cleanup
rm(my.difflist, i, number.of.years)


# merge
# Reduce used to apply binary function to more than two objects -- needed to merge multiple dataframes, as merge(x,y) is binary
prodes.muni.panel <- Reduce(function(x,y) {merge(x, y, all = T)}, prodes.muni.all.years)
rm(prodes.muni.all.years)



# MERGED DATASET CLEANUP

# column cleanup
# use "." for separator in column name in preparation for dataframe reshape
names(prodes.muni.panel) <- sub(pattern = "Municipio",    replacement = "muni_name",                    x = names(prodes.muni.panel))
names(prodes.muni.panel) <- sub(pattern = "CodIbge",      replacement = "muni_code",                    x = names(prodes.muni.panel))
names(prodes.muni.panel) <- sub(pattern = "Estado",       replacement = "state_uf" ,                    x = names(prodes.muni.panel))
names(prodes.muni.panel) <- sub(pattern = "AreaKm2",      replacement = "area_muni",                    x = names(prodes.muni.panel))
names(prodes.muni.panel) <- sub(pattern = "Desmatado",    replacement = "prodes_deforest_accumulated.", x = names(prodes.muni.panel))
names(prodes.muni.panel) <- sub(pattern = "Incremento",   replacement = "prodes_deforest_increment.",   x = names(prodes.muni.panel))
names(prodes.muni.panel) <- sub(pattern = "NaoFloresta",  replacement = "prodes_nonforest.",            x = names(prodes.muni.panel))
names(prodes.muni.panel) <- sub(pattern = "Floresta",     replacement = "prodes_forest.",               x = names(prodes.muni.panel))
names(prodes.muni.panel) <- sub(pattern = "Nuvem",        replacement = "prodes_cloud.",                x = names(prodes.muni.panel))
names(prodes.muni.panel) <- sub(pattern = "NaoObservado", replacement = "prodes_nonobserved.",          x = names(prodes.muni.panel))
names(prodes.muni.panel) <- sub(pattern = "Hidrografia",  replacement = "prodes_hidrography.",          x = names(prodes.muni.panel))


# latin character conversion
prodes.muni.panel <- LatinCharacterConversion(prodes.muni.panel, FROM_enc = "", TO_enc = "ASCII//TRANSLIT")


# merged wide dataset exploration
#class(prodes.muni.panel)
#summary(prodes.muni.panel)
MissingIdColumns(prodes.muni.panel)  # identifies columns containing missing data - 2000 deforestation increment missing in original data
#View(prodes.muni.panel)





# DATAFRAME RESHAPE ---------------------------------------------------------------------------------------------------------------------------------

colnames(prodes.muni.panel)  # ids position of time-invariant columns - cols 1:4 are time-invariant


prodes.muni.panel.long <- reshape(prodes.muni.panel, varying = c(5:dim(prodes.muni.panel)[2]),
                                  timevar = "year", idvar = "muni_code", direction = "long", sep = ".")  # reshapes from WIDE to LONG


prodes.muni.panel.long <- prodes.muni.panel.long[order(prodes.muni.panel.long$muni_code, prodes.muni.panel.long$year), ]
prodes.muni.panel.wide <- prodes.muni.panel


# merged long dataset exploration
#class(prodes.muni.panel.long)
#summary(prodes.muni.panel.long)
MissingIdColumns(prodes.muni.panel.long) # identifies columns containing missing data
#View(prodes.muni.panel.long)





# EXPORT PREP ----------------------------------------------------------------------------------------------------------------------------------------

# LABELS 
label(prodes.muni.panel.long$muni_name)                   <- "municipality name" 
label(prodes.muni.panel.long$muni_code)                   <- "municipality code (7-digit, IBGE)" 
label(prodes.muni.panel.long$state_uf)                    <- "state name (abbreviation)" 
label(prodes.muni.panel.long$area_muni)                   <- "municipal area (sq km)" 
label(prodes.muni.panel.long$year)                        <- "year of reference (PRODES year)" 
label(prodes.muni.panel.long$prodes_deforest_accumulated) <- "total deforested area through Jul/t-1 (sq km; PRODES)" 
label(prodes.muni.panel.long$prodes_deforest_increment)   <- "increment in deforested area from Aug/t-1 through Jul/t (sq km; PRODES)" 
label(prodes.muni.panel.long$prodes_forest)               <- "remaining primary forest area (sq km; PRODES)" 
label(prodes.muni.panel.long$prodes_cloud)                <- "area covered by clouds during remote sensing (sq km; PRODES)" 
label(prodes.muni.panel.long$prodes_nonobserved)          <- "area blocked from view during remote sensing (sq km; PRODES)" 
label(prodes.muni.panel.long$prodes_nonforest)            <- "area originally covered by something other than tropical forest (sq km; PRODES)" 
label(prodes.muni.panel.long$prodes_hidrography)          <- "area covered by bodies of water (sq km; PRODES)" 

# changes object name for exportation
landcover.la.prodes.munilevel.wide.df <- prodes.muni.panel.wide
landcover.la.prodes.munilevel.long.df <- prodes.muni.panel.long



# POST-TREATMENT OVERVIEW
#label(prodes.muni.panel.long)          # prints all labels
#describe(prodes.muni.panel.long)       # full by-variable description
#lapply(prodes.muni.panel.long, class)  # checking column class
#View(prodes.muni.panel.long)





# EXPORT --------------------------------------------------------------------------------------------------------------------------------------------

save(landcover.la.prodes.munilevel.wide.df, landcover.la.prodes.munilevel.long.df, 
     file = file.path(file.path("data/raw2clean/land_cover/prodes_inpe/municipality_level/output", 
                             "landcover_la_prodes_munilevel_df.RData")))





# END OF SCRIPT: ------------------------------------------------------------------------------------------------------------------------------------