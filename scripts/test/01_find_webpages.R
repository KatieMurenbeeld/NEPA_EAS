library(tidyverse)
library(rvest)

# Load the EA data csv
projs <- read.csv('/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/eas_proj_name_num_year.csv')

# Add columns for the "overview" project page and the "detail" project page

projs$overview <- NA
projs$detail <- NA

# Convert the PROJECT NUMBER to character string
projs$PROJECT.NUMBER <- as.character(projs$PROJECT.NUMBER)

### Testing out some really basic webscraping with rvest

test_detail <- read_html("https://www.fs.usda.gov/project/?project=57069&exp=detail")

test_detail %>% html_elements("p") %>% html_text2()

test_detail_df <- as.data.frame(test_detail %>%
                                  html_elements("p") %>%
                                  html_text2())

test_overview <- read_html("https://www.fs.usda.gov/project/?project=57069&exp=overview")

test_overview %>% html_elements("p") %>% html_text2()

test_overview_df <- as.data.frame(test_overview %>%
                                  html_elements("p") %>%
                                  html_text2())

# We already have a list of SOPA html

## Read in a link 
test_sopa <- read_html("https://www.fs.usda.gov/sopa/components/reports/sopa-110102-2007-01.html")

## Save to a table
test_sopa_df <- as.data.frame(test_sopa %>%
                                html_elements("table") %>%
                                html_table())

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

detail_test_urls <- output[[1]][1:500]
overview_test_urls <- output[[2]][1:500]

detail_h1 <- c()
overview_h1 <- c()
#body <- c()

for (url in detail_test_urls) {
  u <- url
  print(u)
  h1 <- read_html(u) %>% 
    html_element("h1") %>%
    html_text2()
  #bod <- read_html(u) %>% html_element("body") %>% html_text2() # returns "This portlet is unavailable."
  detail_h1 <- c(detail_h1, h1)
  #body <- c(body, bod)
  #detail_h1_out <- data.frame(detail_h1)
  #body_out <- data.frame(body)
}
detail_h1_out <- data.frame(detail_h1)
projs_500 <- data.frame(projs$PROJECT.NUMBER[1:500], projs$PROJECT.NAME[1:500], projs$calendarYearInitiated[1:500], detail_h1_out$detail_h1)

for (url in overview_test_urls) {
  u <- url
  print(u)
  h1 <- read_html(u) %>% 
    html_element("h1") %>%
    html_text2()
  #bod <- read_html(u) %>% html_element("body") %>% html_text2() # returns "This portlet is unavailable."
  overview_h1 <- c(overview_h1, h1)
  #body <- c(body, bod)
  #overview_h1_out <- data.frame(overview_h1)
  #body_out <- data.frame(body)
}

overview_h1_out <- data.frame(overview_h1)
projs_500 <- data.frame(projs$PROJECT.NUMBER[1:500], projs$PROJECT.NAME[1:500], projs$calendarYearInitiated[1:500], detail_h1_out$detail_h1)


