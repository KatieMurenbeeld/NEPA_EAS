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
