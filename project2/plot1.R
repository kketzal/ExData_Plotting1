# Read the data from external script
source("read_data.R")

# load library "dplyr" for "group" and "summarise" purpouses
library(dplyr)

# group the dataframe (NEI )by year, and sum total emissions from all sources
grouped_by_year <- summarise(group_by(NEI, year), Total_Emissions = sum(Emissions))

# Plot the result
png("plot1.png")

plot(grouped_by_year$year, grouped_by_year$Total_Emissions,
     main = "Total PM25 Emissions in United States",
     xlab = "Year",
     ylab = "Total Emissions (tons)",
     type = "l")

dev.off()