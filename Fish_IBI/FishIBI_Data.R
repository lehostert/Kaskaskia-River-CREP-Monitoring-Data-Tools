library(tidyverse)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison.ad.uillinois.edu", "/Volumes")
network_path <- paste0(network_prefix, "/ResearchData/Groups/Kaskaskia_CREP")

# TODO do you need this script at all? The data for the IBI Regions should be in database. As should the additional features that you need. 
# This could be a Query that you set up and just run after the FISH data are entered. 

sampling_year <- 2021

# TODO Once json file is on GitHub main branch change link 
column_types <- jsonlite::fromJSON("https://raw.githubusercontent.com/lehostert/Kaskaskia-River-CREP-Monitoring-Data-Tools/new-fish/Combine_Data_IN/column_schemas.json")

bind_data_fun <- function(dat_type, col_type, sampling_year) {
  #' Create dataframe by binding together all of the excel templates for a certain data types and prepare for ingest to DB
  #'
  #' @param dat_type 3-4 letter code used in template files for the data type you want to combine.
  #' @param col_type list of column types for the read_xl function, specific to each data type.
  #' @param sampling_year numeric "YYYY" representation of the sampling year of interest.
  #'
  data_in_path <- "//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_OUT/"
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


bind_data_fun <- function(dat_type, col_type, sampling_year) {
  #' Create dataframe by binding together all of the excel templates for a certain data types and prepare for ingest to DB
  #'
  #' @param dat_type 3-4 letter code used in template files for the data type you want to combine.
  #' @param col_type list of column types for the read_xl function, specific to each data type.
  #' @param sampling_year numeric "YYYY" representation of the sampling year of interest.
  #'
  data_in_path <- "//INHS-Bison.ad.uillinois.edu/ResearchData/Groups/Kaskaskia_CREP/Data/Data_OUT/"
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
  return(data_fulldataset)
}

#### Read IHI data ####
##Bring in the IHI data this will give you the EcoRegion that is needed for the IBI. 
IHI_fulldataset <- bind_data_fun("IHI", column_types$`IHI-for-IBI`, 2021)
view(IHI_fulldataset)

fish <- read_csv(file = paste0(network_path,"/Data/Data_IN/DB_Ingest/FSH_2021.csv"))
ihi <- read_csv(file = paste0(network_path,"/Data/Data_OUT/DB_Ingested/IHI_2021.csv"))

one <- ihi %>% select(PU_Gap_Code, EDU_Code, Reach_Name, Event_Date, IHI_Date)
two <- IHI_fulldataset %>% select(IHI_Date, Gradient, Mean_Width)

ihi_new <- full_join(one, two)

#### Read IBI Regions data ####
##Read in IBI Regions table 
## TODO What is the source of this file? ARCGIS Random data from you or Brian? It looks like it is from Arc
IBI <- read_csv(file = "Fish_IBI/KaskyCatchments_IBIRegion.csv")



#### Compare IHI and IBI Region Tables ####
names(IBI)
names(ihi)
names(IHI_fulldataset)

IBI <- rename(IBI, PU_Gap_Code = PUGAP_CODE)
IBI <- rename(IBI, IBI_Region = IBIREGION_)

#### Join IBI and IHI then reformat any fields for Fish IBI Calculation and save file ####

# IBI_MD <- left_join(IHI_fulldataset, IBI) %>% 
IBI_MD <- left_join(ihi_new, IBI) %>% 
  mutate(Slope_Adjusted = Gradient*100,
         Stream_width_ft = Mean_Width*3.281) %>%
  select(c(PU_Gap_Code, EDU_Code, Reach_Name, Event_Date, IHI_Date, IBI_Region, Slope_Adjusted, Stream_width_ft)) %>% 
  unique()

write.csv(IBI_MD, file= paste0("//INHS-Bison.ad.uillinois.edu/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IBI/IBI_Metadata_",sampling_year,".csv"), row.names = F)

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

# fish_summary <- fish_fulldataset %>%
fish_summary <- fish %>%
  drop_na(Fish_Species_Code) %>% 
  mutate(across(where(is.character), ~na_if(., "no"))) %>% 
  mutate(Release_status = replace_na(Release_status, "alive"))%>%
  group_by(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code, Fish_Species_Common) %>% 
  summarise(Fish_Species_Count = n())
  
view(fish_summary)

write.csv(fish_summary, file= paste0("//INHS-Bison.ad.uillinois.edu/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IBI/FSH_",sampling_year,"_summary.csv"), row.names = F)


#### For 2018 Recalculate ####

fish$Reach_Name <- stringr::str_remove(fish$Reach_Name, "[:blank:]*$")
fish$PU_Gap_Code  <- stringr::str_remove(fish$PU_Gap_Code, "[:blank:]*$")


fish_summary <- fish %>%
  drop_na(Fish_Species_Code) %>% 
  filter(lubridate::year(Event_Date) == 2018) %>% 
  group_by(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code, Fish_Species_Common) %>% 
  summarise(Fish_Species_Count = n()) %>% 
  ungroup()

view(fish_summary)


fish_summary$Site_ID <-paste(str_replace_all(fish_summary$Reach_Name, "[:blank:]", ""), str_replace_all(fish_summary$Event_Date,"-",""), sep = "_")

fish_table <- add_traits_to_data(fish_summary)

IBI_2018 <- fish_table %>% 
  select(Site_ID, Fish_Species_Code, Fish_Species_Count, Hybrid, Unidentified_Species) %>% 
  left_join(fish_summary) %>% 
  filter(Hybrid == 0, Unidentified_Species == 0) %>% 
  select(1,6:8,2,9,3)


write.csv(IBI_2018, file= paste0("//INHS-Bison.ad.uillinois.edu/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IBI/FSH_2018_summary.csv"), row.names = F)

