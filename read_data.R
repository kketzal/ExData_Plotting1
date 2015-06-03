suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(dplyr))

########################################################################################
# this example is extracted from StackOverflow:
# Create a new character class "MyDate". this class is a function that read date 
# with the format d/m/Y and convert it into R Date. 
#
# DOESN'T WORK WITH "data.table" package.
#
setClass('myDate') 
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y") )

# Similar to Time:
# setClass("myTime")
# setAs("character","myTime", function(from) hms(from) )
########################################################################################

#
#x <- read.csv.sql("household_power_consumption.txt", 
#                  sep = ";", 
#                  nrows = 10,
#                  colClasses = c("myDate","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"), 
#                  sql = "SELECT * FROM file WHERE Date BETWEEN date('2007-02-01') AND date('2007-02-02')")


## Check if data file exists
if(!file.exists("household_power_consumption.txt")){
    stop("the file 'household_power_consumption.txt' doesn't exist!")
}

    
full_data <- fread("household_power_consumption.txt", 
                   na.strings = c('?'), 
                   sep = ";", 
                   header = TRUE, 
                   colClasses = c("character","character","character","character","character","character","character","character","character"))
    

data_good <- complete.cases(full_data)
clean_data <- full_data[data_good]
clean_data <- clean_data %>%
              mutate(Date = as.Date(Date, format = "%d/%m/%Y")) %>% # mutate date format
              filter(Date >= "2007-02-01" & Date <= "2007-02-02" ) %>% # filter 2 days only
              mutate_each(funs(as.numeric), -c(Date,Time))  # to mumeric all, less Date & Time

