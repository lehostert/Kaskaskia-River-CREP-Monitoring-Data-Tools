##### The following sets of commands intend to take all .csv files from their respective "Data_In" folders and combine them into
## one file for appending to CREP Access Database. Each data types are in comment before script section.

####
library(tidyverse)
library(docstring)
library(jsonlite)

#### Read json config file ####
column_types_simp <- jsonlite::read_json("Combine_Data_IN/column_schemas.json", simplifyVector = TRUE)
column_types_from <- jsonlite::fromJSON("Combine_Data_IN/column_schemas.json")
x <- jsonlite::fromJSON("https://gist.githubusercontent.com/matthewfeickert/7d51c57dfde341e392b2521bc16cdd2d/raw/a83d46860b7fa7e838f24ba18a0b23b08c6840e6/column_schemas.json")
y <- jsonlite::read_json("https://gist.githubusercontent.com/matthewfeickert/7d51c57dfde341e392b2521bc16cdd2d/raw/a83d46860b7fa7e838f24ba18a0b23b08c6840e6/column_schemas.json")


ihi_columns <- column_types$IHI
ihi_columns_2 <- column_types2$IHI

print(paste("The first column data type in the FSH data type is:", fish_columns[1]))


#### Function for binding data ####

bind_data_fun <- function(dat_type, col_type, sampling_year) {
  #' Create dataframe by binding together all of the excel templates for a certain data types and prepare for ingest to DB
  #'
  #' @param dat_type 3 letter code used in template files for the data type you want to combine.
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
    readxl::read_xlsx(files, sheet = 2, na = c(".", ""), col_types = col_type)
  }))
  # write.csv(data_fulldataset, file = paste0(data_in_path, "DB_Ingest/", dat_type,"_", sampling_year, ".csv"), na = "", row.names = F)
}


