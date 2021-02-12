library(tidyverse)
sampling_year <- 2020

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison", "/Volumes")


# TODO Once json file is on GitHub main branch change link 
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
    readxl::read_xlsx(files, sheet = 2, na = c(".", ""), col_types = col_type)
  }))
  if (dat_type == "FMD") {
    data_fulldataset <- data_fulldataset %>% 
      mutate(Time_Effort = format(Time_Effort,"%H:%M:%S"))
  }
  return(data_fulldataset)
} 

#### Read IHI data ####
##Bring in the IHI data this will give you the EcoRegion that is needed for the IBI. 
IHI_fulldataset <- bind_data_fun("IHI", column_types$`IHI-for-IBI`, 2020)
view(IHI_fulldataset)

#### Read IBI Regions data ####
##Read in IBI Regions table 
## TODO What is the source of this file? ARCGIS Random data from you or Brian? It looks like it is from Arc
IBI <- read_csv(file = "Fish_IBI/KaskyCatchments_IBIRegion.csv")

#### Compare IHI and IBI Region Tables ####
names(IBI)
names(IHI_fulldataset)

IBI <- rename(IBI, PU_Gap_Code = PUGAP_CODE)
IBI <- rename(IBI, IBI_Region = IBIREGION_)

#### Join IBI and IHI then reformat any fields for Fish IBI Calculation and save file ####

IBI_MD <- left_join(IHI_fulldataset, IBI) %>% 
  mutate(Slope_Adjusted = Gradient*100,
         Stream_width_ft = Mean_Width*3.281) %>%
  select(c(PU_Gap_Code, Reach_Name, Event_Date, IBI_Region, Slope_Adjusted, Stream_width_ft)) %>% 
  unique()

write.csv(IBI_MD, file= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IBI/IBI_Metadata_",sampling_year,"version2.csv"), row.names = F)

#### Read in Fish Data ####
# data_type <- "FSH"
# collumns <- c("text", "text", "text","date", "date", "text", "text", "text", "numeric", "numeric",
#               "text","text", "text", "text", "text", "text", "text", "text", "text", "text")
# data_filenames <- list.files(path= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/", data_type), pattern=paste0(sampling_year,"(.*)\\.xlsx$"))
# data_fullpath = file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/", data_type, data_filenames)
# data_fulldataset <- do.call("rbind",lapply(data_fullpath, FUN = function(files){readxl::read_xlsx(files, sheet = 1, na = c(".",""), col_types = collumns)}))


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
  return(data_fulldataset)
} 

fish_fulldataset <- bind_data_fun("FSH", column_types$FSH, 2020)
view(fish_fulldataset)

##
fish <- read_csv(file = paste0(network_prefix, "/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/FSH_2020.csv"))
fish_orig <- read_csv(file = paste0(network_prefix, "/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IBI/FSH_2020_summary.csv"))

#### Fish from single line list then collapse into single line for each species type with count per site####

fish_summary <- fish_fulldataset %>%
# fish_summary <- fish %>% 
  drop_na(Species_Code) %>% 
  mutate(across(where(is.character), ~na_if(., "no"))) %>% 
  mutate(Release_status = replace_na(Release_status, "alive"))%>%
  group_by(PU_Gap_Code, Reach_Name, Event_Date, Species_Code, Fish_Species_Common) %>% 
  summarise(Fish_Species_Count = n())

fish_summary$Reach_Name <- stringr::str_replace(fish_summary$Reach_Name, "copper[:blank:]|copper|Copper|copper[:digit:]","Copper ") 
fish_summary$Reach_Name <- stringr::str_replace(fish_summary$Reach_Name, "kasky[:blank:]|Kasky[:blank:]|Kasky","kasky")
fish_summary$PU_Gap_Code <- stringr::str_to_lower(fish_summary$PU_Gap_Code)
  
view(fish_summary)

write.csv(fish_summary, file= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IBI/FSH_",sampling_year,"_summary2.csv"), row.names = F)
