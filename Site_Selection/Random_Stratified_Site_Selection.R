#Script for CREP Random Site selection 2018. This begins CREP phase III site selection.

library(tidyverse)

df <- read_csv("C:/Users/lhostert/Documents/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Site_Selection/Data/Kaskaskia_Catchment_Sizes_and_Features.csv")
year <- 2019


## Random Sites selected- 5 sites per each basin, size, CRP combo due to the limits of each category.
## This is the type of site selection that was done pre-2018 for "random stratified site selection"
## It included CRP_Class as a factor for site selection. For 2018 on this component will be removed to provide more truly
## random site selection.

# set.seed(2017)
# sites <-  df %>%
#   group_by(basin, size_class, CRP_class) %>%
#   sample_n(5)

## For 2018 onward
## Random Sites selected- 6 sites per each basin, size combo due to the limits of each category.
## We will only sample 5 per basin (3 small, 2 large) but an extra 3 or 4 are chosen to provide  backup for impossible sites.
set.seed(year)
sites <-  df %>%
  group_by(HUC8_Basin_Name, size_class) %>%
  sample_n(6, replace = TRUE)


##Export to .csv

write.csv(sites, file = paste0("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/", year,"_SiteSelection.csv"), row.names = F)

## Least Disturbed sites.
##Less-disturbed sites selected  by filtering for proportion local CRP
# ldsites <- df %>%
#   filter(prop_local_CRP >= 0.50)

set.seed(year)
extra_lower_sites <-  df %>%
  filter(HUC8_Basin_Name == 'Lower') %>% 
  group_by(size_class) %>%
  sample_n(6, replace = TRUE)


write.csv(extra_lower_sites, file = paste0("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/", year,"_SiteSelection_Extra_Lower.csv"), row.names = F)

##### TEst

set.seed(year)
extra_lower_sites_by7 <-  df %>%
  filter(HUC8_Basin_Name == 'Lower') %>% 
  group_by(size_class) %>%
  sample_n(7, replace = TRUE)


write.csv(extra_lower_sites_by7, file = paste0("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/", year,"_SiteSelection_Extra_Lower_by7.csv"), row.names = F)

set.seed(year)
extra_lower_sites_by8 <-  df %>%
  filter(HUC8_Basin_Name == 'Lower') %>% 
  group_by(size_class) %>%
  sample_n(8, replace = TRUE)


write.csv(extra_lower_sites_by8, file = paste0("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/", year,"_SiteSelection_Extra_Lower_by8.csv"), row.names = F)

set.seed(year)
extra_lower_sites_by9 <-  df %>%
  filter(HUC8_Basin_Name == 'Lower') %>% 
  group_by(size_class) %>%
  sample_n(9, replace = TRUE)


write.csv(extra_lower_sites_by9, file = paste0("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/", year,"_SiteSelection_Extra_Lower_by9.csv"), row.names = F)


set.seed(year)
extra_lower_sites_by10 <-  df %>%
  filter(HUC8_Basin_Name == 'Lower') %>% 
  group_by(size_class) %>%
  sample_n(10, replace = TRUE)


write.csv(extra_lower_sites_by10, file = paste0("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/", year,"_SiteSelection_Extra_Lower_by10.csv"), row.names = F)

set.seed(year)
extra_lower_sites_by18 <-  df %>%
  filter(HUC8_Basin_Name == 'Lower') %>% 
  group_by(size_class) %>%
  sample_n(18, replace = TRUE)


write.csv(extra_lower_sites_by18, file = paste0("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/", year,"_SiteSelection_Extra_Lower_by18.csv"), row.names = F)

set.seed(year)
extra_lower_sites_by17 <-  df %>%
  filter(HUC8_Basin_Name == 'Lower') %>% 
  group_by(size_class) %>%
  sample_n(17, replace = TRUE)


write.csv(extra_lower_sites_by17, file = paste0("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/", year,"_SiteSelection_Extra_Lower_by17.csv"), row.names = F)

extra_lower_sites_Large <-  df %>%
  filter(HUC8_Basin_Name == 'Lower') %>% 
  filter(size_class == '2')