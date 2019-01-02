library(tidyverse)


INVLab_2017 <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/INV_Lab/EcoAnalysts_MacroinvertebrateTaxonomy_2014-2017.csv", header = TRUE)
names(INVLab_2017)

names(INVLab_2017)[names(INVLab_2017) == 'DATE_COL'] <- 'Event_Date'
names(INVLab_2017)[names(INVLab_2017) == 'LIFE.STAGE'] <- 'LIFE_STAGE'
names(INVLab_2017)[names(INVLab_2017) == 'X._IN_RC'] <- 'NUM_IN_RC'
names(INVLab_2017)[names(INVLab_2017) == 'LR_TAXA'] <- 'LARGE_RARE_TAXA'
names(INVLab_2017)[names(INVLab_2017) == 'LAB_COM'] <- 'LAB_COMMENTS'
names(INVLab_2017)[names(INVLab_2017) == 'SERIAL'] <- 'ITIS_TAXON_SN'


INVLab_2013 <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/INV_Lab/EcoAnalysts_MacroinvertebrateTaxonomy_2013-2014.csv", header = TRUE, na = ".")
names(INVLab_2013)

names(INVLab_2013)[names(INVLab_2013) == 'ARC'] <- 'PU_Gap_Code'
names(INVLab_2013)[names(INVLab_2013) == 'TYPE'] <- 'Site_Type'
names(INVLab_2013)[names(INVLab_2013) == 'DATE_COL'] <- 'Event_Date'
names(INVLab_2013)[names(INVLab_2013) == 'LIFE.STAGE'] <- 'LIFE_STAGE'
names(INVLab_2013)[names(INVLab_2013) == 'X._IN_RC'] <- 'NUM_IN_RC'
names(INVLab_2013)[names(INVLab_2013) == 'LAB_COM'] <- 'LAB_COMMENTS'
names(INVLab_2013)[names(INVLab_2013) == 'SERIAL'] <- 'ITIS_TAXON_SN'

INVLab_2013_modern <- gather(INVLab_2013, 'LARVAE', 'PUPAE','ADULTS', key = 'LIFE_STAGE', value = "ABUNDANCE", na.rm = TRUE)

###Check to see if there are any sites with no PU Gap Code. Originally there should ahve been 1 from "trib to..." but it was comingup as 0
### Changed blank to "." and additional NAs verify this might help with consolidation. 

INVLab_2013_modern_NA<- INVLab_2013_modern[is.na(INVLab_2013_modern$PU_Gap_Code),] %>%
  distinct(SITE, Reach_Name, Event_Date, .keep_all = TRUE)

INVLab_2017_test<- INVLab_2017


###

 

###


names(INVLab_2013_modern)
names(INVLab_2017)

c13 <-lapply(INVLab_2013_modern, class)
c17 <-lapply(INVLab_2017, class)

INVLab_2017$LAB_TAXON <- as.factor(INVLab_2017$LAB_TAXON)
INVLab_2017$LARGE_RARE_TAXA <- as.character(INVLab_2017$LARGE_RARE_TAXA)
INVLab_2017$LAB_COMMENTS<- as.character(INVLab_2017$LAB_COMMENTS)
INVLab_2017$SUBTRIBE<- as.factor(INVLab_2017$SUBTRIBE)
INVLab_2017$SUBSPECIES<- as.factor(INVLab_2017$SUBSPECIES)
INVLab_2017$ADDITIONS<- as.character(INVLab_2017$ADDITIONS)
INVLab_2017$ITIS_TAXON_SN<- as.character(INVLab_2017$ITIS_TAXON_SN)
INVLab_2017$NUM_IN_RC <- as.integer(INVLab_2017$NUM_IN_RC)

INVLab_2013_modern$AGGREGATED <- as.integer(INVLab_2013_modern$AGGREGATED)
INVLab_2013_modern$LAB_COMMENTS<- as.character(INVLab_2013_modern$LAB_COMMENTS)
INVLab_2013_modern$ITIS_TAXON_SN<- as.character(INVLab_2013_modern$ITIS_TAXON_SN)
INVLab_2013_modern$LIFE_STAGE <- as.factor(INVLab_2013_modern$LIFE_STAGE)
INVLab_2013_modern$ADDITIONS<- as.character(INVLab_2013_modern$ADDITIONS)
INVLab_2013_modern$NUM_IN_RC <- as.integer(INVLab_2013_modern$NUM_IN_RC)

UniqueSitesList_2017 <- read.csv("UniqueSitesList_2017.csv", header = TRUE)
names(UniqueSitesList_2017)
names(INVLab_2017)

INVLab_2017_wGap <- left_join(INVLab_2017, UniqueSitesList_2017)
INVLab_2017_wGap <- INVLab_2017_wGap[c(42,1,2,4,3,43,5:41)]

## UNique Fields INVLab_2013_modern <- -C("TOTAL","X.SUB","") "SITE", "PU_GAP_Code", "Site_Type", "COUNT", 
## Unique Fields INVLab_2017 <- "REP", "LR_TAX", 

cbind(lapply(INVLab_2013_modern, class),lapply(INVLab_2017_wGap, class))

