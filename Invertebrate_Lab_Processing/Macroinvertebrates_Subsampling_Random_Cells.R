library(dplyr)

year <- 2020
cells <- {1:30}

cells

set.seed(year)
# sites <-  cells %>%
#   group_by(basin, size_class, CRP_class) %>%
#   sample(cells)

InvertCells<-replicate(100, sample(cells))
write.csv(t(InvertCells), file = paste0("macroinvertebrate_subsampling_cells_",year,".csv"))

set.seed(year)
InvertCells<-replicate(30, sample(cells))
write.csv(t(InvertCells), file = paste0("macroinvertebrate_subsubsampling_cells_",year,".csv")) 