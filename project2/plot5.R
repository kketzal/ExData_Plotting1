# Read the data from external script
source("read_data.R")

# load library "dplyr" for "group" and "summarise" purpouses
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(data.table))

####################################################
# Merge NEI and SCC tables using data.table package (much faster)
# For merging, we use SCC column

NEI <- data.table(NEI)
SCC <- data.table(SCC)

# Getting the MOTOR VEHICLES rows from SCC, searching in "Data.Category" column. 
# That's (excluding NON-ROAD values):
# > good <- grep("Onroad",SCC$Data.Category)
# > on_road <- SCC[good,]
# > levels(factor(on_road$EI.Sector))
#  [1] "Mobile - On-Road Diesel Heavy Duty Vehicles"   "Mobile - On-Road Diesel Light Duty Vehicles"  
#  [3] "Mobile - On-Road Gasoline Heavy Duty Vehicles" "Mobile - On-Road Gasoline Light Duty Vehicles"
#

# Subsetting the SCC data, we only want "Onroad" values...
good <- grep("Onroad",SCC$Data.Category)
MOTOR_VEHICLES_DATA <- SCC[good,]

# Subsetting the NEI data, we only want "Baltimore" values...in other words "fips = 24518"
BALTIMORE_DATA <- filter(NEI, fips == "24510")

# Set the KEY for both tables before merging
setkey(BALTIMORE_DATA, SCC)
setkey(MOTOR_VEHICLES_DATA, SCC)  

all_data <- merge(BALTIMORE_DATA, MOTOR_VEHICLES_DATA)

####################################################


# group the dataframe (baltimore_df) by year, and type
grouped <- group_by(all_data, year)

# Summarise grouped dataframe and sum 
my_summarize <- summarise(grouped, Total_Emissions = sum(Emissions))

# the my_summarize dataset appears not be sorted by year....we need to order it.
my_summarize <- my_summarize[order(year)]

# Plot
png("plot5.png", width = 650)

plot(my_summarize$year, my_summarize$Total_Emissions,
     main = "Motor Vehicle Sources Emissions from 1999–2008 in Baltimore City",
     xlab = "Year",
     ylab = "Motor Vehicles Emissions (tons)",
     type = "l")

dev.off()
