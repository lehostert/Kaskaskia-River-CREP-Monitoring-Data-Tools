library(arsenal)
library(testthat)
library(tidyverse)

INVLab_2017 <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/INV_Lab/EcoAnalysts_MacroinvertebrateTaxonomy_2014-2017_reconcile_names.csv", header = TRUE, stringsAsFactors = F)
names(INVLab_2017)

names(INVLab_2017)[names(INVLab_2017) == 'SITE.1'] <- 'Reach_Name'
names(INVLab_2017)[names(INVLab_2017) == 'DATE_COL'] <- 'Event_Date'
names(INVLab_2017)[names(INVLab_2017) == 'LIFE.STAGE'] <- 'LIFE_STAGE'
names(INVLab_2017)[names(INVLab_2017) == 'X._IN_RC'] <- 'NUM_IN_RC'
names(INVLab_2017)[names(INVLab_2017) == 'LR_TAXA'] <- 'LARGE_RARE_TAXA'
names(INVLab_2017)[names(INVLab_2017) == 'LAB_COM'] <- 'LAB_COMMENTS'
names(INVLab_2017)[names(INVLab_2017) == 'SERIAL'] <- 'ITIS_TAXON_SN'

INVLab_2017$Reach_Name <- ifelse(str_detect(INVLab_2017$Reach_Name, "^[:digit:]"),
                                 paste("kasky",INVLab_2017$Reach_Name, sep = ""),
                                 paste(INVLab_2017$Reach_Name)
)


INVLab_2013 <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/INV_Lab/EcoAnalysts_MacroinvertebrateTaxonomy_2013-2014_reconcile_names.csv", header = TRUE, na = ".", stringsAsFactors = F)
names(INVLab_2013)

names(INVLab_2013)[names(INVLab_2013) == 'ARC'] <- 'PU_Gap_Code'
names(INVLab_2013)[names(INVLab_2013) == 'TYPE'] <- 'Site_Type'
names(INVLab_2013)[names(INVLab_2013) == 'DATE_COL'] <- 'Event_Date'
names(INVLab_2013)[names(INVLab_2013) == 'LIFE.STAGE'] <- 'LIFE_STAGE'
names(INVLab_2013)[names(INVLab_2013) == 'X._IN_RC'] <- 'NUM_IN_RC'
names(INVLab_2013)[names(INVLab_2013) == 'LAB_COM'] <- 'LAB_COMMENTS'
names(INVLab_2013)[names(INVLab_2013) == 'SERIAL'] <- 'ITIS_TAXON_SN'

INVLab_2013$Reach_Name <- ifelse(str_detect(INVLab_2013$SITE.1, "^[:digit:]"),
                                 paste("kasky",INVLab_2013$SITE.1, sep = ""),
                                 paste(INVLab_2013$SITE.1)
)

##Transform the 2013 data set to match the Abundance collumn of the 2017 dataset
names(INVLab_2013)[names(INVLab_2013) == 'LARVAE'] <- 'Larvae'
names(INVLab_2013)[names(INVLab_2013) == 'PUPAE'] <- 'Pupae'
names(INVLab_2013)[names(INVLab_2013) == 'ADULTS'] <- 'Adults'
INVLab_2013 <- gather(INVLab_2013, 'Larvae', 'Pupae','Adults', key = 'LIFE_STAGE', value = "ABUNDANCE", na.rm = TRUE)

INVLab_2013 <- INVLab_2013 %>% select(c("PU_Gap_Code","Reach_Name","Event_Date",5,7:12,44,45,15:42))

####Give each of the sites a PU_Gap_Code in INV_Lab_2017 df. 

## Create a list of the unique sites from 2014-2017 list
# UNQ_17<- unique(INVLab_2017[c("Reach_Name","SITE","Event_Date", "REP")])
# write.csv(UNQ_17, file= "UniqueSites_2017.csv")
## From resulting file by hand fill in the information for PU Gap Code and Count from phyical datasheets save as "UniqueSitesList_2017.csv"

UniqueSitesList_2017 <- read.csv("~/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/UniqueSitesList_2017.csv", header = TRUE, stringsAsFactors = F)
names(UniqueSitesList_2017)

INVLab_2017_wGap <- left_join(INVLab_2017, UniqueSitesList_2017)
names(INVLab_2017_wGap)
INVLab_2017_wGap <- INVLab_2017_wGap[c(42,2,4,3,43,5:41)]


names(INVLab_2013)
names(INVLab_2017_wGap)


###Change some of the class that do not agree
INVLab_2017_wGap$Event_Date <- as.character.Date(INVLab_2017_wGap$Event_Date)
INVLab_2013$Event_Date <- as.character.Date(INVLab_2013$Event_Date)
INVLab_2017_wGap$SUBGENUS <- as.factor(INVLab_2017_wGap$SUBGENUS)
INVLab_2013$SUBGENUS <- as.factor(INVLab_2013$SUBGENUS)
INVLab_2017_wGap$LIFE_STAGE <- as.factor(INVLab_2017_wGap$LIFE_STAGE)
INVLab_2013$LIFE_STAGE<- as.factor(INVLab_2013$LIFE_STAGE)

INVLab_2013$LAB_TAXON<- as.character(INVLab_2013$LAB_TAXON)
INVLab_2017_wGap$LAB_TAXON<- as.character(INVLab_2017_wGap$LAB_TAXON)
INVLab_2013$AGGREGATED <- as.integer(INVLab_2013$AGGREGATED)
INVLab_2013$ITIS_TAXON_SN<- as.character(INVLab_2013$ITIS_TAXON_SN)
INVLab_2017_wGap$ITIS_TAXON_SN<- as.character(INVLab_2017_wGap$ITIS_TAXON_SN)

### Combine files

INVLab_Combined<- INVLab_2017_wGap %>%
  bind_rows(INVLab_2013, .id = 'EA_Dataset') 

###Ship it!

write.csv(INVLab_Combined, file= "//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/INV_LAB/INVLab_Combined_Edited_Names.csv", na = "")

# byhand <- read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/INVLab_Combined_Update.csv", header = TRUE)
# target <-read.csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/INV_LAB/INVLab_Combined_Update_reconcile_names.csv", header = TRUE)