library(tidyverse)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison", "/Volumes")

f_20 <- readr::read_csv(file = paste0(network_prefix, "/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/FSH_2020.csv"))
# f_19 <- readr::read_csv(file = )

column_types <- jsonlite::fromJSON("https://raw.githubusercontent.com/lehostert/Kaskaskia-River-CREP-Monitoring-Data-Tools/master/Combine_Data_IN/column_schemas.json")

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
  if (dat_type == "FMD") {
    data_fulldataset <- data_fulldataset %>% 
      mutate(Time_Effort = format(Time_Effort,"%H:%M:%S"))
  }
  write.csv(data_fulldataset, file = paste0(data_in_path, "DB_Ingest/", dat_type,"_", sampling_year, ".csv"), na = "", row.names = F)
  return(data_fulldataset)
} 

f_19 <- bind_data_fun("FSH", column_types$FSH, 2019)