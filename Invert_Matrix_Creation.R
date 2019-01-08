library(tidyverse)

#input_file_path <- "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Data/Data_IN/DB_Ingest/INVLab_Combined_blank.csv"
input_file_path <- "INVLab_test.csv"

input_tibble <- tibble::as_tibble(read.csv(input_file_path))

# Some of the data will be repeated in addition to the summary infomation
# Get a list of sequential column names bordered by the first and last columns of interest
feature_names <- names(input_tibble)

first_column_of_interest <- which(feature_names=="KINGDOM")
last_column_of_interest <- which(feature_names=="SUBSPECIES")

relevant_feature_names <- feature_names[first_column_of_interest:last_column_of_interest]

# To get main summary information of interest of the data define the operations that 
# will be performed given the selected group_by value
summary_method_names <- c("sum(ABUNDANCE)","n_distinct(Reach_Name)")
summary_column_names <- c("Total_Abundance","Site_Frequency")

# Append the named summary operations to the repeated unique() calls for the other
# columns in the input_tibble that are desired
operations <- paste0('unique(',relevant_feature_names,')') %>%
  purrr::prepend(summary_method_names)
operation_names <- stringr::str_to_title(relevant_feature_names, locale = "en") %>%
  purrr::prepend(summary_column_names)

# Before gave "summarise" all the information manually
#summary_table <- input_tibble %>% 
#  dplyr::group_by(TAXON_NAME) %>%
#  dplyr::summarise(Total_Abundance=sum(ABUNDANCE),
#            Site_Frequency=n_distinct(Reach_Name),
#            whole bunch of unique() calls)

# Apply the summary operations to get the invertebrate summary tibble
# N.B.: Using "summarise_" and the ".dots" variable
# This is using the "Standard Evaluation" feature of the tidyverse, but 
# the help for "summarise_" says that these are now deprecated, so this
# should get changed in the future
#
# Motivation for this was the following
# - https://datascience.blog.wzb.eu/2016/09/27/dynamic-columnvariable-names-with-dplyr-using-standard-evaluation-functions/
# - https://stackoverflow.com/questions/26724124/standard-evaluation-in-dplyr-summarise-on-variable-given-as-a-character-string
# - https://dplyr.tidyverse.org/articles/programming.html
summary_tibble <- input_tibble %>% 
  dplyr::group_by(TAXON_NAME) %>%
  dplyr::summarise_(.dots=stats::setNames(operations, operation_names))

# save the summary_tibble to .csv
output_file_path = "ltrain_runs_train.csv"
readr::write_csv(summary_tibble, output_file_path)