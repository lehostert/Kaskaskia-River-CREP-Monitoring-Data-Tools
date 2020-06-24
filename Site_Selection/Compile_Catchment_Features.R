library(tidyverse)

kasky_catchments <- read_csv("C:/Users/lhostert/Documents/ArcGIS/Projects/TestProject/Kaskaskia_Local_Catchment_Features.csv")

kasky_catchment_summary <- kasky_catchments %>% 
  filter(PU_CODE == 'kasky') 
  # select(PUGAP_CODE,PU_CODE, GAP_CODE, CRP_Area, CREP_Area, NRCS_Area, CSP_Area, FDA_Area, IDNR_Area, NP_Area, 
  #        All_Conservation_Area,Total_Area, 
  #        HUC8_Name, US_L3NAME, NA_L3NAME, EPA_REGION)

kasky_catchment_summary$CRP_Percent <- kasky_catchment_summary$CRP_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$CREP_Percent <- kasky_catchment_summary$CREP_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$NRCS_Percent <- kasky_catchment_summary$NRCS_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$CSP_Percent <- kasky_catchment_summary$CSP_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$FDA_Percent <- kasky_catchment_summary$FDA_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$INDR_Percent <- kasky_catchment_summary$IDNR_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$NP_Percent <- kasky_catchment_summary$NP_Area/kasky_catchment_summary$Total_Area
kasky_catchment_summary$Total_Conservation_Percent <- kasky_catchment_summary$All_Conservation_Area/kasky_catchment_summary$Total_Area

landuse <- read_csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/Fish/Data/kasky_landuse_geology_CHANNEL.csv")

####Test the dat sets to determine which are separate.
# Use anti join to see what rows are in landuse that are not in kasky_catchment_summary
test_landuse_kcatchment <- anti_join(landuse, kasky_catchment_summary, by = c("PU_Gap_Code" = "PUGAP_CODE"))

# Use anti-join to see what rows are in kasky_catchment_summary that are not in landuse. 
test_kcatchment_landuse <- anti_join(kasky_catchment_summary, landuse,  by = c("PUGAP_CODE" = "PU_Gap_Code"))

## There are 8 kaskaskia segments that do not appear in the data set output from GIS Layer processing (Kaskaskia_Local_Catchment_Features).
## See the test_landuse_kcatchment list to view those units that are in landuse but not the catchment dataset.


# Combine despite not complete catchment data. 8 units will be missing. Total = 5577 when it should be 5585.
kasky_summary <- landuse %>% 
  select(c(PU_Gap_Code, C_ORDER, LINK, DORDER, DLINK)) %>%  
  right_join(kasky_catchment_summary, by = c("PU_Gap_Code" = "PUGAP_CODE"))

kasky_summary$size_class <- ifelse(kasky_summary$LINK <11,
                                             1,
                                             2
                                   )

  
#########
df <- read.csv("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/PU_Gaps_size_and_CRP_classes.csv")
###

df_orig <- df %>% 
  select(-c(prop_local_CRP, CRP_class))

df_new <- kasky_summary %>% 
  select(c(PU_Gap_Code, HUC8_Name, LINK, size_class))

#####
# Compare Brian's old df to new df from Kasky Catchment Features

#####
df_in_orig_not_new  <- anti_join(df_orig, df_new, by = c("pu_gap_code" = "PU_Gap_Code", "basin" = "HUC8_Name", 
                                                "link" = "LINK", "size_class" = "size_class"))

### Result is 2 units that are in the original not exactly as the new ds. 
### Kasky 1560 listed in Upper in orig ds in the middle of Middle Subbasin. 
### kasky 3792 list in Middle in orig ds on the edge of Shoal Subbasin.
### Disregard these errors 

df_in_new_not_orig<- anti_join(df_new, df_orig, by = c("PU_Gap_Code" = "pu_gap_code" , "HUC8_Name" = "basin", 
                                               "LINK" = "link", "size_class" = "size_class"))

### Result is 2791 units that were not correct or included in the original data set. 
### Know this informaiton and proceed with the more compelte dataset from Kaskaskia_Local_Catchment_Features.csv + landuse
### Not the original data set

#Save new site list
kasky_summary<- kasky_summary %>% 
  select(c(1,8,7,12:32,2:6,9:11)) %>% 
  select(-c(OBJECTID)) %>% 
  rename(
    C_Order = C_ORDER,
    Link = LINK,
    DS_Order = DORDER,
    DS_Link = DLINK,
    Gap_Code = GAP_CODE,
    PU_Code = PU_CODE,
    HUC8_Basin_Name = HUC8_Name
  )


write_csv(kasky_summary, path = "C:/Users/lhostert/Documents/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Site_Selection/Kaskaskia_Catchment_Sizes_and_Features.csv")