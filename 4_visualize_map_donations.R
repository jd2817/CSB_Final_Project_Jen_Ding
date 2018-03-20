#Part 4: Visualizes the donation contributions of candidate of interest on a map of the USA.
#The map will have dots representing where the donation came from, and the color of the dots represent the amount of the donation

#import packages
#!!!!!!!!need to install package zipcode and ggmap!!!!!!!!!!
library(zipcode)
library(ggmap)
library(tidyverse)


#read the text file of donation information and put it into master_list
#order master_list alphabetically by candidate, put into ordered_list
#!!!!!!!!!!need to set github project as working directory!!!!!!!!!!
master_list <- read.csv("master_list_all_files", header = TRUE)
ordered_list <- master_list[order(master_list$candidate), ]

#Get rid of extra symbols in the donation_amount column of ordered master list so donation amount can be turned into numeric
ordered_list$donation_amount <- sub("\\$" , "", ordered_list$donation_amount)
ordered_list$donation_amount <- gsub("\" ", "", ordered_list$donation_amount)
ordered_list$donation_amount <- gsub(",", "", ordered_list$donation_amount)

#Change donation_amounts to numeric. Change candidate names into characters. Get rid of middle initial of candidates
ordered_list$donation_amount <- as.numeric(ordered_list$donation_amount)
ordered_list$candidate <- as.character(ordered_list$candidate)
ordered_list$candidate <- sub("\\s\\w$" , "", ordered_list$candidate) #gets rid of middle initial

#Make a table of candidates and the total sum of donations they receive 
select(ordered_list, candidate, donation_amount)
candidate_stats_sum <- ordered_list %>% group_by(candidate) %>% summarise(donation_amount = sum(donation_amount)) 

#Make a table of candidates, sum their donations by zip codes 
select(ordered_list, candidate, donation_amount, donation_location)
candidate_stats_per_zip <- ordered_list %>% group_by(candidate, donation_location) %>% summarise(donation_amount = sum(donation_amount))

#filter by candidate whose donations you want to visualize 
#make donation_location as character 
filtered_by_candidate <- candidate_stats_per_zip %>% filter(candidate == "Feyen, Dan")
filtered_by_candidate$donation_location <- as.character(filtered_by_candidate$donation_location)

#get data that associates zip code with longitude and latitutde. This is necessary for mapping purposes
#merge files so that the candidate has their donations summed to zip codes and these zip codes are associated with their long. and lat.
names(filtered_by_candidate)[names(filtered_by_candidate) == 'donation_location'] <- 'zip'
data(zipcode)
filtered_by_candidate_merge <- merge(filtered_by_candidate, zipcode, by = 'zip')

#Use ggplot to make a map that shows locations of donations for selected candidate. Dots represent location where donation originated.
#Hue of the dot represents amount of donation. 
us <- map_data('state')
ggplot(filtered_by_candidate_merge, aes(longitude, latitude)) + 
  geom_polygon(data = us, aes(x=long, y=lat, group=group), color = 'black', fill = NA, alpha=.5) + 
  geom_point(aes(color = log10(donation_amount)), size =.8, alpha=.50) + xlim(-125, -65) +ylim(20,50)


