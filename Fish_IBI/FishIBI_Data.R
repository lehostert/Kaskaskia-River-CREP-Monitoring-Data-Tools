library(tidyverse)

IBI <- read.csv("SitesIBIRegionsTable.csv", header = TRUE, stringsAsFactors = FALSE) %>%
  select(-c(Event_Date))

IHI_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/IHI", pattern="*.csv")
IHI_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/IHI",IHI_filenames)
IHI_fulldataset <- do.call("rbind",lapply(IHI_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
write.csv(IHI_fulldataset, file= "IHI_2018_full.csv")

IHI <- read.csv("IHI_2018_full.csv", header = TRUE, stringsAsFactors = FALSE)

names(IBI)
names(IHI)

IBI_MD <- full_join(IBI, IHI)
   
IBI_MD$Slope <- IBI_MD$Gradient*100

IBI_MD <- select(IBI_MD, c(PU_Gap_Code,Reach_Name, Event_Date, Stream_Name, IBIREGION_, Mean_Width, Slope))


head(IBI_MD)

write.csv(IBI_MD, file= "IBI_MetaData.csv")

FSH_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FSH", pattern="*.csv")
FSH_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FSH",FSH_filenames)
FSH_fulldataset <- do.call("rbind",lapply(FSH_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
FSH_dataset <- FSH_fulldataset %>% 
  select(-c(Gap_Code,Event_Day,Event_Year,Event_Month)) %>% 
  drop_na()
write.csv(FSH_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/IBI/FSH_2018_FullCopy.csv")