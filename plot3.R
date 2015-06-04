source("read_data.R")

# Change the LOCALE --> LC_TIME to en_US for showing week Days in english
Sys.setlocale('LC_TIME', 'en_US.UTF-8')

png("plot3.png")

# Subsetting data
x <- clean_data$DateTime
y <- clean_data$Sub_metering_1
yy <- clean_data$Sub_metering_2
yyy <- clean_data$Sub_metering_3

# create plot
with(clean_data, plot(x,y, type = "n", xlab="", ylab ="Energy sub metering"))
with(clean_data, lines(x,y))
with(clean_data, lines(x,yy, col="red"))
with(clean_data, lines(x,yyy, col="blue"))

# add legend to plot
legend("topright", 
       lwd = "2",
       col = c("black","red","blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))

dev.off()

# revert the LOCALE to es_ES for showing week Days in spanish
Sys.setlocale('LC_TIME', 'es_ES.UTF-8')

# Remove subsetted data
rm(x,y,yy,yyy)

