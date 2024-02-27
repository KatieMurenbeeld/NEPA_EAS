library(tidyverse)
library(rvest)
library(chromote)

facts_urls <- read.csv("data/processed/facts_url_3.csv")

pinyon_urls <- facts_urls %>%
  filter(pinyon_url != "no pinyon public link") %>%
  select(pinyon_url)

## Use chromote as a headless browser with R to navigate to a url and click on the download button
### will need to find the x and y position of the download button
### within the console of the webpage developer (after right-click inspect or F12)
### use this java code to get a rough estimate of the x and y 
####document.onmousemove = function(e){
####  var x = e.pageX;
####  var y = e.pageY;
####  e.target.title = "X is "+x+" and Y is "+y;
####};

### see the Chrome dev tools protocol especially the Page, Browser and Input domains 
#### https://chromedevtools.github.io/devtools-protocol/tot/Browser/

b <- ChromoteSession$new(wait_ = TRUE)
x <- 1650
y <- 100

for (i in pinyon_urls[1:3,]) {
  tmp <- b$new_session(width = 1700, height = 1800, wait_ = TRUE)
  tmp$Browser$setDownloadBehavior("allow", downloadPath = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS/")
  tmp$Page$navigate(i)
  Sys.sleep(runif(1, 3, 4))
  tmp$Input$dispatchMouseEvent(type = "mousePressed", x = x, y = y, button="left", clickCount=1)
  tmp$Input$dispatchMouseEvent(type = "mouseReleased", x = x, y = y, button="left", clickCount=1)
}

  
  