INVLab_2017_wGap$Event_Date <- as.character.Date(INVLab_2017_wGap$Event_Date)
INVLab_2013_modern$Event_Date <- as.character.Date(INVLab_2013_modern$Event_Date)
INVLab_2017_wGap$DISTINCT <- as.factor(INVLab_2017_wGap$DISTINCT)
INVLab_2013_modern$DISTINCT <- as.factor(INVLab_2013_modern$DISTINCT)
INVLab_2017_wGap$AGGREGATED <- as.factor(INVLab_2017_wGap$AGGREGATED)
INVLab_2013_modern$AGGREGATED <- as.factor(INVLab_2013_modern$AGGREGATED)
INVLab_2017_wGap$LAB_COMMENTS <- as.character(INVLab_2017_wGap$LAB_COMMENTS)
INVLab_2013_modern$LAB_COMMENTS<- as.character(INVLab_2013_modern$LAB_COMMENTS)
INVLab_2017_wGap$KINGDOM <- as.factor(INVLab_2017_wGap$KINGDOM)
INVLab_2013_modern$KINGDOM<- as.factor(INVLab_2013_modern$KINGDOM)
INVLab_2017_wGap$ADDITIONS <- as.character(INVLab_2017_wGap$ADDITIONS)
INVLab_2013_modern$ADDITIONS<- as.character(INVLab_2013_modern$ADDITIONS)
INVLab_2017_wGap$LIFE_STAGE <- as.factor(INVLab_2017_wGap$LIFE_STAGE)
INVLab_2013_modern$LIFE_STAGE<- as.factor(INVLab_2013_modern$LIFE_STAGE)
INVLab_2017_wGap$ABUNDANCE <- as.integer(INVLab_2017_wGap$ABUNDANCE)
INVLab_2013_modern$ABUNDANCE<- as.integer(INVLab_2013_modern$ABUNDANCE)

INVLab_Combined<- INVLab_2013_modern %>% select(-c(Site_Type, TOTAL, X._SUB)) %>%
  bind_rows(INVLab_2017_wGap, .id = 'EA_Dataset')

write.csv(INVLab_Combined, file= "INVLab_Combined.csv")


UNQ_17<- unique(INVLab_2017[c("Reach_Name","SITE","Event_Date", "REP")])
write.csv(UNQ_17, file= "UniqueSites_2017.csv")




##############################################


Sites_2017 <- read.csv("Events_2017.csv", header = TRUE, stringsAsFactors = FALSE)
names(Sites_2017)[names(Sites_2017) == 'PU_Gap_Code'] <- 'Gap_Code'
names(Sites_2017)[names(Sites_2017) == 'ReachName'] <- 'Reach_Name'
names(Sites_2017)[names(Sites_2017) == 'Date'] <- 'Event_Date'
Sites_2017$Purpose <- as.factor(Sites_2017$Purpose)


Sites_2017$PU_Gap_Code<- paste("kasky",Sites_2017$Gap_Code,sep = '')



# Table1_Combo <- Sites_2017 %>%
#   select(Gap_Code, Event_Date, Reach_Name) %>%
  
INVLab_Combined_NOPU<- INVLab_Combined[is.na(INVLab_Combined$PU_Gap_Code),] %>%
 distinct(SITE, Reach_Name, Event_Date, .keep_all = TRUE)
write.csv(INVLab_Combined_NOPU, file= "INVLab_Combined_NO_PU_GAP.csv")
write.csv(INVLab_Combined, file= "INVLab_Combined.csv")

####### Work on replacing NA's in INVLAB_combined with the available information from the "INVLab_Combined_PU_GAP.csv". 
####### This will help match up the sites_2017 with INV_Lab_Combined later. 



INVLab_Table1 <- select(Sites_2017, Gap_Code, Event_Date, Reach_Name) %>%
  right_join( INVLab_2017, by= c("Reach_Name","Event_Date"))

INV_NoMatch1 <- INVLab_Table1[is.na(INVLab_Table1$Gap_Code),]
INV_NoMatch1_Unique <- distinct(INV_NoMatch1, Event_Date, Reach_Name, .keep_all = TRUE)


INVLab_Table2 <- Sites_2017 %>%
  select(Gap_Code, Event_Date, Reach_Name) %>%
  full_join(INVLab_2017, by= c("Reach_Name","Event_Date"))

INV_NoMatch2 <- INVLab_Table2[is.na(INVLab_Table2$SAMPTYPE),]
INV_NoMatch2_Unique <- distinct(INV_NoMatch2, Gap_Code, Event_Date, .keep_all = TRUE)

INV_NoMatch2_unique <- INV_NoMatch2 %>% 
  distinct( Event_Date, Reach_Name, .keep_all = TRUE)
  


INV_NoMatch3_unique <- INV_NoMatch2 %>%
  left_join(INVLab_2017, by= c("Reach_Name","Event_Date"))

#### On going error. 5001 was sampled 7/21/15 aacordind to data sheets. incorrect in DB Table. 

## Invertebrate Lab Data

INV_filenames <- list.files(path="//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/INV", pattern="*.csv")
INV_fullpath=file.path("//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/INV",INV_filenames)
INV_fulldataset <- do.call("rbind",lapply(INV_fullpath, FUN = function(files){read.csv(files, stringsAsFactors = FALSE)}))
INV_dataset <- INV_fulldataset %>% select(-c(Event_Year,Event_Month, Event_Day))
write.csv(INV_dataset, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/INV_2018.csv")
