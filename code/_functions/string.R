
# > PROJECT INFO
# NAME: FUNCTION REPOSITORY
# LEAD: TEAM EFFORT
#
# > THIS SCRIPT
# AIM: BUILD FUNCTIONS TO ADDRESS COMMON TREATMENT OF STRING CLASS IN BOTH SPATIAL AND NON-SPATIAL OBJECTS
# AUTHOR: CLARISSA GANDOUR
#
# > EDIT DETAILS
# BY: CLARISSA GANDOUR
# ON: MAR/22/16
#
# > NOTES
# 1: -





# LATIN CHARACTER CONVERSION -------------------------------------------------------------------------------------------------------------------------

LatinCharacterConversion <- function(x, FROM_enc = "UTF-8", TO_enc = "ASCII//TRANSLIT") {

  # CONVERTS LATIN CHARACTERS IN NON-SPATIAL OBJECTS
  #
  # ARGS
  #   x:        non-spatial object containing string characters
  #   FROM_enc: object's current encoding
  #   TO_enc:   object's target encoding
  #
  # RETURNS
  #   object in which strings with special characters have been replaced by strings with non-special characters
  #
  # OBS
  #   use (utils::head(iconvlist(), n = 500)) for list of available encodings

  for (i in 1:ncol(x)) {
    if (is.factor(x[, i])) {
      if (is.character(levels(x[, i]))) {  # if string is factor, recovers special characters from character levels
	      x[, i] <- iconv(x[, i], from = FROM_enc, to = TO_enc)
	    }
      x[, i] <- as.factor(x[, i])  # restores factor class
	  }
	  else if (is.character(x[, i])) {
	    x[, i] <- iconv(x[, i], from = FROM_enc, to = TO_enc)
	  }
  }
  return(x)
}



LatinCharacterConversionSp <- function(x, FROM_enc = "UTF-8", TO_enc = "ASCII//TRANSLIT") {

  # CONVERTS LATIN CHARACTERS IN SPATIAL OBJECTS
  #
  # ARGS
  #   x:        spatial object containing string characters
  #   FROM_enc: object's current encoding
  #   TO_enc:   object's target encoding
  #
  # RETURNS
  #   object in which strings with special characters have been replaced by strings with non-special characters
  #
  # OBS
  #   use (utils::head(iconvlist(), n = 500)) for list of available encodings

  for (i in 1:ncol(x@data)) {
    if (is.factor(x@data[, i])) {
	    if (is.character(levels(x@data[, i]))) {  # if string is factor, recovers special characters from character levels
	      x@data[, i] <- iconv(x@data[, i], from = FROM_enc, to = TO_enc)
	    }
      x@data[, i] <- as.factor(x@data[, i])  # restores factor class
    }
	  else if (is.character(x@data[, i])) {
	    x@data[, i] <- iconv(x@data[, i], from = FROM_enc, to = TO_enc)
	  }
  }
  return(x)
}



