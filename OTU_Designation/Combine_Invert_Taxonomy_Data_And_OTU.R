library(tidyverse)
# library(readxl)

## df is a file that contains the combined data from 2013-2014 and 2014-2017 EcoAnalyst Taxonomic
## otu is the list of unique Taxon Names as designated by EcoAnaylst with the 
## sum is the first worksheet from the OTU summary .xlsx file. it lists each unique OTU formed, an 8-letter code, and unique 8-digit serial number
## Eight letter code is first 4 of genus + first 4 of species unless this combination is not unique
## serial numbers is '2019' + a unique 4-digit number because 2019 is the year of establishment of the OTU. 

df <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/INV_LAB/Invert_Abundance.csv", header = T, na = "")
otu <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/Invert/OTU_Designation/CREP_Invert_Species_Matrix_OTU.csv", header = TRUE)
sum <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/Invert/OTU_Designation/OTU_Code_Summary.csv", header = TRUE)
#sum_2 <- readxl("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Invert_Analysis/CREP_OTU_Summary.xlsx", sheet = "OTU Summary")
### Error in readxl(path = "//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Invert_Analysis/CREP_OTU_Summary.xlsx",  : could not find function "readxl"


sum <- sum %>% select(-c(X,OTU_Abundance,Resolution_Level))
otu <- otu %>% select(TAXON_NAME, OTU_Suggestion, OTU_Level)
# df <- df %>% select(-c(X, EA_Dataset)) %>% filter(LIFE_STAGE == "Larvae")
df <- df %>% select(-c(Invert_Abundance_ID)) %>% filter(LIFE_STAGE == "Larvae")

CREP <-full_join(df,otu)
CREP <- full_join(CREP,sum)

CREP_final <- filter(CREP, OTU_Suggestion != "REMOVE") %>% select(c(1:11,43,12:46))
colnames(CREP_final) <- colnames(CREP_final) %>% str_replace_all("[:punct:]"," ") %>% str_to_title() %>% str_replace_all("[:blank:]","_")

names(CREP_final)[names(CREP_final) == 'Pu_Gap_Code'] <- 'PU_Gap_Code'
names(CREP_final)[names(CREP_final) == 'Otu_Suggestion'] <- 'OTU'
names(CREP_final)[names(CREP_final) == 'Rep'] <- 'Replicate'
names(CREP_final)[names(CREP_final) == 'Otu_Sn'] <- 'OTU_SN'
names(CREP_final)[names(CREP_final) == 'Otu_Level'] <- 'OTU_Level'
names(CREP_final)[names(CREP_final) == 'Otu_Code'] <- 'OTU_Code'
names(CREP_final)[names(CREP_final) == 'Itis_Taxon_Sn'] <- 'ITIS_Taxon_SN'

write.csv(CREP_final,"//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/Invert/CREP_Invert_Taxonomy_Data_OTU.csv", na = ".") 