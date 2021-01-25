library(tidyverse)

network_prefix <- "//INHS-Bison" #Lauren's Desktop PC
year <- "2020"

### Read in data going into DB
inv2020 <- read_csv(file = paste0(network_prefix,"/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/INV_", year,".csv"))

### Clean and reformat data
inv <- inv2020 %>% 
  select(PU_Gap_Code, Reach_Name, Event_Date, Jab_Habitat, Jab_Collector) %>% 
  group_by(PU_Gap_Code, Reach_Name, Event_Date, Jab_Collector) %>% 
  distinct() %>% 
  summarize(Habitat = toString(Jab_Habitat)) %>% 
  ungroup

inv$Collector <- "lhostert"
inv$Reach_Name <- stringr::str_to_lower(inv$Reach_Name)

## Read in data from lab processing
inv_online <- readxl::read_excel(path = paste0("~/CREP/External_Lab/EcoAnalysts Invert Tables/2020/macroinvertebrate_labprocessing_", year,".xlsx"))
inv_sum <- inv_online %>% 
  select(PUGap_Code, Site_Name, Event_Date, INV_Date, "Final Vials")
  
inv_reform <- full_join(inv, inv_sum, by = c("PU_Gap_Code" = "PUGap_Code", "Event_Date" = "INV_Date", "Reach_Name" = "Site_Name")) %>% 
  rename(INV_Date = Event_Date, Event_Date = Event_Date.y) %>% 
  select(PU_Gap_Code, Reach_Name, Collection_Date = INV_Date, Collector, Habitat, Final_Vials = "Final Vials")

inv_final <- uncount(inv_reform, Final_Vials, .remove = FALSE, .id = "Vial_Num")
inv_final$Collection_Date <- lubridate::date(inv_final$Collection_Date)


write_csv(inv_final, path = paste0("~/CREP/External_Lab/EcoAnalysts Invert Tables/", year,"/Invert_Sample_Labels_", year,".csv"))