#Script for CREP Random Site selection 2018. This begins CREP phase III site selection. 

install.packages("dplyr")
library(dplyr)
attach(dplyr)

df <- read.csv("PU_Gaps_size_and_CRP_classes.csv")
year <- 2019


## Random Sites selected- 5 sites per each basin, size, CRP combo due to the limits of each category.
## This is the type of site selection that was done pre-2018 for "random stratified site selection"
## It included CRP_Class as a factor for site selection. For 2018 on this component will be removed to provide more truly
## random site selection.

# set.seed(2017)
# sites <-  df %>%
#   group_by(basin, size_class, CRP_class) %>%
#   sample_n(5)

## Random Sites selected- 8 sites per each basin, size, CRP combo due to the limits of each category.
## We will only sample 5 per basin but an extra 3 are chosen to provide  backup for impossible sites.
set.seed(year)
sites <-  df %>%
  group_by(basin, size_class) %>%
  sample_n(8, replace = TRUE)


##Export to .csv

write.csv(sites, file = paste0("C:/Users/lhostert/Documents/CREP/R_Scripts/Sites/", year,"_SiteSelection.csv"), row.names = F)

##Less-disturbed sites selected  by filtering for proportion local CRP
# ldsites <- df %>%
#   filter(prop_local_CRP >= 0.50)
