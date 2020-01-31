library(tidyverse)

#### Combine fish data and turn into abundance data ####

FSH_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/FSH", pattern=".\\.csv$")
FSH_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/FSH",FSH_filenames)
FSH_fulldataset <- do.call("rbind",lapply(FSH_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE, na = c("","#N/A"))}))
FSH_dataset <- FSH_fulldataset %>% 
  drop_na(Species_Code) 

FSH_dataset$Species_Code <- stringr::str_to_upper(FSH_dataset$Species_Code)
FSH_dataset$Reach_Name <- stringr::str_to_lower(FSH_dataset$Reach_Name) 
FSH_dataset$Reach_Name <- stringr::str_replace_all(FSH_dataset$Reach_Name,"[:blank:]", "") 

FSH_dataset$Reach_Name <- if_else(str_detect(FSH_dataset$Reach_Name,"copper"), str_to_title(FSH_dataset$Reach_Name),FSH_dataset$Reach_Name)
FSH_dataset$Reach_Name <- str_replace(FSH_dataset$Reach_Name, "Copper", "Copper ")

FSH_dataset <- FSH_dataset %>%
  select(c(PU_Gap_Code, Reach_Name, Event_Date,Species_Code, Fish_Species_Common, Fish_Species_Scientific, Release_status))

FSH_abundance <- FSH_dataset %>% 
  count(PU_Gap_Code, Reach_Name, Event_Date,Species_Code, Fish_Species_Common, Fish_Species_Scientific, Release_status, sort = T)

FSH_abundance <- FSH_abundance %>% replace_na(list(Release_status = "Released"))
FSH_abundance$Release_status <- str_replace(FSH_abundance$Release_status, "mortality", "Destroyed")
FSH_abundance$Release_status <- str_replace(FSH_abundance$Release_status, "alive", "Released")
FSH_abundance$Release_status <- str_replace(FSH_abundance$Release_status, "voucher", "Donated to INHS")

FSH_abundance <- rename(FSH_abundance, Count = n)
FSH_abundance$Collection_Method <- "Electrofishing"
FSH_abundance$Event_Date <- as.Date(FSH_abundance$Event_Date, format = "%m/%d/%Y")
 
# write.csv(FSH_abundance, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/FSH_2019.csv")
# fsh <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/FSH_2018.csv", header = T, na = ".")


#### Read in Location Data ####

loc <- readxl::read_excel("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/Sites_2019.xlsx", sheet = 1)
loc$Event_Date <- as.Date(loc$Event_Date, format = "%Y-%m-%d")
loc$Reach_Name <- str_replace(loc$Reach_Name, "Copper", "Copper ")

#### Create Permit Summary Table ####

fish_sum <- full_join(FSH_abundance, loc)
fish_sum <- fish_sum %>% select(c(PU_Gap_Code, Latitude, Longitude, Stream_Name, Event_Date, Fish_Species_Common, Fish_Species_Scientific, Count, Collection_Method, Release_status))

write_excel_csv(fish_sum, path = "~/CREP/Permits/2019/2019_Fish_Summary.csv", delim = ",")
