library(tidyverse)
library(rvest)

# Load the EA data csv
projs <- read.csv("/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/eas_proj_2009_purpose.csv")

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

detail_h1_out <- data.frame(detail_h1)
projs_500 <- data.frame(projs$PROJECT.NUMBER[1:500], projs$PROJECT.NAME[1:500], projs$calendarYearInitiated[1:500], detail_h1_out$detail_h1)
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
