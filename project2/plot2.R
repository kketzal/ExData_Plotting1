# Read the data from external script
source("read_data.R")

# load library "dplyr" for "group" and "summarise" purpouses
suppressPackageStartupMessages(library(dplyr))

# Convert NEI dataframe in a dplyr package "tbl_df".
NEI <- tbl_df(NEI)

# subsetting Baltimore values
baltimore_df <- filter(NEI, fips == "24510")

# group the dataframe (baltimore_df) by year, and sum total emissions
grouped_by_year <- summarise(group_by(baltimore_df, year), Total_Emissions = sum(Emissions))

# Plot
png("plot2.png")

plot(grouped_by_year$year, grouped_by_year$Total_Emissions,
     main = "Total PM25 Emissions in Baltimore, Maryland",
     xlab= "Year",
     ylab = "Total Emissions (tons)",
     type = "l")

dev.off()
