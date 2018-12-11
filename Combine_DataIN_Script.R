#setwd("\\INHS-Bison\\ResearchData\\Groups\\Kaskaskia CREP\\Data\\Data_IN\\DSC")
library(dplyr)
# DSC_2018 <- 
#   do.call(rbind, lapply(list.files(path = "\\INHS-Bison\\ResearchData\\Groups\\Kaskaskia CREP\\Data\\Data_IN\\DSC"), read.csv))
#         
# list.files(path = "\\INHS-Bison\\ResearchData\\Groups\\Kaskaskia CREP\\Data\\Data_IN\\DSC")

# temp = list.files(pattern=".csv")
# fish_metadata<- lapply(temp, read.delim)
# bind_rows(fish_metadata)

# install.packages("tidyverse")
# library(tidyverse)
# list.files(path= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FMD)", pattern = "*.csv",full.names = T) %>%
#              map_df(~read_csv(.))

##Fish Metadata with Tidy verse
# library(tidyverse)
# FMD_dataset_TV <- lapply(FishMD_filenames, read_csv) %>% bind_rows()

# library(tidyverse)
# 
# TidyLW <- list.files(path = "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FLW",
#                      pattern="*.csv", 
#                      full.names = T) %>% 
#   map_df(~read_csv(.))

library(tidyverse)

##### The following sets of commands intend to take all csv files from their respective "Data_In" folders and combine them into
## one file for appending to CREP Access Database.

## Discharge
DSC_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DSC", pattern="*.csv")
DSC_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DSC", DSC_filenames)
Discharge_dataset <- do.call("rbind",lapply(DSC_fullpath, FUN = function(files){read.csv(files)}))
##Potentially dropping 0s therefore not same number of rows for all. 

head(Discharge_dataset) 

DSC_dataset <- Discharge_dataset %>% select(-c(Gap_Code,Data_Entered_By,Data_Entered_Date))

write.csv(FMD_dataset, file= "FMD_2018.csv", na=".")

head(FMD_dataset)

 
## Fish Metadata 
 FishMD_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FMD", pattern="*.csv")
  FishMD_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FMD",FishMD_filenames)
  FishMD_dataset <- do.call("rbind",lapply(FishMD_fullpath, FUN = function(files){read.csv(files)}))
  
 head(FishMD_dataset) 
 
 FMD_dataset <- FishMD_dataset %>% select(-c(Gap_Code,Data_Entered_By,Data_Entered_Date))
 write.csv(FMD_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/FMD_2018.csv", na=".")

## Fish Abundance 
 
FSH_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FSH", pattern="*.csv")
FSH_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FSH",FSH_filenames)
 FishA_dataset <- do.call("rbind",lapply(FSH_fullpath, FUN = function(files){read.csv(files)}))
 
 head(FishA_dataset) 
 
 FSH_dataset <- FishA_dataset %>% select(-c(Gap_Code,Fish_Species_Common,Fish_Species_Scientific,Event_Day,Event_Year,Event_Month))
 write.csv(FSH_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/FSH_2018.csv", na=".")
 
 ## Fish Length Weight
 
 FLW_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FLW", pattern="*.csv")
 FLW_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FLW",FLW_filenames)
 FishLW_dataset <- do.call("rbind",lapply(FLW_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
 
 head(FishLW_dataset) 
 
 FLW_dataset <- FishLW_dataset %>% select(-c(Gap_Code,Event_Year,Event_Month,Event_Day,Fish_Species_Common,Fish_Species_Scientific))
 write.csv(FLW_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/FLW_2018.csv")

 ## Illinois Habitat Index
 
IHI_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/IHI", pattern="*.csv")
 IHI_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/IHI",IHI_filenames)
 IHI_fulldataset <- do.call("rbind",lapply(IHI_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
 
 head(IHI_fulldataset) 
 
  IHI_dataset <- IHI_fulldataset %>% select(-c(Ecoregion,Gradient))
  write.csv(IHI_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/IHI_2018.csv")
  
## Invertebrate Field Collection
  
INV_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/INV", pattern="*.csv")
  INV_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/INV",INV_filenames)
  INV_fulldataset <- do.call("rbind",lapply(INV_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
  
  head(INV_fulldataset) 
  
  INV_dataset <- INV_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day))
  write.csv(INV_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/INV_2018.csv")
  

## Qualitative Habitat Evaluation Index
  
  QHEI_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/QHEI", pattern="*.csv")
  QHEI_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/QHEI",QHEI_filenames)
  QHEI_fulldataset <- do.call("rbind",lapply(QHEI_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
  
  head(QHEI_fulldataset) 
  
  QHEI_dataset <- QHEI_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day))
  write.csv(QHEI_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/QHEI_2018.csv")
  
  
## Stream Water Chemistry
  
  SWC_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/SWC", pattern="*.csv")
  SWC_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/SWC",SWC_filenames)
  SWC_fulldataset <- do.call("rbind",lapply(SWC_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
  
  head(SWC_fulldataset) 
  
  SWC_dataset <- SWC_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day))
  write.csv(SWC_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/SWC_2018.csv")
  

## Stream Water Chemistry
  
  SWC_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/SWC", pattern="*.csv")
  SWC_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/SWC",SWC_filenames)
  SWC_fulldataset <- do.call("rbind",lapply(SWC_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
  
  head(SWC_fulldataset) 
  
  SWC_dataset <- SWC_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day))
  write.csv(SWC_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/SWC_2018.csv") 











