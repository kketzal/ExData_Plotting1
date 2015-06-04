source("read_data.R")

# Change the LOCALE --> LC_TIME to en_US for showing week Days in english
Sys.setlocale('LC_TIME', 'en_US.UTF-8')

png("plot2.png")
x <- clean_data$DateTime
y <- clean_data$Global_active_power

plot(x,y,            
     xlab = "",
     ylab = "Global Active Power (kilowats)",
     type="l"
     )
dev.off()

# revert the LOCALE to es_ES for showing week Days in spanish
Sys.setlocale('LC_TIME', 'es_ES.UTF-8')