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

# Getting the MOTOR VEHICLES rows from SCC, searching in "Sector" column. 
# That's (excluding NON-ROAD values):
# > grep("Non-Road", grep("Mobile", levels(SCC$EI.Sector), value = T), invert = T, value = T)
# [1] "Mobile - Aircraft"                             "Mobile - Commercial Marine Vessels"           
# [3] "Mobile - Locomotives"                          "Mobile - On-Road Diesel Heavy Duty Vehicles"  
# [5] "Mobile - On-Road Diesel Light Duty Vehicles"   "Mobile - On-Road Gasoline Heavy Duty Vehicles"
# [7] "Mobile - On-Road Gasoline Light Duty Vehicles"
#

motor_vehicles_rows <- grep("Non-Road", grep("Mobile", SCC$EI.Sector, value = T), invert = T, value = T)

# Subsetting the SCC data, we only want "motor_vehicles" values...
MOTOR_VEHICLES_DATA <- SCC[motor_vehicles_rows]

# Subsetting the NEI data, we only want "Baltimore" values...in other words "fips = 24518"
BALTIMORE_DATA <- filter(NEI, fips == "24510")

# Set the KEY for both tables before merging
setkey(BALTIMORE_DATA, SCC)
setkey(MOTOR_VEHICLES_DATA, SCC)  

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
