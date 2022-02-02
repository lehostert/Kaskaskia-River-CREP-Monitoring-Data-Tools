library(tidyverse)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison", "/Volumes")

f_20 <- readr::read_csv(file = paste0(network_prefix, "/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/FSH_2020.csv"))
# f_19_code <- readr::read_csv(file = paste0(network_prefix, "/ResearchData/Groups/Kaskaskia_CREP/Data/Data_OUT/DB_Ingested/FSH_2019.csv") )
# f_18_code <- readr::read_csv(file = paste0(network_prefix, "/ResearchData/Groups/Kaskaskia_CREP/Data/Data_OUT/DB_Ingested/FSH_2018.csv") )


column_types <- jsonlite::fromJSON("https://raw.githubusercontent.com/lehostert/Kaskaskia-River-CREP-Monitoring-Data-Tools/new-fish/Combine_Data_IN/column_schemas.json")

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

f_19 <- bind_data_fun("FSH", column_types$FSH19, 2019)
f_19$Event_Date <- as.Date(f_19$Event_Date)
f_19$Fish_Date <- f_19$Event_Date

f19_full2 <- f_19 %>%
  mutate(across(where(is.character), ~na_if(., "no"))) %>% 
  mutate(Release_status = replace_na(Release_status, "alive")) %>% 
  select(-c(Gap_Code)) %>% 
  drop_na(Species_Code)
  
f20_full <- f_20 %>%
  mutate(across(where(is.character), ~na_if(., "no"))) %>% 
  mutate(Release_status = replace_na(Release_status, "alive")) %>% 
  select(-c(Gap_Code)) %>% 
  drop_na(Species_Code)

f_1920 <- bind_rows(f20_full, f19_full)

fish_summary_bind <- fcount %>% 
  group_by(lubridate::year(Event_Date)) %>% 
  summarise(Total_Fish = sum(Fish_Species_Count))


## Connect to DB and pull in the Fcount and flength data that is already in the database. 
## Filter for all data that is 2018 and before. NO 2019 and no 2020. Double check!
## use uncount() from dplyr in order to spread data from single line to multiple lines
## Find a way to add lw data to single line spp data. 

write_csv(fcount_short, "~/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Combine_Data_IN/counts.csv")
write_csv(flength_short, "~/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Combine_Data_IN/lengths.csv")

fcount_short <- fcount %>% filter(PU_Gap_Code == "kasky12")
flength_short <- flength %>% filter(PU_Gap_Code == "kasky12")


fcount <- as_tibble(tbl(con, "Fish_Count"))
flength <- as_tibble(tbl(con, "Fish_Length_Weight"))

dbDisconnect(con)
