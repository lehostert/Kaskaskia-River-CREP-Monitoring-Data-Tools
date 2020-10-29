library(tidyverse)

network_prefix <- "//INHS-Bison" #Lauren's Desktop PC

inv2020 <- read_csv(file = paste0(network_prefix,"/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/INV_2019.csv"))

inv <- inv2020 %>% 
  select(PU_Gap_Code, Reach_Name, Event_Date, Jab_Habitat, Jab_Collector) %>% 
  group_by(PU_Gap_Code, Reach_Name, Event_Date, Jab_Collector) %>% 
  distinct() %>% 
  summarize(Habitat = toString(Jab_Habitat)) %>% 
  ungroup

write_csv(inv, path = "~/CREP/External_Lab/EcoAnalysts Invert Tables/2019/Invert_Sample_Labels_2019.csv")