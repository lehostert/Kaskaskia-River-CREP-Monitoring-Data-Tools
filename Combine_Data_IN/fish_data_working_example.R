###Minumum working example
library(tidyverse)
library(odbc)
library(DBI)
library(docstring)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison", "/Volumes")


### Read in 2019 and 2020 full data ####
f20 <- readr::read_csv(file = paste0(network_prefix, "/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/FSH_2020.csv"))

f20_full <- f20 %>%
  select(-c(Gap_Code)) %>% 
  drop_na(Species_Code)

f19 <- readr::read_csv(file = paste0(network_prefix, "/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/FSH_2019.csv"),
                       col_types = cols(PU_Gap_Code = col_character(),
                             Reach_Name = col_character(),
                             Event_Date = col_date(format = ""),
                             Species_Code = col_character(),
                             Fish_Species_Common = col_character(),
                             Fish_Species_Scientific = col_character(),
                             Length = col_double(),
                             Weight = col_double(),
                             Sex = col_character(),
                             Maturity = col_character(),
                             Deformity = col_character(),
                             Eroded_fins = col_character(),
                             Lesions = col_character(),
                             Tumors = col_character(),
                             Parasites = col_character(),
                             Electrofishing_Injury = col_character(),
                             Release_status = col_character(),
                             Notes = col_character())
                       )

f19_full <- f19 %>%
  select(-c(Gap_Code)) %>% 
  drop_na(Species_Code) %>% 
  mutate(Fish_Date = Event_Date)

#### Combine 2019 and 2020 data into 1 dataset ####
f1920 <- bind_rows(f20_full, f19_full)

#### Connect to datebase ###
odbcListDrivers() # to get a list of the drivers your computer knows about 
# con <- dbConnect(odbc::odbc(), "Testing_Database")
con <- dbConnect(odbc::odbc(), "2019_CREP_Database")
options(odbc.batch_rows = 1) # Must be defined as 1 for Access batch writing or appending to tables See .
dbListTables(con) # To get the list of tables in the database

#### Read in length/weight table and count tables from 2013-2018 ####
# counts <- read_csv(file = "~/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Combine_Data_IN/counts.csv")
# lengths <- read_csv(file = "~/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Combine_Data_IN/lengths.csv")

counts <- as_tibble(tbl(con, "Fish_Count"))
lengths <- as_tibble(tbl(con, "Fish_Length_Weight"))

# Convert Fish_Species_Count to one individual fish  per line
f1318 <- uncount(counts, Fish_Species_Count)

# Count the number of fish that you have length weight data on
length_sum <- lengths %>% 
  group_by(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code) %>% 
  summarise(Fish_Species_Count = n())

# Create summary table of the counts of fish per species for each site/data combo and see how these numbers difference between the counts and length data tables.
clw_sum <- counts %>% 
  group_by(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code) %>% 
  summarize(Fish_Species_Count = sum(Fish_Species_Count)) %>% 
  full_join(length_sum, by = c("PU_Gap_Code", "Reach_Name", "Event_Date", "Fish_Species_Code"), suffix = c(".COUNTS", ".LW")) %>% 
  replace_na(list(Fish_Species_Count.LW = 0, Fish_Species_Count.COUNTS = 0)) %>% 
  mutate(count_dif = Fish_Species_Count.COUNTS - Fish_Species_Count.LW,
         length_dif = Fish_Species_Count.LW - Fish_Species_Count.COUNTS,
         count_dif = if_else(count_dif< 0, 0, count_dif),
         length_dif = if_else(length_dif< 0, 0, length_dif))

#### TODO Please take a look at clw_sum before continuing. It seems like there might be more species with length/weight data that were not on the count list than we thought
### Fix this. 

write_csv(clw_sum, path = "~/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Combine_Data_IN/clw_sum_review.csv")

# Get a df of those fish that we counted by did not measure for 2013-2018. 
not_measured <- clw_sum %>% 
  select(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code, count_dif) %>% 
  uncount(count_dif)

# Combine the fish that were just counted with those that were counted and measured.
clw_combined <- bind_rows(lengths, not_measured)

# Combine the 2013-2018 data with the 2019/2020 data

combo <- bind_rows(f1920, clw_combined)

#### Fill in the information that is missing in the end ####

fish_combined_final <- combo %>%
  mutate(across(where(is.character), ~na_if(., "no"))) %>% 
  mutate(Release_status = replace_na(Release_status, "alive"))
