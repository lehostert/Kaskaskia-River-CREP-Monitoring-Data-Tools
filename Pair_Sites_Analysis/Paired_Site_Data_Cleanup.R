library(tidyverse)

fish <- readr::read_csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/Fish/Output/Fish_Metrics.csv", na = ".")
habitat <- readr::read_csv("~/CREP/Analysis/Paired_Sites/Paired_Site_Characteristics.csv")

habitat$Event_Date <- as.Date(habitat$Habitat_IHI_Event_Date, "%m/%d/%Y")
habitat <- habitat[,c(1:5,57,6:56)]

paired_site_list <- habitat %>%
  select(PU_Gap_Code, Reach_Name, Site_Type, Pair_Number, CRP_Class, Event_Date)

fish$Reach_Name <- as.character(stringr::str_extract_all(fish$Site_ID, "[:alnum:]+(?=\\_)"))

fish$Event_Date <- stringr::str_extract_all(fish$Site_ID, "(?<=\\_)[:digit:]+")

fish$Event_Date <- as.Date(as.character(fish$Event_Date), "%Y%m%d")

# fish$Event_Date <- as.Date(as.character(stringr::str_extract_all(fish$Site_ID, "(?<=\\_)[:digit:]+")))

paired_fish<- paired_site_list %>%
  left_join(fish, by = c('Reach_Name', 'Event_Date'))


pair_data <- habitat %>%
  select(-c(Visual_Water_Clarity, Chloride, Chloride_QU, Habitat_IHI_Event_Date, Habitat_QHEI_Event_Date, Water_Chemistry_Field_Event_Date)) %>%
  right_join(paired_fish, c("PU_Gap_Code", "Reach_Name", "Site_Type", "Pair_Number", "CRP_Class", "Event_Date"))

# replace 
# pair_data <- replace_na(pair_data)
pair_data[is.na(pair_data)] <- 0

#Remove Site_ID it is inocmplete and unncessary
pair_data <- pair_data %>% select(-c(Site_ID))

#Select only continuous variables to make plots with.
pair_metrics<- names(pair_data[,c(7:16,23:179)])

# Create boxplot for all metrics in pair_data. 

# Like this but for all metrics, at once. 
# f <- ggplot(pair_data, aes(CRP_Class,RICHNESS))
# f + geom_boxplot()
# ggsave("botplot_test.pdf")
# 
# box <- ggplot(data = pair_data) + geom_boxplot(mapping = aes(CRP_Class, INDIVIDUALS))
# box
# ggsave(box ,file = "box_test.pdf")

#

for(metric in seq_along(pair_metrics)) {
  
  box <- ggplot(data = pair_data) + geom_boxplot(mapping = aes(x = CRP_Class, y = get(pair_metrics[metric])))
  box
  ggsave(box, file = paste0(pair_metrics[metric],"_by_CRP_Level_boxplot.pdf"))
  
  histogram <- ggplot(pair_data, aes(get(pair_metrics[metric]))) + geom_histogram(binwidth = 2)
  ggsave(histogram, file = paste0(pair_metrics[metric],"_histogram.pdf"))
  
}

# The above solution is based on the get funtion. 
# It takes a character string as input and looks if there is a variable with the same name. If there is, it gives this variable.

# 




# leveneTest(, pair_data)
#  repeated measures anova()