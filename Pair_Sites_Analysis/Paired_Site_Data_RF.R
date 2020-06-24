library(tidyverse)
library(randomForest)

pair.df <- read.csv("~/CREP/Analysis/Paired_Sites/Paired_Sites_AllData.csv", header = T, stringsAsFactors = F)

pair.df$Pair_Number <- as.factor(pair.df$Pair_Number)
pair.df$CRP_Class <- as.factor(pair.df$CRP_Class)
pair.df$L_Buffer_Width <- as.factor(pair.df$L_Buffer_Width)
pair.df$R_Buffer_Width <- as.factor(pair.df$R_Buffer_Width)
pair.df$L_Bare_Bank <- as.factor(pair.df$L_Bare_Bank)
pair.df$R_Bare_Bank <- as.factor(pair.df$R_Bare_Bank)
pair.df$Dominant_Substrate <- as.factor(pair.df$Dominant_Substrate)
pair.df$Subdominant_Substrate <- as.factor(pair.df$Subdominant_Substrate)

pair.df$Site_ID <- paste(pair.df$PU_Gap_Code, lubridate::year(pair.df$Event_Date), sep = "_")
row.names(pair.df) <- pair.df$Site_ID

# Remove factors that should not be treated as predictors. 
paired <- pair.df %>% 
  select(-c(Site_ID, PU_Gap_Code, Reach_Name, Event_Date, Site_Type, PU_Code.x, PU_Code.y, PU_Code.x.x, PU_Code.y.y, HYD_CAT, Gap_Code.x, Gap_Code.y, Gap_Code.x.x, Gap_Code.y.y, Gap_Code, PU_Code))

#Random Forest requires complete cases, no NAs so remove the rows with NAs

paired.complete <- na.omit(paired)

set.seed(2019)

pair.rf <- randomForest(CRP_Class~., data = paired.complete, importance = T)
print(pair.rf)

importance(pair.rf)
varImpPlot(pair.rf, type = 1)

#variable important plot dtermines that 
# W_ Agriculture, WT_DARCYX, SINUOUS, W_Grassland, WT_Urban, WT_Forested_upland, RT_TOTAL_SQME, RT_Forested_wetland, 
# and RT_Grassland are the top 11 predictors. 

paired.fish <- paired.complete %>% 
  select(-c(149:419))

set.seed(2019)

paired.fish.rf <- randomForest(CRP_Class~., data = paired.fish, importance = T)
print(paired.fish.rf)

importance(paired.fish.rf)
varImpPlot(paired.fish.rf, type = 1)
