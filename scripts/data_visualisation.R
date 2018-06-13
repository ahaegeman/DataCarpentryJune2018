#load libraries
library(tidyverse)

#download file
download.file("https://ndownloader.figshare.com/files/11930600?private_link=fe0cd1848e06456e6f38",
              "data/surveys_complete.csv")
#read file
surveys_complete<-read_csv("data/surveys_complete.csv")
#read_csv : is from tidyverse package, has some other settings than read.csv, for example strings are not automatically factors)

#plot with ggplot2
#if you split over multiple lines, end each line with a "plus" sign
ggplot(data=surveys_complete, aes(x=weight, y=hindfoot_length)) + geom_point()
