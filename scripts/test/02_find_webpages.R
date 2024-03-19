library(tidyverse)
library(rvest)
library(stringr)
library(RSelenium)
library(httr)
library(RCurl)

options(timeout = 3600)

# Load the EA data csv
#projs <- read.csv("/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/eas_proj_01-2009_03-2023_purpose.csv")
projs <- read.csv("/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/pals-in-facts_2009.csv")

# Filter out the grazing and mining
#projs <- projs %>%
#  filter(TM.Forest.products...purpose == 1 | HF.Fuels.management...purpose == 1 | VM.Vegetation.management..non.forest.products....purpose == 1)

# Add columns for the "overview" project page and the "detail" project page

#projs$overview <- NA

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
  overview_urls <- c(overview_urls, gsub('PROJNUM', n, overview))
  proj_nums <- c(proj_nums, n)
  # make lists into a dataframe
  output <- data.frame(proj_nums, overview_urls)
  #output <- data.frame(output)
}
#output <- data.frame(output)

overview_2009_urls <- output[[2]]# update this index in increments of 500

## get the htmls available for each project
overview_2009_htmls <- c()
proj_names <- c()
proj_htmls <- c()
pinyon_list <- c()


for (url in overview_2009_urls[2001:3000]) {
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

write.csv(df, here::here("data/processed/pinyon_url_list.csv"), append = TRUE)

#pinyon_list_1_1000 <- pinyon_list
#pinyon_list_1001_2000 <- pinyon_list

output$proj_url <- proj_names
output$pinyon_url <- pinyon_list

## Join the output data frame to the projs data frame by project number
proj_url_df <- left_join(projs, output, by = c("PROJECT.NUMBER" = "proj_nums"))

## Save df to csv
#write_csv(proj_url_df, "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/project_url.csv")
proj_url_df <- read.csv("/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/project_url.csv")
proj_url_df$PROJECT.NUMBER <- as.character(proj_url_df$PROJECT.NUMBER)

## Read in the PALS-FACTS csv
pals_facts <- read.csv("/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/df_pals_comm_NEPA_init_2009_2018_noneg_allpurp_v02_c20221208.csv")

pals_facts$NEPA_DOC_NBR <- as.character(pals_facts$NEPA_DOC_NBR)

## Join to url data frame
url_2_facts <- left_join(proj_url_df, pals_facts, by = c("PROJECT.NUMBER" = "NEPA_DOC_NBR"))
facts_2_url <- left_join(pals_facts, proj_url_df, by = c("NEPA_DOC_NBR" = "PROJECT.NUMBER"))

facts_df <- url_2_facts %>%
  select(PROJECT.NUMBER, PROJECT.NAME.x, LMU...REGION, overview_urls, proj_url, pinyon_url, FOREST_ID, PROJECT.STATUS.x,
         PROJECT.CREATED, INITIATION.DATE, DECISION.SIGNED, DECISION.TYPE, APPEALED.OR.OBJECTED., LITIGATED., 
         ELAPSED.DAYS, calendarYearInitiated.x, calendarYearSigned, NEPA_SIGNED_DATE, H, E, D, DATE_COMP_MIN, 
         DATE_COMP_MAX, PERCENT_PROJ_COMP, DATE_AWARD_MIN, DATE_AWARD_MAX, PROJECT_DUR_PLAN_YR, TOT_AREA_PLAN,
         NBR_ACTIVITIES, FIRE, RANGE, REC, TIMBER, SAW, WILDLIFE, RESTORE, MISC, ENGI, PROJ_RICHNESS, PROJ_DIVERSE, 
         PROJ_EVENNESS)

# Save df to csv
write_csv(facts_df, "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/facts_url_3.csv")

facts_sub_df <- facts_df %>%
  filter(proj_url != "no project webpage")

