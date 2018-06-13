##Data Carpentry workshop 130618

#Loading libraries
library(tidyverse)
library(lubridate) #for date

#Download files
download.file("https://ndownloader.figshare.com/files/2292169", "data/portal_data_joined.csv")

#Read data into R
surveys<-read.csv("data/portal_data_joined.csv")
view(surveys)
head(surveys)
tail(surveys)
str(surveys)
dim(surveys)
nrow(surveys)
ncol(surveys)
names(surveys)
rownames(surveys)
summary(surveys)

#create a new variable that is a factor
sex<-factor(c("male","female","female","male"))
levels(sex)
nlevels(sex)

#change order of factors
lvls<-factor(c("high","medium","low"))
levels(lvls)
lvls<-factor(lvls, levels=c("low","medium","high")) #change the order of the factors (R orders alphabetically by default)

#make character instead of factor
as.character(lvls)  #data type characters instead of factors
year_fct <- factor(c(1988,1986))
#as.numeric(year_fct) #returns the position in the list, not what we want!
as.character(year_fct)#now characters, not factors
as.numeric(as.character(year_fct)) #now they are numeric
#other way to do it
as.numeric(levels(year_fct))
as.numeric(levels(year_fct))[year_fct]
#still another way
surveys<-read.csv("data/portal_data_joined.csv",stringsAsFactors=TRUE)
surveys<-read.csv("data/portal_data_joined.csv",stringsAsFactors=FALSE)
str(surveys)

#explore the data with simple plots
plot(surveys$sex)
sex<-surveys$sex
levels(sex)
#change the name of the factor, change first "empty" factor to undetermined
levels(sex)[1]<-"undetermined"
levels(sex)
plot(sex)
#rename F and M to female and male
levels(sex)[2]<-"female"
levels(sex)[3]<-"male"
plot(sex)
#put undetermined at the end of the plot
sex2<-sex
sex2<-factor(sex2, levels=c("female","male","undetermined"))
plot(sex2)

#Dates
my_date<-ymd("2015-01-01")
str(my_date) #date format
my_date<-ymd(paste("2015","1","1",sep="-"))

#make a date column in the dataset by combining the other 
surveys$date<-ymd(paste(surveys$year,surveys$month,surveys$day,sep="-"))
#we get a warning message: 129 failed to parse => something went wrong for 129 lines
is_missing_date<-is.na(surveys$date)  #check where the missing dates are => gives a boolean
missing_dates<-surveys[is_missing_date,c("year","month","day")]
missing_dates
#apparently the day is not missing, but there are only 30 days in these months, and we see 31!
head(missing_dates)
#so the data should need to be changed
