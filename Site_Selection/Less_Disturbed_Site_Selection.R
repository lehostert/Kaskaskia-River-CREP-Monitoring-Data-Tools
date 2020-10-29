library(tidyverse)

network_prefix <- "//INHS-Bison" #Lauren's Desktop PC
# network_prefix <- "/Volumes" #Lauren's Mac Laptop

## Add in data for all of the Kaskaskia River PU Gaps
catchment_features <- read_csv("C:/Users/lhostert/Documents/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Site_Selection/Data/Kaskaskia_Catchment_Sizes_and_Features.csv")
extra_features <- read_csv(file = paste0(network_prefix,"/ResearchData/Groups/Kaskaskia_CREP/Analysis/Fish/Data/kasky_landuse_geology_metrics_revised.csv"))

extra_catchment_features <- extra_features %>% select("PU_Gap_Code", "W_SLOPE", "WT_SLOPE", "GRADIENT", "W_CREPCRP_Percent","W_HEL_Percent")
catchment_features <- catchment_features %>% left_join(extra_catchment_features, by = "PU_Gap_Code")
catchment_features$Gap_Code <- as.character(catchment_features$Gap_Code)

year <- 2020


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

LD_sites_W_and_WT_overlap <- inner_join(LD_sites_W_all, LD_sites_WT_all, by = 'PU_Gap_Code')

LD_sites <- LD_sites_W_and_WT_overlap %>%  sample_n(30, replace = TRUE)

######################## Refactor

LD_sites_2 <- kasky_landuse_W %>% 
  full_join(kasky_landuse_WT, by = c('PU_Gap_Code', 'PU_Code', 'Gap_Code')) %>% 
  select(PU_Gap_Code, PU_Code, Gap_Code, W_LU_Disturbed, W_LU_Undisturbed, W_Undisturbed_Level, WT_LU_Disturbed, WT_LU_Undisturbed, WT_Undisturbed_Level) %>% 
  filter(W_Undisturbed_Level == 'Medium-High' | W_Undisturbed_Level == 'High',
         WT_Undisturbed_Level == 'Medium-High' | WT_Undisturbed_Level == 'High'
         ) %>% 
  sample_n(30, replace = TRUE)

LD_sites_final <- catchment_features %>% 
  select(1:4, 13, 24:36) %>%
  right_join(LD_sites_2)

write.csv(LD_sites_final, file = paste0("~/CREP/R_Scripts/Sites/", year,"_SiteSelection_LeastDisturbed.csv"), row.names = F)

ld_pugap_only <- LD_sites_final %>% 
  select(PU_Gap_Code)

write.csv(ld_pugap_only, file = paste0("~/CREP/R_Scripts/Sites/", year,"_SiteSelection_LeastDisturbed_gaponly.csv"), row.names = F)  
### 
#TODO compare LD_sites with LD_sites_2. should be pretty similar. 

LD_sites <- LD_sites %>% 
  rename(PU_Code = PU_Code.x,
         Gap_Code = Gap_Code.x) %>% 
  select(PU_Gap_Code, PU_Code, Gap_Code, W_LU_Disturbed, W_LU_Undisturbed, W_Undisturbed_Level, WT_LU_Disturbed, WT_LU_Undisturbed, WT_Undisturbed_Level)


########################

review <- LD_sites_W_and_WT %>%
  select(PU_Gap_Code, W_LU_Disturbed, W_LU_Undisturbed, WT_LU_Disturbed, WT_LU_Undisturbed, W_Undisturbed_Level, WT_Undisturbed_Level)

W_not_in_WT <- anti_join(LD_sites_W_all, LD_sites_WT_all, by = 'PU_Gap_Code')

WT_not_in_W <- anti_join(LD_sites_WT_all, LD_sites_W_all, by = 'PU_Gap_Code')


Find_me <- review %>%
  filter(PU_Gap_Code == 'kasky1295'|PU_Gap_Code == 'kasky1263'|PU_Gap_Code == 'kasky3014'|PU_Gap_Code == 'kasky3955')

##Export to .csv

# write.csv(sites, file = paste0("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/", year,"_SiteSelection.csv"), row.names = F)

## Least Disturbed sites.
##Less-disturbed sites selected  by filtering for proportion local CRP
# ldsites <- df %>%
#   filter(prop_local_CRP >= 0.50)

####FINDING ALERNATIVE LD SITES

LD_sites_list <- kasky_landuse_W %>% 
  full_join(kasky_landuse_WT, by = c('PU_Gap_Code', 'PU_Code', 'Gap_Code')) %>% 
  select(PU_Gap_Code, PU_Code, Gap_Code, W_LU_Disturbed, W_LU_Undisturbed, W_Undisturbed_Level, WT_LU_Disturbed, WT_LU_Undisturbed, WT_Undisturbed_Level) 

%>% 
  filter(W_Undisturbed_Level == 'Medium-High' | W_Undisturbed_Level == 'High',
         WT_Undisturbed_Level == 'Medium-High' | WT_Undisturbed_Level == 'High')

LD_sites_list <- catchment_features %>% 
  select(1:4, 13, 24:36) %>%
  right_join(LD_sites_list)


# LD_sites_best <- catchment_features %>% 
#   select(1:4, 13, 24:36) %>%
#   right_join(LD_sites_list) %>%
#   filter(size_class == 1, 
#          Link >1,
#          W_Undisturbed_Level == 'Medium-High' | W_Undisturbed_Level == 'High',
#          WT_Undisturbed_Level == 'Medium-High' | WT_Undisturbed_Level == 'High')

LD_sites_best <- LD_sites_list %>% 
  filter(size_class == 1, 
         Link >1,
         W_Undisturbed_Level == 'Medium-High' | W_Undisturbed_Level == 'High',
         WT_Undisturbed_Level == 'Medium-High' | WT_Undisturbed_Level == 'High')