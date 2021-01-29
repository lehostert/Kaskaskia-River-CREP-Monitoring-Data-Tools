library(tidyverse)
library(odbc)
library(DBI)
library(docstring)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison", "/Volumes")

# dbWriteTable()

### with odbc
odbcListDrivers() # to get a list of the drivers your computer knows about 
# con <- dbConnect(odbc::odbc(), "Testing_Database")
con <- dbConnect(odbc::odbc(), "2019_CREP_Database")
dbListTables(con) # To get the list of tables in the database


dbAppendTable(conn = con, name = "Habitat_Discharge", value = DSC_2020,  batch_rows = 1)
dbAppendTable(conn = con, name = "Fish_Metadata", value = FMD, batch_rows = 1)
dbAppendTable(conn = con, name = "Habitat_IHI", value = IHI_2020, batch_rows = 1)
dbAppendTable(conn = con, name = "Habitat_QHEI", value = QHEI_2020, batch_rows = 1)
dbAppendTable(conn = con, name = "Invert_Metadata_Field", value = INV_2020, batch_rows = 1)
dbAppendTable(conn = con, name = "Water_Chemistry_Field", value = SWC_2020, batch_rows = 1)


## This is based on GitHub Comments for issues #263 of the odbc package. but you should continue reading to see
## if dbAppendTable is a "safer" option for what you want to do because there is no way to set append to be FALSE with dbAppendTable but there is for 
## See https://github.com/r-dbi/odbc/issues/263 for more information 


dbDisconnect(con)

move_in_to_out <- function(dat_type, sampling_year) {
  #' After appending data to DB ingested tables are move from Data_IN folder to Data_OUT folder. 
  #'
  #' @param dat_type 3-4 letter code used in template files for the data type you want to combine.
  #' @param sampling_year numeric "YYYY" representation of the sampling year of interest.
  #'

file.rename(paste0(network_prefix,"/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/",dat_type, "_",sampling_year, ".csv"), 
            paste0(network_prefix,"/ResearchData/Groups/Kaskaskia_CREP/Data/Data_OUT/DB_Ingested/",dat_type, "_",sampling_year, ".csv"))

}

move_in_to_out("DSC", 2020)
move_in_to_out("FMD", 2020)
move_in_to_out("IHI", 2020)
move_in_to_out("QHEI", 2020)
move_in_to_out("INV", 2020)
move_in_to_out("SWC", 2020)


# TODO make the ingest portion of this code more generic. Remove years from object names for "value" and to ingest data from .csv  and not from objects saved in R
# TODO fix the fact that you need to FMD <- FMD %>% select(-c(Data_Entered_By, Data_Entered_Date)) in order to ingest Fish Metadata