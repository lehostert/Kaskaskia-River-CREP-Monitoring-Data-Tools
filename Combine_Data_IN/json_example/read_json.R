library(jsonlite)

column_types <- jsonlite::read_json("column_schemas.json")

fish_columns <- column_types$FSH

print(paste("The first column data type in the FSH data type is:", fish_columns[1]))
