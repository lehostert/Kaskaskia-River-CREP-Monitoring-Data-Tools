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
# The function below is based on the get funtion. 
# It takes a character string as input and looks if there is a variable with the same name. If there is, it gives this variable.

for(metric in seq_along(pair_metrics)) {
  
  box <- ggplot(data = pair_data) + geom_boxplot(mapping = aes(x = CRP_Class, y = get(pair_metrics[metric])))
  box
  ggsave(box, file = paste0(pair_metrics[metric],"_by_CRP_Level_boxplot.pdf"))
  
  histogram <- ggplot(pair_data, aes(get(pair_metrics[metric]))) + geom_histogram(binwidth = 2)
  ggsave(histogram, file = paste0(pair_metrics[metric],"_histogram.pdf"))
  
}

# BELOW Error plot needs work

# error <- ggplot(data = pair_data, aes(x = lubridate::year(Event_Date), y = INDIVIDUALS, color = CRP_Class, ymin = fit-se, ymax = fit+se)) + 
#   geom_errorbar()
# 
# error

pair_data$Year <- lubridate::year(pair_data$Event_Date)
brief_pair_data <- pair_data %>% 
  select(c(Reach_Name, Site_Type, Pair_Number, CRP_Class, Year, IHI_Score, 
           QHEI_Score, DO, Turbidity, Nitrate, Ammonia, Orthophosphate, TOLRPIND, INTOLPIND, SENSPIND))

brief_pair_data[12,7]= NA

#Normality
PD_2016_low <- brief_pair_data %>% 
  filter(Year == 2016, CRP_Class == "low")
PD_2017_low <- brief_pair_data %>% 
  filter(Year == 2017, CRP_Class == "low")
PD_2018_low <- brief_pair_data %>% 
  filter(Year == 2018, CRP_Class == "low")
PD_2016_high <- brief_pair_data %>% 
  filter(Year == 2016, CRP_Class == "high")
PD_2017_high <- brief_pair_data %>% 
  filter(Year == 2017, CRP_Class == "high")
PD_2018_high <- brief_pair_data %>% 
  filter(Year == 2018, CRP_Class == "high")
#Low
shapiro.test(PD_2016_low$IHI_Score)
shapiro.test(PD_2017_low$IHI_Score)
shapiro.test(PD_2018_low$IHI_Score)
shapiro.test(PD_2016_low$QHEI_Score)
shapiro.test(PD_2017_low$QHEI_Score)
shapiro.test(PD_2018_low$QHEI_Score)
shapiro.test(PD_2016_low$DO)
shapiro.test(PD_2017_low$DO)
shapiro.test(PD_2018_low$DO)
shapiro.test(PD_2016_low$Turbidity)
shapiro.test(PD_2017_low$Turbidity)
shapiro.test(PD_2018_low$Turbidity)
shapiro.test(PD_2016_low$Nitrate)
shapiro.test(PD_2017_low$Nitrate)
shapiro.test(PD_2018_low$Nitrate)
shapiro.test(PD_2016_low$Ammonia)
shapiro.test(PD_2017_low$Ammonia)
shapiro.test(PD_2018_low$Ammonia)
shapiro.test(PD_2016_low$Orthophosphate)
shapiro.test(PD_2017_low$Orthophosphate)
shapiro.test(PD_2018_low$Orthophosphate)
shapiro.test(PD_2016_low$TOLRPIND)
shapiro.test(PD_2017_low$TOLRPIND)
shapiro.test(PD_2018_low$TOLRPIND)
shapiro.test(PD_2016_low$INTOLPIND)
shapiro.test(PD_2017_low$INTOLPIND)
shapiro.test(PD_2018_low$INTOLPIND)
shapiro.test(PD_2016_low$SENSPIND)
shapiro.test(PD_2017_low$SENSPIND)
shapiro.test(PD_2018_low$SENSPIND)

