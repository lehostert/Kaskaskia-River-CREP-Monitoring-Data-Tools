##### The following sets of commands intend to take all .csv files from their respective "Data_In" folders and combine them into
## one file for appending to CREP Access Database. Each data types are in comment before script section.

library(tidyverse)
sampling_year <- 2019

### Discharge
DSC_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DSC", pattern=paste0(sampling_year,"(.*)\\.csv$"))
DSC_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DSC", DSC_filenames)
DSC_fulldataset <- do.call("rbind",lapply(DSC_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE, na.strings = ".")}))
DSC_dataset <- DSC_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day)) 
DSC_dataset$Reach_Name <- stringr::str_replace(DSC_dataset$Reach_Name, "kasky[:blank:]|Kasky[:blank:]","kasky")
write.csv(DSC_dataset, file= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/DSC_",sampling_year,".csv"), na= "", row.names = F)


### Illinois Habitat Index
 
IHI_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IHI", pattern=paste0(sampling_year,"(.*)\\.csv$"))
IHI_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IHI",IHI_filenames)
IHI_fulldataset <- do.call("rbind",lapply(IHI_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE, na.strings = ".")}))
IHI_dataset <- IHI_fulldataset %>% select(-c(Ecoregion,Gradient))
IHI_dataset$Reach_Name <- stringr::str_replace(IHI_dataset$Reach_Name, "kasky[:blank:]|Kasky[:blank:]|Kasky","kasky")
IHI_dataset$Reach_Name <- stringr::str_replace(IHI_dataset$Reach_Name, "copper[:blank:]|copper","Copper ")
write.csv(IHI_dataset, file= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/IHI_",sampling_year,".csv"), na= "", row.names = F)
  
## Invertebrate Field Collection
  
INV_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/INV", pattern=paste0(sampling_year,"(.*)\\.csv$"))
  INV_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/INV",INV_filenames)
  INV_fulldataset <- do.call("rbind",lapply(INV_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE, na.strings = ".")}))
  INV_dataset <- INV_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day))
  INV_dataset$Reach_Name <- stringr::str_replace(INV_dataset$Reach_Name, "kasky[:blank:]|Kasky[:blank:]|Kasky","kasky")
  INV_dataset$Reach_Name <- stringr::str_replace(INV_dataset$Reach_Name, "copper[:blank:]|copper|Copper|Copper[:blank:]","Copper ")
  write.csv(INV_dataset, file= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/INV_", sampling_year,".csv"), na= "", row.names = F)
  

## Qualitative Habitat Evaluation Index
  
  QHEI_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/QHEI", pattern=paste0(sampling_year,"(.*)\\.csv$"))
  QHEI_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/QHEI",QHEI_filenames)
  QHEI_fulldataset <- do.call("rbind",lapply(QHEI_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE, na.strings = ".")}))
  QHEI_dataset <- QHEI_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day))
  QHEI_dataset$Reach_Name <- stringr::str_replace(QHEI_dataset$Reach_Name, "kasky[:blank:]|Kasky[:blank:]|Kasky","kasky")
  QHEI_dataset$Reach_Name <- stringr::str_replace(QHEI_dataset$Reach_Name, "copper[:blank:]|copper|Copper|Copper[:blank:]","Copper ")
  write.csv(QHEI_dataset, file= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/QHEI_",sampling_year,".csv"), na= "", row.names = F)
  
  
### Stream Water Chemistry
  SWC_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/SWC", pattern=paste0(sampling_year,"(.*)\\.csv$"))
  SWC_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/SWC",SWC_filenames)
  SWC_fulldataset <- do.call("rbind",lapply(SWC_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE, na.strings='.')}))
  SWC_dataset <- SWC_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day))
  SWC_dataset$Reach_Name <- stringr::str_replace(SWC_dataset$Reach_Name, "kasky[:blank:]|Kasky[:blank:]|Kasky","kasky")
  SWC_dataset$Reach_Name <- stringr::str_replace(SWC_dataset$Reach_Name, "copper[:blank:]|copper|Copper|Copper[:blank:]","Copper ")
  write.csv(SWC_dataset, file= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/SWC_",sampling_year,".csv"), na= "", row.names = F)
  ### Template used in 2019 contained error in collumn title "DO_Saturation" is written as "DO%Saturation" which is incompatible with the CREP_Database in Access.
  ### After writing .csv you must change header before ingesting to DB. 
  ### Template error fixed 1/9/2020 for future data entry. 
  
  
### Fish Metadata 
  FMD_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/FMD", pattern=paste0(sampling_year,"(.*)\\.csv$"))
  FMD_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/FMD",FMD_filenames)
  FMD_fulldataset <- do.call("rbind",lapply(FMD_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE, na.strings = ".")}))
  FMD_dataset <- FMD_fulldataset %>% select(-c(Gap_Code,Event_Year,Event_Month,Event_Day,Data_Entered_By,Data_Entered_Date))
  write.csv(FMD_dataset, file= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/FMD_", sampling_year,".csv"), na= "", row.names = F)
  
### Fish Abundance 
  
  FSH_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/FSH", pattern=paste0(sampling_year,"(.*)\\.csv$"))
  FSH_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/FSH",FSH_filenames)
  FSH_fulldataset <- do.call("rbind",lapply(FSH_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
  FSH_dataset <- FSH_fulldataset %>% 
    select(-c(Gap_Code,Fish_Species_Common,Fish_Species_Scientific,Event_Day,Event_Year,Event_Month)) %>% 
    drop_na()
  write.csv(FSH_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/FSH_2018.csv")
  
### Fish Length Weight
  
  FLW_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/FLW", pattern=paste0(sampling_year,"(.*)\\.csv$"))
  FLW_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/FLW",FLW_filenames)
  FLW_fulldataset <- do.call("rbind",lapply(FLW_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
  FLW_dataset <- FLW_fulldataset %>% select(-c(Gap_Code,Event_Year,Event_Month,Event_Day,Fish_Species_Common,Fish_Species_Scientific))
  write.csv(FLW_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/FSH_LW_2018.csv")
  
  
  #head(DSC_fulldataset) 
  #head(FishMD_dataset) 
  #head(FishA_dataset) 
  #head(FishLW_dataset) 
  #head(IHI_fulldataset) 
  #head(INV_fulldataset) 
  #head(QHEI_fulldataset) 
  #head(SWC_fulldataset) 
  
  #lapply(SWC_dataset, class)



