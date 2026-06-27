
# > PROJECT INFO
# NAME: DATABASE CONSTRUCTION - BRAZILIAN INDIGENOUS LANDS
# LEAD: CLARISSA GANDOUR
#
# > THIS SCRIPT
# AIM: BUILD PROJECT-SPECIFIC FUNCTIONS (IE. FUNCTIONS ARE NOT GENERAL ENOUGH TO BE IN CENTRAL FUNCTION REPOSITORY)
# AUTHOR: (ADAPTED FROM) PEDRO PEIXOTO
#
# > EDIT DETAILS
# BY: CLARISSA GANDOUR
# ON: AUG/25/2016
#
# > NOTES
# 1. -





# LATIN CHARACTER CONVERSION ------------------------------------------------------------------------------------------------------------------------

DiacriticRemoval <- function(list.isa.scrap) {
  # CONVERTS LATIN CHARACTERS IN LIST RESULTING FROM ISA WEBSITE DATA SCRAPPING
  #
  # ARGS
  #   list.isa.scrap: large list resulting from scrapping of ISA website (composed of sublists, each, in turn, composed of IL name and associated df)
  #
  # RETURNS
  #   large list (same format as ARG) in which strings with special characters have been replaced by strings with non-special characters

  list.isa.scrap[[1]]        <- iconv(list.isa.scrap[[1]], from = "UTF-8", to = "ASCII//TRANSLIT")         # name of IL
  names(list.isa.scrap[[2]]) <- iconv(names(list.isa.scrap[[2]]), from = "UTF-8", to = "ASCII//TRANSLIT")  # column names in status history df
  list.isa.scrap[[2]]        <- LatinCharacterConversion(list.isa.scrap[[2]])                                 # content in status history df

  return(list.isa.scrap)
}





# STATUS HISTORY CONSTRUCTION -----------------------------------------------------------------------------------------------------------------------

# ProtectionDateIdentifier function revised to include 'ignore.case = T' due to varying spelling (regarding capitalization) in original data - use code
# below for cross-check:
#   check <- unlist(status.history.isa, recursive = F)
#
#   is.even <- function(x) x %% 2 == 0
#   check <- check[is.even(seq_along(check))]
#
#   for (i in seq_along(check)) {
#     check[[i]]$Etapa <- as.factor(check[[i]]$Etapa)
#   }
#
#   check.df <- data.frame()
#
#   for (i in 1:length(test2)) {
#     check.df <- rbind(check.df, check[[i]])
#   }
#
#   summary(check.df$Etapa)

ProtectionDateIdentifier <- function(list.isa.scrap, dates) {
  # BUILDS STATUS HISTORY FOR INDIGENOUS LANDS LISTED IN ISA WEBSITE
  #
  # ARGS
  #   list.isa.scrap: large list resulting from scrapping of ISA website (composed of sublists, each, in turn, composed of IL name and associated df)
  #   dates: option relevant for ILs that have multiple data entries for a single demarcation status
  #            dates = "first" -> only first (earliest) same-status entry stored in return object
  #            dates = "last"  -> only last (latest) same-status entry stored in return object
  #
  # RETURNS
  #   status.dates.isa: data frame consulting ILs names, status dates for 'declared', 'approved' and 'reserved'
  #
  # notes:
  #   1. function selects ILs in only two stages of demarcartion (delimited and approved), plus indigenous reserves
  #   2. on the use of as.Date(NA): because ProtectionDateIdentifier will be used inside a function of the apply family, returned object binds NAs (logical
  #      value) with dates. If NAs are not coerced from "logical" to "Date" prior to binding, R coerces them to a common class (typically numeric),
  #      causing date columns to be of class "numeric". Recording missing entries as as.Date(NA) avoids this issue.
  #   3. list.isa.scrap[[1]] refers to the first component of each large list element (IL name, or status.history,isa[[X]][[1]])) and
  #      list.isa.scrap[[2]] refers to the second component of each large list element (IL data frame, or status.history,isa[[X]][[2]]))



  # NAME SELECTION
  IL_name <- list.isa.scrap[[1]]



  # PROTECTION DATE SELECTION
  # ILs in 'declared' stage
  if (any(grepl("DECLARADA", list.isa.scrap[[2]]$Etapa, ignore.case = T) == TRUE)) {

    date_declared_isa <- list.isa.scrap[[2]][grepl("DECLARADA", list.isa.scrap[[2]]$Etapa, ignore.case = T), ]$Data
    date_declared_isa <- as.Date(date_declared_isa, format = "%d/%m/%Y")

    if (length(date_declared_isa) > 1) {

      if (dates == "first") {
        date_declared_isa <- min(date_declared_isa, na.rm = TRUE)
      }

      if (dates == "last") {
        date_declared_isa <- max(date_declared_isa, na.rm = TRUE)
      }
    }

  } else {

    date_declared_isa <- as.Date(NA)
  }


  # ILs in 'approved' stage
  if (any(grepl("HOMOLOGADA", list.isa.scrap[[2]]$Etapa, ignore.case = T) == TRUE)) {

    date_approved_isa <- list.isa.scrap[[2]][grepl("HOMOLOGADA", list.isa.scrap[[2]]$Etapa, ignore.case = T), ]$Data
    date_approved_isa <- as.Date(date_approved_isa, format = "%d/%m/%Y")

    if (length(date_approved_isa) > 1) {

      if (dates == "first") {
        date_approved_isa <- min(date_approved_isa, na.rm = TRUE)
      }

      if (dates == "last") {
        date_approved_isa <- max(date_approved_isa, na.rm = TRUE)
      }
    }

  } else {

    date_approved_isa <- as.Date(NA)
  }


  # ILs in 'reserved' stage
    if (any(grepl("RESERVADA", list.isa.scrap[[2]]$Etapa, ignore.case = T) == TRUE)) {

    date_reserved_isa <- list.isa.scrap[[2]][grepl("RESERVADA", list.isa.scrap[[2]]$Etapa, ignore.case = T), ]$Data
    date_reserved_isa <- as.Date(date_reserved_isa, format = "%d/%m/%Y")

    if (length(date_reserved_isa) > 1) {

      if (dates == "first") {
        date_reserved_isa <- min(date_reserved_isa, na.rm = TRUE)
      }

      if (dates == "last") {
        date_reserved_isa <- max(date_reserved_isa, na.rm = TRUE)
      }
    }

  } else {

    date_reserved_isa <- as.Date(NA)
  }


  # OUTPUT
  status.dates.isa <- data.frame(IL_name, date_declared_isa, date_approved_isa, date_reserved_isa, stringsAsFactors = F)
  names(status.dates.isa) <- c("IL_name", "date_declared_isa", "date_approved_isa", "date_reserved_isa")

  return(status.dates.isa)
}





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------