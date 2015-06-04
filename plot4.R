source("read_data.R")

# Change the LOCALE --> LC_TIME to en_US for showing week Days in english
Sys.setlocale('LC_TIME', 'en_US.UTF-8')

png("plot4.png")

par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
# par(mfrow = c(2, 2))
with(clean_data, {
    # Plot 1
    plot(DateTime,Global_active_power, xlab = "", ylab = "Global Active Power", type="l")
    #Plot 2
    plot(DateTime, Voltage, type = "l" , xlab = "datetime", ylab = "Voltage")  
})


# Subsetting data for Plot #3
x <- clean_data$DateTime
y <- clean_data$Sub_metering_1
yy <- clean_data$Sub_metering_2
yyy <- clean_data$Sub_metering_3

with(clean_data, plot(x,y, type = "n", xlab="", ylab ="Energy sub metering"))
with(clean_data, lines(x,y))
with(clean_data, lines(x,yy, col="red"))
with(clean_data, lines(x,yyy, col="blue"))

# add legend to plot.
legend("topright", 
       bty = "n", # legend box dissapears
       lwd = "1",
       col = c("black","red","blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))


## Plot 4
with(clean_data, plot(DateTime, Global_reactive_power, 
                      type = "l" , 
                      xlab = "datetime", 
                      ylab = "Global_reactive_power")
     )


dev.off()


# revert the LOCALE to es_ES for showing week Days in spanish
Sys.setlocale('LC_TIME', 'es_ES.UTF-8')

# Remove subsetted data for plot 3
rm(x,y,yy,yyy)