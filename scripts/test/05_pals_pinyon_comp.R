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


#----Histograms----

ggplot(pals_pin_new) +
  geom_histogram(aes(Total_Files), bins = 50) 

column_names = c("Total_Files", "Prescoping", "Scoping", "Supporting", "Analysis", "Assessment", "Decision", "Postdecision", "Postdecision_Appeals")

counts <- as.data.frame(colSums(pinpub_meta))
counts <- cbind(Doc_Type = rownames(counts), counts)
counts <- counts[-1,]

ggplot(counts) + 
  geom_col(aes(x = Doc_Type, y = `colSums(pinpub_meta)`)) + 
  theme(axis.text.x = element_text(angle = 90))
  


#----Scatter Plots: Elapsed Days by Total Document Count----

ggplot(pals_pin_new) +
  geom_point(aes(x = Total_Files, y = ELAPSED.DAYS, color = LITIGATED.)) + 
  scale_y_log10()

ggplot(pals_pin_new) +
  geom_point(aes(x = Total_Files, y = ELAPSED.DAYS, color = APPEALED.OR.OBJECTED.)) + 
  scale_y_log10()
