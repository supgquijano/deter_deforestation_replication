
# > PROJECT INFO
# NAME: DETERRING DEFORESTATION IN THE AMAZON: ENVIRONMENTAL MONITORING AND LAW ENFORCEMENTE - CODE AND DATA REPLICATION ARCHIVE
#
# > THIS SCRIPT
# AIM: CREATION OF MAPS FOR DETER CLOUDS AND ALERTS
#
# > NOTES
#





# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# LIBRARIES & FUNCTIONS
source(file.path("code/_functions/setup.R"))



# GRAPHIC ELEMENTS
# ggplot can only do one hole per poly. To plot polygons with multiple holes, e.g. deter clouds, place factor(hole) inside fill and col arguments
# and determine colours for both inside and outside of holes.

# color palette
INPUT.colors.contrast <- c("#80466B", "#825972", "#99738C", "#C58AAF", "#E0C1D5", "#529B6C", "#6AAA81", "#94CCA8", "#B9D9C1", "#CEE7E0", "#8F4C4D",
                           "#B27272", "#C38181", "#D09494","#E2A8A7", "#548D9D", "#739DB2", "#82B1C3", "#8FC2D2", "#9FD0E1", "#A08157", "#B29B74",
                           "#C0A780", "#D7BB8E", "#E8CE9F", "#6E6E6D", "#808181", "#969695","#C0BFBF", "#D0D0D1", "#374151", "#495466", "#596577",
                           "#6A7689", "#7A899E", "firebrick", "palevioletred3", "black")

# theme
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
    plot.subtitle = element_text(size = 9, hjust = 0.5)
  )
}
  




# DATA INPUT & PREP ---------------------------------------------------------------------------------------------------------------------------------

# AUXILIARY OBJECTS
aux.years.deter <- c("2011")
aux.months <- c("JANUARY", "APRIL", "JULY", "OCTOBER")
aux.period <- c("Q1", "Q2", "Q3", "Q4")



# LOAD DATA
# ADMINISTRATIVE
load(file = file.path("data/raw2clean/administrative/territorial_ibge/legal_amazon/output", "admin_la_territory_sp.Rdata"))



# DETER ALERTS & CLOUDS
load(file = file.path("data/raw2clean/land_cover/deter_inpe/output", "deter_alerts_sp.Rdata"))
load(file = file.path("data/raw2clean/land_cover/deter_inpe/output", "deter_clouds_sp.Rdata"))



# AMAZON BIOME
load(file = file.path("data/raw2clean/geography/biomes_ibge/output", "geo_br_biomes_spdf.Rdata"))
amazonBiome  <- geo.br.biomes.spdf[geo.br.biomes.spdf@data$biome_name == "Amazon", ]
amazonBiome  <- crop(amazonBiome, admin.la.sp)  # removes part of Amazon biome outside Legal Amazon border



# DETER CLOUDS FORTIFY
for (y in seq_along(aux.years.deter)) {
  for (s in seq_along(aux.period)) {

    # TIMER
    time.start <- Sys.time()

    # DETER division -- first month of each quarter
    deterclouds.year <- get(paste0("policy.la.deter.clouds.", aux.years.deter[y], ".sp"))

    deterclouds.Q1 <- deterclouds.year[[1]]
    deterclouds.Q2 <- deterclouds.year[[4]]
    deterclouds.Q3 <- deterclouds.year[[7]]
    deterclouds.Q4 <- deterclouds.year[[10]]


    # recovers deter with generic name
    aux.obj.deter <- get(paste0("deterclouds.", aux.period[s]))

    # changes Spatial Polygons IDs to match with new ID created below on df
    aux.obj.deter <- spChFIDs(obj = aux.obj.deter, x = paste0("deterclouds.", aux.period[s], ".", 1:length(aux.obj.deter)))

    # creates data.frame to associaten with SP
    df <- data.frame(id = paste0("deterclouds.", aux.period[s], ".", 1:length(aux.obj.deter)), type = rep("DETER_CLOUDS", length(aux.obj.deter)),
                     year_prodes = aux.years.deter[y])

    # changes row.names to match with new ID created above on df
    row.names(df) <- df$id

    # associates the data frama with spatial polygons
    aux.obj.deter <- SpatialPolygonsDataFrame(aux.obj.deter, df)



    # FORTIFICATION
    fortified.sp <- fortify(aux.obj.deter, region = "id")
    fortified.sp <- merge(fortified.sp, df, by = "id")



    # RETURN
    assign(x     = paste0(paste0("deterclouds.", aux.years.deter[y], ".", aux.period[s], ".fortified")),
           value = fortified.sp)



    # ENVIRONMENT CLEANUP
    rm(fortified.sp, df, aux.obj.deter)
    gc()



    # TIMER
    time.end <- Sys.time()
    print(paste0("** started deter polygon fortification for ", aux.years.deter[y], " at ", time.start, " and finished at ", time.end))

  }

}



