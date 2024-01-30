library(tidyverse)

pals <- read.csv('https://conservancy.umn.edu/bitstream/handle/11299/211669/pals_ongoing_projects_11-2022.csv?sequence=42&isAllowed=y', sep = ";")

# Filter only for projects that are Environmental Assessments (EAs)
eas_df <- pals %>%
  filter(DECISION.TYPE == "DN")

eas_2009_purpose_df <- pals %>%
  filter(DECISION.TYPE == "DN") %>%
  filter(HF.Fuels.management...purpose == 1 | TM.Forest.products...purpose == 1 |
         MG.Minerals.and.geology...purpose == 1 | RG.Grazing.management...purpose == 1 |
           VM.Vegetation.management..non.forest.products....purpose == 1)

# Create a subset dataframe of EA project numbers, project names, and calendar year initiated

eas_projs <- eas_df %>%
  select(PROJECT.NUMBER, PROJECT.NAME, calendarYearInitiated)

eas_projs_2009_purpose <- eas_2009_purpose_df %>%
  select(PROJECT.NUMBER, PROJECT.NAME, calendarYearInitiated, HF.Fuels.management...purpose, 
         TM.Forest.products...purpose, MG.Minerals.and.geology...purpose, RG.Grazing.management...purpose,
         VM.Vegetation.management..non.forest.products....purpose, PROJECT.STATUS)

# Write this to a csv

write_csv(eas_projs, '/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/eas_proj_name_num_year.csv')

write_csv(eas_projs_2009_purpose, "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/eas_proj_2009_purpose.csv")
