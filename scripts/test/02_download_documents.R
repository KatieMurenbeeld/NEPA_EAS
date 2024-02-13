### Testing out RSelenium to download FS documents
### Using https://joshuamccrain.com/tutorials/web_scraping_R_selenium.html
### as a starting point

library(RSelenium)
library(tidyverse)
library(rvest)

#shell('docker run -d -p 4444:4444 --shm-size="2g" selenium/standalone-chrome:4.17.0-20240123')

# in R terminal: username$ docker pull selenium/standalone-chrome
remDr <- rsDriver(port = 4445L, browser = "chrome")

remDr$open()

remDr$navigate("https://www.fs.usda.gov/project/?project=57069&exp=overview")

## Had to install Docker...

remDr <- rsDriver(
  port = 4445L
)

remDr$open()


#### Testing from 01_find_webpages.R

# -----------------------
# New rvest testing see https://www.zenrows.com/blog/web-scraping-r#retrieve-html 
# retrieving the target web page 
document <- read_html("https://www.fs.usda.gov/project/?project=57069&exp=overview")

pin_doc <- read_html("https://usfs-public.app.box.com/v/PinyonPublic/folder/158109726766")

doc_html <- read_html("https://www.fs.usda.gov/project/?project=57069&exp=overview") %>% toString()

# selecting the list of product HTML elements 
html_products <- document %>% html_elements("a.item-link")

test <- document %>% html_elements("a") %>% html_attr("href")
test[c(2,7)]


html_divs <- document %>% html_elements("div") 

document %>% html_elements("iframe") 

pin_doc %>% html_element("iframe.")

pin_doc %>% html_nodes("iframe") %>% html_attr("src")

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
