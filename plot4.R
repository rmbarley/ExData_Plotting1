## Calculate how many rows to read in
## 60*24*2 = 2880

## If file is not already in working directory, download and unzip it
dir.create("./data", showWarnings=FALSE) 

if(!file.exists("./data/household_power_consumption.txt")) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, destfile = "./data/data.zip")
  unzip(zipfile="./data/data.zip", files = NULL, list = FALSE, overwrite = TRUE,
        junkpaths = FALSE, exdir = "./data", unzip = "internal",
        setTimes = FALSE)
}

## Get column classes and read in large data set as per 
## http://www.biostat.jhsph.edu/~rpeng/docs/R-large-tables.html
first5rows <- read.table('./data/household_power_consumption.txt', 
                         header = TRUE, 
                         sep = ";", 
                         nrows = 5)
classes <- sapply(first5rows, class)
fulldata <- read.table('./data/household_power_consumption.txt', 
                       header = TRUE,
                       sep = ";",
                       na.strings = "?",
                       colClasses = classes,
                       skip = 66637,
                       nrows = 2880)

## Give fulldata columns names, and tidy them up 
names(fulldata) <- names(first5rows)
names(fulldata) <- gsub('_', '', tolower(names(fulldata)))

## Convert date from factor to date
fulldata$date <- as.Date(fulldata$date, "%m/%d/%Y")

## Paste date and time together for x-axis reasons
fulldata$date <- as.POSIXct(paste(fulldata$date, fulldata$time), 
                            format="%Y-%d-%m %H:%M:%S")

# Check for NAs
any(is.na(fulldata))
## [1] FALSE

## Plot 4, create PNG

png(file = "plot4.png",  width = 480, height = 480)
## t    y
par(mfrow = c(2, 2))
## First row, first column 
plot(fulldata$date, 
              fulldata$globalactivepower, 
              type = "l", 
              main = "", 
              xlab = "", 
              ylab = "Global Active Power")
## First row, second column
plot(fulldata$date,
    fulldata$voltage,
    type = "l",
    xlab = "datetime",
    ylab = "voltage",
    main = "")
## Second row, first column
plot(fulldata$date,
              fulldata$submetering1,
              type = "l",
              col ="black", 
              xlab = "",
              ylab = "Energy sub metering")
lines(fulldata$date,
      fulldata$submetering2,
      col="red")
lines(fulldata$date,
      fulldata$submetering3,
      col="blue")
legend("topright", 
       lty = 1,
       bty = "n",
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
## Second row, second column
plot(fulldata$date,
     fulldata$globalreactivepower,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power",
     main = "")
dev.off()