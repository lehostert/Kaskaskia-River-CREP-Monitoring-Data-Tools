library(tidyverse)

# file_path <- "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_Invert_Species_Matrix_LEH_RPMC.csv"

file_path <- "~/GitHub/Kaskaskia-River-CREP-Monitoring-Data-Tools/CREP_Invert_Species_Matrix_LEH_RPMC _test.csv"

inv <- tibble::as_tibble(read.csv(file_path, header = T, na = c("NA",".")))

output <- ifelse(
  
)


