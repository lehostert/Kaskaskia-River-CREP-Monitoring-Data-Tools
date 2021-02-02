library(tidyverse)
library(odbc)
library(DBI)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison", "/Volumes")
### with odbc
odbcListDrivers() # to get a list of the drivers your computer knows about 
# con <- dbConnect(odbc::odbc(), "Testing_Database")
con <- dbConnect(odbc::odbc(), "2019_CREP_Database")
dbListTables(con) # To get the list of tables in the database
options(odbc.batch_rows = 1)


# TODO Fix errors for the time effors in the Fish Metadata table for 2020 "Time_Effort"


## Example for fixing an error you must overwrite a file. 
# ihi_table <- as_tibble(tbl(con, "Habitat_IHI"))
# 
# ### Example for updating and replacing all of the records in a table
# 
# invert_field_table <- as_tibble(tbl(con, "Invert_Metadata_Field"))
# inv_col_unique <- unique(invert_field_table$Jab_Collector)
# 
# invert_field_table$Jab_Collector <- stringr::str_remove(invert_field_table$Jab_Collector, "[:punct:]")
# invert_field_table$Jab_Collector <- stringr::str_to_lower(invert_field_table$Jab_Collector)
# inv_col_unique2 <- unique(invert_field_table$Jab_Collector)
# 
# dbWriteTable(con, "Invert_Metadata_Field", invert_field_table, batch_rows = 1, overwrite = TRUE, append = FALSE)

#Test with inspecting "BLukaszczyk" and "David S."

#### Update the DB to have the corrected Fish Metadata for 2020. ####

fmd <- as_tibble(tbl(con, "Fish_Metadata"))

FMD_2020 <- FMD_test %>% 
  rename(FMD_Entered_By = Data_Entered_By, FMD_Entered_Date = Data_Entered_Date)

# FMD_2021 <- FMD_2020 %>% 
#   select(-c(Gap_Code, FMD_Entered_By, FMD_Entered_Date))

fmd_update <- fmd %>% 
  filter(lubridate::year(Event_Date) != 2020) %>% 
  mutate(Fish_Date = Event_Date) %>% 
  full_join(FMD_2020) %>% 
  tibble::rowid_to_column("ID") %>% 
  select(-c(Gap_Code, Fish_Metadata_ID)) %>%
  rename(Fish_Metadata_ID = ID)

# dbWriteTable(con, "Fish_Metadata", fmd_update, overwrite = TRUE, append = FALSE)


#### Add Fish Metadata from 2019 ####
FMD_2019 <- readxl::read_xlsx(path = "//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/FMD/Fish_Metadata_2019_LEH.xlsx", 
                              sheet = 1, col_types = column_types$FMD) 
FMD_19 <- FMD_2019 %>% 
  mutate(Time_Effort = format(Time_Effort,"%H:%M:%S"), 
         Fish_Date = Event_Date) %>% 
  rename(FMD_Entered_By = Data_Entered_By, FMD_Entered_Date = Data_Entered_Date) %>% 
  select(-c(Gap_Code))

# dbAppendTable(conn = con, name = "Fish_Metadata", value = FMD_19, row.names = NULL)
