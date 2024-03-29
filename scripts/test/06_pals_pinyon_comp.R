library(here)
library(tidyverse)
library(stringr)
library(ggplot2)

pinpub_meta <- read.csv(here::here("data/processed/03-11-2024_metadata_29-projects.csv"))

pals_df <- read.csv(here::here("data/original/df_pals_comm_NEPA_init_2009_2018_noneg_allpurp_v02_c20221208.csv"))
pals_new <- read.csv('https://conservancy.umn.edu/bitstream/handle/11299/211669/pals_ongoing_projects_11-2022.csv?sequence=42&isAllowed=y', sep = ";")

pals_pin <- left_join(pinpub_meta, pals_df, by = c("Project_Number" = "NEPA_DOC_NBR"))

pals_pin_new <- left_join(pinpub_meta, pals_new, by = c("Project_Number" = "PROJECT.NUMBER"))

mean(pals_pin_new$Total_Files)
median(pals_pin_new$Total_Files)
sd(pals_pin_new$Total_Files)
min(pals_pin_new$Total_Files)
max(pals_pin_new$Total_Files)

#----Histogram and bar chart----

ggplot(pals_pin_new) +
  geom_histogram(aes(Total_Files), bins = 50) 

ggplot(pals_pin_new) +
  geom_histogram(aes(ELAPSED.DAYS), bins = 30) 

counts <- as.data.frame(colSums(pinpub_meta))
counts <- cbind(Doc_Type = rownames(counts), counts)
counts <- counts[-1,]

ggplot(counts) + 
  geom_col(aes(x = Doc_Type, y = `colSums(pinpub_meta)`, fill = Doc_Type)) + 
  theme(axis.text.x = element_text(angle = 90))
  
#----Scatter Plots----

ggplot(pals_pin_new) +
  geom_point(aes(x = Total_Files, y = ELAPSED.DAYS, color = as.factor(LITIGATED.))) + 
  labs(color = "Litigated") +
  scale_y_log10()

ggplot(pals_pin_new) +
  geom_point(aes(x = Total_Files, y = ELAPSED.DAYS, color = as.factor(APPEALED.OR.OBJECTED.))) + 
  labs(color = "Appealed") +
  scale_y_log10()

ggplot(pals_pin) +
  geom_point(aes(x = Total_Files, y = PROJECT_DUR_PLAN_YR, color = as.factor(APPEALED.OR.OBJECTED.))) +
  labs(color = "Appealed")

ggplot(pals_pin) +
  geom_point(aes(x = Total_Files, y = NBR_ACTIVITIES, color = as.factor(APPEALED.OR.OBJECTED.))) +
  labs(color = "Appealed") 

ggplot(pals_pin) +
  geom_point(aes(x = Total_Files, y = TOT_AREA_PLAN, color = as.factor(APPEALED.OR.OBJECTED.))) +
  labs(color = "Appealed") + 
  scale_y_log10()

ggplot(pals_pin) +
  geom_point(aes(x = Total_Files, y = PROJ_EVENNESS, color = as.factor(APPEALED.OR.OBJECTED.))) +
  labs(color = "Appealed") + 
  scale_x_log10() + 
  scale_y_log10()


