
data_type <- "FSH"
collumns <- c("text", "text", "text","date", "date", "text", "text", "text", "numeric", "numeric",
              "text","text", "text", "text", "text", "text", "text", "text", "text", "text")

collumn_types <- list(FSH = c("text", "text", "text","date", "date", "text", "text", "text", "numeric", "numeric",
                              "text","text", "text", "text", "text", "text", "text", "text", "text", "text"),
                      IHI = c("text","text","date","skip","skip","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric",
                              "text","text","text","text","text","text",
                              "numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric"),
                      
                      )
collumn_types$FSH
collumn_types$IHI

library(jsonlite)
x <- jsonlite::fromJSON("https://raw.githubusercontent.com/sitepoint-editors/json-examples/master/package.json")
x <- jsonlite::fromJSON("https://gist.githubusercontent.com/matthewfeickert/7d51c57dfde341e392b2521bc16cdd2d/raw/a83d46860b7fa7e838f24ba18a0b23b08c6840e6/column_schemas.json")
y <- jsonlite::read_json("https://gist.githubusercontent.com/matthewfeickert/7d51c57dfde341e392b2521bc16cdd2d/raw/a83d46860b7fa7e838f24ba18a0b23b08c6840e6/column_schemas.json")

identical(x, y)