# High
shapiro.test(PD_2016_high$IHI_Score)
shapiro.test(PD_2017_high$IHI_Score)
shapiro.test(PD_2018_high$IHI_Score)
shapiro.test(PD_2016_high$QHEI_Score)
shapiro.test(PD_2017_high$QHEI_Score)
shapiro.test(PD_2018_high$QHEI_Score)
shapiro.test(PD_2016_high$DO)
shapiro.test(PD_2017_high$DO)
shapiro.test(PD_2018_high$DO)
shapiro.test(PD_2016_high$Turbidity)
shapiro.test(PD_2017_high$Turbidity)
shapiro.test(PD_2018_high$Turbidity)
shapiro.test(PD_2016_high$Nitrate)
shapiro.test(PD_2017_high$Nitrate)
shapiro.test(PD_2018_high$Nitrate)
shapiro.test(PD_2016_high$Ammonia)
shapiro.test(PD_2017_high$Ammonia)
shapiro.test(PD_2018_high$Ammonia)
shapiro.test(PD_2016_high$Orthophosphate)
shapiro.test(PD_2017_high$Orthophosphate)
shapiro.test(PD_2018_high$Orthophosphate)
shapiro.test(PD_2016_high$TOLRPIND)
shapiro.test(PD_2017_high$TOLRPIND)
shapiro.test(PD_2018_high$TOLRPIND)
shapiro.test(PD_2016_high$INTOLPIND)
shapiro.test(PD_2017_high$INTOLPIND)
shapiro.test(PD_2018_high$INTOLPIND)
shapiro.test(PD_2016_high$SENSPIND)
shapiro.test(PD_2017_high$SENSPIND)
shapiro.test(PD_2018_high$SENSPIND)

# Levene Test- Homogeneity of Varience
library(car)

brief_pair_data$Year <- factor(brief_pair_data$Year)
  
leveneTest(IHI_Score ~ CRP_Class*Year, data = brief_pair_data)
leveneTest(QHEI_Score ~ CRP_Class*Year, data = brief_pair_data)
leveneTest(DO ~ CRP_Class*Year, data = brief_pair_data)
leveneTest(Turbidity ~ CRP_Class*Year, data = brief_pair_data)
leveneTest(Orthophosphate ~ CRP_Class*Year, data = brief_pair_data)
leveneTest(INTOLPIND ~ CRP_Class*Year, data = brief_pair_data)

# Bartlett Test- Homogeneity of Varience

bartlett.test(IHI_Score ~ interaction(CRP_Class, Year), data = brief_pair_data)
bartlett.test(QHEI_Score ~ interaction(CRP_Class, Year), data = brief_pair_data)
bartlett.test(DO ~ interaction(CRP_Class, Year), data = brief_pair_data)
bartlett.test(Turbidity ~ interaction(CRP_Class, Year), data = brief_pair_data)
bartlett.test(Orthophosphate ~ interaction(CRP_Class, Year), data = brief_pair_data)
bartlett.test(INTOLPIND ~ interaction(CRP_Class, Year), data = brief_pair_data)

# Mauchly Test for Sphericity
# For this to work you must reorganize data into a matrix with YEar as columm and site as row
# I think the way to do this is as follows
### Please see https://biostats.w.uib.no/test-for-sphericity-mauchly-test/ for more details.
#IHI matrix

PS_IHI_matrix <- brief_pair_data %>% 
  select(c(Reach_Name, IHI_Score, Year)) %>% 
  spread(Year, IHI_Score)
## This takes values for sites in slightly different locations and adds them to their counterpart.
## only effects kasky1517A & kasky15717B  and  kasky761 & kasky761B
PS_IHI_matrix[5,4]= 22
PS_IHI_matrix[14,4]= 8
PS_IHI_matrix[-c(4,15),]

IHI_model <- lm(PS_IHI_matrix ~ 1)
IHI_design <- factor(c(2016,2017,2018))

options(contrasts=c("contr.sum", "contr.poly"))
results<-Anova(IHI_model, idata=data.frame(IHI_design), idesign=~IHI_design, type="III")
summary(results, multivariate=F)

#### Mixed ANOVA 
#IHI
aov_IHI_class_year <- aov(IHI_Score ~ CRP_Class*Year + Error(Reach_Name/Year), data = brief_pair_data)
summary(aov_IHI_class_year)
# model.tables(aov_IHI_class_year)

#QHEI
aov_QHEI_class_year <- aov(QHEI_Score ~ CRP_Class*Year + Error(Reach_Name/Year), data = brief_pair_data)
summary(aov_QHEI_class_year)

#DO
aov_DO_class_year <- aov(DO ~ CRP_Class*Year + Error(Reach_Name/Year), data = brief_pair_data)
summary(aov_DO_class_year)

#Turbidity
aov_Turbidity_class_year <- aov(Turbidity ~ CRP_Class*Year + Error(Reach_Name/Year), data = brief_pair_data)
summary(aov_Turbidity_class_year)

#Nitrate
aov_Nitrate_class_year <- aov(Nitrate ~ CRP_Class*Year + Error(Reach_Name/Year), data = brief_pair_data)
summary(aov_Nitrate_class_year)



