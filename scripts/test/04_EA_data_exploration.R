library(tidyverse)
library(stringr)
library(ggplot2)
library(lubridate)

## Load the csv 
facts_df <- read.csv("/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/facts_url_3.csv")

sub_df <- facts_df %>%
  filter(proj_url != "no project webpage")

## Create some plots or show summary stats

### Filter out forests in Region 10
sub_df <- sub_df %>%
  filter(FOREST_ID < 1000)

#sub_df$DECISION.SIGNED <- as_datetime(sub_df$DECISION.SIGNED)

# Histogram of elapsed days
ggplot(sub_df, aes(x=ELAPSED.DAYS)) + 
  geom_histogram()
# Histogram of elapsed days by Region
ggplot(sub_df, aes(x=ELAPSED.DAYS, color=LMU...REGION)) + 
  geom_histogram(fill="white") + 
  facet_wrap(~LMU...REGION)

# Histogram of number of activities
ggplot(sub_df, aes(x=NBR_ACTIVITIES)) + 
  geom_histogram()
# Histogram of number of activities by Region
ggplot(sub_df, aes(x=NBR_ACTIVITIES, color=LMU...REGION)) + 
  geom_histogram(fill="white") + 
  facet_wrap(~LMU...REGION)

# Bar plot of the number of EAs completed per Region
reg_counts <- sub_df %>% count(LMU...REGION)

ggplot(reg_counts, aes(x=LMU...REGION, y=n, color=LMU...REGION)) + 
  geom_bar(fill="white", stat = "identity") 
# Line plot of the number of EAs completed per year
year_counts <- sub_df %>% count(calendarYearSigned)

ggplot(year_counts, aes(x=calendarYearSigned, y=n)) + 
  geom_line()
# Line plots of the number of EAs completed per Region by year
reg_year_counts <- sub_df %>%
  group_by(LMU...REGION) %>%
  count(calendarYearSigned)

ggplot(reg_year_counts, aes(x=calendarYearSigned, y=n, color=LMU...REGION)) + 
  geom_line() + 
  facet_wrap(~LMU...REGION)

# Bar plot of the number of EAs signed per month
months_signed <- ymd(sub_df$DECISION.SIGNED)

months_signed_v <- month(months_signed)

sub_df$month_signed <- months_signed_v

month_signed_counts <- sub_df %>%
  count(month_signed)

month_signed_reg_counts <- sub_df %>%
  group_by(LMU...REGION) %>%
  count(month_signed)

ggplot(month_signed_counts, aes(x=month_signed, y=n)) + 
  geom_bar(stat = "identity") 

# Bar plot of the number of EAs signed per month per Region
ggplot(month_signed_reg_counts, aes(x=month_signed, y=n, color=LMU...REGION)) +
  geom_bar(stat = "identity") +
  facet_wrap(~LMU...REGION) +
  theme(legend.position = "none")

