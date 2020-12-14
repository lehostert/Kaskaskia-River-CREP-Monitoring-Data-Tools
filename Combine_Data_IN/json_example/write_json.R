library(jsonlite)

column_types <- list(
  SWC = c("text","text","date","skip","skip","skip","date","numeric","numeric",
          "numeric","numeric","numeric","numeric","numeric","numeric","numeric",
          "numeric"
          ),
  FSH = c(
    "text", "text", "text", "date", "date", "text", "text", "text", "numeric",
    "numeric", "text", "text", "text", "text", "text", "text", "text", "text",
    "text", "text"
    ),
  FMD = c(
    "text", "text", "date", "date", "text", "numeric", "numeric", "numeric",
    "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "skip",
    "skip"
    ),
  IHI = c(
    "text", "text", "date", "skip", "skip", "numeric", "numeric", "numeric",
    "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
    "text", "text", "text", "text", "text", "text", "numeric", "numeric",
    "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
    "numeric", "numeric", "numeric", "numeric"
    ),
  QHEI = c("text","text","date","skip","skip","skip","numeric","numeric",
           "numeric","numeric","numeric","numeric","numeric","numeric"
           ),
  DSC = c(
    "text", "text", "date", "date", "numeric", "numeric", "numeric", "numeric",
    "numeric", "numeric"
    ),
  INV = c(
    "text", "text", "date", "skip", "skip", "skip", "numeric", "text", "text",
    "text", "text"
    )
  
  )

output_filename <- "Combine_Data_IN/column_schemas.json"
jsonlite::write_json(column_types, output_filename, pretty = TRUE)

cat("Wrote file", output_filename, "to disk\n")
