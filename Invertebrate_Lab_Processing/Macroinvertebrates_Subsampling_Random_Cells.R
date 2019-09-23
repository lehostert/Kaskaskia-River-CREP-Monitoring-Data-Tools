library(dplyr)

cells <- {1:30}

cells

set.seed(2018)
# sites <-  cells %>%
#   group_by(basin, size_class, CRP_class) %>%
#   sample(cells)

InvertCells<-replicate(100, sample(cells))


write.csv(t(InvertCells), file = "macroinvertebrate_subsampling_cells_2018") 

set.seed(2018)
InvertCells<-replicate(30, sample(cells))
write.csv(t(InvertCells), file = "macroinvertebrate_subsubsampling_cells_2018") 