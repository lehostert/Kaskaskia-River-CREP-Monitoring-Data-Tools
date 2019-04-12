library(car)

##Normality
PD_low <- brief_pair_data %>% 
  filter(CRP_Class == "low")
PD_high <- brief_pair_data %>% 
  filter(CRP_Class == "high")
#Low
shapiro.test(PD_low$IHI_Score)
shapiro.test(PD_low$QHEI_Score)
shapiro.test(PD_low$DO)
shapiro.test(PD_low$Turbidity)
shapiro.test(PD_low$Nitrate)
shapiro.test(PD_low$Ammonia)
shapiro.test(PD_low$Orthophosphate)
shapiro.test(PD_low$RICHNESS)
shapiro.test(PD_low$DIVERSITY)
shapiro.test(PD_low$TOLRPIND)
shapiro.test(PD_low$INTOLPIND)
shapiro.test(PD_low$SENSPIND)

# High
shapiro.test(PD_high$IHI_Score)
shapiro.test(PD_high$QHEI_Score)
shapiro.test(PD_high$DO)
shapiro.test(PD_high$Turbidity)
shapiro.test(PD_high$Nitrate)
shapiro.test(PD_high$Ammonia)
shapiro.test(PD_high$Orthophosphate)
shapiro.test(PD_high$RICHNESS)
shapiro.test(PD_high$DIVERSITY)
shapiro.test(PD_high$TOLRPIND)
shapiro.test(PD_high$INTOLPIND)
shapiro.test(PD_high$SENSPIND)

# Levene Test- Homogeneity of Varience
# brief_pair_data$Year <- factor(brief_pair_data$Year)
brief_pair_data$CRP_Class <- factor(brief_pair_data$CRP_Class)

leveneTest(IHI_Score ~ CRP_Class, data = brief_pair_data)
leveneTest(QHEI_Score ~ CRP_Class, data = brief_pair_data)
leveneTest(DO ~ CRP_Class, data = brief_pair_data)
leveneTest(Turbidity ~ CRP_Class, data = brief_pair_data)
leveneTest(Nitrate ~ CRP_Class, data = brief_pair_data)
leveneTest(Ammonia~ CRP_Class, data = brief_pair_data)
leveneTest(Orthophosphate ~ CRP_Class, data = brief_pair_data)
leveneTest(RICHNESS ~ CRP_Class, data = brief_pair_data)
leveneTest(DIVERSITY ~ CRP_Class, data = brief_pair_data)
leveneTest(TOLRPIND ~ CRP_Class, data = brief_pair_data)
leveneTest(INTOLPIND ~ CRP_Class, data = brief_pair_data)
leveneTest(SENSPIND ~ CRP_Class, data = brief_pair_data)
