##### The following sets of commands intend to take all .csv files from their respective "Data_In" folders and combine them into
## one file for appending to CREP Access Database. Each data types are in comment before script section.

####
library(tidyverse)
library(docstring)
library(jsonlite)

year = 2021

#### Read json config file ####
# column_types <- jsonlite::fromJSON("Combine_Data_IN/column_schemas.json")

# TODO Once json file is on GitHub main branch change link 
column_types <- jsonlite::fromJSON("https://raw.githubusercontent.com/lehostert/Kaskaskia-River-CREP-Monitoring-Data-Tools/new-fish/Combine_Data_IN/column_schemas.json")

# column_types <- jsonlite::fromJSON("https://raw.githubusercontent.com/lehostert/Kaskaskia-River-CREP-Monitoring-Data-Tools/master/Combine_Data_IN/column_schemas.json")

#### Function for binding data ####

bind_data_fun <- function(dat_type, col_type, sampling_year) {
  #' Create dataframe by binding together all of the excel templates for a certain data types and prepare for ingest to DB
  #'
  #' @param dat_type 3-4 letter code used in template files for the data type you want to combine.
  #' @param col_type list of column types for the read_xl function, specific to each data type.
  #' @param sampling_year numeric "YYYY" representation of the sampling year of interest.
  #'
  data_in_path <- "//INHS-Bison.ad.uillinois.edu/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/"
  data_filenames <- list.files(
    path = file.path(data_in_path, dat_type),
    pattern = paste0(sampling_year, "(.*)\\.xlsx$")
  )
  data_fullpath <- file.path(data_in_path, dat_type, data_filenames)
  data_fulldataset <- do.call("rbind", lapply(data_fullpath, FUN = function(files) {
    readxl::read_xlsx(files, sheet = 2, na = c(".", "", "-"), col_types = col_type)
  }))
  if (dat_type == "FMD") {
    data_fulldataset <- data_fulldataset %>% 
      mutate(Time_Effort = format(Time_Effort,"%H:%M:%S"))
  }
  write.csv(data_fulldataset, file = paste0(data_in_path, "DB_Ingest/", dat_type,"_", sampling_year, ".csv"), na = "", row.names = F)
  return(data_fulldataset)
} 

IHI <- bind_data_fun("IHI", column_types$IHI, year)
SWC <- bind_data_fun("SWC", column_types$SWC, year)
QHEI <- bind_data_fun("QHEI", column_types$QHEI, year)
DSC <- bind_data_fun("DSC", column_types$DSC, year)
INV <- bind_data_fun("INV", column_types$INV, year)
FMD <- bind_data_fun("FMD", column_types$FMD, year)
FSH <- bind_data_fun("FSH", column_types$FSH, year)

