library(tidyverse)

fish <- readr::read_csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/Fish/Output/Fish_Metrics.csv", na = ".")
habitat <- readr::read_csv("~/CREP/Analysis/Paired_Sites/Paired_Site_Characteristics.csv")

habitat$Event_Date <- as.Date(habitat$Habitat_IHI_Event_Date, "%m/%d/%Y")

paired_site_list <- habitat %>%
  select(PU_Gap_Code, Reach_Name, Site_Type, Pair_Number, CRP_Class, Event_Date)

fish$Reach_Name <- as.character(stringr::str_extract_all(fish$Site_ID, "[:alnum:]+(?=\\_)"))


fish$Event_Date <- stringr::str_extract_all(fish$Site_ID, "(?<=\\_)[:digit:]+")

fish$Event_Date <- as.Date(as.character(fish$Event_Date), "%Y%m%d")

# fish$Event_Date <- as.Date(as.character(stringr::str_extract_all(fish$Site_ID, "(?<=\\_)[:digit:]+")))

paired_fish<- paired_site_list %>%
  left_join(fish, by = c('Reach_Name', 'Event_Date'))