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

# Subsetting the NEI data, we only want "Baltimore" and "L.A."values...
# in other words "fips = 24518" and "fips = 06037"
BALTIMORE_L.A._DATA <- filter(NEI, fips == "24510" |  fips == "06037")

# We can change the FIPS values to their city names (using data.table package capabilities)...
BALTIMORE_L.A._DATA[fips == "24510", fips := "Baltimore City"]
BALTIMORE_L.A._DATA[fips == "06037", fips := "Los Angeles County"]

# Set the KEY for both tables before merging
setkey(BALTIMORE_L.A._DATA, SCC)
setkey(MOTOR_VEHICLES_DATA, SCC)  

all_data <- merge(BALTIMORE_L.A._DATA, MOTOR_VEHICLES_DATA)

####################################################


# group the dataframe (all_data) by year, and fips code
grouped <- group_by(all_data, year, fips)

# Summarise grouped dataframe and compute the SUM of emissions 
my_summarize <- summarise(grouped, Total_Emissions = sum(Emissions))

# the my_summarize dataset appears not be sorted by year....we need to order it.
my_summarize <- my_summarize[order(fips, year)]

# if we want to calculate PERCENTAGE CHANGE on every city, subset the data for each city
# and calculate the percentage change on each dataset
my_summarize_Baltimore <- my_summarize[1:4]
my_summarize_Los_Angeles <- my_summarize[5:8]

# add a new variable "since1999" with the percentage change
my_summarize_Baltimore <- transform(my_summarize_Baltimore, since1999 = (Total_Emissions-Total_Emissions[1])/Total_Emissions[1]*100)
my_summarize_Los_Angeles <- transform(my_summarize_Los_Angeles, since1999 = (Total_Emissions-Total_Emissions[1])/Total_Emissions[1]*100)

# BIND the 2 previous datasets in one dataset for plotting
my_summarize <- rbind(my_summarize_Baltimore, my_summarize_Los_Angeles)

# Plotting, with assign explicitly the image width
png("plot6.png", width = 650, height = 360)

# qplot() doesn't print anything from R files. you need to assign the result
# to a variable ('p' in this case), and then, explicitly call to print() function
p <- qplot(year, since1999, data = my_summarize, 
           facets =.~fips, 
           geom = "line",
           xlab= "Year",
           ylab = "% CHANGE of Total Emissions",
           main = "Greater Changes Over Time in Motor Vehicle Emissions")

print(p)

dev.off()

