# CSB_Final_Project_Jen_Ding
Final project 

Elections are the bedrock of our democracy. Because of their significance, there is substantial manpower put into analyzing voting trends and how they are influenced. The last 2016 general election contained a lot of surprises (and grief), so I was interested in looking at how voting patterns are influenced by campaign contributions. 

I was originally motivated to look at purple states that swung unexpectedly red in the presidential election. This motivation came from the desire to make some sense of our current madness. First, I looked online at the governmental websites of swing states like Wisconsin, Virginia, Pennsylvania, etc., to see if there were accessible, clean public databases keeping track of campaign donations. Wisconsin's state website was a great resource. I wanted to look all of the contributions between Nov 2015 - Nov 2016. The total number of donations in this period was over 46,000. 

My first python script (1_extract_campaign_finance_data) extracts the data from the Wisconsin campaign contribution website and stores it in individual html files, with each html file containing the information for 100 donations. Therefore, I have downloaded over 460 html files.  

My second python script (2_extract_campaign_donations.ipynb) extracts information from all of the ~460 html files and stores them in a masterlist text file (master_list_all_files). With regular expressions and BeautifulSoup, I extract the information for the candidate the donation went to, the zip code where the donation is coming from, and the amount of the donation. Therefore, the masterlist text file contains 3 columns. I will include this masterlist in the data folder on this github. 

My third python script (3_extract_candidate_results) will make 2 separate text files containing information for the candidates that won their race and the position that they won (winner_dict) and the candidates that lost their race (loser_dict). In order to do this, I downloaded a spreadsheet from the Wisconsin governmental website with all of the results of the races. I scraped the information from these files and put them into two separate text files. 

My R scripts will help visualize the results. The first one (4_visualize_map_donations) will make a modified heat map of the United States, where the dots will show the origin of the donation, and the color of the dots will represent the amount donated. You will be able to specify which Wisconsin candidate you are interested and visualize where their donations are coming from. ###PLEASE set working directory to the downloaded github project folder and install packages 'zipcode' and 'ggmap' if not on your RStudio!####

The second R script (5_bar_graph_donations_vs_win) will visualize if there is any correlation between the total sum of the donations to the candidates and the candidate's chances of winning. For example, do more donations always mean electoral success? The final bar graph shows the vast majority of candidates who recieve more donations win their seat, but there are a few outliers where the losing candidate receive more donations. ###Please set working directory to the downloaded github project folder###


 
