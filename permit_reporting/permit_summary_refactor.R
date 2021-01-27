library(tidyverse)
library(writexl)
network_prefix <- "//INHS-Bison" #Lauren's Desktop PC

sampling_year <- 2020

#### Read in fish data and turn into abundance data ####

fish <- read.csv(file = paste0(network_prefix,"/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/FSH_",sampling_year,".csv"), header = T, na.strings = "")
fish$Event_Date <- as.Date(fish$Event_Date)


#### Fish from single line list then collapse into single line for each species type with count per site####

fish_summary <- fish %>% 
  drop_na(Species_Code) %>% 
  mutate(across(where(is.character), ~na_if(., "no"))) %>% 
  mutate(Release_status = replace_na(Release_status, "alive"))%>%
  group_by(PU_Gap_Code, Reach_Name, Event_Date, Species_Code, Fish_Species_Common, Fish_Species_Scientific, Release_status) %>% 
  summarise(Fish_Species_Count = n())

# fish_summary$Reach_Name <- stringr::str_replace(fish_summary$Reach_Name, "copper[:blank:]|copper|Copper|copper[:digit:]","Copper ") %>% 
#   stringr::str_replace(fish_summary$Reach_Name, "kasky[:blank:]|Kasky[:blank:]|Kasky","kasky")

fish_summary$PU_Gap_Code <- stringr::str_to_lower(fish_summary$PU_Gap_Code)
fish_summary$Reach_Name <-  stringr::str_to_lower(fish_summary$Reach_Name)
fish_summary$Reach_Name <- stringr::str_remove(fish_summary$Reach_Name, "[:blank:]")

fish_summary$Release_status <- str_replace(fish_summary$Release_status, "mortality", "Destroyed")
fish_summary$Release_status <- str_replace(fish_summary$Release_status, "alive", "Released")
fish_summary$Release_status <- str_replace(fish_summary$Release_status, "voucher", "Donated to INHS")
fish_summary$Release_status <- str_replace(fish_summary$Release_status, "Voucher", "Donated to INHS")


### Read in 2020 location data

location <- read.csv(file = paste0(network_prefix,"/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/Sites_",sampling_year,".csv"), header = T, na.strings = c("NA", ""))
location$Event_Date  <- as.Date(location$Event_Date, format = "%m/%d/%Y")

location_summary <- location %>%
  drop_na(PU_Gap_Code) %>%
  select(PU_Gap_Code, Reach_Name, Latitude, Longitude, Stream_Name, Event_Date)

location_summary$PU_Gap_Code <- stringr::str_to_lower(location_summary$PU_Gap_Code)
location_summary$Reach_Name <-  stringr::str_to_lower(location_summary$Reach_Name)
location_summary$Reach_Name <- stringr::str_remove(location_summary$Reach_Name, "[:blank:]")


### Join Fish and Location Data
permit_summary <- right_join(location_summary, fish_summary, by = c("PU_Gap_Code", "Reach_Name", "Event_Date")) %>% 
  select(-c(Reach_Name))

### Write it to a file

writexl::write_xlsx(permit_summary, path = paste0("~/CREP/Permits/",sampling_year,"/",sampling_year,"_Fish_Permit_Summary.xlsx"))