ConvertLatinCharsbyChars <- function(x) {
  
  # SUBSTITUTES LATIN CHARACTERS
  #
  # ARGS
  #   x: data.frame containing latin characters
  #
  # RETURNS
  #   data.frame or data.table without special characters
  # OBS: checks only character columns
  
  if (all(class(x) == "data.frame")) {
  
    # treating column names
    names(x) <- gsub("À", "A", names(x))
    names(x) <- gsub("Á", "A", names(x))
    names(x) <- gsub("Ã", "A", names(x))
    names(x) <- gsub("Â", "A", names(x))
    names(x) <- gsub("È", "E", names(x))
    names(x) <- gsub("É", "E", names(x))
    names(x) <- gsub("Ê", "E", names(x))
    names(x) <- gsub("Ì", "I", names(x))
    names(x) <- gsub("Í", "I", names(x))
    names(x) <- gsub("Î", "I", names(x))
    names(x) <- gsub("Ò", "O", names(x))
    names(x) <- gsub("Ó", "O", names(x))
    names(x) <- gsub("Õ", "O", names(x))
    names(x) <- gsub("Ô", "O", names(x))
    names(x) <- gsub("Ù", "U", names(x))
    names(x) <- gsub("Ú", "U", names(x))
    names(x) <- gsub("Û", "U", names(x))
    names(x) <- gsub("Ç", "C", names(x)) 
    names(x) <- gsub("à", "a", names(x))
    names(x) <- gsub("á", "a", names(x))
    names(x) <- gsub("ã", "a", names(x))
    names(x) <- gsub("â", "a", names(x))
    names(x) <- gsub("è", "e", names(x))
    names(x) <- gsub("é", "e", names(x))
    names(x) <- gsub("ê", "e", names(x))
    names(x) <- gsub("ì", "i", names(x))
    names(x) <- gsub("í", "i", names(x))
    names(x) <- gsub("î", "i", names(x))
    names(x) <- gsub("ò", "o", names(x))
    names(x) <- gsub("ó", "o", names(x))
    names(x) <- gsub("õ", "o", names(x))
    names(x) <- gsub("ô", "o", names(x))
    names(x) <- gsub("ù", "u", names(x))
    names(x) <- gsub("ú", "u", names(x))
    names(x) <- gsub("û", "u", names(x))
    names(x) <- gsub("ç", "c", names(x))
    
    # treating observations column by column 
    for (i in 1:ncol(x)) {
      if (class(x[, i]) == "character"){
        
        x[, i] <- gsub("À", "A", x[, i])
        x[, i] <- gsub("Á", "A", x[, i])
        x[, i] <- gsub("Ã", "A", x[, i])
        x[, i] <- gsub("Â", "A", x[, i])
        x[, i] <- gsub("È", "E", x[, i])
        x[, i] <- gsub("É", "E", x[, i])
        x[, i] <- gsub("Ê", "E", x[, i])
        x[, i] <- gsub("Ì", "I", x[, i])
        x[, i] <- gsub("Í", "I", x[, i])
        x[, i] <- gsub("Î", "I", x[, i])
        x[, i] <- gsub("Ò", "O", x[, i])
        x[, i] <- gsub("Ó", "O", x[, i])
        x[, i] <- gsub("Õ", "O", x[, i])
        x[, i] <- gsub("Ô", "O", x[, i])
        x[, i] <- gsub("Ù", "U", x[, i])
        x[, i] <- gsub("Ú", "U", x[, i])
        x[, i] <- gsub("Û", "U", x[, i])
        x[, i] <- gsub("Ç", "C", x[, i]) 
        x[, i] <- gsub("à", "a", x[, i])
        x[, i] <- gsub("á", "a", x[, i])
        x[, i] <- gsub("ã", "a", x[, i])
        x[, i] <- gsub("â", "a", x[, i])
        x[, i] <- gsub("è", "e", x[, i])
        x[, i] <- gsub("é", "e", x[, i])
        x[, i] <- gsub("ê", "e", x[, i])
        x[, i] <- gsub("ì", "i", x[, i])
        x[, i] <- gsub("í", "i", x[, i])
        x[, i] <- gsub("î", "i", x[, i])
        x[, i] <- gsub("ò", "o", x[, i])
        x[, i] <- gsub("ó", "o", x[, i])
        x[, i] <- gsub("õ", "o", x[, i])
        x[, i] <- gsub("ô", "o", x[, i])
        x[, i] <- gsub("ù", "u", x[, i])
        x[, i] <- gsub("ú", "u", x[, i])
        x[, i] <- gsub("û", "u", x[, i])
        x[, i] <- gsub("ç", "c", x[, i])
      } else {
  
        print(paste0("ATTENTION: function did not aplly to column ", colnames(x)[i], " because its class was not 'character'!"))
      }
    }
    
  } else {

    stop("Function must be applied before coversion to data.table")
  }
  
  return(x)
  
}

