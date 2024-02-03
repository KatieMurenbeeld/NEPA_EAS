library(tidyverse)
library(rvest)

# Load the EA data csv
projs <- read.csv("/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/eas_proj_2009_purpose.csv")

# Filter out the grazing and mining
projs <- projs %>%
  filter(RG.Grazing.management...purpose == 1 | MG.Minerals.and.geology...purpose == 1)

# Add columns for the "overview" project page and the "detail" project page

projs$overview <- NA
projs$detail <- NA

# Convert the PROJECT NUMBER to character string
projs$PROJECT.NUMBER <- as.character(projs$PROJECT.NUMBER)

## Make a list of url links based on the project numbers

overview <- "https://www.fs.usda.gov/project/?project=PROJNUM&exp=overview"
detail <- "https://www.fs.usda.gov/project/?project=PROJNUM&exp=detail"

# Create 2 empty lists
detail_urls <- c()
overview_urls <- c()

# create a list of the project numbers
nums <- projs$PROJECT.NUMBER

for(num in nums) {
  n <- num 
  # append to your empty lists
  detail_urls <- c(detail_urls, gsub('PROJNUM', n, detail))
  overview_urls <- c(overview_urls, gsub('PROJNUM', n, overview))
  # make lists into a dataframe
  output <- data.frame(detail_urls, overview_urls)
}

detail_2009_h1 <- c() # do not remake, want to keep appending to this list
overview_2009_h1 <- c() # do not remake, want to keep appending to this list

detail_2009_urls <- output[[1]][1:500] # update this index in increments of 500
overview_2009_urls <- output[[2]][1:500] # update this index in increments of 500

for (url in detail_2009_urls) {
  u <- url
  print(u)
  h1 <- read_html(u) %>% 
    html_element("h1") %>%
    html_text2()
  detail_2009_h1 <- c(detail_2009_h1, h1)
}

detail_h1_out <- data.frame(detail_2009_h1)
projs_500 <- data.frame(projs$PROJECT.NUMBER[1:500], projs$PROJECT.NAME[1:500], projs$calendarYearInitiated[1:500], detail_h1_out$detail_2009_h1)
write.csv(projs_500, "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/projs_500_2009_h1.csv")
projs_1000 <- data.frame(projs$PROJECT.NUMBER[1:1000], projs$PROJECT.NAME[1:1000], projs$calendarYearInitiated[1:1000], detail_h1_out$detail_h1)

detail_2009_h1_out <- data.frame(detail_2009_h1)

for (url in overview_2009_urls) {
  u <- url
  print(u)
  h1 <- read_html(u) %>% 
    html_element("h1") %>%
    html_text2()
  overview_2009_h1 <- c(overview_2009_h1, h1)
}

overview_2009_h1_out <- data.frame(overview_2009_h1)
projs_500 <- data.frame(projs$PROJECT.NUMBER[1:500], projs$PROJECT.NAME[1:500], 
                        projs$calendarYearInitiated[1:500], detail_h1_out$detail_h1,
                        overview_h1_out$overview_h1)
projs_1000 <- data.frame(projs$PROJECT.NUMBER[1:1000], projs$PROJECT.NAME[1:1000], 
                        projs$calendarYearInitiated[1:1000], detail_h1_out$detail_h1,
                        overview_h1_out$overview_h1)

#projs_2009_all <- 

# -----------------------
# New rvest testing see https://www.zenrows.com/blog/web-scraping-r#retrieve-html 
# retrieving the target web page 
document <- read_html("https://www.fs.usda.gov/project/?project=57069&exp=overview")

# selecting the list of product HTML elements 
html_products <- document %>% html_elements("a.item-link")

document %>% html_elements("a") %>% html_attr("href")

html_divs <- document %>% html_elements("div") 

document %>% html_elements("iframe") 

document %>% html_elements("html") %>% html_attrs("href")

document %>% html_elements("div.item-name")

document %>% html_nodes(xpath = '//*[@id="contextmenutarget16"]/div/div[2]/div/div[1]/div[1]/div')

document %>% html_nodes(xpath = '/html/body/div[1]/div[5]/span/div/main/div/div/div[2]/div/div[2]/div/div/div[1]/div/div/div[2]/div/div[1]/div/div[2]/div/div[1]/div[1]/div/a')
