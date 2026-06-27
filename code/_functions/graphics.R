# > PROJECT INFO
# NAME: FUNCTION REPOSITORY
# LEAD: TEAM EFFORT
#
# > THIS SCRIPT
# AIM: BUILD GRAPHIC SPECIFIC FUNCTIONS
# AUTHOR: TEAM EFFORT
#
# > EDIT DETAILS
# BY: -
# ON: -
#
# > NOTES
# 1: -





# SET OR VIEW THE GRAPHICS PALETTE ------------------------------------------------------------------------------------------------------------------

palette()   # obtain the current palette

# KINDS OF PALETTE
palette(gray(seq(0,.9,len = 20))) # gray scales
palette(rainbow(6)) # six color rainbow


# INPUT scales
INPUT.colors     <- c("#80466B", "#825972", "#99738C", "#C58AAF", "#E0C1D5", "#529B6C", "#6AAA81", "#94CCA8", "#B9D9C1", "#CEE7E0", "#8F4C4D",
                      "#B27272", "#C38181", "#D09494","#E2A8A7", "#548D9D", "#739DB2", "#82B1C3", "#8FC2D2", "#9FD0E1", "#A08157", "#B29B74",
                      "#C0A780", "#D7BB8E", "#E8CE9F", "#6E6E6D", "#808181", "#969695","#C0BFBF", "#D0D0D1", "#374151", "#495466", "#596577", 
                      "#6A7689", "#7A899E")

# colors associated to the numbers
# creates a palette

palette(INPUT.colors)  # sets the palette


# INPUT scales with contrast
INPUT.colors.contrast <- c("#80466B", "#825972", "#99738C", "#C58AAF", "#E0C1D5", "#529B6C", "#6AAA81", "#94CCA8", "#B9D9C1", "#CEE7E0", "#8F4C4D",
                           "#B27272", "#C38181", "#D09494","#E2A8A7", "#548D9D", "#739DB2", "#82B1C3", "#8FC2D2", "#9FD0E1", "#A08157", "#B29B74",
                           "#C0A780", "#D7BB8E", "#E8CE9F", "#6E6E6D", "#808181", "#969695","#C0BFBF", "#D0D0D1", "#374151", "#495466", "#596577", 
                           "#6A7689", "#7A899E", "firebrick")

# colors associated to the numbers
# creates a palette

palette(INPUT.colors.contrast)

# colors associated to the numbers
# creates a palette

# CPI scales
CPI.colors <- c("#B43535", "#DB6530", "#EAC483", "#37746C", "#557CA0", "#815871", "#6D6E70", "#A7A9AB")
# colors associated to the numbers
# creates a palette

palette(CPI.colors)  # sets the palette



# PLOT
# matplot(outer(1:100, 1:30), type = "l", lty = 1,lwd = 2, col = CPI.colors[1:8],
#       main = "Color Scales Palette")   # color rainbow

pie(rep(1, 35), col = INPUT.colors[1:35], main = "Color Scales Palette")  # color wheel
# notice this works regardless
# notice this works regardless
# of the current palette


# pie(rep(1, 28), col = 1:28, main = "Color Scales Palette")  # this, however, depends on the current palette
# notice the description of palette():
#   View or manipulate the color palette
#   which is used when a col= has a
#   numeric index.

# palette("default")    # reset to the default





# BASIC GGPLOT MAP CONSTRUCTION THEME ---------------------------------------------------------------------------------------------------------------
# NOTES ON GGPLOT :
# ggplot can only do one hole per poly. To plot polygons with multiple holes, e.g. deter clouds, place factor(hole) inside fill and col arguments
# and determine colours for both inside and outside of holes. See code on deter clouds maps for example.

theme_CPI <- function(base_size = 10, font = "Calibri") {

  
  theme(
       
        # AXIS
        axis.title.x=element_blank(),  # element_blank() removes feature
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        
        
        # BACKGRUND
        panel.background = element_rect(fill="white", colour="white", color="white"),
        
        
        # LEGEND
        legend.position="bottom",
        legend.box = "horizontal",
        legend.title =  element_blank(),
        legend.background = element_rect(fill="transparent", colour= NA),
        legend.key        = element_rect(fill="transparent", colour= NA , size=5),
        legend.margin     = margin(t = 0, unit='cm'), 
        legend.text	      = element_text(size=10),
        legend.justification=c(0.5, 0),
        legend.spacing.x  = unit(0.2, 'cm'),
        
    

  
        # TITLE
        plot.title    = element_text(size = 13, face = "bold", hjust=0.5),
        plot.subtitle = element_text(size = 9, hjust = 0.5))
    
  }
  

theme_CPI_graphs <- function(base_size = 10, font = "Calibri") {
  
  
  theme(
    

    # AXIS
    axis.line = element_line(size = 1),
    axis.title = element_text(size = 14, face = "bold"),
    axis.text =  element_text(size = 13),

    
    # BACKGRUND
    panel.background    = element_rect(fill = NA, colour = NA), 
    panel.grid.major.x  = element_blank(),
    panel.grid.major.y  = element_line(colour = INPUT.colors[29], linetype = "solid"), 

    
    
    # LEGEND
    legend.position   = "bottom",
    legend.box        = "horizontal",
    legend.title      =  element_blank(),
    legend.background = element_rect(fill="transparent", colour= NA),
    legend.key        = element_rect(fill="transparent", colour= NA , size=5),
    legend.margin     = margin(t = 0, unit='cm'), 
    legend.text	      = element_text(size=13.5),
    legend.justification=c(0.5, 0),
    legend.spacing.x  = unit(0.2, 'cm'),
    
    
    
    # TITLE
    plot.title    = element_text(size = 15, face = "bold", hjust=0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5))
  
}

# 
print( "*** ATTENTION! - ALWAYS RESPECT THE ORDER IN LEVELS(FACTOR(COLUMN_NAME)) WHEN SETTING COLORS AND LEGENDS MANUALLY! ***")
    




# END OF SCRIPT ------------------------------------------------------------------------------------------------------------------------------------- 