ConvertLatinCharsbyCharsSp <- function(x) {
 
 # SUBSTITUTES LATIN CHARACTERS IN SPDF
 #
 # ARGS
 #   x: spatial data.frame containing latin characters
 #
 # RETURNS
 #   spatial data.frame without special characters
 # OBS: checks only character columns
 
 if (all(class(x@data) == "data.frame")) {
  
  # treating column names
  names(x@data) <- gsub("À", "A", names(x@data))
  names(x@data) <- gsub("Á", "A", names(x@data))
  names(x@data) <- gsub("Ã", "A", names(x@data))
  names(x@data) <- gsub("Â", "A", names(x@data))
  names(x@data) <- gsub("È", "E", names(x@data))
  names(x@data) <- gsub("É", "E", names(x@data))
  names(x@data) <- gsub("Ê", "E", names(x@data))
  names(x@data) <- gsub("Ì", "I", names(x@data))
  names(x@data) <- gsub("Í", "I", names(x@data))
  names(x@data) <- gsub("Î", "I", names(x@data))
  names(x@data) <- gsub("Ò", "O", names(x@data))
  names(x@data) <- gsub("Ó", "O", names(x@data))
  names(x@data) <- gsub("Õ", "O", names(x@data))
  names(x@data) <- gsub("Ô", "O", names(x@data))
  names(x@data) <- gsub("Ù", "U", names(x@data))
  names(x@data) <- gsub("Ú", "U", names(x@data))
  names(x@data) <- gsub("Û", "U", names(x@data))
  names(x@data) <- gsub("Ç", "C", names(x@data)) 
  names(x@data) <- gsub("à", "a", names(x@data))
  names(x@data) <- gsub("á", "a", names(x@data))
  names(x@data) <- gsub("ã", "a", names(x@data))
  names(x@data) <- gsub("â", "a", names(x@data))
  names(x@data) <- gsub("è", "e", names(x@data))
  names(x@data) <- gsub("é", "e", names(x@data))
  names(x@data) <- gsub("ê", "e", names(x@data))
  names(x@data) <- gsub("ì", "i", names(x@data))
  names(x@data) <- gsub("í", "i", names(x@data))
  names(x@data) <- gsub("î", "i", names(x@data))
  names(x@data) <- gsub("ò", "o", names(x@data))
  names(x@data) <- gsub("ó", "o", names(x@data))
  names(x@data) <- gsub("õ", "o", names(x@data))
  names(x@data) <- gsub("ô", "o", names(x@data))
  names(x@data) <- gsub("ù", "u", names(x@data))
  names(x@data) <- gsub("ú", "u", names(x@data))
  names(x@data) <- gsub("û", "u", names(x@data))
  names(x@data) <- gsub("ç", "c", names(x@data))
  
  # treating observations column by column 
  for (i in 1:ncol(x@data)) {
   if (class(x@data[, i]) == "character"){
    
    x@data[, i] <- gsub("À", "A", x@data[, i])
    x@data[, i] <- gsub("Á", "A", x@data[, i])
    x@data[, i] <- gsub("Ã", "A", x@data[, i])
    x@data[, i] <- gsub("Â", "A", x@data[, i])
    x@data[, i] <- gsub("È", "E", x@data[, i])
    x@data[, i] <- gsub("É", "E", x@data[, i])
    x@data[, i] <- gsub("Ê", "E", x@data[, i])
    x@data[, i] <- gsub("Ì", "I", x@data[, i])
    x@data[, i] <- gsub("Í", "I", x@data[, i])
    x@data[, i] <- gsub("Î", "I", x@data[, i])
    x@data[, i] <- gsub("Ò", "O", x@data[, i])
    x@data[, i] <- gsub("Ó", "O", x@data[, i])
    x@data[, i] <- gsub("Õ", "O", x@data[, i])
    x@data[, i] <- gsub("Ô", "O", x@data[, i])
    x@data[, i] <- gsub("Ù", "U", x@data[, i])
    x@data[, i] <- gsub("Ú", "U", x@data[, i])
    x@data[, i] <- gsub("Û", "U", x@data[, i])
    x@data[, i] <- gsub("Ç", "C", x@data[, i]) 
    x@data[, i] <- gsub("à", "a", x@data[, i])
    x@data[, i] <- gsub("á", "a", x@data[, i])
    x@data[, i] <- gsub("ã", "a", x@data[, i])
    x@data[, i] <- gsub("â", "a", x@data[, i])
    x@data[, i] <- gsub("è", "e", x@data[, i])
    x@data[, i] <- gsub("é", "e", x@data[, i])
    x@data[, i] <- gsub("ê", "e", x@data[, i])
    x@data[, i] <- gsub("ì", "i", x@data[, i])
    x@data[, i] <- gsub("í", "i", x@data[, i])
    x@data[, i] <- gsub("î", "i", x@data[, i])
    x@data[, i] <- gsub("ò", "o", x@data[, i])
    x@data[, i] <- gsub("ó", "o", x@data[, i])
    x@data[, i] <- gsub("õ", "o", x@data[, i])
    x@data[, i] <- gsub("ô", "o", x@data[, i])
    x@data[, i] <- gsub("ù", "u", x@data[, i])
    x@data[, i] <- gsub("ú", "u", x@data[, i])
    x@data[, i] <- gsub("û", "u", x@data[, i])
    x@data[, i] <- gsub("ç", "c", x@data[, i])
   } else {
    
    print(paste0("ATTENTION: function did not aplly to column ", colnames(x@data)[i], " because its class was not 'character'!"))
   }
  }
  
 } else {
  
  stop("Function must be applied before coversion to data.table")
 }
 
 return(x)
 
}

