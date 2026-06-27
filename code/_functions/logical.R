
# > PROJECT INFO
# NAME: FUNCTION REPOSITORY
# LEAD: TEAM EFFORT
#
# > THIS SCRIPT
# AIM: BUILD LOGICAL FUNCTIONS
# AUTHOR: CLARISSA GANDOUR
#
# > EDIT DETAILS
# BY: -
# ON: -
#
# > NOTES
# 1: -





# LOGICAL TESTS -------------------------------------------------------------------------------------------------------------------------------------

IdenticalMultipleArgs <- function(...) {
  # TESTS EQUALITY ACROSS MULTIPLE ITEMS
  #
  # ARGS
  #   ...: item names separated by commas (do not use " " to list item names)
  #
  # RETURNS
  #   logical value T if all tested items are identical

  args <- c(...)

  if (length(args) > 2L) {
    out <- c(identical(args[1], args[2]), IdenticalMultipleArgs(args[-1]))  # recursively call IdenticalMultipleArgs() such that each new iteration
                                                                            # excludes previous iteration's first item
  } else {
    out <- identical(args[1], args[2])
  }

  return(all(out))  # returns T if all values in 'out' are T
}





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------