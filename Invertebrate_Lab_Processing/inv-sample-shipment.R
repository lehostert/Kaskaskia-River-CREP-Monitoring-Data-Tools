library(tidyverse)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison.ad.uillinois.edu", "/Volumes")
network_path <- paste0(network_prefix, "/ResearchData/Groups/StreamEcologyLab/CREP")

year <- 2021

### Read in data going into DB
inv <- read_csv(file = paste0(network_path,"/Data/Data_OUT/DB_Ingested/INV_", year,".csv"))

### Clean and reformat data
invert <- inv %>% 
  select(EDU_Code, Reach_Name, Event_Date, Invert_Date, Jab_Habitat, Jab_Collector) %>% 
  group_by(EDU_Code, Reach_Name, Event_Date, Invert_Date, Jab_Collector) %>% 
  distinct() %>% 
  summarize(Habitat = toString(Jab_Habitat)) %>% 
  ungroup()

invert$Collector <- "lhostert"
# invert$Reach_Name <- stringr::str_to_lower(invert$Reach_Name)

## Read in data from lab processing
inv_online <- readxl::read_excel(path = paste0("~/CREP/External_Lab/EcoAnalysts Invert Tables/",year,"/macroinvertebrate_labprocessing_", year,".xlsx"), na = c("."))

inv_online <- inv_online[-c(16),]

online <- inv_online %>% 
  select(EDU_Code, Site_Name, Event_Date, INV_Date, Final_Vials ="Final Vials", Final_Org_Count = "Final Organism Count...16")

## TODO It seems like the Event_Date, Inv_Date, Collection_Date is going to become an issues later on please clearify the code below in order to work better
## for future users. 
  
inv_reform <- invert %>% 
  select(-c(Jab_Collector)) %>% 
  # left_join(online, by = c("EDU_Code", "Reach_Name" = "Site_Name", "Event_Date", "Invert_Date" = "INV_Date")) %>% 
  # rename(INV_Date = Event_Date, Event_Date = Event_Date.y) %>% 
  select(EDU_Code, Reach_Name, Collection_Date = Invert_Date, Collector, Habitat, Final_Vials, Final_Org_Count) %>% 
  # mutate(Final_Vials = replace_na(Final_Vials, 1))


inv_final <- uncount(inv_reform, Final_Vials, .remove = FALSE, .id = "Vial_Num")
inv_final$Collection_Date <- lubridate::date(inv_final$Collection_Date)

inv_final <- invert %>% 
  select(EDU_Code, Reach_Name, Invert_Date, Habitat, Collector) %>% 
  arrange(Invert_Date)

write_csv(inv_final, path = paste0(network_path,"/EcoAnalysts Invert Tables Copy/", year,"/Invert_Sample_COC_", year,".csv"))
