##### The following sets of commands intend to take all .csv files from their respective "Data_In" folders and combine them into
## one file for appending to CREP Access Database. Each data types are in comment before script section.

library(tidyverse)

### Discharge
DSC_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DSC", pattern="*.csv")
DSC_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DSC", DSC_filenames)
DSC_fulldataset <- do.call("rbind",lapply(DSC_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
DSC_dataset <- DSC_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day))
write.csv(DSC_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/DSC_2018.csv")
 
### Fish Metadata 
 FMD_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FMD", pattern="*.csv")
  FMD_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FMD",FMD_filenames)
  FMD_fulldataset <- do.call("rbind",lapply(FMD_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
  FMD_dataset <- FMD_fulldataset %>% select(-c(Gap_Code,Event_Year,Event_Month,Event_Day,Data_Entered_By,Data_Entered_Date))
 write.csv(FMD_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/FMD_2018.csv", na=".")

### Fish Abundance 
 
FSH_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FSH", pattern="*.csv")
FSH_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FSH",FSH_filenames)
 FSH_fulldataset <- do.call("rbind",lapply(FSH_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
 FSH_dataset <- FSH_fulldataset %>% 
      select(-c(Gap_Code,Fish_Species_Common,Fish_Species_Scientific,Event_Day,Event_Year,Event_Month)) %>% 
      drop_na()
 write.csv(FSH_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/FSH_2018.csv")
 
 ### Fish Length Weight
 
 FLW_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FLW", pattern="*.csv")
 FLW_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FLW",FLW_filenames)
 FLW_fulldataset <- do.call("rbind",lapply(FLW_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
 FLW_dataset <- FLW_fulldataset %>% select(-c(Gap_Code,Event_Year,Event_Month,Event_Day,Fish_Species_Common,Fish_Species_Scientific))
 write.csv(FLW_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/FLW_2018.csv")

 ### Illinois Habitat Index
 
IHI_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/IHI", pattern="*.csv")
 IHI_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/IHI",IHI_filenames)
 IHI_fulldataset <- do.call("rbind",lapply(IHI_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
 IHI_dataset <- IHI_fulldataset %>% select(-c(Ecoregion,Gradient))
 write.csv(IHI_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/IHI_2018.csv")
  
## Invertebrate Field Collection
  
INV_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/INV", pattern="*.csv")
  INV_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/INV",INV_filenames)
  INV_fulldataset <- do.call("rbind",lapply(INV_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
  INV_dataset <- INV_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day))
  write.csv(INV_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/INV_2018.csv")
  

## Qualitative Habitat Evaluation Index
  
  QHEI_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/QHEI", pattern="*.csv")
  QHEI_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/QHEI",QHEI_filenames)
  QHEI_fulldataset <- do.call("rbind",lapply(QHEI_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
  QHEI_dataset <- QHEI_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day))
  write.csv(QHEI_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/QHEI_2018.csv")
  
  
### Stream Water Chemistry
  
  SWC_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/SWC", pattern="*.csv")
  SWC_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/SWC",SWC_filenames)
  SWC_fulldataset <- do.call("rbind",lapply(SWC_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE, na.strings='.')}))
  SWC_dataset <- SWC_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day))
  write.csv(SWC_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/SWC_2018.csv")
  

  #head(DSC_fulldataset) 
  #head(FishMD_dataset) 
  #head(FishA_dataset) 
  #head(FishLW_dataset) 
  #head(IHI_fulldataset) 
  #head(INV_fulldataset) 
  #head(QHEI_fulldataset) 
  #head(SWC_fulldataset) 
  
  #lapply(SWC_dataset, class)



