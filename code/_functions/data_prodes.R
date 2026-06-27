# > PROJECT INFO
# NAME: FUNCTION REPOSITORY
# LEAD: TEAM EFFORT
#
# > THIS SCRIPT
# AIM: FUNCTIONS SPECIFIC TO 'PRODES' DATASET
# AUTHOR: CLARISSA GANDOUR
#
# > EDIT DETAILS
# BY: -
# ON: -
#
# > NOTES
# 1: -





# YEAR_PRODES - VARIABLE CONSTRUCTION FUNCTION ------------------------------------------------------------------------------------------------------

YearProdes <- function(date) {
    
    # Creates year_prodes variable based on a date variable
    # PRODES year t defined as period from AUG/01/t-1 through JUL/31/t
    #
    # ARGS
    #   DATE VARIABLE
    #
    # RETURNS
    #   4 DIGIT "YEAR" VARIABLE
    
    
    # calculates PRODES year of creation based on month of creation
    year_prodes <- as.numeric()
    
    for (i in 1:nrow(settlements@data)) {
        if (as.numeric(format(creation_date[i], '%m')) <= 7) {
            year_prodes[i] <- as.numeric(format(creation_date[i], '%Y'))
        } else {
            year_prodes[i] <- as.numeric(format(creation_date[i], '%Y')) + 1
        }
    }
    return(year_prodes)
}





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------