###Minumum working example
library(tidyverse)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison", "/Volumes")

f20 <- readr::read_csv(file = paste0(network_prefix, "/ResearchData/Groups/Kaskaskia_CREP/Data/Data_IN/DB_Ingest/FSH_2020.csv"))

f20_full <- f_20 %>%
  select(-c(Gap_Code)) %>% 
  drop_na(Species_Code)
          
## Connect to DB and pull in the Fcount and flength data that is already in the database. 
## Filter for all data that is 2018 and before. NO 2019 and no 2020. Double check!
## use uncount() from dplyr in order to spread data from single line to multiple lines
## Find a way to add lw data to single line spp data. 

counts <- read_csv(file = "~/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Combine_Data_IN/counts.csv")
lengths <- read_csv(file = "~/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/Combine_Data_IN/lengths.csv")

#Fish_Species_Count
f17 <- uncount(counts, Fish_Species_Count)

length_sum <- lengths %>% 
  group_by(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code) %>% 
  summarise(Fish_Species_Count = n())

tbl_sum <- full_join(length_sum, counts, by = c("PU_Gap_Code", "Reach_Name", "Event_Date", "Fish_Species_Code"), suffix = c(".LW", ".COUNTS")) %>% 
  replace_na(list(Fish_Species_Count.LW = 0, Fish_Species_Count.COUNTS = 0)) %>% 
  mutate(count_dif = Fish_Species_Count.COUNTS - Fish_Species_Count.LW,
         length_dif = Fish_Species_Count.LW - Fish_Species_Count.COUNTS,
         count_dif = if_else(count_dif< 0, 0, count_dif),
         length_dif = if_else(length_dif< 0, 0, length_dif))

tbl_sum2 <- counts %>% 
  group_by(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code) %>% 
  summarize(Fish_Species_Count = sum(Fish_Species_Count)) %>% 
  full_join(length_sum, by = c("PU_Gap_Code", "Reach_Name", "Event_Date", "Fish_Species_Code"), suffix = c(".COUNTS", ".LW")) %>% 
  replace_na(list(Fish_Species_Count.LW = 0, Fish_Species_Count.COUNTS = 0)) %>% 
  mutate(count_dif = Fish_Species_Count.COUNTS - Fish_Species_Count.LW,
         length_dif = Fish_Species_Count.LW - Fish_Species_Count.COUNTS,
         count_dif = if_else(count_dif< 0, 0, count_dif),
         length_dif = if_else(length_dif< 0, 0, length_dif))

### is is piossible to use the new DF tbl_sum with a new collumn to create a new set of rows on the LW datat set that have no lw data. Given the 0 difference 
### count set to 1 and the other difference count will give you a multiple row. 

not_measured <- tbl_sum %>% 
  select(PU_Gap_Code, Reach_Name, Event_Date, Fish_Species_Code, count_dif) %>% 
  uncount(count_dif)


df_combined <- bind_rows(lengths, not_measured)


# test <- left_join(f17, lengths, by = c("PU_Gap_Code", "Reach_Name", "Event_Date", "Fish_Species_Code"))

####################

### is is better to add counts to the full dataset first then add in the length weight or add l/w and then add to f20 full dataset?
combo <- f20_full %>% 
  left_join(f17_full, by = c("PU_Gap_Code", "Reach_Name", "Event_Date", "Fish_Species_Code")) %>% 
              
          

# 
# 
# coalesce_join <- function(x, y, 
#                           by = NULL, suffix = c(".x", ".y"), 
#                           join = dplyr::full_join, ...) {
#   joined <- join(x, y, by = by, suffix = suffix, ...)
#   # names of desired output
#   cols <- union(names(x), names(y))
#   
#   to_coalesce <- names(joined)[!names(joined) %in% cols]
#   suffix_used <- suffix[ifelse(endsWith(to_coalesce, suffix[1]), 1, 2)]
#   # remove suffixes and deduplicate
#   to_coalesce <- unique(substr(
#     to_coalesce, 
#     1, 
#     nchar(to_coalesce) - nchar(suffix_used)
#   ))
#   
#   coalesced <- purrr::map_dfc(to_coalesce, ~dplyr::coalesce(
#     joined[[paste0(.x, suffix[1])]], 
#     joined[[paste0(.x, suffix[2])]]
#   ))
#   names(coalesced) <- to_coalesce
#   
#   dplyr::bind_cols(joined, coalesced)[cols]
# }
# 
# f17_full <- coalesce_join(f17, lengths, by = c("PU_Gap_Code", "Reach_Name", "Event_Date", "Fish_Species_Code"))
# 




# Fill in the information that is missing in the end

combined_final <- combo %>%
  mutate(across(where(is.character), ~na_if(., "no"))) %>% 
  mutate(Release_status = replace_na(Release_status, "alive"))
