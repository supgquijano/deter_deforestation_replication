
# > PROJECT INFO
# NAME: DETERRING DEFORESTATION IN THE AMAZON: ENVIRONMENTAL MONITORING AND LAW ENFORCEMENTE - CODE AND DATA REPLICATION ARCHIVE
#
# > THIS SCRIPT
# AIM: CALCULATE SHARE OF PLANTED AREA
#
# > NOTES
# -



# SETUP ----------------------------------------------------------------------------------------------------------------------------------------------

# LIBRARIES
source(file.path("./code/_functions", "setup.R"))





# DATA INPUT -----------------------------------------------------------------------------------------------------------------------------------------

# MUNICIPAL AGRICULTURAL PRODUCTION (PAM)
load("./data/raw2clean/agriculture/pam_ibge/output/ag_br_pam_5crops_df.Rdata")
load("./data/raw2clean/agriculture/pam_ibge/output/ag_br_pam_all_crops.Rdata")



# PANEL SAMPLE
load("./data/projectSpecific/panel_fromR.Rdata")





# FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------

clear.labels <- function(x) {
  if(is.list(x)) {
    for(i in 1 : length(x)) class(x[[i]]) <- setdiff(class(x[[i]]), 'labelled')
    for(i in 1 : length(x)) attr(x[[i]],"label") <- NULL
  }
  else {
    class(x) <- setdiff(class(x), "labelled")
    attr(x, "label") <- NULL
  }
  return(x)
}


# CALCULATE SHARE OF PLANTED AREA --------------------------------------------------------------------------------------------------------------------

# change column class to guarantee all are in the same
panel.fromR$muni_code <- as.numeric(panel.fromR$muni_code)
ag.br.pam.all.crops$muni_code <- as.numeric(ag.br.pam.all.crops$muni_code)
ag.br.pam.5crops.df$municipality_code <- as.numeric(ag.br.pam.5crops.df$municipality_code)

panel.fromR <- clear.labels(panel.fromR)


# calculate average share of planted area for all 5 crops by year
share.amazon.crops.collapsed <-
  ag.br.pam.5crops.df %>%
  dplyr::rename(muni_code = municipality_code) %>%
  mutate(year = as.numeric(year)) %>%
  right_join(panel.fromR, by = c("muni_code", "year")) %>%
  left_join(ag.br.pam.all.crops, by = c("muni_code", "year")) %>%
  filter(year < 2016 & year > 2001) %>%
  dplyr::select(year, starts_with("planted")) %>%
  mutate(planted_area_5crops = planted_area_cassava + planted_area_corn + planted_area_rice +
           planted_area_soybean + planted_area_sugarcane) %>%
  group_by(year) %>%
  summarise_all(.funs = sum, na.rm = T) %>%
  mutate(share_5crops = planted_area_5crops/planted_area_all_crops) %>%
  mutate_at(.vars = vars(matches("share")), funs(if_else(planted_area_all_crops == 0, 0, as.numeric(.)))) %>% # change NaNs to 0s
  dplyr::select(year, share_5crops)

# plot of average share of the planted area destined to one of the 5 selected crops by year
share.amazon.crops.collapsed %>%
  ggplot(aes(x = year, y = share_5crops)) +
  geom_line() +
  geom_point() +
  scale_x_continuous(breaks = 2002:2015) +
  scale_y_continuous(breaks = seq(0.84, 0.90, 0.01)) +
  expand_limits(y = 0.90) +
  theme_classic() 
  
  ggsave(filename = "./results/stats/supportStats_share_5crops_byYear.pdf", width = 7)






# END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------