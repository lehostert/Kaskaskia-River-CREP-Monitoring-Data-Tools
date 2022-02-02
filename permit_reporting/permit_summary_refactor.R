library(tidyverse)
library(writexl)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison.ad.uillinois.edu", "/Volumes")
network_path <- paste0(network_prefix, "/ResearchData/Groups/StreamEcologyLab/CREP")


sampling_year <- 2021

#### Connect to Database using odbc####
library(odbc)
library(DBI)
odbcListDrivers() # to get a list of the drivers your computer knows about, be sure there is one for MS Access
# con <- dbConnect(odbc::odbc(), "Testing_Database")
con <- dbConnect(odbc::odbc(), "2019_CREP_Database")
options(odbc.batch_rows = 1) # Must be defined as 1 for Access batch writing or appending to tables.
dbListTables(con) # To get the list of tables in the database

loc <- as_tibble(tbl(con, "Established_Locations"))
fmd <- as_tibble(tbl(con, "Fish_Metadata"))
fish <- as_tibble(tbl(con, "Fish_Abundance"))

dbDisconnect(con)

#### Clean up Data from Database; There are issues was additional spaces after text fields in the Fish Tables ####
fish$Reach_Name <- stringr::str_remove(fish$Reach_Name, "[:blank:]*$")
fish$PU_Gap_Code  <- stringr::str_remove(fish$PU_Gap_Code, "[:blank:]*$")
fish$Release_status  <- stringr::str_remove(fish$Release_status, "[:blank:]*$")


fish_voucher_21 <- fish %>% 
  filter(lubridate::year(Event_Date) == sampling_year,
         Release_status == "voucher")

fish$Release_status <- str_replace(fish$Release_status, "mortality", "Released")
fish$Release_status <- str_replace(fish$Release_status, "alive", "Released")
fish$Release_status <- str_replace(fish$Release_status, "voucher", "Destroyed")
fish$Release_status <- str_replace(fish$Release_status, "Voucher", "Destroyed")
fish$Release_status <- str_replace(fish$Release_status, "INHS", "Donated to INHS")
fish$Release_status  <- stringr::str_remove(fish$Release_status, "[:blank:]*$")

####  Consolidate fish data by sampling event and release status ####

fish_data <- fish %>%
  drop_na(Fish_Species_Code) %>% 
  mutate(Release_status = replace_na(Release_status, "Released")) %>% #TODO Fix Db Fish Entries so blanks have 'Released'
  filter(lubridate::year(Event_Date) == sampling_year) %>%
  group_by(PU_Gap_Code, Reach_Name, Fish_Date, Fish_Species_Code, Release_status) %>% 
  summarise(Fish_Species_Count = n()) %>% 
  ungroup()


#### Check IL and Federal Status ####

il_fish_path <- paste0(network_path, "/Analysis/Fish/Fish_Trait_Matrix_Base.csv")
il_fish_list <- read.csv(il_fish_path, header = T, stringsAsFactors = F, na ="")

fish_check<- fish_data %>% 
  left_join(il_fish_list)

fish_check_IL <- fish_check %>% 
  filter(!is.na(IL_Status))

fish_check_USA <- fish_check %>% 
  filter(!is.na(Federal_Status))

# TODO Print Error Message for if there any fish from the IL or FED T&E list

if_else(nrow(fish_check_IL) > 0, print("Submit Additional Report for T&E Species"), print(""))
if_else(nrow(fish_check_USA) > 0, print("Submit Additional Report for T&E Species"), print(""))

#### Write Permit Summary Report ####
permit <- fish_check %>% 
  left_join(loc) %>% 
  mutate(Collection_Method = "electrofishing",
         Fish_Species_Common_Name = stringr::str_to_title(Fish_Species_Common)) %>% 
  select(Fish_Species_Common_Name, Latitude, Longitude, Observation_Date = Fish_Date, Abundance = Fish_Species_Count, 
         Collection_Method, Disposition = Release_status) %>% 
  group_by(Latitude, Longitude) %>% 
  arrange(Observation_Date, Fish_Species_Common_Name) %>% 
  ungroup()

write_csv(permit, path = "~/CREP/Permits/2021/2021_Fish_Permit_Summary.csv")
