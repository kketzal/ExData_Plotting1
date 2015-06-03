source("read_data.R")
png("plot1.png")
hist(clean_data$Global_active_power, 
     main = "Global Active Power", 
     col = "red",
     xlab = "Global Active Power (kilowats)"
     )
dev.off()