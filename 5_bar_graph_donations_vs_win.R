#Part 5. Makes bar graphs showing campaign donation amounts to the winning candidate and the losing candidate. 
#This file will merge information from the text files containing donation information with the text files containing
#information for the winning candidates and losing candidates. Only the seats with both a winning and a losing candidate will be visualized. 
#This means that uncontested seats are left out of this graph. 

#import packages 
library(tidyverse)
library(ggplot2)

#need to set github project as working directory!!!! 
#read the text files of winner and loser dictionaries. Read the master list of all the donation amounts for all candidates.
winner_list <- read.csv("winner_dict.csv", header = FALSE)
loser_list <- read.csv("loser_dict.csv", header = FALSE)
master_list <- read.csv("master_list_all_files", header = TRUE)
ordered_list <- master_list[order(master_list$candidate), ]

#Get rid of extra symbols in the donation_amount column of ordered master list so donation amount can be turned into numeric
ordered_list$donation_amount <- sub("\\$" , "", ordered_list$donation_amount)
ordered_list$donation_amount <- gsub("\" ", "", ordered_list$donation_amount)
ordered_list$donation_amount <- gsub(",", "", ordered_list$donation_amount)

#Change donation_amounts to numeric. Change candidate names into characters. Get rid of middle initial of candidates to 
#match the name pattern of winner and loser lists
ordered_list$donation_amount <- as.numeric(ordered_list$donation_amount)
ordered_list$candidate <- as.character(ordered_list$candidate)
ordered_list$candidate <- sub("\\s\\w$" , "", ordered_list$candidate) #gets rid of middle initial

#Make a table of candidates and the total sum of donations they receive 
select(ordered_list, candidate, donation_amount)
candidate_stats_sum <- ordered_list %>% group_by(candidate) %>% summarise(donation_amount = sum(donation_amount)) 

#Get rid of the extra punctuations in the candidate names in winner list. Rename column "V2" to "candidate". 
#Make another column called type, and specify every entry with "winning_candidate".
colnames(winner_list)[2] <- "candidate"
winner_list$candidate <- sub("\\[", "", winner_list$candidate)
winner_list$candidate <- sub("\\'", "", winner_list$candidate)
winner_list$candidate <- sub("\\]", "", winner_list$candidate)
winner_list$candidate <- sub("\\'", "", winner_list$candidate)
winner_list$type <- "winning_candidate"

#Get rid of the extra punctuations in the candidate names in loser list. Rename column "V2" to "candidate". 
#Make another column called type, and specify every entry with "losing_candidate".
colnames(loser_list)[2] <- "candidate"
loser_list$candidate <- gsub("SCATTERING", "", loser_list$candidate)
loser_list$candidate <- sub("\\[", "", loser_list$candidate)
loser_list$candidate <- gsub("\\'", "", loser_list$candidate)
loser_list$candidate <- substr(loser_list$candidate, 1, nchar(loser_list$candidate)-5)
loser_list$candidate <- str_match(loser_list$candidate, "\\w+[[:punct:]]\\s\\w+")
loser_list$type <- "losing_candidate" 

#merge winner_list with candidate_stats_sum to yield table with winner names with associated donations
winner_total <- merge(winner_list, candidate_stats_sum, by = "candidate")

#merge loser_list with candidate_stats_sum to yield table with loser names with associated donations
loser_total <- merge(loser_list, candidate_stats_sum, by = "candidate")

#merge winner_total and loser_total to get information on which seats had more than 1 person running for it. I 
#want to get rid of the entries for seats that were uncontested (only had 1 person running for them).
results_total <- merge(winner_total, loser_total, by = "V1")


#isolate information about the winning candidate, type, and donation amount 
results_w <- (results_total)
results_w$candidate.y <- NULL
results_w$type.y <- NULL
results_w$donation_amount.y <- NULL
colnames(results_w)[2] <- "candidate"
colnames(results_w)[3] <- "type"
colnames(results_w)[4] <- "donation_amount"

#isolate information about the losing candidate, type, and donation amount 
results_l <- results_total
results_l$candidate.x <- NULL
results_l$type.x <- NULL
results_l$donation_amount.x <- NULL
colnames(results_l)[2] <- "candidate"
colnames(results_l)[3] <- "type"
colnames(results_l)[4] <- "donation_amount"

#want to make 1 list containing candidate, type (winning_candidate or losing_candidate), and donation_amount 
results_total_final <- rbind(results_w, results_l)

#plot the data that is grouped by position in the government the candidates are running for. 
#for each position, orange indicates the losing_candidate and how much donations he/she received. 
#turquoise is for winning_candidate and how much donations he/she recived. 
ggplot(data=results_total_final, aes(x= V1, y = donation_amount,  fill=factor(type))) +
  geom_bar(stat="identity", position=position_dodge(width=.8)) + 
  coord_flip() + ggtitle("Donation Amounts to Winning and Losing Candidates for Each Office") +
  scale_y_continuous(limits = c(0, 250000), expand = c(0, 0)) + 
  theme(text = element_text(size = 8), panel.grid.major.x = element_line(size = .2, color = "black"), panel.grid.major.y = element_blank()) 
 

