library(tidyverse)

fish <- readr::read_csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/Fish/Output/Fish_Metrics.csv", na = ".")
habitat <- readr::read_csv("~/CREP/Analysis/Paired_Sites/Paired_Site_Characteristics.csv")

habitat$Event_Date <- as.Date(habitat$Habitat_IHI_Event_Date, "%m/%d/%Y")

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
  right_join(paired_fish)

# pair_data <- replace_na(pair_data)
pair_data[is.na(pair_data)] <- 0

pair_metrics <- pair_data %>%
  select(-c("PU_Gap_Code", "Reach_Name", "Site_Type", "Pair_Number", "CRP_Class"))

pair_metrics<- names(pair_data)[6:180]

# metric_list <-colnames(pair_metrics)
# 
# metric_list <- pair_data %>%
#   select(-c("PU_Gap_Code", "Reach_Name", "Site_Type", "Pair_Number", "CRP_Class")) %>%
#   colnames()

for(metric in seq_along(pair_metrics)) {
  
  f <- ggplot(pair_data, aes(CRP_Class, pair_metrics[metric]))
  
  f + geom_boxplot() 
  
  ggsave(paste("boxplot_",pair_metrics[metric],"_by_CRP_Level.pdf"))
  
}


for(metric in seq_along(metric_list)) {

f <- ggplot(pair_data, aes(CRP_Class, metric))

f+ geom_boxplot() 

ggsave(paste("boxplot_",metric_list[metric],"_by_CRP_Level.pdf"))

}



habitat_2_list <- rownames(imp_fish_RF1) 

for (habitat_feature in seq_along(habitat_2_list)) {
  file_out <- paste0("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/Fish/Output/fish_RF1/fish_RF1_PP_", habitat_2_list[habitat_feature], ".pdf")
  pdf(file_out)
  partialPlot(fish_RF1, habitat_2, habitat_2_list[habitat_feature], main = paste("Partial Dependancy Plot on", habitat_2_list[habitat_feature]), xlab = paste(habitat_2_list[habitat_feature]))
  dev.off()
}

ggplot(pair_data, aes(RICHNESS)) + geom_histogram(binwidth = 2)

# f <- ggplot(pair_data, aes(CRP_Class,RICHNESS))
# 
# f+ geom_boxplot()
# 
# ggsave("botplot_test.pdf")