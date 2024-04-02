library(tidyverse)
library(rvest)
library(chromote)

pals <- read.csv(here::here("data/processed/pals-in-facts_2009.csv"))
facts_urls <- read.csv(here::here("data/processed/projects_pinyon_2009.csv"))

pinyon_urls <- facts_urls %>%
  filter(Pinyon_url != "no pinyon public link") %>%
  select(Pinyon_url, project_number)
pinyon_urls$project_number <- as.character(pinyon_urls$project_number)

pals$PROJECT.NUMBER <- as.character(pals$PROJECT.NUMBER)
pinyon_pals <- left_join(pinyon_urls, pals, by = c("project_number" = "PROJECT.NUMBER"))
pinyon_eas <- pinyon_pals %>%
  filter(DECISION.TYPE == "DN") 
min(pinyon_eas$calendarYearSigned)

pinyon_eis <- pinyon_pals %>%
  filter(DECISION.TYPE == "ROD")
min(pinyon_eis$calendarYearSigned)

pinyon_eas_urls <- pinyon_eas %>%
  filter(grepl("https://usfs-public.app.box.com/v", pinyon_eas[,1]) == TRUE)

pinyon_eis_urls <- pinyon_eis %>%
  filter(grepl("https://usfs-public.app.box.com/v", pinyon_eis[,1]) == TRUE)

## Use chromote as a headless browser with R to navigate to a url and click on the download button
### will need to find the x and y position of the download button
### within the console of the webpage developer (after right-click inspect or F12)
### use this java code to get a rough estimate of the x and y 
### it will add a little popup over your cursor that shows the x and y
### in this case the y (distance from top of page) is fairly constant despite the size of the browser window
### and x seems to be about 50 pixels from the right side of the browser window
####document.onmousemove = function(e){
####  var x = e.pageX;
####  var y = e.pageY;
####  e.target.title = "X is "+x+" and Y is "+y;
####};

### see the Chrome dev tools protocol especially the Page, Browser and Input domains 
#### https://chromedevtools.github.io/devtools-protocol/tot/Browser/

# Check number of zip files downloaded
length(list.files(here::here("data/original/NEPA_DOCS/")))
length(list.files(here::here("data/original/NEPA_DOCS/EISs")))

b <- ChromoteSession$new(wait_ = TRUE)
x <- 1650 # 50 pixels less than the width of the browser set in the for loop
y <- 100

for (i in pinyon_eis_urls[,1]) { # update index based on number of zip files downloaded.
  tmp <- b$new_session(width = 1700, height = 1800, wait_ = TRUE)
  # update download path for EIS documents
  tmp$Browser$setDownloadBehavior("allow", downloadPath = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS/EISs")
  tmp$Page$navigate(i)
  Sys.sleep(runif(1, 3, 4))
  tmp$Input$dispatchMouseEvent(type = "mousePressed", x = x, y = y, button="left", clickCount=1)
  tmp$Input$dispatchMouseEvent(type = "mouseReleased", x = x, y = y, button="left", clickCount=1)
}

