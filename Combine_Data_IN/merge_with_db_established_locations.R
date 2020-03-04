library(tidyverse)

db <- readxl::read_xlsx("Combine_Data_IN/Established_Locations_20200304.xlsx")

sites_2019 <- readxl::read_xlsx(path ="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/Sites_2019.xlsx")

db <- db %>% 
  select(-c(Established_Locations_ID))

sites_2019 <- sites_2019 %>% 
  select(-c(Event_Year, Event_Day, Event_Month, X__1, X__2, X__3))

sites_2019$Reach_Name <- str_replace(sites_2019$Reach_Name, "Copper", "Copper ")

sites_2019_condensed <- sites_2019 %>% 
  select(-c(Event_Purpose, Event_Date))

complete_sites <- bind_rows("y2019" = sites_2019_condensed, "database" = db, .id = "dataset")

uniq_db <- db %>% 
  select(Reach_Name) %>% 
  unique()

uniq_2019 <- sites_2019_condensed %>% 
  select(Reach_Name) %>% 
  unique()

uniq_all <- complete_sites %>% 
  select(-c(dataset, Stream_Name, Site_Type)) %>% 
  unique()

complete_sites$dup_reach <- duplicated(complete_sites$Reach_Name)
complete_sites$dup_lat<- duplicated(complete_sites$Latitude)
complete_sites$dup_lon<- duplicated(complete_sites$Longitude)

write_csv(complete_sites, path = "Combine_Data_IN/db_2019_sites_combined.csv")