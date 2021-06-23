library(tidyverse)

year <- 2021
cells <- {1:30}

cells

set.seed(year)
# sites <-  cells %>%
#   group_by(basin, size_class, CRP_class) %>%
#   sample(cells)

invert_cells <- replicate(100, sample(cells))
#TODO pivot matrix so that the values for each "sample" are in a row
write.csv(invert_cells, file = paste0("Invertebrate_Lab_Processing/macroinvertebrate_subsampling_cells_",year,".csv"))

set.seed(year)
invert_secondary_cells <-replicate(30, sample(cells))
write.csv(t(invert_secondary_cells), file = paste0("Invertebrate_Lab_Processing/macroinvertebrate_subsubsampling_cells_",year,".csv")) 
