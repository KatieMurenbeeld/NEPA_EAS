library(tidyverse)
library(rvest)
library(stringr)
library(RSelenium)
library(httr)
library(RCurl)

# Load the EA data csv
projs <- read.csv("/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/eas_proj_2009_purpose.csv")

# Filter out the grazing and mining
projs <- projs %>%
  filter(TM.Forest.products...purpose == 1 | HF.Fuels.management...purpose == 1 | VM.Vegetation.management..non.forest.products....purpose == 1)

# Add columns for the "overview" project page and the "detail" project page

projs$overview <- NA

# Convert the PROJECT NUMBER to character string
projs$PROJECT.NUMBER <- as.character(projs$PROJECT.NUMBER)

## Make a list of url links based on the project numbers

overview <- "https://www.fs.usda.gov/project/?project=PROJNUM&exp=overview"
#detail <- "https://www.fs.usda.gov/project/?project=PROJNUM&exp=detail"

# Create 2 empty lists
#detail_urls <- c()
overview_urls <- c()
proj_nums <- c()

# create a list of the project numbers
nums <- projs$PROJECT.NUMBER

for(num in nums) {
  n <- num 
  # append to your empty lists
  #detail_urls <- c(detail_urls, gsub('PROJNUM', n, detail))
  overview_urls <- c(overview_urls, gsub('PROJNUM', n, overview))
  proj_nums <- c(proj_nums, n)
  # make lists into a dataframe
  #print(n)
  output <- data.frame(proj_nums, overview_urls)
  #output <- data.frame(output)
}
output <- data.frame(output)

#detail_2009_h1 <- c() # do not remake, want to keep appending to this list
overview_2009_h1 <- c() # do not remake, want to keep appending to this list

#detail_2009_urls <- output[[1]][1:50] # update this index in increments of 500
overview_2009_urls <- output[[2]][1:5] # update this index in increments of 500

## get the htmls available for each project
overview_2009_htmls <- c()
proj_names <- c()
proj_htmls <- c()
name_html <- c()
pinyon_list <- c()


for (url in overview_2009_urls) {
  u <- url
  print(u)
  names <- read_html(u) %>%
    html_elements("h1") %>%
    html_text2()
  if (is_empty(names)) {
    names <- "no project page"
    #htmls <- character(0)
  } else {
    names <- names
    htmls <- read_html(u) %>%
      html_elements("a") %>%
      html_attr("href")
    pinyon <- htmls[2]
  }
 # htmls <- read_html(u) %>% 
  #  html_elements("a") %>%
  #  html_attr("href")
  #pinyon <- htmls %>%
  #  html_elements("href") 
  #print(pinyon)
  #If the page exists we want the 1st link (second element [2]) which is the pinyon public folder
  #print(htmls)
  proj_names <- c(proj_names, names)
  proj_htmls <- c(proj_htmls, htmls)
  pinyon_list <- c(pinyon_list, pinyon)
  name_html <- c(name_html, names, htmls)
  test <- cbind(name_html)
  overview_2009_htmls <- c(overview_2009_htmls, names, htmls)
}

test_df <- data.frame(test)
test_htmls <- data.frame(overview_2009_htmls)


test <- test_htmls %>% 
  pivot_wider()

test_names <- data.frame(proj_names)
htmls_2009 <- data.frame(proj_names, overview_2009_htmls)

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

for (url in overview_2009_urls)

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

doc_html <- read_html("https://www.fs.usda.gov/project/?project=57069&exp=overview") %>% toString()

# selecting the list of product HTML elements 
html_products <- document %>% html_elements("a.item-link")

test <- document %>% html_elements("a") %>% html_attr("href")
test[c(2,7)]


html_divs <- document %>% html_elements("div") 

document %>% html_elements("iframe") 

document %>% html_elements("html") %>% html_attrs("href")

document %>% html_elements("div.item-name")

document %>% html_elements("button")

document %>% html_nodes(xpath = '//*[@id="contextmenutarget16"]/div/div[2]/div/div[1]/div[1]/div')

document %>% html_nodes(xpath = '/html/body/div[1]/div[5]/span/div/main/div/div/div[2]/div/div[2]/div/div/div[1]/div/div/div[2]/div/div[1]/div/div[2]/div/div[1]/div[1]/div/a')

document %>% html_elements("body")

document %>% html_element(xpath = '/html/body/div[1]/div/div/div/div/div/div/div/div/div[1]/div/main/div[1]/iframe')

document %>% html_elements("svg")

iframe <- document %>% html_elements("iframe")

# copy element: <a data-resin-folder_id="159108591507" data-resin-target="openfolder" class="item-link item-link " href="/s/2p4nq5j0n58ftr5jiu64xzux16n0rkgn/folder/159108591507">Decision</a>
# copy selector:  #contextmenutarget372 > div > div.ReactVirtualized__Table__rowColumn.file-list-name > div > div.item-name-holder > div.name-row > div > a
# JS path: document.querySelector("#contextmenutarget372 > div > div.ReactVirtualized__Table__rowColumn.file-list-name > div > div.item-name-holder > div.name-row > div > a")


# Just the link to the documents on pinyon public xpath //*[@id="centercol"]/p[5]/a

doc_html %>% str_match("iframe")

doc_text <- document %>% html_text2()

# ------------------------------------
# bread crumb: test with RSelenium

rD <- rsDriver(browser = "chrome",
              chromever = 121.0.6167.139)


