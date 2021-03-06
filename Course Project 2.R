library(knitr)
library(dplyr)

# Loading and preprocessing the data
data <- read.csv("E:/S/Coursera/DS-JHU/5Reproducible Research/Course Project 2/repdata-data-StormData.csv", header = T, sep=",")

data <- select(data,BGN_DATE,STATE, EVTYPE, FATALITIES, INJURIES, PROPDMG, PROPDMGEXP,CROPDMG,CROPDMGEXP)

dim(data)
head(data)
tail(data)
 
data$PROP <- 0
data$CROP <- 0
data$FI <- 0
data$CP <- 0
 
data$PROP <- ifelse(data$PROPDMG=="H" | data$PROPDMG=="h",data$PROPDMG*0.0000001,data$PROP)
data$CROP <- ifelse(data$CROPDMG=="H" | data$CROPDMG=="h",data$CROPDMG*0.0000001,data$CROP)

data$PROP <- ifelse(data$PROPDMG=="K" | data$PROPDMG=="k",data$PROPDMG*0.000001,data$PROP)
data$CROP <- ifelse(data$CROPDMG=="K" | data$CROPDMG=="k",data$CROPDMG*0.000001,data$CROP)

data$PROP <- ifelse(data$PROPDMG=="M" | data$PROPDMG=="m",data$PROPDMG*0.001,data$PROP)
data$CROP <- ifelse(data$CROPDMG=="M" | data$CROPDMG=="m",data$CROPDMG*0.001,data$CROP)

data$PROP <- ifelse(data$PROPDMG=="B" | data$PROPDMG=="b",data$PROPDMG*1,data$PROP)
data$CROP <- ifelse(data$CROPDMG=="B" | data$CROPDMG=="b",data$CROPDMG*1,data$CROP)

# Data Consolidating
data$PROPDMG = as.numeric(data$PROPDMG)
data$PROPDMGEXP = as.numeric(data$PROPDMGEXP)

data$CROPDMG = as.numeric(data$CROPDMG)
data$CROPDMGEXP = as.numeric(data$CROPDMGEXP)

data$FATALITIES = as.numeric(data$FATALITIES)
data$INJURIES = as.numeric(data$INJURIES)

data$CP <- data$PROP+data$CROP
data$FI <- data$FATALITIES+data$INJURIES

# Data Aggregating
health <- aggregate(FI~EVTYPE,data=data,sum)
damages <- aggregate(CP~EVTYPE,data=data,sum)

dim(health)
head(health)
tail(health)

dim(damages)
head(damages)
tail(damages)

library(ggplot2)

# 1. Across the United States, which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?
ggplot(health,aes(EVTYPE,FI))+geom_bar(stat="identity")+xlab("Event Types") + ylab("Fatalities and Injuries") + ggtitle("Top 5 Events That Are Most Harmful to Population Health")

# 2. Across the United States, which types of events have the greatest economic consequences?
ggplot(damages,aes(EVTYPE,CP))+geom_bar(stat="identity")+xlab("Event Types") + ylab("Property and Crop Damage") + ggtitle("Top 5 Events That Have the Greatest Economic Consequence")
