## Load ggplot for making plots
library("ggplot2")

## Read the data into R and subset it to the needed columns only
## assumes the data is in the working directory wiht original file name
tempdata <- read.csv("repdata-data-StormData.csv.bz2")
data <- tempdata[,c("STATE","EVTYPE","FATALITIES","INJURIES","PROPDMG","CROPDMG")]
rm(tempdata)

## Create a dataframe for injuries and fatalities by Event Type and 
## order the results. Uses a for loop through each EVTYPE and populates
## a new data frame called "health"
health <- data.frame()
Event <- levels(data$EVTYPE)
for (i in Event) {
    injury <- sum(data$INJURIES[data$EVTYPE == i])
    fatality <- sum(data$FATALITIES[data$EVTYPE == i])
    total <- injury + fatality
    nrow <- c(injury, fatality, total)
    health <- rbind.data.frame(health, nrow)
}
names(health) <- c("Injuries", "Fatalities", "Total")
health <- cbind.data.frame(Event, health)
health <- health[order(-health$Total), ]

## Create a dataframe for property damage and crop damage by Event Type and 
## order the results. Uses a for loop through each EVTYPE and populates
## a new data frame called "health"
econ <- data.frame()
Event <- levels(data$EVTYPE)
for (i in Event) {
  propimpact <- sum(data$PROPDMG[data$EVTYPE == i])
  cropimpact <- sum(data$CROPDMG[data$EVTYPE == i])
  totalimpact <- propimpact + cropimpact
  nrow <- c(propimpact, cropimpact, totalimpact)
  econ <- rbind.data.frame(econ, nrow)
}
names(econ) <- c("PropDmg", "CropDmg", "TotalDmg")
econ <- cbind.data.frame(Event, econ)
# Order the result
econ <- econ[order(-econ$TotalDmg), ]

## Plot the top 10 results for health impact as a graph and data
tophealth <- health[1:10,]
qplot(Event,Total,data=tophealth,geom="bar",stat="identity",
  main="Top Ten Event Types for Health Impacts",xlab="Event Types",
  ylab="Total (Fatalities + Injuries)")
tophealth

## Plot the top 10 results for economic impact as a graph and data
topecon <- econ[1:10,]
qplot(Event,TotalDmg,data=topecon,geom="bar",stat="identity",
      main="Top Ten Event Types for Economic Impacts",xlab="Event Types",
      ylab="Total (Property Damage + Crop Damage)")
topecon