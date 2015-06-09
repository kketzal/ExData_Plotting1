# Read the data from external script
source("read_data.R")

# load library "dplyr" for "group" and "summarise" purpouses
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(ggplot2))

# Convert NEI dataframe in a dplyr package "tbl_df".
NEI <- tbl_df(NEI)

# subsetting Baltimore values
baltimore_df <- filter(NEI, fips == "24510")

# group the dataframe (baltimore_df) by year, and type
grouped <- group_by(baltimore_df, year, type)

# Summarise grouped dataframe and sum 
my_summarize <- summarise(grouped, Total_emisions = sum(Emissions))

# Plotting, with assign explicitly the image width
png("plot3.png", width = 650, height = 360)

# qplot() doesn't print anything from R files. you need to assign the result
# to a variable ('p' in this case), and then, explicitly call to print() function
p <- qplot(year, Total_emisions, data = my_summarize, 
      facets =.~type, 
      geom = "line",
      xlab= "Year",
      ylab = "Total Emissions (tons)",
      main = "Total PM25 Emissions by Type in Baltimore, Maryland")

print(p)

dev.off()
