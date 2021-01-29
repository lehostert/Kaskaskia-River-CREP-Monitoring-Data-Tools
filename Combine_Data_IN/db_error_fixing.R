library(tidyverse)

network_prefix <- if_else(as.character(Sys.info()["sysname"]) == "Windows", "//INHS-Bison", "/Volumes")


# TODO Fix errors for the time effors in the Fish Metadata table for 2020 "Time_Effort"


## Example for fixing an error you must overwrite a file. 
# ihi_table <- as_tibble(tbl(con, "Habitat_IHI"))
# 
# ### Example for updating and replacing all of the records in a table
# 
# invert_field_table <- as_tibble(tbl(con, "Invert_Metadata_Field"))
# inv_col_unique <- unique(invert_field_table$Jab_Collector)
# 
# invert_field_table$Jab_Collector <- stringr::str_remove(invert_field_table$Jab_Collector, "[:punct:]")
# invert_field_table$Jab_Collector <- stringr::str_to_lower(invert_field_table$Jab_Collector)
# inv_col_unique2 <- unique(invert_field_table$Jab_Collector)
# 
# dbWriteTable(con, "Invert_Metadata_Field", invert_field_table, batch_rows = 1, overwrite = TRUE, append = FALSE)

#Test with inspecting "BLukaszczyk" and "David S."