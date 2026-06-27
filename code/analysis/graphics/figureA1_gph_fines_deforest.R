
# > PROJECT INFO
# NAME: DETERRING DEFORESTATION IN THE AMAZON: ENVIRONMENTAL MONITORING AND LAW ENFORCEMENTE - CODE AND DATA REPLICATION ARCHIVE
#
# > THIS SCRIPT
# AIM: CREATION OF GRAPHICS FOR ENVIRONMENTAL FINES X DEFORESTATION ANNUAL TRENDS
#
# > NOTES
# -



# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# LIBRARIES
source(file.path("code/_functions", "setup.R"))





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# panel for analysis input
load("./data/projectSpecific/panel_fromR.Rdata")



# DATA PREP ------------------------------------------------------------------------------------------------------------------------------------------

# create a vector containing only the muni_codes from the final sample (after data prep in stata - 521 municipalities)
aux.muni.code.final.sample <-
  panel.fromR %>%
  filter(year >= 2006, year <= 2016) %>%
  filter(!is.na(prodes_deforest)) %>%
  group_by(muni_code) %>%
  mutate(sd_deforest = sd(prodes_deforest, na.rm = T)) %>%
  ungroup() %>%
  filter(sd_deforest != 0) %>%
  pull(muni_code) %>%
  unique()



# DATA MANIPULATION
panel.forPlot <-
  panel.fromR %>%
  filter(year >= 2002, year <= 2016) %>% # time frame definition
  filter(muni_code %in% aux.muni.code.final.sample) %>% # sample definition
  dplyr::select(muni_code, year, fines_count, prodes_deforest) %>%  # select columns of interest
  group_by(year) %>%
  summarize_all(.funs = sum, na.rm = T) %>%
  mutate(prodes_deforest = prodes_deforest) %>%
  mutate(fines_count = fines_count/1000,
         prodes_deforest = prodes_deforest/1000) %>%
  dplyr::select(-muni_code)





# PLOT -----------------------------------------------------------------------------------------------------------------------------------------------

# PLOT
panel.forPlot %>%
  ggplot(aes(x = year)) +
  geom_line(aes(y = fines_count*3.5, linetype = "total number of fines", col = "total number of fines"), size = 1) +
  geom_line(aes(y = prodes_deforest, linetype = "total deforested area", col = "total deforested area"), size = 1) +
  scale_y_continuous(name = "deforestation (thousand square kilometers)", sec.axis = sec_axis(~./3.5, name = "number of fines (thousands)",
                                                                   breaks = seq(0, 9, 1)), breaks = seq(0, 30, 5)) +
  scale_x_continuous(name = NULL, breaks = 2002:2016) +
  scale_linetype_manual(name = "", values = c("solid", "dotted")) +
  scale_colour_manual(name = "", values = c("firebrick4", "black")) +
  labs(linetype = NULL) +
  theme_classic() +
  theme(legend.position = "bottom",
        axis.title.y = element_text(margin = margin(t = 0, r = 12, b = 0, l = 0)),
        axis.title.y.right = element_text(margin = margin(t = 0, r = 0, b = 0, l = 12)),
        axis.text = element_text(color = "black"),
        axis.ticks.y = element_blank())

  ggsave(filename = "./results/graphics/figureA1_gph_deforestFines.pdf", width = 8, height = 5, dpi = 300)





# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------