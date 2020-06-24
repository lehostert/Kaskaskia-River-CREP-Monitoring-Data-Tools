library(tidyverse)

## Add in data for all of the Kaskaskia River PU Gaps
catchment_features <- read_csv("C:/Users/lhostert/Documents/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Site_Selection/Data/Kaskaskia_Catchment_Sizes_and_Features.csv")
year <- 2019


## Less Disturbed Sites are selected- At the PU_Gap 24k Watershed level but combine all LD landuse types within a single PU
##  from Watershed scale landuse/geology data. 
# #Additionally combine all LD landuse types within a single PU from Total Watershed scale landuse/geology data. 
# #Select sites with > 50% LD landuse type in both data sets
# #Find the overlap of these two sites lists and randomly select 20 sites from list. 

#Load Landuse Data

# landuse_W <- read_csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/Fish/Data/kasky_landuse_geology_WATERSHED.csv")
# landuse_WT <- read_csv("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/Fish/Data/kasky_landuse_geology_WATERSHED_TOTAL.csv") 

landuse_W <- readxl::read_excel("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/GL_AQ_GAP_Data_2010/VIEW_WATERSHED_minus_ny.xlsx", 
                          sheet = 2, col_types = c("text","text","text","text", "text",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric"
                                                   
                          ))

kasky_landuse_W <- landuse_W %>% 
  filter(PU_CODE == 'kasky')

colnames(kasky_landuse_W)[colnames(kasky_landuse_W)=="PU_CODE"] <- "PU_Code"
colnames(kasky_landuse_W)[colnames(kasky_landuse_W)=="GAP_CODE"] <- "Gap_Code"
colnames(kasky_landuse_W)[colnames(kasky_landuse_W)=="PU_GAP"] <- "PU_Gap_Code"

kasky_landuse_W$W_LU_Disturbed <- kasky_landuse_W$W_LU0P + kasky_landuse_W$W_LU11P + kasky_landuse_W$W_LU12P +
  kasky_landuse_W$W_LU13P + kasky_landuse_W$W_LU14P	+ kasky_landuse_W$W_LU21P + kasky_landuse_W$W_LU22P + kasky_landuse_W$W_LU23P

kasky_landuse_W$W_LU_Undisturbed <- kasky_landuse_W$W_LU30P + kasky_landuse_W$W_LU41P + kasky_landuse_W$W_LU42P + kasky_landuse_W$W_LU43P +
  kasky_landuse_W$W_LU50P + kasky_landuse_W$W_LU61P + kasky_landuse_W$W_LU610P + kasky_landuse_W$W_LU611P + kasky_landuse_W$W_LU612P + 
  kasky_landuse_W$W_LU613P + kasky_landuse_W$W_LU62P + kasky_landuse_W$W_LU70P + kasky_landuse_W$W_LU99P

kasky_landuse_W$W_LU_Total <- kasky_landuse_W$W_LU0P + kasky_landuse_W$W_LU11P + kasky_landuse_W$W_LU12P + kasky_landuse_W$W_LU13P +
  kasky_landuse_W$W_LU14P	+ kasky_landuse_W$W_LU21P + kasky_landuse_W$W_LU22P + kasky_landuse_W$W_LU23P + kasky_landuse_W$W_LU30P +
  kasky_landuse_W$W_LU41P + kasky_landuse_W$W_LU42P + kasky_landuse_W$W_LU43P + kasky_landuse_W$W_LU50P + kasky_landuse_W$W_LU61P + 
  kasky_landuse_W$W_LU610P + kasky_landuse_W$W_LU611P + kasky_landuse_W$W_LU612P + kasky_landuse_W$W_LU613P + kasky_landuse_W$W_LU62P +
  kasky_landuse_W$W_LU70P + kasky_landuse_W$W_LU99P

kasky_landuse_W$W_Undisturbed_Level <- if_else(kasky_landuse_W$W_LU_Undisturbed < 0.25, 'Low',
                                              if_else(kasky_landuse_W$W_LU_Undisturbed >0.25 & kasky_landuse_W$W_LU_Undisturbed <0.505, 'Medium-Low',
                                                      if_else(kasky_landuse_W$W_LU_Undisturbed >0.504 & kasky_landuse_W$W_LU_Undisturbed <0.75, 'Medium-High',
                                                              if_else(kasky_landuse_W$W_LU_Undisturbed >0.75, 'High', 'Undefined')
                                                      )))


