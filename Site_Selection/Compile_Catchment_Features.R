library(tidyverse)

kasky_catchments <- read_csv("C:/Users/lhostert/Documents/ArcGIS/Projects/TestProject/Kasky_Local_Catchment_Features.csv")

kasky_catchment_summary <- kasky_catchments %>%
  filter(PU_CODE == 'kasky') %>%
  select(PUGAP_CODE,PU_CODE, GAP_CODE, CRP_Area, CREP_Area, NRCS_Area, CSP_Area, FDA_Area, IDNR_Area, NP_Area,
         All_Conservation_Area,Total_Area,
         HUC8_Name, US_L3NAME, NA_L3NAME, EPA_REGION)

kasky_catchment_summary$CRP_Percent <- kasky_catchment_summary$CRP_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$CREP_Percent <- kasky_catchment_summary$CREP_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$NRCS_Percent <- kasky_catchment_summary$NRCS_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$CSP_Percent <- kasky_catchment_summary$CSP_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$FDA_Percent <- kasky_catchment_summary$FDA_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$INDR_Percent <- kasky_catchment_summary$IDNR_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$NP_Percent <- kasky_catchment_summary$NP_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$Total_Conservation_Percent <- kasky_catchment_summary$All_Conservation_Area/kasky_catchment_summary$Total_Area

landuse <- read_csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/Fish/Data/kasky_landuse_geology_CHANNEL.csv")

kasky_summary <- landuse %>%
  select(c(PU_Gap_Code, C_ORDER, LINK, DORDER, DLINK)) %>%
  right_join(kasky_catchment_summary, by = c("PU_Gap_Code" = "PUGAP_CODE"))

kasky_summary$size_class <- ifelse(kasky_summary$LINK <11,
                                             1,
                                             2
                                   )



df <- read.csv("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/PU_Gaps_size_and_CRP_classes.csv")

df_orig <- df %>%
  select(-c(prop_local_CRP, CRP_class))
# REMOVE Duplicated in new
df_new <- kasky_summary %>%
  select(c(PU_Gap_Code, HUC8_Name, LINK, size_class)) %>%
  distinct()

df_compare <- anti_join(df_new, df_orig, by = c("PU_Gap_Code" = "pu_gap_code" , "HUC8_Name" = "basin",
                                               "LINK" = "link", "size_class" = "size_class"))

#####
df_in_orig <- anti_join(df_orig, df_new, by = c("pu_gap_code" = "PU_Gap_Code", "basin" = "HUC8_Name",
                                                "link" = "LINK", "size_class" = "size_class"))

#  Only ones in the this set Kasky1560 Middle 521 2 (Upper in orig) and kasky3792 Shoal 8 1 (Middle in Orig)

######
set.seed(2019)
sites <-  df %>%
  group_by(basin, size_class) %>%
  sample_n(10)
