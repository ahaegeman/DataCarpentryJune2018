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
#scatterplot
ggplot(data=surveys_complete, aes(x=weight, y=hindfoot_length)) + geom_point()
#data is overplotted, set alpha (set transparency level of points)
ggplot(data=surveys_complete, aes(x=weight, y=hindfoot_length)) + geom_point(alpha=0.1)
#color
ggplot(data=surveys_complete, aes(x=weight, y=hindfoot_length)) + geom_point(alpha=0.1,color="blue")
#color by a variable, this should be within aesthetic. In most cases it does not matter if you put it in the general aesthetic or not. 
#But if you add extra plots, for example geom_plot and geom_line, then it is best to add aesthetic to each plot seperately.
#if you add it in the general, it is applied to all plots
ggplot(data=surveys_complete, aes(x=weight, y=hindfoot_length)) + 
  geom_point(alpha=0.1,aes(color=species_id))
#Use what you just learned to create a scatter plot of weight (y-axis) over species_id (x-axis) with the plot types showing in different colors. 
#Is this a good way to show this type of data? No, better to use a box plot.
ggplot(data=surveys_complete, aes(x=species_id, y=weight)) + 
  geom_boxplot() +
  geom_jitter(alpha=0.3, color="tomato") #jitter plots dots onto the boxplot, alpha gives transparency
#now the boxplots are not visible. ggplot plot things in the order you give it, so first plot the points, only then the boxplots.
ggplot(data=surveys_complete, aes(x=species_id, y=weight)) + 
  geom_jitter(alpha=0.3, aes(color=plot_id)) +
  geom_boxplot()
#color by plot ID is a color scale because the class of the plot_id is a collector_character, we should change it to factor
surveys_complete$plot_id<-factor(surveys_complete$plot_id)
ggplot(data=surveys_complete, aes(x=species_id, y=weight)) + 
  geom_jitter(alpha=0.3, aes(color=plot_id)) +
  geom_boxplot()
#replace the boxplot with a violin plot
ggplot(data=surveys_complete, aes(x=species_id, y=weight)) + 
  geom_jitter(alpha=0.3, aes(color=plot_id)) +
  geom_violin()
#set a log10 scale to weight
ggplot(data=surveys_complete, aes(x=species_id, y=weight)) + 
  geom_jitter(alpha=0.3, aes(color=plot_id)) +
  scale_y_log10() +
  geom_violin()
#boxplot for hindfoot_length
ggplot(data=surveys_complete, aes(x=species_id, y=hindfoot_length)) + 
  geom_jitter(alpha=0.3, aes(color=plot_id)) +
  geom_boxplot()

#create new object
yearly_count <- surveys_complete %>%
  group_by(year,species_id) %>%
  tally()
head(yearly_count)

#check number of observarions per species
ggplot(data=yearly_count,aes(x=year,y=n, group=species_id, color=species_id)) +
  geom_line()
#check number of observarions per species, give them a different color
ggplot(data=yearly_count,aes(x=year,y=n, color=species_id)) +
  geom_line()
#not very clear, we would like to split it into smaller graphs using facet_wrap
ggplot(data=yearly_count,aes(x=year,y=n)) +
  geom_line() +
  facet_wrap(~species_id)

#check number of observations per sex
yearly_sex_counts <- surveys_complete %>%
  group_by(year, species_id, sex) %>%
  tally()
#plot
ggplot(data=yearly_sex_counts, aes(x=year,y=n,color=sex)) +
  geom_line() +
  facet_wrap(~species_id)  


#controlling aesthetics data
#remove background by changing themes
ggplot(data=yearly_sex_counts, aes(x=year,y=n,color=sex)) +
  geom_line() +
  facet_wrap(~species_id) +
  theme_bw() +
  theme(panel.grid=element_blank(), 
        text=element_text(size=16),
        axis.text.x = element_text(color="grey20",size=12,angle=90, hjust=0.5)) +
  labs(title="Observed species over time",x = "Year of observation", y="Number of observations") #also add some labels
  
#create your own theme
grey_theme<-theme(panel.grid=element_blank(), 
                  text=element_text(size=16),
                  axis.text.x = element_text(color="grey20",size=12,angle=90, hjust=0.5))
ggplot(data=yearly_sex_counts, aes(x=year,y=n,color=sex)) +
  geom_line() +
  facet_wrap(~species_id) +
  theme_bw() +
  grey_theme +  #now use your own created theme
  labs(title="Observed species over time",x = "Year of observation", y="Number of observations")

#save plot to an object
my_plot<-ggplot(data=yearly_sex_counts, aes(x=year,y=n,color=sex)) +
  geom_line() +
  facet_wrap(~species_id) +
  theme_bw() +
  labs(title="Observed species over time",x = "Year of observation", y="Number of observations")
my_plot + grey_theme

#save your plot
ggsave(("plots/my_first_plot.png"), my_plot, widt=15, height=10, dpi=300)
