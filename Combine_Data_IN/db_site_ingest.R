library(tidyverse)
library(odbc)
library(DBI)
# library(docstring)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison.ad.uillinois.edu", "/Volumes")
network_path <- paste0(network_prefix,"/ResearchData/Groups/Kaskaskia_CREP")

### with odbc
odbcListDrivers() # to get a list of the drivers your computer knows about 
# con <- dbConnect(odbc::odbc(), "Testing_Database")
con <- dbConnect(odbc::odbc(), "2019_CREP_Database")
options(odbc.batch_rows = 1) # Must be defined as 1 for Access batch writing or appending to tables See .
dbListTables(con) # To get the list of tables in the database


##### Locations 2019 2020 #####
# loc_19 <- readxl::read_xlsx(paste0(network_path, "/Data/Data_IN/SITES/Sites_2019.xlsx"))
# loc_20 <- readxl::read_xlsx(paste0(network_path, "/Data/Data_IN/SITES/Sites_2020.xlsx"))
# 
# loc_1920 <- loc_19 %>% 
#   bind_rows(loc_20) %>% 
#   select(-c(Event_Date, Event_Year, Event_Month, Event_Day, Event_Purpose)) %>% 
#   mutate(Latitude = round(Latitude, digits = 5),
#          Longitude = round(Longitude, digits = 5))
# 
# loc_1920_unique <- unique(loc_1920)
# 
# loc_1920_unique$Latitude[[49]] == loc_1920_unique$Latitude[[1]]
# loc_1920_unique$Latitude[[1]]
# 
# #### pull in the Locations from DB ####
# loc_db <- as_tibble(tbl(con, "Established_Locations")) %>% 
#   select(-c(Established_Locations_ID))
# 
# bm_fish_loc <- readxl::read_xlsx(path = "~/CREP/Data/Query/2021/CREP_Intern/INHS_CREP_Fish_Locations.xlsx") 
# bm_all_loc <- read_csv(file = "~/CREP/Data/Query/2021/CREP_Intern/INHS_CREP_Site_Locations.csv")
# bm_all_loc_xl <- readxl::read_xlsx(path = "~/CREP/Data/Query/2021/CREP_Intern/INHS_CREP_Site_Locations.xlsx")
# bm_all_loc_update <- readxl::read_xlsx(path = "~/CREP/Data/Query/2021/CREP_Intern/INHS_CREP_DataQuery_20210915/INHS_CREP_Site_Locations.xlsx", na = "NA")
# 
# loc_all20 <- bm_all_loc %>% 
#   select(PU_Gap_Code, Reach_Name, Site_Type, Latitude, Longitude, Stream_Name) %>% 
#   unique()
# 
# loc_all20_update <- bm_all_loc_update %>% 
#   select(PU_Gap_Code, Reach_Name, Site_Type, Latitude, Longitude, Stream_Name) %>% 
#   unique()
# 
# loc_fish20 <- bm_fish_loc %>% 
#   select(PU_Gap_Code, Reach_Name, Site_Type, Latitude, Longitude, Stream_Name) %>% 
#   unique()
# 
# names(loc_db)
# names(loc_1920)
# 
# new_locations <- setdiff(loc_1920, loc_db)
# 
# loc_db <- loc_db %>% select(-c(PU_Code, Gap_Code))
# db_bm <- setdiff(loc_all20, loc_db)
# 
# fish_db <- as_tibble(tbl(con, "Fish_Locations"))
# 
# fish_db_missing <- fish_db %>% 
#   filter(is.na(Site_Type))
# 
# 
# loc_missing <- fish_db_missing %>% 
#   select(PU_Gap_Code, Reach_Name)
# 
# all_locations_with_dup <- bind_rows("new" = new_locations , "db" = loc_db, .id = "source")
# 
# map <-  all_locations_with_dup %>% 
#   filter(Site_Type == "random") %>% 
#   select(-c(Stream_Name, source, PU_Code, Gap_Code, Site_Type)) %>% 
#   unique()
# 
# names(map) <- stringr::str_to_lower(names(map))
# 
# map_fish <- fish_df_random %>% 
#   left_join(map, by = c("pu_gap_code", "reach_name")) %>% 
#   select(1:5, 78:79, 6:77)
# 
# write_csv(map_fish, path = "~/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Combine_Data_IN/fish_locations_random_sites.csv")
# 


#### pull in the Locations from DB ####
loc_db <- as_tibble(tbl(con, "Established_Locations")) %>%
  select(-c(Established_Locations_ID))

new_locations <- read_csv(file = paste0(network_path, "/Data/Data_IN/SITES/All_New_Sites_2021_kasky1038_removed.csv"))

diff <- setdiff(new_locations$Reach_Name, loc_db$Reach_Name)
diff <- setdiff(loc_db$Reach_Name, new_locations$Reach_Name)

dbAppendTable(con, name = "Established_Locations", new_locations)

dbDisconnect(con)
