library(tidyverse)
library(odbc)
library(DBI)
library(docstring)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison.ad.uillinois.edu", "/Volumes")

data_year <- 2021
  
#### Connect to Database ####
### with odbc
odbcListDrivers() # to get a list of the drivers your computer knows about 
# con <- dbConnect(odbc::odbc(), "Testing_Database")
con <- dbConnect(odbc::odbc(), "2019_CREP_Database")
options(odbc.batch_rows = 1) # Must be defined as 1 for Access batch writing or appending to tables See below.
dbListTables(con) # To get the list of tables in the database


#### Read current Ingest files waiting to be uploaded ####
#### TODO These might need additional cleaning before ingesting them
read_ingest_files <- function(dat_type, sampling_year) {
  #' After appending data to DB ingested tables are move from Data_IN folder to Data_OUT folder. 
  #'
  #' @param dat_type 3-4 letter code used in template files for the data type you want to combine. Must be in quotes "".
  #' @param sampling_year numeric "YYYY" representation of the sampling year of interest.
  #'
  data_in_path <- "//INHS-Bison.ad.uillinois.edu/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/"
  x <- read_csv(file = paste0(data_in_path, "DB_Ingest/",dat_type,"_",sampling_year,".csv"))
  return(x)
}


DSC <- read_ingest_files("DSC", data_year)
FMD <- read_ingest_files("FMD", data_year)
IHI <- read_ingest_files("IHI", data_year)
QHEI <- read_ingest_files("QHEI", data_year)
INV <- read_ingest_files("INV", data_year)
SWC <- read_ingest_files("SWC", data_year)
# TODO resolve this will column type specification
# This creates a parsing erro because Sex, Eroded_fins and Tumors will be treated col_logical() not Character
# Length, weight are col_double() Event_Date and Fish_Date are col_datetime(format= "") while all others are col_character()
FSH <- read_ingest_files("FSH", data_year)

#### Append New Data to Database ####
dbAppendTable(conn = con, name = "Habitat_Discharge", value = DSC)
dbAppendTable(conn = con, name = "Fish_Metadata", value = FMD)
dbAppendTable(conn = con, name = "Habitat_IHI", value = IHI)
dbAppendTable(conn = con, name = "Habitat_QHEI", value = QHEI)
dbAppendTable(conn = con, name = "Invert_Metadata_Field", value = INV)
dbAppendTable(conn = con, name = "Water_Chemistry_Field", value = SWC)
dbAppendTable(conn = con, name = "Fish_Abundance", value = FSH)

## This is based on GitHub Comments for issues #263 of the odbc package. but you should continue reading to see
## if dbAppendTable is a "safer" option for what you want to do because there is no way to set append to be FALSE with dbAppendTable but there is for dbWriteTable()
## See https://github.com/r-dbi/odbc/issues/263 for more information 
# dbWriteTable()

#### Disconnect from Database ####
dbDisconnect(con)

#### Move the DB ingest files from IN folder to OUT folder  ####
move_in_to_out <- function(dat_type, sampling_year) {
  #' After appending data to DB ingested tables are move from Data_IN folder to Data_OUT folder. 
  #'
  #' @param dat_type 3-4 letter code used in template files for the data type you want to combine.
  #' @param sampling_year numeric "YYYY" representation of the sampling year of interest.
  #'

file.rename(paste0(network_prefix,"/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/",dat_type, "_",sampling_year, ".csv"), 
            paste0(network_prefix,"/ResearchData/Groups/Kaskaskia_CREP/Data/Data_OUT/DB_Ingested/",dat_type, "_",sampling_year, ".csv"))

}

move_in_to_out("DSC", data_year)
# move_in_to_out("FMD", data_year)
move_in_to_out("IHI", data_year)
move_in_to_out("QHEI", data_year)
move_in_to_out("INV", data_year)
move_in_to_out("SWC", data_year)


# TODO make the ingest portion of this code more generic. Remove years from object names for "value" and to ingest data from .csv  and not from objects saved in R

#### Move raw data files IN folder to OUT folder ####

move_raw_in_to_out <- function(dat_type, sampling_year) {
  #' After appending data to DB ingested tables are move from Data_IN folder to Data_OUT folder. 
  #'
  #' @param dat_type 3-4 letter code used in template files for the data type you want to combine.
  #' @param sampling_year numeric "YYYY" representation of the sampling year of interest.
  #'
  
  data_in_path <- "//INHS-Bison.ad.uillinois.edu/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/"
  data_out_path <- "//INHS-Bison.ad.uillinois.edu/ResearchData/Groups/Kaskaskia_CREP/Data/Data_OUT/"
  data_filenames <- list.files(
    path = file.path(data_in_path, dat_type),
    pattern = paste0(sampling_year, "(.*)\\.xlsx$")
  )
  
  file.rename(paste0(data_in_path, dat_type, "/", data_filenames), 
              paste0(data_out_path, dat_type, "/", data_filenames))
  
}

move_raw_in_to_out("DSC", data_year)
move_raw_in_to_out("FMD", data_year)
move_raw_in_to_out("IHI", data_year)
move_raw_in_to_out("QHEI", data_year)
move_raw_in_to_out("INV", data_year)
move_raw_in_to_out("SWC", data_year)

