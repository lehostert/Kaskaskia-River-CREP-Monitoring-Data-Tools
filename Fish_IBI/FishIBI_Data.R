library(tidyverse)
sampling_year <- 2020

#### Read IHI data ####
##Bring in the IHI data this will give you the EcoRegion that is needed for the IBI. 
data_type <- "IHI"
collumns <- c("text","text","date","text","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric",
              "text","text","text","text","text","text",
              "numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

data_filenames <- list.files(path= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/", data_type), pattern=paste0(sampling_year,"(.*)\\.xlsx$"))
data_fullpath = file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/", data_type, data_filenames)
IHI_fulldataset <- do.call("rbind",lapply(data_fullpath, FUN = function(files){readxl::read_xlsx(files, sheet = 2, na = c(".",""), col_types = collumns)}))
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

IBI_MD <- left_join(IHI_fulldataset, IBI)
   
IBI_MD$Slope <- IBI_MD$Gradient*100

IBI_MD <- IBI_MD %>% 
  select(c(PU_Gap_Code, Reach_Name, Event_Date, IBI_Region, Slope)) %>% 
  rename(Slope_Adjusted = Slope) %>% 
  unique()

write.csv(IBI_MD, file= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IBI/IBI_Metadata_",sampling_year,".csv"), row.names = F)

#### Read in Fish Data ####
data_type <- "FSH"
collumns <- c("text", "text", "text","date", "date", "text", "text", "text", "numeric", "numeric",
              "text","text", "text", "text", "text", "text", "text", "text", "text", "text")

data_filenames <- list.files(path= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/", data_type), pattern=paste0(sampling_year,"(.*)\\.xlsx$"))
data_fullpath = file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/", data_type, data_filenames)
data_fulldataset <- do.call("rbind",lapply(data_fullpath, FUN = function(files){readxl::read_xlsx(files, sheet = 1, na = c(".",""), col_types = collumns)}))

view(data_fulldataset)

#### Fish from single line list then collapse into single line for each species type with count per site####

fish_summary <- data_fulldataset %>% 
  drop_na(Species_Code) %>% 
  mutate(across(where(is.character), ~na_if(., "no"))) %>% 
  mutate(Release_status = replace_na(Release_status, "alive"))%>%
  group_by(PU_Gap_Code, Reach_Name, Event_Date, Species_Code, Fish_Species_Common) %>% 
  summarise(Fish_Species_Count = n())

fish_summary$Reach_Name <- stringr::str_replace(fish_summary$Reach_Name, "copper[:blank:]|copper|Copper|copper[:digit:]","Copper ") %>% 
  stringr::str_replace(fish_summary$Reach_Name, "kasky[:blank:]|Kasky[:blank:]","kasky")

fish_summary$PU_Gap_Code <- stringr::str_to_lower(fish_summary$PU_Gap_Code)
  
view(fish_summary)

write.csv(fish_summary, file= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IBI/FSH_",sampling_year,"_summary.csv"), row.names = F)

