library(tidyverse)
library(odbc)
library(DBI)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison", "/Volumes")

# dbWriteTable()

### with odbc
odbcListDrivers() # to get a list of the drivers your computer knows about 
con <- dbConnect(odbc::odbc(), "Testing_Database")
# con <- dbConnect(odbc::odbc(), "2019_CREP_Database")
dbListTables(con) # To get the list of tables in the database

dbWriteTable(con, "Habitat_IHI", IHI_2020, append = TRUE)
# dbWriteTable(con, "Habitat_IHI", IHI_2020, batch_rows = 1, append = TRUE)

##TODO test this
dbAppendTable(conn = con, name = "Habitat_IHI", value = IHI_2020, row.names = FALSE)

## This is based on GitHub Comments for issues #263 of the odbc package. but you should continue reading to see
## if dbAppendTable is a "safer" option for what you want to do because there is no way to set append to be FALSE with dbAppendTable but there is for 
## See https://github.com/r-dbi/odbc/issues/263 for more information 

ihi_table <- as_tibble(tbl(con, "Habitat_IHI"))

### Example for updating and replacing all of the records in a table

invert_field_table <- as_tibble(tbl(con, "Invert_Metadata_Field"))
inv_col_unique <- unique(invert_field_table$Jab_Collector)

invert_field_table$Jab_Collector <- stringr::str_remove(invert_field_table$Jab_Collector, "[:punct:]")
invert_field_table$Jab_Collector <- stringr::str_to_lower(invert_field_table$Jab_Collector)
inv_col_unique2 <- unique(invert_field_table$Jab_Collector)

dbWriteTable(con, "Invert_Metadata_Field", invert_field_table, batch_rows = 1, overwrite = TRUE, append = FALSE)

#Test with inspecting "BLukaszczyk" and "David S."

dbDisconnect(con)

## Keep this for when you are creating a script to ingest all of the data into the DB then auto move them to the OUT folder
## file.rename(paste0(network_prefix,"/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/test.csv"), paste0(network_prefix,"/ResearchData/Groups/Kaskaskia_CREP/Data/Data_OUT/DB_Ingested/test.csv"))


#####################################################
#### Below here be dragons ####
odbc_result <- DBI::dbReadTable(con, "Fish_Abundance") # The dbReadTable() command will return the data table from the database as class: "data.frame"
result_dbi<- as_tibble(odbc_result) # Use as_tibble() turn the dataframe as a tibble dataframe to continue with queries using the dplyr syntax
result_dplyr <- as_tibble(tbl(con, "Fish_Abundance")) # OR directly return the data table from the database as a tibble

#### Conducting Queries ####
## Using DBI and SQL 
fish_locations_sql_dbi <- DBI::dbGetQuery(con, "SELECT DISTINCT Fish_Abundance.PU_Gap_Code, Fish_Abundance.Reach_Name, Fish_Abundance.Event_Date, 
                                          Established_Locations.Site_Type, Established_Locations.Latitude, 
                                          Established_Locations.Longitude, Established_Locations.Stream_Name 
                                       FROM Fish_Abundance LEFT JOIN Established_Locations 
                                       ON (Fish_Abundance.PU_Gap_Code = Established_Locations.PU_Gap_Code) 
                                       AND (Fish_Abundance.Reach_Name = Established_Locations.Reach_Name)") 

# You can use dbGetQuery() for SELECT queries only not queries that involve manipulation. 



## Using dplyr and SQL 
fish_locations_sql_dplyr <- as_tibble(tbl(con, sql("SELECT DISTINCT Fish_Abundance.PU_Gap_Code, Fish_Abundance.Reach_Name, Fish_Abundance.Event_Date, 
                                          Established_Locations.Site_Type, Established_Locations.Latitude, 
                                          Established_Locations.Longitude, Established_Locations.Stream_Name 
                                       FROM Fish_Abundance LEFT JOIN Established_Locations 
                                       ON (Fish_Abundance.PU_Gap_Code = Established_Locations.PU_Gap_Code) 
                                       AND (Fish_Abundance.Reach_Name = Established_Locations.Reach_Name)")))
# tbl() this is a generic method for creating a table from a datasource. In this case the source is our database connection called "con"
# sql() allows you to write SQL queries directly
# as_tibble() will turn the resulting object into a tibble data.frame
# If you remove the as_tibble() function you will get a result that is class ["tbl_ACCESS" "tbl_dbi"    "tbl_sql"    "tbl_lazy"   "tbl"]
# As a tibble you will be able to manipulate it using any 
# TODO can you use sql() for manipulating queries??

## Using dplyr and tidyverse syntax only
fish_locations_dplyr <- as_tibble(tbl(con, "Fish_Abundance")) %>% 
  left_join(as_tibble(tbl(con, "Established_Locations")), by = c("PU_Gap_Code", "Reach_Name")) %>% 
  select(PU_Gap_Code, Reach_Name, Event_Date, Site_Type, Latitude, Longitude, Stream_Name) %>% 
  distinct()


# You can either pull tables out one by one and then join them or use the tbl() function to pull tables from the DB and join them in the same lines of code
# NOTE that if you don't specify the "by" for the `join` dplyr will automatically use all of the fields that are the same between the two tables. 
# In this case removing the "by" argument would result in the same dataframe. 

# NOTE: fish_locations_sql_dbi, fish_locations_sql_dplyr, and fish_locations_dplyr all have the same information (ie. number of observations and variables) 
# but they are  different classes. 
# The DBI query is just a class "data.frame" but the dplyr queries have explicitly been turned into class "tbl_df" "tbl" "data.frame"


#### When you are done close your database connection ####
dbDisconnect(con)