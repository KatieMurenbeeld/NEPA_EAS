### Testing out RSelenium to download FS documents
### Using https://joshuamccrain.com/tutorials/web_scraping_R_selenium.html
### as a starting point

library(RSelenium)
library(tidyverse)
library(rvest)

#rD <- rsDriver(browser="chrome", port=4545L, verbose=FALSE)
#remDr <- rD[["client"]]

## Had to install Docker...

remDr <- rsDriver(
  port = 4445L
)

remDr$open()
