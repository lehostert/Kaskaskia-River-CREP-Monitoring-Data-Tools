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
 
 ### You must return to this in order to fix the problems. Currently when applyings the do.call string 
 
 FLW_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FLW", pattern="*.csv")
 FLW_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FLW",FLW_filenames)
 FishLW_dataset <- do.call("rbind",lapply(FLW_fullpath, FUN = function(files){read.csv(files)}))
 
 head(FishLW_dataset) 
 
 FSH_dataset <- FishA_dataset %>% select(-c(Gap_Code,Fish_Species_Common,Fish_Species_Scientific,Event_Day,Event_Year,Event_Month))
 write.csv(FSH_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/FSH_2018.csv", na=".")
 
LW_1517 <- read.csv('//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FLW/Fish_Lw_kasky1517_20181001.csv')

 read.csv('//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FLW/Fish_Lw_kasky2240_20180925.csv')
 
 
 library(tidyverse)
 
TidyLW <- list.files(path = "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FLW",
            pattern="*.csv", 
            full.names = T) %>% 
            map_df(~read_csv(.))
 
##TEST
test_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/TEST", pattern="*.csv")
test_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/TEST",test_filenames)
test_dataset <- do.call("rbind",lapply(test_fullpath, FUN = function(x){read.csv(x)}))
head(test_dataset)
