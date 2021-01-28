##### The following sets of commands intend to take all .csv files from their respective "Data_In" folders and combine them into
## one file for appending to CREP Access Database. Each data types are in comment before script section.

####
library(tidyverse)
library(docstring)
library(jsonlite)

#### Read json config file ####
# column_types <- jsonlite::fromJSON("Combine_Data_IN/column_schemas.json")

# TODO Once json file is on GitHub main branch change link 
column_types <- jsonlite::fromJSON("https://raw.githubusercontent.com/lehostert/Kaskaskia-River-CREP-Monitoring-Data-Tools/read-from-excel/Combine_Data_IN/column_schemas.json")

#### Function for binding data ####

bind_data_fun <- function(dat_type, col_type, sampling_year) {
  #' Create dataframe by binding together all of the excel templates for a certain data types and prepare for ingest to DB
  #'
  #' @param dat_type 3-4 letter code used in template files for the data type you want to combine.
  #' @param col_type list of column types for the read_xl function, specific to each data type.
  #' @param sampling_year numeric "YYYY" representation of the sampling year of interest.
  #'
  data_in_path <- "//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/"
  data_filenames <- list.files(
    path = file.path(data_in_path, dat_type),
    pattern = paste0(sampling_year, "(.*)\\.xlsx$")
  )
  data_fullpath <- file.path(data_in_path, dat_type, data_filenames)
  data_fulldataset <- do.call("rbind", lapply(data_fullpath, FUN = function(files) {
    readxl::read_xlsx(files, sheet = 2, na = c(".", ""), col_types = col_type)
  }))
  write.csv(data_fulldataset, file = paste0(data_in_path, "DB_Ingest/", dat_type,"_", sampling_year, ".csv"), na = "", row.names = F)
  return(data_fulldataset)
} 

IHI_2020 <- bind_data_fun("IHI", column_types$IHI, 2020)
SWC_2020 <- bind_data_fun("SWC", column_types$SWC, 2020)
QHEI_2020 <- bind_data_fun("QHEI", column_types$QHEI, 2020) 
DSC_2020 <- bind_data_fun("DSC", column_types$DSC, 2020)
INV_2020 <- bind_data_fun("INV", column_types$INV, 2020)

# TODO Change Template so that fish data is on second sheet. 
# TODO remove the section below and add fish above when the template is adjusted for future years. 

bind_data_fun <- function(dat_type, col_type, sampling_year) {
  #' Create dataframe by binding together all of the excel templates for a certain data types and prepare for ingest to DB
  #'
  #' @param dat_type 3-4 letter code used in template files for the data type you want to combine.
  #' @param col_type list of column types for the read_xl function, specific to each data type.
  #' @param sampling_year numeric "YYYY" representation of the sampling year of interest.
  #'
  data_in_path <- "//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/"
  data_filenames <- list.files(
    path = file.path(data_in_path, dat_type),
    pattern = paste0(sampling_year, "(.*)\\.xlsx$")
  )
  data_fullpath <- file.path(data_in_path, dat_type, data_filenames)
  data_fulldataset <- do.call("rbind", lapply(data_fullpath, FUN = function(files) {
    readxl::read_xlsx(files, sheet = 1, na = c(".", ""), col_types = col_type)
  }))
  write.csv(data_fulldataset, file = paste0(data_in_path, "DB_Ingest/", dat_type,"_", sampling_year, ".csv"), na = "", row.names = F)
  return(data_fulldataset)
} 

FSH_2020 <- bind_data_fun("FSH", column_types$FSH, 2020)
