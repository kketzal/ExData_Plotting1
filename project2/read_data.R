
# assign file names to vars... 
data_pm25_file <- "summarySCC_PM25.rds"
data_source_classif_file <- "Source_Classification_Code.rds"

# check if files exist...
if(!match(data_pm25_file, dir(), nomatch = FALSE))
    stop(paste("The file", data_pm25_file, "doesn't exist!"))

if(!match(data_source_classif_file, dir(), nomatch = FALSE))
    stop(paste("The file", data_source_classif_file, "doesn't exist!"))

# read the data
message(paste("Reading", data_pm25_file, "...", collapse = ""))
NEI <- readRDS(data_pm25_file)
message(paste("Reading", data_source_classif_file, "...", collapse = ""))
SCC <- readRDS(data_source_classif_file)
message("Done!")