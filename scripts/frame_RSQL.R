
#---- R and SQL ----
  
# Installing new packages ----
#install.packages("dbplyr")
#install.packages("RSQLite") 

#Load the libraries ----
library(dplyr)
library(dbplyr)
library(DBI)
library(RSQLite)

#download data ----
download.file(url = "https://ndownloader.figshare.com/files/2292171",
              destfile = "data/portal_mammals.sqlite", mode = "wb")

#create connection to the sqlite database ----
# the RSQLite package allows R to interface with SQLite databases.
#Important: this SQLite function does not load the data into the R session, this saves memory!
?dbConnect
DBConnection <-DBI::dbConnect(RSQLite::SQLite(),
                              "data/portal_mammals.sqlite")
str(DBConnection)

#looing into DBConnection
?src_dbi
dbplyr::src_dbi(DBConnection)

#interacting with tables
?tbl
surveys <- dplyr::tbl(DBConnection,"surveys")
species <- dplyr::tbl(DBConnection,"species")
plots <- dplyr::tbl(DBConnection,"plots")
#now surveys and species and plots are LISTS that point to the SQL databases

#you can use some of the commands, but not all
head(surveys)
nrow(surveys) #number of rows cannot be calculated because the full database is not in memory!
#but we CAN use the functions learned in the tidyverse lesson
surveys %>%
  filter(year==2002,weight>220)
#store as data frame, now you can actually see all data in your environment
surveys2002 <- surveys %>%
  filter (year == 2002) %>%
  as.data.frame()
#show the SQL command behind it
show_query(surveys %>%
             filter (year == 2002))
#mutate function: SELECT weight as mean.weight
#write a dplyr mutate on surveys to add a column with the weight in kg
surveys %>%
  mutate(weigth_kg=weight/1000)
show_query(surveys %>%
             mutate(weigth_kg=weight/1000))

#plot
library(ggplot2)
ggplot(data = surveys2002, aes(weight, colour = "red")) +
  stat_density(geom = "line", size = 2, position = "identity") +
  theme_classic() +
  theme(legend.position = "none")

#now do this in one step
surveys %>%
  filter (year == 2002) %>%
  as.data.frame() %>%
  ggplot(aes(weight, colour = "red")) +
  stat_density(geom = "line", size = 2, position = "identity") +
  theme_classic() +
  theme(legend.position = "none")

#save the surveys2002 to a csv file
write_csv(surveys2002,path="data/surveys2002.csv")
