library(tidyverse)


df1 <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/INVLab_Combined.csv", header = TRUE)

df2 <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/INVLab_Combined_blank.csv", header = TRUE)

df3 <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/INVLab_Combined_blank2.csv", header = TRUE)

df1 <- df1 %>% select(-c(X, EA_Dataset))
df2 <- df2 %>% select(-c(X, EA_Dataset))
df3 <- df3 %>% select(-c(X, EA_Dataset))

setdiff(df1, df2)


FLW_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FLW", pattern="*.csv")
FLW_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/FLW",FLW_filenames)
FLW_fulldataset <- do.call("rbind",lapply(FLW_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
FLW_dataset <- FLW_fulldataset %>% select(-c(Gap_Code,Event_Year,Event_Month,Event_Day,Fish_Species_Common,Fish_Species_Scientific))
write.csv(FLW_fulldataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/FISHLW_2018.csv")

library(tidyverse)

# OTU_file_path <- "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_Invert_Species_Matrix_OTU.csv"

otu_summary$OTU_Code <- ifelse(str_detect(otu_summary$OTU_Suggestion, "[:punct:]|[:blank:]"), 
                               paste(toupper(str_sub(otu_summary$OTU_Suggestion, 1, 4)), toupper(str_sub(str_extract(otu_summary$OTU_Suggestion,"(?<=[:punct:]|[:blank:])[a-z]+"),1,4)), sep = ""), 
                               ifelse(str_detect(otu_summary$OTU_Suggestion, "[a-z]{7,}"), 
                                      paste(toupper(str_sub(otu_summary$OTU_Suggestion, 1, 8))),
                                      paste(toupper(str_sub(otu_summary$OTU_Suggestion, 1, 4)), "2019", sep = "")     
                               )
)


otu_summary$OTU_SN <- paste("2019",str_pad(seq.int(from =  1, to = nrow(otu_summary) ),3,pad = "0"), sep = "")

# If there is a space or forward slash then
#   
#   Then first 4 and second 4 pull and concatenate
#  
#   If not then If >8 characters 
#   
#     Then take firrst 8 
#     
#     If not  then first 4 + 2019 concatenate. 


hw <- "Hadley Wickham"

str_sub(hw, 1, 6)
str_sub(hw, end = 6)
str_sub(hw, 8, 14)
str_sub(hw, 8)
str_sub(hw, c(1, 8), c(6, 14))

shopping_list <- c("apples x4", "bagof flour", "butter_margarine", "milk x2", "gum", "Baking Soda")
str_extract(shopping_list, "\\d")
str_extract(shopping_list, "[a-z]{2}")
str_extract(shopping_list, "(?<=[:punct:]|[:blank:])[a-z]+")

str_sub(str_extract(shopping_list, "(?<=[:punct:]|[:blank:])[a-z]+"),1,2)
str_sub(str_extract(otu_summary$OTU_Suggestion,"(?<=[:punct:]|[:blank:])[a-z]+"),1,4)
str_detect(shopping_list, "[a-z]{8,}")
str_sub(str_extract(shopping_list,"(?<=[:punct:]|[:blank:])[a-z]+"),1,2)

nd <- data.frame(table(otu_summary$OTU_Code))
nd[nd$Freq> 1,]
##data.frame[row_number, column_number] = new_value
otu_summary[199,4]="STEMELLA"
otu_summary[198,4]="STEMLINA"

nd[20,2]="You Did It!"

########################### Summary Stats on Carp in CREP samples

library(tidyverse)

fish <- read.csv("C:/Users/lhostert/Documents/Invertebrate_Analysis/Fish_Abundance.csv", header = T, stringsAsFactors = F)
code <- read.csv("C:/Users/lhostert/Documents/Invertebrate_Analysis/Fish_Codes.csv", header = T, stringsAsFactors = F)

fish$Fish_Species_Code<- as.character(fish$Fish_Species_Code)

asian_carp <- fish %>% dplyr::filter(Fish_Species_Code ==  "HYC|BHC|SCP|GRC|GBH")
common_carp <- fish %>% dplyr::filter(Fish_Species_Code, CAP|CGH|GOF)
common_carp <- fish %>% dplyr::filter(Fish_Species_Code == "CAP||CGH||GOF")
common_carp <- fish %>% dplyr::filter(Fish_Species_Code == "CAP")

asian_carp <- dplyr::filter(fish, Fish_Species_Code == HYC|BHC|SCP|GRC|GBH)

names(fish)

##########################
library(tidyverse)
habitat <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/Invert/CREP_Invert_Habitat_Characteristics.csv", header = T, stringsAsFactors = F)


habitat <- habitat %>% select(-c("Habitat_IHI_ID","Habitat_IHI_PU_Gap_Code","Habitat_IHI_Reach_Name","Habitat_IHI_Event_Date",
                                 "Habitat_QHEI_ID","Habitat_QHEI_PU_Gap_Code","Habitat_QHEI_Reach_Name","Habitat_QHEI_Event_Date",
                                 "Water_Chemistry_Field_ID","Water_Chemistry_Field_PU_Gap_Code", "Water_Chemistry_Field_Reach_Name","Water_Chemistry_Field_Event_Date" ))


names(habitat)[names(habitat) == "Invert_Abundance_PU_Gap_Code"]<- "PU_Gap_Code"
names(habitat)[names(habitat) == "Invert_Abundance_Reach_Name"]<- "Reach_Name"
names(habitat)[names(habitat) == "Invert_Abundance_Event_Date"]<- "Event_Date"

write.csv(habitat, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/Invert/CREP_Invert_Habitat_Data.csv", row.names= F, na=".")
