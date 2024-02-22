### Testing out RSelenium to download FS documents
### Using https://joshuamccrain.com/tutorials/web_scraping_R_selenium.html
### as a starting point

library(RSelenium)
library(tidyverse)
library(rvest)
library(chromote)
library(selenider)

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

########## Breadcrumb: test with RSelenium #####

#rD <- rsDriver(browser = "chrome",
#               chromever = 121.0.6167.139)

######## Breadcrumb: rvest with live html (chromote) ####

facts_urls <- read.csv("data/processed/facts_url_3.csv")

pinyon_urls <- facts_urls %>%
  filter(pinyon_url != "no pinyon public link") %>%
  select(pinyon_url)

s <- session(pinyon_urls[1,])

# Need to download rvest from developer? read_html_live() is experimental
sess <- read_html_live(pinyon_urls[1,])

b <- ChromoteSession$new()

b$Page$navigate(pinyon_urls[1,])

b$Browser$setDownloadBehavior(behavior = "allow", 
                              downloadPath = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS/")

x <- b$DOM$getDocument()

x = 160 ## horizontal X coordinate of the button relative to the main frame's viewport in CSS pixels; 
y = 40 ## vertical Y coordinate of the buttonrelative to the main frame's viewport in CSS pixels. 0 refers to the top of the viewport and Y increases as it proceeds towards the bottom of the viewport;

b$Input$dispatchMouseEvent(type = "mousePressed", x = x, y = y, button="left", clickCount=1) # clickCount=Number of times the mouse button was clicked, 1= normal click, 2 = double-click
b$Input$dispatchMouseEvent(type = "mouseReleased", x = x, y = y, button="left", clickCount=1) # see: https://chromedevtools.github.io/devtools-protocol/tot/Input/#method-dispatchMouseEvent


####### Testing out selenider #####

open_url(pinyon_urls[1,])

s(css = '*') %>%
  find_elements("button") %>%
  elem_find(has_text("bulkdownload")) %>%
  elem_click(js=TRUE, timeout=60)
  
  
  
  
  
