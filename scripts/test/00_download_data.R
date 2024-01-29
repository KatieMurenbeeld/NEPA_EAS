library(tidyverse)

pals <- read.csv('https://conservancy.umn.edu/bitstream/handle/11299/211669/pals_ongoing_projects_11-2022.csv?sequence=42&isAllowed=y', sep = ";")

# Filter only for projects that are Environmental Assessments (EAs)
eas_df <- pals %>%
  filter(DECISION.TYPE == "DN")

# Create a subset dataframe of EA project numbers, project names, and calendar year initiated

eas_projs <- eas_df %>%
  select(PROJECT.NUMBER, PROJECT.NAME, calendarYearInitiated)

# Write this to a csv

write_csv(eas_projs, '/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/processed/eas_proj_name_num_year.csv')