#Load Watershed Total
landuse_WT <- readxl::read_excel("//INHS-Bison/ResearchData/Groups/Kaskaskia_CREP/Analysis/GL_AQ_GAP_Data_2010/VIEW_WATERSHED_TOTAL_minus_ny.xlsx", 
                          sheet = 2, col_types = c("text","text","text","text", "text",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric", "numeric",
                                                   "numeric","numeric","numeric", "numeric", "numeric"
                                                   
                          ))

kasky_landuse_WT <- landuse_WT %>% 
  filter(PU_CODE == 'kasky')

colnames(kasky_landuse_WT)[colnames(kasky_landuse_WT)=="PU_CODE"] <- "PU_Code"
colnames(kasky_landuse_WT)[colnames(kasky_landuse_WT)=="GAP_CODE"] <- "Gap_Code"
colnames(kasky_landuse_WT)[colnames(kasky_landuse_WT)=="PU_GAP"] <- "PU_Gap_Code"

kasky_landuse_WT$WT_LU_Disturbed <- kasky_landuse_WT$WT_LU0P + kasky_landuse_WT$WT_LU11P + kasky_landuse_WT$WT_LU12P +
  kasky_landuse_WT$WT_LU13P + kasky_landuse_WT$WT_LU14P	+ kasky_landuse_WT$WT_LU21P + kasky_landuse_WT$WT_LU22P + kasky_landuse_WT$WT_LU23P

kasky_landuse_WT$WT_LU_Undisturbed <- kasky_landuse_WT$WT_LU30P + kasky_landuse_WT$WT_LU41P + kasky_landuse_WT$WT_LU42P + kasky_landuse_WT$WT_LU43P +
  kasky_landuse_WT$WT_LU50P + kasky_landuse_WT$WT_LU61P + kasky_landuse_WT$WT_LU610P + kasky_landuse_WT$WT_LU611P + kasky_landuse_WT$WT_LU612P + 
  kasky_landuse_WT$WT_LU613P + kasky_landuse_WT$WT_LU62P + kasky_landuse_WT$WT_LU70P + kasky_landuse_WT$WT_LU99P

kasky_landuse_WT$WT_LU_Total <- kasky_landuse_WT$WT_LU0P + kasky_landuse_WT$WT_LU11P + kasky_landuse_WT$WT_LU12P + kasky_landuse_WT$WT_LU13P +
  kasky_landuse_WT$WT_LU14P	+ kasky_landuse_WT$WT_LU21P + kasky_landuse_WT$WT_LU22P + kasky_landuse_WT$WT_LU23P + kasky_landuse_WT$WT_LU30P +
  kasky_landuse_WT$WT_LU41P + kasky_landuse_WT$WT_LU42P + kasky_landuse_WT$WT_LU43P + kasky_landuse_WT$WT_LU50P + kasky_landuse_WT$WT_LU61P + 
  kasky_landuse_WT$WT_LU610P + kasky_landuse_WT$WT_LU611P + kasky_landuse_WT$WT_LU612P + kasky_landuse_WT$WT_LU613P + kasky_landuse_WT$WT_LU62P +
  kasky_landuse_WT$WT_LU70P + kasky_landuse_WT$WT_LU99P


kasky_landuse_WT$WT_Undisturbed_Level <- if_else(kasky_landuse_WT$WT_LU_Undisturbed < 0.25, 'Low',
                                              if_else(kasky_landuse_WT$WT_LU_Undisturbed >0.25 & kasky_landuse_WT$WT_LU_Undisturbed <0.505, 'Medium-Low',
                                                      if_else(kasky_landuse_WT$WT_LU_Undisturbed >0.504 & kasky_landuse_WT$WT_LU_Undisturbed <0.75, 'Medium-High',
                                                              if_else(kasky_landuse_WT$WT_LU_Undisturbed >0.75, 'High', 'Undefined')
                                                              )))

  
#If you wanted to select sites based off of just Local Watershed or just Total Watershed you would do so like below. 
 
set.seed(year)

LD_sites_W <- kasky_landuse_W %>% 
  filter(W_Undisturbed_Level == 'Medium-High' | W_Undisturbed_Level == 'High') %>% 
  group_by(W_Undisturbed_Level) %>%
  sample_n(15, replace = TRUE)

