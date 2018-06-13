##Data Carpentry workshop 130618

#Loading libraries
library(tidyverse)

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