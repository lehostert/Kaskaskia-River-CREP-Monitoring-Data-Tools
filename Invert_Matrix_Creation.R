library(tidyverse)

#INV <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/INVLab_Combined_blank.csv")
INV <- read.csv("INVLab_test.csv")
INV <- as_tibble(INV)

names(INV)

unique_taxa <- uni


INV_Matrix <- INV %>% group_by(TAXON_NAME)%>% summarise(Total_Abundance= sum(ABUNDANCE), Site_Frequency= n())
##INV_Matrix <- INV %>% group_by(TAXON_NAME)%>% summarise(Total_Abundance= sum(ABUNDANCE), Site_Frequency= n(unique("Reach_Name", "Event_Date")))
INV_Matrix <- INV %>% group_by(TAXON_NAME)%>% summarise(Site_Frequency= n_distinct("Reach_Name", "Event_Date"), Total_Abundance= sum(ABUNDANCE))
INV_Matrix2 <- INV %>% group_by(TAXON_NAME) %>% n_distinct("Reach_Name", "Event_Date")

INV_Matrix4 <- INV %>% group_by(TAXON_NAME) %>% count()
INV_Matrix5 <- unique(INV_Matrix4, "Reach_Name")

class(INV$Reach_Name)


INV_Matrix_stage <- INV %>% group_by(TAXON_NAME, LIFE_STAGE)%>% summarise(Total_Abundance= sum(ABUNDANCE), Site_Frequency= n())
EPT_Matrix <- Awesome



#unique(INVLab_2017[c("Reach_Name","SITE","Event_Date", "REP")])

 