LD_sites_WT <- kasky_landuse_WT %>% 
  filter(WT_Undisturbed_Level == 'Medium-High' | WT_Undisturbed_Level == 'High') %>% 
  group_by(WT_Undisturbed_Level) %>%
  sample_n(15, replace = TRUE)

## To select LD sites based off of both Local and Total Watershed Undisturbed Level of 50% or higher. Use the folowing code. 

LD_sites_W_all <- kasky_landuse_W %>% 
  filter(W_Undisturbed_Level == 'Medium-High' | W_Undisturbed_Level == 'High')

LD_sites_WT_all <- kasky_landuse_WT %>% 
  filter(WT_Undisturbed_Level == 'Medium-High' | WT_Undisturbed_Level == 'High')

LD_sites_W_and_WT <- full_join(LD_sites_W_all, LD_sites_WT_all, by = 'PU_Gap_Code') %>% 
                                distinct()

LD_sites_W_and_WT_overlap <- inner_join(LD_sites_W_all, LD_sites_WT_all, by = 'PU_Gap_Code')

set.seed(year)
LD_sites_2 <- LD_sites_W_and_WT %>%  sample_n(30, replace = TRUE) %>% 
  select(PU_Gap_Code, W_LU_Disturbed, W_LU_Undisturbed, WT_LU_Disturbed, WT_LU_Undisturbed, W_Undisturbed_Level, WT_Undisturbed_Level) %>% 
  left_join(catchment_features, by = 'PU_Gap_Code')

set.seed(year)
LD_sites_3 <- LD_sites_W_and_WT_overlap %>%  sample_n(30, replace = TRUE) %>% 
  select(PU_Gap_Code, W_LU_Disturbed, W_LU_Undisturbed, WT_LU_Disturbed, WT_LU_Undisturbed, W_Undisturbed_Level, WT_Undisturbed_Level) %>% 
  left_join(catchment_features, by = 'PU_Gap_Code')

########################

review <- LD_sites_W_and_WT %>%
  select(PU_Gap_Code, W_LU_Disturbed, W_LU_Undisturbed, WT_LU_Disturbed, WT_LU_Undisturbed, W_Undisturbed_Level, WT_Undisturbed_Level)

W_not_in_WT <- anti_join(LD_sites_W_all, LD_sites_WT_all, by = 'PU_Gap_Code')

WT_not_in_W <- anti_join(LD_sites_WT_all, LD_sites_W_all, by = 'PU_Gap_Code')


Find_me <- review %>%
  filter(PU_Gap_Code == 'kasky1295'|PU_Gap_Code == 'kasky1263'|PU_Gap_Code == 'kasky3014'|PU_Gap_Code == 'kasky3955')
  
##Export to .csv

write.csv(LD_sites, file = paste0("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/", year,"_LD_SiteSelection.csv"), row.names = F)

write.csv(LD_sites_2, file = paste0("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/", year,"_LD_SiteSelection_2.csv"), row.names = F)
write.csv(LD_sites_3, file = paste0("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/", year,"_LD_SiteSelection_3.csv"), row.names = F)

###### This below demonstrates that adding the two landuse datasets together then filtering for medium-high to high undisturbed land types
######  on the W and WT scales will result in the same list of 756 sites as the use of the "inner_join" command above. 

# LD_W_and_WT <- full_join(kasky_landuse_W, kasky_landuse_WT, by = 'PU_Gap_Code')%>% 
#   filter(W_Undisturbed_Level == 'Medium-High' | W_Undisturbed_Level == 'High', WT_Undisturbed_Level == 'Medium-High' | WT_Undisturbed_Level == 'High')
# 
# test_fj <- LD_W_and_WT %>% 
#   select(PU_Gap_Code,W_LU_Disturbed, W_LU_Undisturbed, WT_LU_Disturbed, WT_LU_Undisturbed)
# test_ij <- LD_sites_W_and_WT_overlap %>% 
#   select(PU_Gap_Code,W_LU_Disturbed, W_LU_Undisturbed, WT_LU_Disturbed, WT_LU_Undisturbed)
# 
# all_equal(test_fj, test_ij, ignore_col_order = TRUE)
## Result was TRUE 