# DETER ALERTS FORTIFY
for (y in seq_along(aux.years.deter)) {
  for (s in seq_along(aux.period)) {

    # TIMER
    time.start <- Sys.time()

    # DETER division -- first month of each quarter
    deteralerts.year <- get(paste0("policy.la.deter.alerts.", aux.years.deter[y], ".sp"))

    deter.alerts.Q1 <- deteralerts.year[[1]]
    deter.alerts.Q2 <- deteralerts.year[[4]]
    deter.alerts.Q3 <- deteralerts.year[[7]]
    deter.alerts.Q4 <- deteralerts.year[[10]]


    # recovers deter with generic name
    aux.obj.deter <- get(paste0("deter.alerts.", aux.period[s]))

    # changes Spatial Polygons IDs to match with new ID created below on df
    aux.obj.deter <- spChFIDs(obj = aux.obj.deter, x = paste0("deter.alerts.", aux.period[s], ".", 1:length(aux.obj.deter)))

    # creates data.frame to associaten with SP
    df <- data.frame(id = paste0("deter.alerts.", aux.period[s], ".", 1:length(aux.obj.deter)), type = rep("DETER", length(aux.obj.deter)),
                     year_prodes = aux.years.deter[y])

    # changes row.names to match with new ID created above on df
    row.names(df) <- df$id

    # associates the data frama with spatial polygons
    aux.obj.deter <- SpatialPolygonsDataFrame(aux.obj.deter, df)



    # FORTIFICATION
    fortified.sp <- fortify(aux.obj.deter, region = "id")
    fortified.sp <- merge(fortified.sp, df, by = "id")



    # RETURN
    assign(x     = paste0(paste0("deter.alerts.", aux.years.deter[y], ".", aux.period[s], ".fortified")),
           value = fortified.sp)



    # ENVIRONMENT CLEANUP
    rm(fortified.sp, df, aux.obj.deter, deter.alerts.Q1, deter.alerts.Q2, deter.alerts.Q3, deter.alerts.Q4)
    gc()



    # TIMER
    time.end <- Sys.time()
    print(paste0("** started deter polygon fortification for ", aux.years.deter[y], " at ", time.start, " and finished at ", time.end))
    gc()
  }

}



# AUXILIAR FORTIFY
admin.la.fort       <- fortify(admin.la.sp)
amazonBiome.fort    <- fortify(amazonBiome)





# CLOUDS & ALERTS -----------------------------------------------------------------------------------------------------------------------------------
print("starting plots")
# PLOT
for (y in seq_along(aux.years.deter)) {

  for (s in seq_along(aux.period)) {

    # TIMER
    time.start <- Sys.time()

    aux.deter.clouds <- get(paste0("deterclouds.", aux.years.deter[y], ".", aux.period[s], ".fortified"))

    aux.deter.alerts <- get(paste0("deter.alerts.", aux.years.deter[y], ".", aux.period[s], ".fortified"))

    adminDiv_sampleDefinition <-  ggplot() +

      geom_polygon(data = aux.deter.clouds, aes(x = long, y = lat, group=group, fill= factor(hole)),   col = NA,  size = 0.0) +
      geom_polygon(data = aux.deter.alerts, aes(x = long, y = lat, group=group, fill= INPUT.colors.contrast[1]), col = "firebrick", size = 1.0) +
      geom_polygon(data = amazonBiome.fort, aes(x = long, y = lat, group=group, col= INPUT.colors.contrast[26]), fill = NA,  size= 0.5 ) +
      geom_polygon(data = admin.la.fort,    aes(x = long, y = lat, group=group, col= INPUT.colors.contrast[38]), fill = NA,  size= 0.5 ) +


      scale_colour_manual(values= c(INPUT.colors.contrast[26], INPUT.colors.contrast[38]),
                          label = c("Amazon biome", "Legal Amazon"),
                          guide=guide_legend(direction = "horizontal", keyheight = 1.2, keywidth = 1.2, order = 1, ncol = 1)) +


      scale_fill_manual(values= c("firebrick", INPUT.colors.contrast[20], "white"),
                        label = c( "DETER alerts", "DETER clouds", " "),
                        guide = guide_legend(direction = "horizontal", keyheight = 1.2, keywidth = 1.2, order = 2, ncol = 2 ,
                                             override.aes = list(col = "transparent"))) +

      labs(title    =  "DETER ALERTS & CLOUDS",
           subtitle =   paste0(aux.months[s], " - ", aux.years.deter[y])) +

      coord_equal(ratio=1)


    adminDiv_sampleDefinition + theme_CPI()

    
    if (s == 1) {
      ggsave(paste0("figure2a_map_deter_cloudsAlerts_", aux.years.deter[y], aux.period[s], ".pdf"), path = "./results/graphics", dpi = 300)
    }

    if (s == 2) {
      ggsave(paste0("figure2b_map_deter_cloudsAlerts_", aux.years.deter[y], aux.period[s], ".pdf"), path = "./results/graphics", dpi = 300)
    }
    
    if (s == 3) {
      ggsave(paste0("figure2c_map_deter_cloudsAlerts_", aux.years.deter[y], aux.period[s], ".pdf"), path = "./results/graphics", dpi = 300)
    }
    
    if (s == 4) {
      ggsave(paste0("figure2d_map_deter_cloudsAlerts_", aux.years.deter[y], aux.period[s], ".pdf"), path = "./results/graphics", dpi = 300)
    }

    # TIMER
    time.end <- Sys.time()
    print(paste0("** started deter plot for ", aux.years.deter[y], " at ", time.start, " and finished at ", time.end))
    rm(aux.deter.alerts, aux.deter.clouds)
    gc()
  }

  }





# END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------