ConvertLatinCharsbyCharsSf <- function(x) {
 
 # SUBSTITUTES LATIN CHARACTERS IN SF
 #
 # ARGS
 #   x: sf data.frame containing latin characters
 #
 # RETURNS
 #   sf data.frame without special characters
 # OBS: checks only character columns
 
 require(sf)
 
 if (all(class(x) == c("sf", "data.frame"))) {
  
  x <- as.data.frame(x)
  
  # treating column names
  names(x) <- gsub("À", "A", names(x))
  names(x) <- gsub("Á", "A", names(x))
  names(x) <- gsub("Ã", "A", names(x))
  names(x) <- gsub("Â", "A", names(x))
  names(x) <- gsub("È", "E", names(x))
  names(x) <- gsub("É", "E", names(x))
  names(x) <- gsub("Ê", "E", names(x))
  names(x) <- gsub("Ì", "I", names(x))
  names(x) <- gsub("Í", "I", names(x))
  names(x) <- gsub("Î", "I", names(x))
  names(x) <- gsub("Ò", "O", names(x))
  names(x) <- gsub("Ó", "O", names(x))
  names(x) <- gsub("Õ", "O", names(x))
  names(x) <- gsub("Ô", "O", names(x))
  names(x) <- gsub("Ù", "U", names(x))
  names(x) <- gsub("Ú", "U", names(x))
  names(x) <- gsub("Û", "U", names(x))
  names(x) <- gsub("Ç", "C", names(x)) 
  names(x) <- gsub("à", "a", names(x))
  names(x) <- gsub("á", "a", names(x))
  names(x) <- gsub("ã", "a", names(x))
  names(x) <- gsub("â", "a", names(x))
  names(x) <- gsub("è", "e", names(x))
  names(x) <- gsub("é", "e", names(x))
  names(x) <- gsub("ê", "e", names(x))
  names(x) <- gsub("ì", "i", names(x))
  names(x) <- gsub("í", "i", names(x))
  names(x) <- gsub("î", "i", names(x))
  names(x) <- gsub("ò", "o", names(x))
  names(x) <- gsub("ó", "o", names(x))
  names(x) <- gsub("õ", "o", names(x))
  names(x) <- gsub("ô", "o", names(x))
  names(x) <- gsub("ù", "u", names(x))
  names(x) <- gsub("ú", "u", names(x))
  names(x) <- gsub("û", "u", names(x))
  names(x) <- gsub("ç", "c", names(x))
  
  # treating observations column by column 
  for (i in 1:ncol(x)) {
   if (all(class(x[, i]) == "character")){
    
    x[, i] <- gsub("À", "A", x[, i])
    x[, i] <- gsub("Á", "A", x[, i])
    x[, i] <- gsub("Ã", "A", x[, i])
    x[, i] <- gsub("Â", "A", x[, i])
    x[, i] <- gsub("È", "E", x[, i])
    x[, i] <- gsub("É", "E", x[, i])
    x[, i] <- gsub("Ê", "E", x[, i])
    x[, i] <- gsub("Ì", "I", x[, i])
    x[, i] <- gsub("Í", "I", x[, i])
    x[, i] <- gsub("Î", "I", x[, i])
    x[, i] <- gsub("Ò", "O", x[, i])
    x[, i] <- gsub("Ó", "O", x[, i])
    x[, i] <- gsub("Õ", "O", x[, i])
    x[, i] <- gsub("Ô", "O", x[, i])
    x[, i] <- gsub("Ù", "U", x[, i])
    x[, i] <- gsub("Ú", "U", x[, i])
    x[, i] <- gsub("Û", "U", x[, i])
    x[, i] <- gsub("Ç", "C", x[, i]) 
    x[, i] <- gsub("à", "a", x[, i])
    x[, i] <- gsub("á", "a", x[, i])
    x[, i] <- gsub("ã", "a", x[, i])
    x[, i] <- gsub("â", "a", x[, i])
    x[, i] <- gsub("è", "e", x[, i])
    x[, i] <- gsub("é", "e", x[, i])
    x[, i] <- gsub("ê", "e", x[, i])
    x[, i] <- gsub("ì", "i", x[, i])
    x[, i] <- gsub("í", "i", x[, i])
    x[, i] <- gsub("î", "i", x[, i])
    x[, i] <- gsub("ò", "o", x[, i])
    x[, i] <- gsub("ó", "o", x[, i])
    x[, i] <- gsub("õ", "o", x[, i])
    x[, i] <- gsub("ô", "o", x[, i])
    x[, i] <- gsub("ù", "u", x[, i])
    x[, i] <- gsub("ú", "u", x[, i])
    x[, i] <- gsub("û", "u", x[, i])
    x[, i] <- gsub("ç", "c", x[, i])
   } else {
    
    print(paste0("ATTENTION: function did not aplly to column ", colnames(x)[i], " because its class was not 'character'!"))
   }
  }
  
 } else {
  
  stop("Function must be applied before coversion to data.table")
 }
 
 x <- st_as_sf(x)
 
 return(x)
 
}



