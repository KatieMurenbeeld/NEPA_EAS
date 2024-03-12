library(here)
library(tidyverse)
library(stringr)
library(ggplot2)

pinpub_meta <- read.csv(here::here("data/processed/2024-02-29_metadata_29-projects.csv"))

pals_df <- read.csv(here::here("data/original/df_pals_comm_NEPA_init_2009_2018_noneg_allpurp_v02_c20221208.csv"))

pals_pin <- left_join(pinpub_meta, pals_df, by = c("Project_Number" = "NEPA_DOC_NBR"))
