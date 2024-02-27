### Testing out RSelenium to download FS documents
### Using https://joshuamccrain.com/tutorials/web_scraping_R_selenium.html
### as a starting point

library(tidyverse)
library(rvest)
library(chromote)


######## Breadcrumb: rvest with live html (chromote) ####

facts_urls <- read.csv("data/processed/facts_url_3.csv")

pinyon_urls <- facts_urls %>%
  filter(pinyon_url != "no pinyon public link") %>%
  select(pinyon_url)


####This Code Worked!!!#####

b <- ChromoteSession$new(wait_ = TRUE)
b1 <- b$new_session(width = 1700, height = 1800, wait_ = TRUE)
b1$Browser$setDownloadBehavior("allow", downloadPath = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS/")
x <- 1650
y <- 100
Sys.sleep(runif(1, 3, 4))

for (i in pinyon_urls[1:3,]) {
  print(i)
}

for (i in pinyon_urls[1:3,]) {
  b1$Page$navigate(i)
  Sys.sleep(runif(1, 3, 4))
  b1$Input$dispatchMouseEvent(type = "mousePressed", x = x, y = y, button="left", clickCount=1)
  b1$Input$dispatchMouseEvent(type = "mouseReleased", x = x, y = y, button="left", clickCount=1) # see: https://chromedevtools.github.io/devtools-protocol/tot/Input/#method-dispatchMouseEvent
}
####^^The code above worked!!!!^^##

# Need to download rvest from developer? read_html_live() is experimental
## It was updated!!
sess <- read_html_live("https://usfs-public.app.box.com/v/PinyonPublic/folder/246700028568")
#sess$view()

test <- sess %>% html_elements(".base-button-module_button__TsfJa.base-button-module_secondary__sRO2F")
test[1]
test[2]

sess$click(test[2])

b <- ChromoteSession$new()

b$Page$navigate(pinyon_urls[1,])

b$Browser$setDownloadBehavior(behavior = "allow", 
                              downloadPath = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS/")

x <- b$DOM$getDocument()

x = 160 ## horizontal X coordinate of the button relative to the main frame's viewport in CSS pixels; 
y = 40 ## vertical Y coordinate of the buttonrelative to the main frame's viewport in CSS pixels. 0 refers to the top of the viewport and Y increases as it proceeds towards the bottom of the viewport;

b$Input$dispatchMouseEvent(type = "mousePressed", x = x, y = y, button="left", clickCount=1) # clickCount=Number of times the mouse button was clicked, 1= normal click, 2 = double-click
b$Input$dispatchMouseEvent(type = "mouseReleased", x = x, y = y, button="left", clickCount=1) # see: https://chromedevtools.github.io/devtools-protocol/tot/Input/#method-dispatchMouseEvent
  
  
  
