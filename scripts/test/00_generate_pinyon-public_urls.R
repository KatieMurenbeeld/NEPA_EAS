library(tidyverse)
library(rvest)
library(stringr)
library(httr)
library(RCurl)

options(timeout = 3600)

# Load the EA data csv
projs <- read.csv("~/scratch/nepa_eas/scripts/test/pals-in-facts_2009.csv")

# Convert the PROJECT NUMBER to character string
projs$PROJECT.NUMBER <- as.character(projs$PROJECT.NUMBER)

## Make a list of url links based on the project numbers

overview <- "https://www.fs.usda.gov/project/?project=PROJNUM&exp=overview"

# Create 2 empty lists
overview_urls <- c()
proj_nums <- c()

# create a list of the project numbers
nums <- projs$PROJECT.NUMBER

for(num in nums) {
  n <- num 
  # append to your empty lists
  overview_urls <- c(overview_urls, gsub('PROJNUM', n, overview))
  proj_nums <- c(proj_nums, n)
  # make lists into a dataframe
  output <- data.frame(proj_nums, overview_urls)
}


overview_2009_urls <- output[[2]]# update this index in increments of 500

## get the htmls available for each project
overview_2009_htmls <- c()
proj_names <- c()
proj_htmls <- c()
pinyon_list <- c()

for (url in overview_2009_urls) {
  u <- url
  print(u)
  names <- read_html(u) %>%
    html_elements("h1") %>%
    html_text2()
  if (is_empty(names)) {
    names <- "no project webpage"
    htmls <- character(0)
    pinyon <- "no pinyon public link"
  } else {
    names <- u
    htmls <- read_html(u) %>%
      html_elements("a") %>%
      html_attr("href")
    pinyon <- htmls[2]
  }
  proj_names <- c(proj_names, names)
  #str_remove_all(proj_names, "\r")
  proj_htmls <- c(proj_htmls, htmls)
  pinyon_list <- c(pinyon_list, pinyon)
}

df <- map2_dfr(pinyon_list, proj_names, ~ tibble(Pinyon_url = .x, Overview_url = .y))

write.csv(df, "~/scratch/nepa_eas/scripts/test/pinyon_url_list.csv")


























