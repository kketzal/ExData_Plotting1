suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(lubridate))

########################################################################################
# this example is extracted from StackOverflow:
# Create a new character class "MyDate". this class is a function that read date 
# with the format d/m/Y and convert it into R Date. 
#
# DOESN'T WORK WITH "data.table"
#
setClass('myDate') 
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y") )

# Similar to Time:
setClass("myTime")
setAs("character","myTime", function(from) hms(from) )
########################################################################################

#
#x <- read.csv.sql("household_power_consumption.txt", 
#                  sep = ";", 
#                  nrows = 10,
#                  colClasses = c("myDate","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"), 
#                  sql = "SELECT * FROM file WHERE Date BETWEEN date('2007-02-01') AND date('2007-02-02')")

full_data <- fread("household_power_consumption.txt", 
                na.strings = c('?'), 
                sep = ";", 
                header = TRUE, 
                colClasses = c("myDate","character","character","character","character","character","character","character","character"))

data_good <- complete.cases(full_data)
clean_data <- full_data[data_good]