ihi_columns_orig <- c("text","text","date","skip","skip","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric",
             "text","text","text","text","text","text",
             "numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

y <- bind_data_fun("IHI", column_types2$IHI, 2020)
w <- bind_data_fun("IHI", column_types_simp$IHI, 2020)

## TODO fix the above function so it is working again with the below code then make year generic and separately try to again make the DATA_IN path generic. 
## Function worked with the below code BEFORE data_path_in was created. 

ihi_funct2 <- bind_data(2020, "IHI", c(
  "text", "text", "date", "skip", "skip", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
  "numeric", "numeric", "numeric",
  "text", "text", "text", "text", "text", "text",
  "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
  "numeric", "numeric"
))

ihi_funct2 <- bind_data(2020, "IHI", c(
  "text", "text", "date", "skip", "skip", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
  "numeric", "numeric", "numeric",
  "text", "text", "text", "text", "text", "text",
  "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
  "numeric", "numeric"
))


dsc_funct <- bind_data(2020, "DSC", c("text", "text", "date", "date", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

view(dsc_funct)

### Generic

data_type <- "IHI"
collumns <- c("text","text","date","skip","skip","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric",
              "text","text","text","text","text","text",
              "numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric")


data_filenames <- list.files(path= paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/", data_type), pattern=paste0(sampling_year,"(.*)\\.xlsx$"))	
data_fullpath = file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/", data_type, data_filenames)	
data_fulldataset <- do.call("rbind",lapply(data_fullpath, FUN = function(files){readxl::read_xlsx(files, sheet = 2, na = c(".",""), col_types = collumns)}))
view(data_fulldataset)




### Generic
data_filenames <- list.files(path = paste0(data_in_path, data_type), pattern = paste0(sampling_year, "(.*)\\.xlsx$"))
data_fullpath <- file.path(data_in_path, data_type, data_filenames)
data_fulldataset <- do.call("rbind", lapply(data_fullpath, FUN = function(files) {
  readxl::read_xlsx(files, sheet = 2, na = c(".", ""), col_types = collumns)
}))
view(data_fulldataset)

# data_dataset <- data_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day))

data_fulldataset$Reach_Name <- stringr::str_replace(data_fulldataset$Reach_Name, "copper[:blank:]|copper|Copper|copper[:digit:]", "Copper ") %>%
  stringr::str_replace(data_fulldataset$Reach_Name, "kasky[:blank:]|Kasky[:blank:]", "kasky")

write.csv(data_fulldataset, file = paste0(data_in_path, "DB_Ingest/", data_type, "_", sampling_year, ".csv"), na = "", row.names = F)


### TODO change sheet to sheet 1 in function for FSH and FSH_MD for 2020 datasheets. Templates have been adjusted to makde them sheet 2 for future years.

### Discharge
DSC_filenames <- list.files(path = paste0(data_in_path, "DSC"), pattern = paste0(sampling_year, "(.*)\\.xlsx$"))
DSC_fullpath <- file.path(data_in_path, "DSC", DSC_filenames)
DSC_fulldataset <- do.call("rbind", lapply(DSC_fullpath, FUN = function(files) {
  readxl::read_xlsx(files, sheet = 2, na = c(".", ""))
}))
DSC_dataset <- DSC_fulldataset %>% select(-c(Event_Year, Event_Month, Event_Day))
DSC_dataset$Reach_Name <- stringr::str_replace(DSC_dataset$Reach_Name, "kasky[:blank:]|Kasky[:blank:]", "kasky") %>%
  stringr::str_replace(DSC_dataset$Reach_Name, "copper[:blank:]|Copper[:blank:]", "copper")

write.csv(DSC_dataset, file = paste0(data_in_path, "DB_Ingest/DSC_", sampling_year, ".csv"), na = "", row.names = F)


FSH_fulldataset_xl <- do.call("rbind", lapply(FSH_fullpath, FUN = function(files) {
  readxl::read_xlsx(files,
    sheet = 1, col_types =
      c(
        "text", "text", "text",
        "date", "date",
        "text", "text", "text",
        "numeric", "numeric",
        "text", "text",
        "text", "text", "text", "text", "text", "text",
        "text", "text"
      ),
    na = c(".", "")
  )
}))

### Illinois Habitat Index

IHI_filenames <- list.files(path = paste0(data_in_path, "IHI"), pattern = paste0(sampling_year, "(.*)\\.xlsx$"))
IHI_fullpath <- file.path(data_in_path, "IHI", IHI_filenames)
IHI_fulldataset <- do.call("rbind", lapply(IHI_fullpath, FUN = function(files) {
  read.csv(files, stringsAsFactors = FALSE, na.strings = ".")
}))
IHI_dataset <- IHI_fulldataset %>% select(-c(Ecoregion, Gradient))
IHI_dataset$Reach_Name <- stringr::str_replace(IHI_dataset$Reach_Name, "kasky[:blank:]|Kasky[:blank:]|Kasky", "kasky")
IHI_dataset$Reach_Name <- stringr::str_replace(IHI_dataset$Reach_Name, "copper[:blank:]|copper", "Copper ")
write.csv(IHI_dataset, file = paste0(data_in_path, "DB_Ingest/IHI_", sampling_year, ".csv"), na = "", row.names = F)

## Invertebrate Field Collection

INV_filenames <- list.files(path = paste0(data_in_path, "INV"), pattern = paste0(sampling_year, "(.*)\\.xlsx$"))
INV_fullpath <- file.path(data_in_path, "INV", INV_filenames)
INV_fulldataset <- do.call("rbind", lapply(INV_fullpath, FUN = function(files) {
  read.csv(files, stringsAsFactors = FALSE, na.strings = ".")
}))
INV_dataset <- INV_fulldataset %>% select(-c(Event_Year, Event_Month, Event_Day))
INV_dataset$Reach_Name <- stringr::str_replace(INV_dataset$Reach_Name, "kasky[:blank:]|Kasky[:blank:]|Kasky", "kasky")
INV_dataset$Reach_Name <- stringr::str_replace(INV_dataset$Reach_Name, "copper[:blank:]|copper|Copper|Copper[:blank:]", "Copper ")
write.csv(INV_dataset, file = paste0(data_in_path, "DB_Ingest/INV_", sampling_year, ".csv"), na = "", row.names = F)


## Qualitative Habitat Evaluation Index

QHEI_filenames <- list.files(path = paste0(data_in_path, "QHEI"), pattern = paste0(sampling_year, "(.*)\\.xlsx$"))
QHEI_fullpath <- file.path(data_in_path, "QHEI", QHEI_filenames)
QHEI_fulldataset <- do.call("rbind", lapply(QHEI_fullpath, FUN = function(files) {
  read.csv(files, stringsAsFactors = FALSE, na.strings = ".")
}))
QHEI_dataset <- QHEI_fulldataset %>% select(-c(Event_Year, Event_Month, Event_Day))
QHEI_dataset$Reach_Name <- stringr::str_replace(QHEI_dataset$Reach_Name, "kasky[:blank:]|Kasky[:blank:]|Kasky", "kasky")
QHEI_dataset$Reach_Name <- stringr::str_replace(QHEI_dataset$Reach_Name, "copper[:blank:]|copper|Copper|Copper[:blank:]", "Copper ")
write.csv(QHEI_dataset, file = paste0(data_in_path, "DB_Ingest/QHEI_", sampling_year, ".csv"), na = "", row.names = F)


### Stream Water Chemistry
SWC_filenames <- list.files(path = paste0(data_in_path, "SWC"), pattern = paste0(sampling_year, "(.*)\\.xlsx$"))
SWC_fullpath <- file.path(data_in_path, "SWC", SWC_filenames)
SWC_fulldataset <- do.call("rbind", lapply(SWC_fullpath, FUN = function(files) {
  read.csv(files, stringsAsFactors = FALSE, na.strings = ".")
}))
SWC_dataset <- SWC_fulldataset %>% select(-c(Event_Year, Event_Month, Event_Day))
SWC_dataset$Reach_Name <- stringr::str_replace(SWC_dataset$Reach_Name, "kasky[:blank:]|Kasky[:blank:]|Kasky", "kasky")
SWC_dataset$Reach_Name <- stringr::str_replace(SWC_dataset$Reach_Name, "copper[:blank:]|copper|Copper|Copper[:blank:]", "Copper ")
write.csv(SWC_dataset, file = paste0(data_in_path, "DB_Ingest/SWC_", sampling_year, ".csv"), na = "", row.names = F)
### Template used in 2019 contained error in collumn title "DO_Saturation" is written as "DO%Saturation" which is incompatible with the CREP_Database in Access.
### After writing .csv you must change header before ingesting to DB.
### Template error fixed 1/9/2020 for future data entry.


### Fish Metadata
FMD_filenames <- list.files(path = paste0(data_in_path, "FMD"), pattern = paste0(sampling_year, "(.*)\\.xlsx$"))
FMD_fullpath <- file.path(data_in_path, "FMD", FMD_filenames)
FMD_fulldataset <- do.call("rbind", lapply(FMD_fullpath, FUN = function(files) {
  read.csv(files, stringsAsFactors = FALSE, na.strings = ".")
}))
FMD_dataset <- FMD_fulldataset %>% select(-c(Gap_Code, Event_Year, Event_Month, Event_Day, Data_Entered_By, Data_Entered_Date))
write.csv(FMD_dataset, file = paste0(data_in_path, "DB_Ingest/FMD_", sampling_year, ".csv"), na = "", row.names = F)

### Fish Abundance

FSH_filenames <- list.files(path = paste0(data_in_path, "FSH"), pattern = paste0(sampling_year, "(.*)\\.xlsx$"))
FSH_fullpath <- file.path(data_in_path, "FSH", FSH_filenames)
FSH_fulldataset <- do.call("rbind", lapply(FSH_fullpath, FUN = function(files) {
  read.csv(files, stringsAsFactors = FALSE)
}))
FSH_dataset <- FSH_fulldataset %>%
  select(-c(Gap_Code, Fish_Species_Common, Fish_Species_Scientific, Event_Day, Event_Year, Event_Month)) %>%
  drop_na()
write.csv(FSH_dataset, file = data_in_path, "DB_Ingest/FSH_2018.csv")

#### Fish Abundance EXcel
sampling_year <- 2020
FSH_filenames <- list.files(path = paste0(data_in_path, "FSH"), pattern = paste0(sampling_year, "(.*)\\.xlsx$"))
FSH_fullpath <- file.path(data_in_path, "FSH", FSH_filenames)
FSH_fulldataset_xl <- do.call("rbind", lapply(FSH_fullpath, FUN = function(files) {
  readxl::read_xlsx(files,
    sheet = 1, col_types =
      collumn_types$FSH,
    na = c(".", "")
  )
}))

FSH_fulldataset_xl <- FSH_fulldataset_xl %>%
  drop_na(Species_Code) %>%
  mutate(across(where(is.character), ~ na_if(., "no"))) %>%
  mutate(Release_status = replace_na(Release_status, "alive"))

write.csv(FSH_fulldataset_xl, file = paste0(data_in_path, "DB_Ingest/FSH_", sampling_year, ".csv"), na = "", row.names = F)


df <- starwars %>%
  mutate(across(where(is.character), ~ na_if(., "unknown")))

#   FSH_incomplete <- FSH_fulldataset_xl %>%
#     filter(is.na(Event_Date)) %>%
#     select(PU_Gap_Code, Reach_Name) %>%
#     unique()
#
# fsh_kasky157test_d <- readxl::read_xlsx("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/FSH/FSH_kasky157test_20200821.xlsx",
#                                   sheet = 1,
#                                   col_types = c("text", "text", "text",
#                                       "date", "date",
#                                       "text", "text", "text",
#                                       "numeric", "numeric",
#                                       "text","text",
#                                       "text", "text", "text", "text", "text", "text",
#                                       "text", "text"),
#                                   na = c(".",""))
#
# fsh_kasky1508_d <- readxl::read_xlsx("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/FSH/FSH_Kasky1508_20200922.xlsx",
#                                   sheet = 1,
#                                   col_types = c("text", "text", "text",
#                                                 "date", "date",
#                                                 "text", "text", "text",
#                                                 "numeric", "numeric",
#                                                 "text","text",
#                                                 "text", "text", "text", "text", "text", "text",
#                                                 "text", "text"),
#                                   na = c(".",""))


# FSH_fulldataset_xl$Event_Date <- as.Date(FSH_fulldataset_xl$Event_Date, origin = "1899-12-30")
# FSH_fulldataset_xl$Fish_Date <- as.Date(FSH_fulldataset_xl$Event_Date, origin = "1899-12-30")

# FSH_fulldataset_xl <- do.call("rbind",lapply(FSH_fullpath, FUN = function(files){readxl::read_xlsx(files, sheet = 1)}))

####


### Fish Length Weight

# FLW_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/FLW", pattern=paste0(sampling_year,"(.*)\\.csv$"))
# FLW_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/FLW",FLW_filenames)
# FLW_fulldataset <- do.call("rbind",lapply(FLW_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
# FLW_dataset <- FLW_fulldataset %>% select(-c(Gap_Code,Event_Year,Event_Month,Event_Day,Fish_Species_Common,Fish_Species_Scientific))
# write.csv(FLW_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/FSH_LW_2018.csv")


# head(DSC_fulldataset)
# head(FishMD_dataset)
# head(FishA_dataset)
# head(FishLW_dataset)
# head(IHI_fulldataset)
# head(INV_fulldataset)
# head(QHEI_fulldataset)
# head(SWC_fulldataset)

# lapply(SWC_dataset, class)