# BLANK SPACES --------------------------------------------------------------------------------------------------------------------------------------

StringTrim <- function(string) {
  # REMOVES LEADING/TRAILING AND DUPLICATE BLANK SPACES IN CHARACTER STRING
  #
  # ARGS
  #   string: character string
  #
  # RETURNS
  #   edited character string

  output <- gsub(pattern = "^\\s+|\\s+$", replacement = "",  x = string)  # removes leading/trailing blank spaces
  output <- gsub(pattern = "\\s+",        replacement = " ", x = output)  # removes duplicate blank spaces

  return(output)
}





# CAPITALIZATION ------------------------------------------------------------------------------------------------------------------------------------

SimpleCap <- function(string) {
  # CAPITALIZES ANY STRING, REGARDLESS OF WORD COUNT
  #
  # ARGS
  #   string: character string
  #
  # RETURNS
  #   capitalized character string

  s <- strsplit(string, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse=" ")
}





# DESTRING FUNCTION ---------------------------------------------------------------------------------------------------------------------------------

Destring <- function(dataframe) {

    # DESTRING FUNCTION (AS IN STATA) - returns numeric variable when possible, and character when as.numeric function output is all NA
    #
    # ARGS
    #   DATA FRAME (usually factor variables)
    #
    # RETURNS
    #   DATA FRAME - ONLY CHARACTER OR NUMERIC VARIABLES

    df.1    <- data.frame(lapply(dataframe, as.character), stringsAsFactors=FALSE)
    df.2    <- data.frame(lapply(df.1, as.numeric))

    names   <- names(dataframe)

    for (i in seq_along(names)) {
        if (sum(is.na(df.2[,i]))==length(df.2[,1])) {
            df.2[,i] <- df.1[,i]
        }
    }
    return(df.2)
}




# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------