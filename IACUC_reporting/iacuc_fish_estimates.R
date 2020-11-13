library(tidyverse)
library(odbc)
library(DBI)


### with odbc
odbcListDrivers() # to get a list of the drivers your computer knows about 
con <- dbConnect(odbc::odbc(), "2019_CREP_Database") #2019_CREP_Database is what you named the current CREP_Database when you set up the driver
dbListTables(con) # To get the list of tables in the database #There is a bunch of additional stuff in here that I don't know what it does

fish <- as_tibble(tbl(con, "Fish_Abundance")) # Directly return the data table from the database as a tibble

# Summary of all of the fish data by sampling event
summary_fish <- fish %>%
  mutate(year = lubridate::year(Event_Date)) %>% 
  group_by(Reach_Name, year) %>% 
  summarise(
    total_fish = sum(Fish_Species_Count)
  ) %>% 
  ungroup()

# Summary of all of the fish data by year "How many fish over how many years"
summary_fish_ave <- fish %>%
  mutate(year = lubridate::year(Event_Date)) %>% 
  group_by(year) %>% 
  summarise(
    total_fish = sum(Fish_Species_Count),
    total_sites = n_distinct(Reach_Name)
  )

se <- function(x) {
  sqrt(var(x)/length(x))
}

#per year summary
per_year_summary <- summarise(summary_fish_ave, 
          mean = mean(total_fish),
          sd = sd(total_fish),
          sem = se(total_fish),
          n = n(),
          min = min(total_fish),
          max = max(total_fish)
          )

#per site summary 
per_site_summary <- summarise(summary_fish, 
                              mean = mean(total_fish),
                              median = median(total_fish),
                              sd = sd(total_fish),
                              sem = se(total_fish),
                              n = n(),
                              max = max(total_fish),
                              min = min(total_fish)
                              )

f19 <- readxl::read_xlsx(path = "~/CREP/Permits/2019/2019_Fish_Permit_Summary.xlsx", col_names = T)
f18 <- readxl::read_xlsx(path = "~/CREP/Permits/2018/2018_Fish_Permit_Summary.xlsx", col_names = T)


f18_fix <- rename(f18, c(Count= Number, Release_status = Disposition))

mort <- bind_rows(f19, f18_fix) %>%
  mutate(Year = replace_na(lubridate::year(Event_Date), 2018)) %>% 
  group_by(Year, Release_status)%>% 
  summarise(
    total_fish = sum(Count))%>% 
  ungroup()

## Estimated 2013-2017 only 20 fish were vouchered for donation to INHS Museum Collection. 

# mort$Release_status <- if_else(mort$Release_status = "", "", )

#TODO Find a way to get the ratio of mortality to released total for 2018 & 2019 as well as mort ratio by year. 

# mort %>% group_by(Release_status) %>% 
#   summarise(
#   total_fish = sum(Count)
# )
  
combo <- bind_rows(f19, f18_fix) 

summarise(combo, 
    total_fish = sum(Count)
  )

#### When you are done close your database connection ####
dbDisconnect(con)

