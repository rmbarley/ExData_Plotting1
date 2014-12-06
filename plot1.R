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
fulldata$date <- as.POSIXct(paste(fulldata$date, fulldata$time), 
                            format="%Y-%d-%m %H:%M:%S")

# Check for NAs
any(is.na(fulldata))
## [1] FALSE

## Plot 1, create PNG
png(file = "plot1.png", width = 480, height = 480)
plot1 <- hist(fulldata$globalactivepower, 
              breaks = 12, 
                 col = "red",
                xlab = "Global Active Power (killowatts)",
                ylab = "Frequency",
                main = "Global Active Power")
plot1
dev.off()