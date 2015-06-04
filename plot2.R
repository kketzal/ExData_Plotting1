source("read_data.R")
png("plot2.png")
x <- clean_data$DateTime
y <- clean_data$Global_active_power

plot(x,y,            
     xlab = "",
     ylab = "Global Active Power (kilowats)",
     type="l"
     )
dev.off()