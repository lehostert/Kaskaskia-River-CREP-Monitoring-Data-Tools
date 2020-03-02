library(tidyverse)

IBI <- read.csv("SitesIBIRegionsTable.csv", header = TRUE, stringsAsFactors = FALSE) %>%
  select(-c(Event_Date))

IHI_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IHI", pattern="_2019.csv")
IHI_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IHI",IHI_filenames)
IHI_fulldataset <- do.call("rbind",lapply(IHI_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
write.csv(IHI_fulldataset, file= "IHI_2018_full.csv")

IHI <- read.csv("IHI_2018_full.csv", header = TRUE, stringsAsFactors = FALSE)


IHI_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IHI", pattern="*.xlsx")
IHI_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IHI",IHI_filenames)
IHI_fulldataset_xl <- do.call("rbind",lapply(IHI_fullpath, FUN = function(files){readxl::read_xlsx(files, sheet = 2, col_types = 
                                  c("text", "text", "numeric", "text", 
                                    "numeric", "numeric", "numeric", "numeric","numeric", "numeric","numeric", "numeric","numeric", "numeric", "numeric",
                                    "text", "text", "text", "text", "text", "text",
                                    "numeric", "numeric", "numeric", "numeric","numeric", "numeric","numeric", "numeric","numeric", "numeric", "numeric", "numeric"),
                                  na = ".")}))

IHI_fulldataset_xl$Event_Date <- as.Date(IHI_fulldataset_xl$Event_Date, origin = "1899-12-30")

IBI <- read_csv(file = "Fish_IBI/KaskyCatchments_IBIRegion.csv")
IHI <- read_csv(file = "//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_OUT/DB_Ingested/IHI_2019.csv")

IBI_2019<- readxl::read_xlsx("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IBI/IBI_Metadata_2019.xlsx")
IBI_2019 <- IBI_2019 %>% 
  select(c(PU_Gap_Code, Reach_Name, Event_Date, IBIREGION_, `Slope Adjusted`))
IBI_2019 <- rename(IBI_2019, Slope_Adjusted = `Slope Adjusted`)
IBI_2019 <- rename(IBI_2019, IBI_Region = IBIREGION_)
IBI_2019$Event_Date <- as.Date(IBI_2019$Event_Date)


names(IBI)
names(IHI)

IBI <- rename(IBI, PU_Gap_Code = PUGAP_CODE)
IBI <- rename(IBI, IBI_Region = IBIREGION_)

IBI_MD <- full_join(IBI, IHI_fulldataset_xl)
   
IBI_MD$Slope <- IBI_MD$Gradient*100

IBI_MD_2019 <- IBI_MD %>% 
  filter(lubridate::year(Event_Date) > 2018) %>% 
  select(c(PU_Gap_Code, Reach_Name, Event_Date, IBI_Region, Slope))

IBI_MD_2019 <- rename(IBI_MD_2019, Slope_Adjusted = Slope)
IBI_MD_2019$Reach_Name <- str_to_lower(IBI_MD_2019$Reach_Name)
IBI_2019$Reach_Name <- str_to_lower(IBI_2019$Reach_Name)

identical(IBI_2019, IBI_MD_2019)

list_2019 <- full_join(IBI_MD_2019, IBI_2019, by = c("PU_Gap_Code", "Reach_Name", "Event_Date"))
list_2019 <- rename(list_2019, IBI_Region.True =IBI_Region.x)
list_2019 <- rename(list_2019, IBI_Region.Used =IBI_Region.y)
list_2019 <- rename(list_2019, Slope_Adjusted.True =Slope_Adjusted.x)
list_2019 <- rename(list_2019, Slope_Adjusted.Used =Slope_Adjusted.y)

write.csv(list_2019, file= "Fish_IBI/IBI_MetaData_2019.csv")

head(IBI_MD)

write.csv(IBI_MD, file= "IBI_MetaData.csv")

FSH_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FSH", pattern="*.csv")
FSH_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FSH",FSH_filenames)
FSH_fulldataset <- do.call("rbind",lapply(FSH_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
FSH_dataset <- FSH_fulldataset %>% 
  select(-c(Gap_Code,Event_Day,Event_Year,Event_Month)) %>% 
  drop_na()
write.csv(FSH_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/IBI/FSH_2018_FullCopy.csv")