library(tidyverse)
library(stringr)
library(ggplot2)

## Load the csv 
facts_df <- read.csv("/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/facts_url_3.csv")

sub_df <- facts_df %>%
  filter(proj_url != "no project webpage")

## Create some plots or show summary stats

sub_df <- sub_df %>%
  filter(FOREST_ID < 1000)

ggplot(sub_df, aes(x=ELAPSED.DAYS)) + 
  geom_histogram()

ggplot(sub_df, aes(x=ELAPSED.DAYS, color=LMU...REGION)) + 
  geom_histogram(fill="white")

reg_counts <- sub_df %>% count(LMU...REGION)

ggplot(reg_counts, aes(x=LMU...REGION, y=n, color=LMU...REGION)) + 
  geom_bar(fill="white", stat = "identity")

year_counts <- sub_df %>% count(calendarYearSigned)

ggplot(year_counts, aes(x=calendarYearSigned, y=n)) + 
  geom_line()

reg_year_counts <- sub_df %>%
  group_by(LMU...REGION) %>%
  count(calendarYearSigned)

ggplot(reg_year_counts, aes(x=calendarYearSigned, y=n, color=LMU...REGION)) + 
  geom_line()



