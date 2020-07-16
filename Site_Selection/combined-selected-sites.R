############### Review Random from ArcGis ####
arc_rand_combined <-  read_csv(file = "~/ArcGIS/Projects/CREP/random_stream_intersections_combined.csv")
arc_rand <-  read_csv(file = "~/ArcGIS/Projects/CREP/random_stream_intersections.csv")

arc_rand_combined_2 <- arc_rand_combined %>%
  select(-c(OBJECTID)) %>% 
  rename( PU_GAP = FIRST_PU_GAP,
          GAP_CODE = FIRST_GAP_CODE,
          FULLNAME = FIRST_FULLNAME,
          RTTYP = FIRST_RTTYP) %>% 
  distinct()

arc_rand_combined_3 <- arc_rand_combined %>%
  select(-c(OBJECTID)) %>% 
  rename( PU_GAP = FIRST_PU_GAP,
          GAP_CODE = FIRST_GAP_CODE,
          FULLNAME = FIRST_FULLNAME,
          RTTYP = FIRST_RTTYP)

arc_rand_combined_3$dup <-   duplicated(arc_rand_combined_3)


arc_rand_2 <- arc_rand %>% 
  select(Latitude, Longitude, PU_GAP, GAP_CODE, PU_CODE) %>% 
  distinct()

############### Review LD from ArcGis ####
arc_ld_combined <-  read_csv(file = "~/ArcGIS/Projects/CREP/ld_stream_intersections_combined.csv")
arc_ld <-  read_csv(file = "~/ArcGIS/Projects/CREP/ld_stream_intersections.csv")

arc_ld_combined_2 <- arc_ld_combined %>%
  select(-c(OBJECTID)) %>% 
  rename( PU_GAP = FIRST_PU_GAP,
          GAP_CODE = FIRST_GAP_CODE,
          FULLNAME = FIRST_FULLNAME,
          RTTYP = FIRST_RTTYP) %>% 
  distinct()

arc_ld_combined_3 <- arc_ld_combined %>%
  select(-c(OBJECTID)) %>% 
  rename( PU_GAP = FIRST_PU_GAP,
          GAP_CODE = FIRST_GAP_CODE,
          FULLNAME = FIRST_FULLNAME,
          RTTYP = FIRST_RTTYP)

arc_ld_combined_3$dup <-   duplicated(arc_ld_combined_3)


arc_ld_2 <- arc_ld %>% 
  select(Latitude, Longitude, PU_GAP, GAP_CODE, PU_CODE) %>% 
  distinct()

##### Combine Random and LD

all_sites <- bind_rows("Least Disturbed" = arc_ld_2, "Random"= arc_rand_2, .id = "Site_Type") %>% 
  rename(PU_Gap_Code = PU_GAP,
         PU_Code = PU_CODE,
         Gap_Code = GAP_CODE)

all_sites$Gap_Code <- as.character(all_sites$Gap_Code)

landuse_all <- kasky_landuse_W %>% 
  full_join(kasky_landuse_WT, by = c('PU_Gap_Code', 'PU_Code', 'Gap_Code')) %>% 
  select(PU_Gap_Code, PU_Code, Gap_Code, W_LU_Disturbed, W_LU_Undisturbed, W_Undisturbed_Level, WT_LU_Disturbed, WT_LU_Undisturbed, WT_Undisturbed_Level)

catchment_features_all <- catchment_features %>% 
  select(1:4, 13, 24:36)

all_sites_2020 <- all_sites %>% 
  left_join(landuse_all) %>% 
  left_join(catchment_features_all)

write_csv(all_sites_2020, path = paste0("~/CREP/R_Scripts/Sites/", year,"_SiteSelection_PotentialList.csv"))

### Add Extra Sites
arc_rand_extra<-  read_csv(file = "~/ArcGIS/Projects/CREP/random_stream_extra_intersections.csv") %>% 
  rename(PU_Gap_Code = PU_GAP,
         PU_Code = PU_CODE,
         Gap_Code = GAP_CODE)%>% 
  select(Latitude, Longitude, PU_Gap_Code, Gap_Code, PU_Code) %>% 
  distinct()

arc_rand_extra$Site_Type <- "Random"

landuse_all <- kasky_landuse_W %>% 
  full_join(kasky_landuse_WT, by = c('PU_Gap_Code', 'PU_Code', 'Gap_Code')) %>% 
  select(PU_Gap_Code, PU_Code, Gap_Code, W_LU_Disturbed, W_LU_Undisturbed, W_Undisturbed_Level, WT_LU_Disturbed, WT_LU_Undisturbed, WT_Undisturbed_Level)
landuse_all$Gap_Code <- as.numeric(landuse_all$Gap_Code)

catchment_features_all <- catchment_features %>% 
  select(1:4, 13, 24:36)
catchment_features_all$Gap_Code <- as.numeric(catchment_features_all$Gap_Code)

extra_sites_2020 <- arc_rand_extra %>%
  select(6, 1:5) %>% 
  left_join(landuse_all) %>% 
  left_join(catchment_features_all)  

write_csv(extra_sites_2020, path = paste0("~/CREP/R_Scripts/Sites/", year,"_SiteSelection_ExtraList.csv"))

#### Pair Sites

paired <- read_csv(file = paste0("~/CREP/R_Scripts/Sites/Established_Locations_20200715.csv"))

pairs_2020 <- paired %>% 
  filter(Site_Type == "paired") %>% 
  select(Site_Type, Latitude, Longitude, PU_Gap_Code, Gap_Code, PU_Code, Reach_Name, Stream_Name) %>% 
  left_join(landuse_all) %>% 
  left_join(catchment_features_all)  

write_csv(pairs_2020, path = paste0("~/CREP/R_Scripts/Sites/", year,"_PairedSites.csv"))

##ISWS Sites
ISWS <- read_csv(file = paste0("~/CREP/R_Scripts/Sites/2020_SiteSelection_ISWS_Locations.csv"))%>% 
  left_join(landuse_all) %>% 
  left_join(catchment_features_all)

write_csv(ISWS, path = paste0("~/CREP/R_Scripts/Sites/", year,"_SiteSelection_ISWS.csv"))
