library(tidyverse)

surveys<-read_csv("data/portal_data_joined.csv")
str(surveys)

#select specific columns
select(surveys, plot_id, species_id, weight)

#filter
filter(surveys,year==1995)

#select animals weighing less than 5g in different ways, and only keep columns you are interested in
#way1
surveys2<-filter(surveys,weight<5)
surveys_sml<-select(surveys2, species_id, sex, weight)
#way2: drawback is that if you do multiple things, it becomes hard to read
surveys_sml<-select(filter(surveys,weight<5), species_id, sex, weight)
#way3: by using pipes
surveys_sml<- surveys %>% 
  filter(weight < 5) %>%
  select(species_id,sex,weight)

#using pipes, subset the surveys data to include only individuals collected before 1995 and retain only the columns year, sex and weight
surveys_subset<- surveys %>% 
  filter(year < 1995) %>%
  select(year,sex,weight)

#mutate command to change values in your data
surveys %>%
  mutate(weight_kg=weight/1000)
#you can add multiple columns
surveys %>%
  mutate(weight_kg=weight/1000,
         weight_kg2 = weight_kg*2)
#you can add multiple columns and then use it again to select columns
surveys %>%
  mutate(weight_kg=weight/1000,
         weight_kg2 = weight_kg*2) %>%
  select(year, weight, weight_kg, weight_kg2) %>%
  tail()

#create a new data frame from the surveys data that contains only the species_id columns and hindfoot_half, which has half the hindfoot_length values.
#In this column there should be no NAs and all values are less than 30
surveys %>%
  #filter(hindfoot_length != 'NA') %>%
  filter(!is.na(hindfoot_length)) %>%
  mutate(hindfoot_half = hindfoot_length/2) %>%
  filter (hindfoot_half < 30)
  select(species_id,hindfoot_half)

  
#now also use the group_by operator to group your data and then to some commands on all the groups
#calculate mean weight per sex and species_id
surveys %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight=mean(weight,na.rm=TRUE)) %>%
  tail()
#note thate some entries have a NaN number. it is because the group by is done first, and for these entries the sex or the species_id is missing 
#best to remove the NA's before the calculation
summarized_surveys<-surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight=mean(weight,na.rm=TRUE)) %>%
  tail()
#you can also add some extra filters to filter out NA values from sex and species_id

#write to table
write_csv(summarized_surveys,path="plots/summarized_surveys_sex_species_wieght.csv")