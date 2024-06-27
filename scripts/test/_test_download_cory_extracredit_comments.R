library(httr)
library(tidyverse)
library(stringr)
library(rvest)
library(googledrive)
options(
  gargle_oauth_cache = ".secrets",
  gargle_oauth_email = TRUE
)

# read in the csv with the urls for the articles
folder_url <- "https://drive.google.com/drive/u/0/folders/1Ii3vlPpwj6uZnSSU9QgJuaor5VADpEO-"
## old folder url, not sure if it will make a difference
#folder_url <- "https://drive.google.com/drive/u/0/folders/1ob5sagTtT3svhc7ZKeemd9TiAq1_MsCL"
folder <- drive_get(as_id(folder_url))

gdrive_files <- drive_ls(folder)
id <- gdrive_files[gdrive_files$name != "Struthers extra credit instructions spring 2024", ]$id


for (i in 1:length(id)){
drive_download(id[i], 
               path = here::here(paste0("data/original/struther_extra-cred_comments", i, ".csv")), 
               overwrite = TRUE)
}

# Read in each file, they do not all have the same number of columns....
comments_1 <- read_csv(here::here("data/original/struther_extra-cred_comments1.csv"))
comments_2 <- read_csv(here::here("data/original/struther_extra-cred_comments2.csv"))
comments_3 <- read_csv(here::here("data/original/struther_extra-cred_comments3.csv"))
comments_4 <- read_csv(here::here("data/original/struther_extra-cred_comments4.csv"))
comments_5 <- read_csv(here::here("data/original/struther_extra-cred_comments5.csv"))
comments_6 <- read_csv(here::here("data/original/struther_extra-cred_comments6.csv"))
comments_7 <- read_csv(here::here("data/original/struther_extra-cred_comments7.csv"))
comments_8 <- read_csv(here::here("data/original/struther_extra-cred_comments8.csv"))

names(comments_1)
names(comments_5)
names(comments_6)
names(comments_7)

comments_5_clean <- comments_5 %>%
  select(-scoping_type, -draft_type) %>%
  rename(`#_comment_scoping` = `#_scoping`) %>%
  rename(`#_comment_draft` = `#_draft`)
identical(names(comments_1), names(comments_5_clean))

merged_comment_data <- rbind()

merged_comment_data <- 
  do.call(rbind,
          lapply(list.files(path = here::here("data/original/"), pattern = "struther*", full.names = TRUE), read.csv))

article_codes <- read.csv(file = "data/original/new_article_coding.csv")