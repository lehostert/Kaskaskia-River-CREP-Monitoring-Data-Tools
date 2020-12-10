library(tidyverse)
sampling_year <- 2020

# # I believe the bloe file is an old file from Brian that has some of the IBI Regions Incirrect for the various 
# IBI <- read.csv("Fish_IBI/SitesIBIRegionsTable.csv", header = TRUE, stringsAsFactors = FALSE) %>%
#   select(-c(Event_Date))
# 
# IHI_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IHI", pattern="_2019.csv")
# IHI_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IHI",IHI_filenames)
# IHI_fulldataset <- do.call("rbind",lapply(IHI_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
# write.csv(IHI_fulldataset, file= "IHI_2018_full.csv")
# 
# IHI <- read.csv("IHI_2018_full.csv", header = TRUE, stringsAsFactors = FALSE)

# #Bring in the IHI data this will give you the EcoRegion that is needed for the IBI. 

#### PULL In IHI if it has not already been compiled ####
IHI_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IHI", pattern="*.xlsx")
IHI_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IHI",IHI_filenames)
IHI_fulldataset_xl <- do.call("rbind",lapply(IHI_fullpath, FUN = function(files){readxl::read_xlsx(files, sheet = 2, col_types = 
                                  c("text", "text", "numeric", "text", 
                                    "numeric", "numeric", "numeric", "numeric","numeric", "numeric","numeric", "numeric","numeric", "numeric", "numeric",
                                    "text", "text", "text", "text", "text", "text",
                                    "numeric", "numeric", "numeric", "numeric","numeric", "numeric","numeric", "numeric","numeric", "numeric", "numeric", "numeric"),
                                  na = ".")}))

IHI_fulldataset_xl$Event_Date <- as.Date(IHI_fulldataset_xl$Event_Date, origin = "1899-12-30")

#### Read in IHI Table for current year if it has already been compiled ####
IHI <- read_csv(file = paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/IHI_", sampling_year,".csv"))

# #IDK why this is here? Remove it please
# IBI_2019<- readxl::read_xlsx("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IBI/IBI_Metadata_2019.xlsx")
# IBI_2019 <- IBI_2019 %>% 
#   select(c(PU_Gap_Code, Reach_Name, Event_Date, IBIREGION_, `Slope Adjusted`))
# IBI_2019 <- rename(IBI_2019, Slope_Adjusted = `Slope Adjusted`)
# IBI_2019 <- rename(IBI_2019, IBI_Region = IBIREGION_)
# IBI_2019$Event_Date <- as.Date(IBI_2019$Event_Date)

#### Read in IBI Regions table ####
# TODO What is the source of this file? ARCGIS Random data from you or Brian? It looks like it is from Arc


IBI <- read_csv(file = "Fish_IBI/KaskyCatchments_IBIRegion.csv")

#### IHI ####
data_type <- "IHI"
collumns <- c("text","text","date","text","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric",
              "text","text","text","text","text","text",
              "numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

### IHI
data_filenames <- list.files(path= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/", data_type), pattern=paste0(sampling_year,"(.*)\\.xlsx$"))
data_fullpath = file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/", data_type, data_filenames)
IHI_fulldataset <- do.call("rbind",lapply(data_fullpath, FUN = function(files){readxl::read_xlsx(files, sheet = 2, na = c(".",""), col_types = collumns)}))
view(IHI_fulldataset)


#### Compare IHI and IBI Region Table ####
names(IBI)
# names(IHI)
names(IHI_fulldataset)

IBI <- rename(IBI, PU_Gap_Code = PUGAP_CODE)
IBI <- rename(IBI, IBI_Region = IBIREGION_)

### Join IBI and IHI then reformat any fields for Fish IBI Calculation.

# IBI_MD <- full_join(IBI, IHI)
IBI_MD <- left_join(IHI_fulldataset, IBI)
   
IBI_MD$Slope <- IBI_MD$Gradient*100

IBI_MD <- IBI_MD %>% 
  # filter(lubridate::year(Event_Date) > 2018) %>% 
  select(c(PU_Gap_Code, Reach_Name, Event_Date, IBI_Region, Slope)) %>% 
  rename(Slope_Adjusted = Slope) %>% 
  unique()

# IBI_MD_2020$Reach_Name <- str_to_lower(IBI_MD_2020$Reach_Name)
# IBI_2020$Reach_Name <- str_to_lower(IBI_2020$Reach_Name)

# identical(IBI_2019, IBI_MD_2019)
# 
# list_2019 <- full_join(IBI_MD_2019, IBI_2019, by = c("PU_Gap_Code", "Reach_Name", "Event_Date"))
# list_2019 <- rename(list_2019, IBI_Region.True =IBI_Region.x)
# list_2019 <- rename(list_2019, IBI_Region.Used =IBI_Region.y)
# list_2019 <- rename(list_2019, Slope_Adjusted.True =Slope_Adjusted.x)
# list_2019 <- rename(list_2019, Slope_Adjusted.Used =Slope_Adjusted.y)
# 
# write.csv(list_2019, file= "Fish_IBI/IBI_MetaData_2019.csv")
# 
# head(IBI_MD)

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

# test_fish <- fish_summary %>% 
#   group_by(PU_Gap_Code, Reach_Name) %>% 
#   summarise(fish_count = sum(Fish_Species_Count))

# FSH_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FSH", pattern="*.csv")
# FSH_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FSH",FSH_filenames)
# FSH_fulldataset <- do.call("rbind",lapply(FSH_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
# FSH_dataset <- FSH_fulldataset %>% 
#   select(-c(Gap_Code,Event_Day,Event_Year,Event_Month)) %>% 
#   drop_na()


write.csv(fish_summary, file= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/IBI/FSH_",sampling_year,"_summary.csv"), row.names = F)






