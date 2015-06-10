# Read the data from external script
source("read_data.R")

# load library "dplyr" for "group" and "summarise" purpouses
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(data.table))

####################################################
# Merge NEI and SCC tables using data.table package (much faster)
# For merging, we use SCC column

NEI <- data.table(NEI)
SCC <- data.table(SCC)

# Getting the COAL rows from SCC, searching in "SCC.Level.Three" column
coal_scc_rows <- grep("[Cc]oal", SCC$SCC.Level.Three)

# Subsetting the SCC data, we only want COAL values...
COAL_DATA <- SCC[coal_scc_rows]

# Set the KEY for both tables before merging
setkey(NEI, SCC)
setkey(COAL_DATA, SCC)  

all_coal_data <- merge(NEI, COAL_DATA)

####################################################


# group the dataframe (baltimore_df) by year, and type
grouped <- group_by(all_coal_data, year)

# Summarise grouped dataframe and sum 
my_summarize <- summarise(grouped, Total_Emissions = sum(Emissions))

# Plot
png("plot4.png")

plot(my_summarize$year, my_summarize$Total_Emissions,
     main = "Total COAL Combustion Emissions in United States",
     xlab = "Year",
     ylab = "Total Coal Emissions (tons)",
     type = "l")

dev.off()
