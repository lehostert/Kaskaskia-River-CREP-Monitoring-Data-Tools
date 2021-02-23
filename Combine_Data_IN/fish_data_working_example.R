### Purpose of this script to to combine all fish data from 2013 through 2020 into 1 DB table. 
### As of Feb 2020 the fish length/weight table is separate from the fish count table. 
### These data need to be cleaned and combined into 1 table. 

library(tidyverse)
library(odbc)
library(DBI)
library(docstring)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison", "/Volumes")

### Read in Fish traits
il_fish_traits <- read_csv(paste0(network_prefix,"/ResearchData/Groups/Kaskaskia_CREP/Analysis/Fish/Data/Illinois_fish_traits.csv"))

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

#### Combine 2019 and 2020 data into 1 data set ####
f1920 <- bind_rows(f20_full, f19_full) %>% 
  rename(Fish_Species_Code = Species_Code) %>% 
  mutate(Fish_Species_Code = str_to_upper(Fish_Species_Code))

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

write_csv(clw_sum, path = "~/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Combine_Data_IN/clw_sum_review_20210222b.csv")

# length_differences <- clw_sum %>%
#   filter(length_dif >0)

## Get a df of those fish that we counted by did not measure for 2013-2018.Only if there are no unresolved measured but not counted fish
differences <- clw_sum %>%
  ungroup() %>%
  summarise(differences = sum(length_dif))


if(differences[[1]] == 0){
  not_measured <- clw_sum %>%
    select(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code, count_dif) %>%
    uncount(count_dif)
} else {
stop("
             Review fish in weights/length data that are but not in count data!")
  }


### TODO may this should be a stack overflow type of question for later?
# if_else(differences[[1]] == 0,
#         not_measured <- clw_sum %>%
#           select(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code, count_dif) %>%
#           uncount(count_dif),
#         stop("Review fish in weights/length data that are but not in count data!")
#         )

# not_measured <- clw_sum %>% 
#   select(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code, count_dif) %>% 
#   uncount(count_dif)

#### TODO Please take a look at clw_sum before continuing. It seems like there might be more species with length/weight data that were not on the count list than we thought
### Fix this. 

# write_csv(clw_sum, path = "~/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Combine_Data_IN/clw_sum_review_20210215.csv")

## TODO remove this small section for final version
## Get a df of those fish that we counted by did not measure for 2013-2018.Only if there are no unresolved measured but not counted fish
# not_measured <- clw_sum %>%
#   select(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code, count_dif) %>%
#   uncount(count_dif)

## CONTINUE
# Combine the fish that were just counted (reformatted from above) with those that were weighted and measured (direct from DB).
combined_clw <- bind_rows(lengths, not_measured) %>% 
  select(-c(Fish_Length_Weight_ID)) %>% 
  mutate(Fish_Date = Event_Date)%>% 
  filter(!lubridate::year(Event_Date) == 2019)

# Combine the 2013-2018 data with the 2019/2020 data

combined_f1320 <- bind_rows(f1920, combined_clw)

#### Fill in the information that is missing in the end ####

il_fish_traits <- il_fish_traits %>% 
  select(Fish_Species_Code, Fish_Species_Common, Fish_Species_Scientific)

combined_fish <- combined_f1320 %>%
  arrange(Event_Date, Fish_Species_Code) %>% 
  mutate(across(where(is.character), ~na_if(., "no"))) %>% 
  mutate(Release_status = replace_na(Release_status, "alive"),
         Fish_Abundance_ID = row.names(combined_f1320)) %>% 
  select(-c(Fish_Species_Common, Fish_Species_Scientific)) %>% 
  left_join(il_fish_traits) %>% 
  select(18,1:5,19:20,6:17)

combined_fish$PU_Gap_Code <- str_to_lower(combined_fish$PU_Gap_Code)

# combined_fish$Reach_Name <- str_to_lower(combined_fish$Reach_Name)


combined_fish$Reach_Name <- ifelse(str_detect(combined_fish$Reach_Name, "copper[:digit:]+"),
                        str_replace(combined_fish$Reach_Name, "copper", "Copper "),
                        paste(combined_fish$Reach_Name)
                        )

combined_fish$Reach_Name <- ifelse(str_detect(combined_fish$Reach_Name, "Copper[:digit:]+"),
                                   str_replace(combined_fish$Reach_Name, "Copper", "Copper "),
                                   paste(combined_fish$Reach_Name)
                                   )

combined_fish$Reach_Name <- ifelse(str_detect(combined_fish$Reach_Name, "copper [:digit:]+"),
                                   str_replace(combined_fish$Reach_Name, "copper", "Copper "),
                                   paste(combined_fish$Reach_Name)
                                   )

combined_fish$Reach_Name <- ifelse(str_detect(combined_fish$Reach_Name, "Kasky[:digit:]+"),
                                   str_replace(combined_fish$Reach_Name, "Kasky", "kasky"),
                                   paste(combined_fish$Reach_Name)
                                   )

x <- combined_fish %>% 
  select(Reach_Name) %>% 
  unique()

# If you want to use this for Fish Analysis

analysis_fish <- combined_fish %>%
  select(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code) %>%
  group_by(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code) %>%
  summarise(Fish_Species_Count =  n())

write_csv(analysis_fish, paste0(network_prefix, "/ResearchData/Groups/Kaskaskia_CREP/Analysis/Fish/Data/Fish_Abundance_Data_CREP_2013-2020.csv"))

### Write the final version to a table in the DB

dbGetQuery(con, "CREATE TABLE Fish_Abundance
  (
  Fish_Abundance_ID AutoIncrement PRIMARY KEY,
  PU_Gap_Code CHAR NOT NULL,
  Reach_Name CHAR NOT NULL,
  Event_Date DATE NOT NULL,
  Fish_Date DATE NOT NULL,
  Fish_Species_Code CHAR (3) NOT NULL,
  Fish_Species_Common CHAR (60),
  Fish_Species_Scientific CHAR (60),
  Length DOUBLE,
  Weight DOUBLE,
  Sex CHAR (10),
  Maturity CHAR (10),
  Deformity CHAR (3),
  Eroded_fins CHAR (3),
  Lesions CHAR (3),
  Tumors CHAR (3),
  Parasites CHAR (3),
  Electrofishing_Injury CHAR (3),
  Release_status CHAR (10),
  Notes CHAR
  )")


dbAppendTable(conn = con, "Fish_Abundance", combined_fish)

dbDisconnect(con)
