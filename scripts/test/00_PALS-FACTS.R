library(tidyverse)
library(sf)

# Set timeout
options(timeout = 3600)

#---Load the data----------

# Load the PALS data (from Cory)
pals_ongoing <- readRDS("~/Analysis/NEPA_EAs/scripts/pals_ongoing_projects_thru_3-2023.rds")


# Download the FS common attribute databases
reg_lst <- c("01", "02", "03", "04", "05", "06", "08", "09")

zip_url <- paste0("https://data.fs.usda.gov/geodata/edw/edw_resources/fc/Actv_CommonAttribute_PL_Region")

for (i in reg_lst) {
  link <- paste0(zip_url, i, ".zip")
  print(link)
  fname <- paste0(here::here("data/original/CommonAttribute_"),i,".zip")
  print(fname)
  download.file(url = link, destfile = fname)
}

fnames <- list()

for (i in reg_lst) {
  name <- paste0(here::here("data/original/CommonAttribute_"),i,".zip")
  fnames <- append(fnames, list(name))
}

for (i in fnames) {
  unzip(i, exdir = here::here("data/original/"))
}

#---Subset the CommonAttribute geodatabases------

# could make a function and loop for this
reg1 <- st_read(here::here("data/original/Actv_CommonAttribute_PL_Region01.gdb"),
                query = "SELECT * from Actv_CommonAttribute_PL WHERE FISCAL_YEAR_PLANNED > 2005")
reg2 <- st_read(here::here("data/original/Actv_CommonAttribute_PL_Region02.gdb"),
                query = "SELECT * from Actv_CommonAttribute_PL WHERE FISCAL_YEAR_PLANNED > 2005")
reg3 <- st_read(here::here("data/original/Actv_CommonAttribute_PL_Region03.gdb"),
                query = "SELECT * from Actv_CommonAttribute_PL WHERE FISCAL_YEAR_PLANNED > 2005")
reg4 <- st_read(here::here("data/original/Actv_CommonAttribute_PL_Region04.gdb"), 
                query = "SELECT * from Actv_CommonAttribute_PL WHERE FISCAL_YEAR_PLANNED > 2005")
reg5 <- st_read(here::here("data/original/Actv_CommonAttribute_PL_Region05.gdb"), 
                query = "SELECT * from Actv_CommonAttribute_PL WHERE FISCAL_YEAR_PLANNED > 2005")
reg6 <- st_read(here::here("data/original/Actv_CommonAttribute_PL_Region06.gdb"), 
                query = "SELECT * from Actv_CommonAttribute_PL WHERE FISCAL_YEAR_PLANNED > 2005")
reg8 <- st_read(here::here("data/original/Actv_CommonAttribute_PL_Region08.gdb"), 
                query = "SELECT * from Actv_CommonAttribute_PL WHERE FISCAL_YEAR_PLANNED > 2005")
reg9 <- st_read(here::here("data/original/Actv_CommonAttribute_PL_Region09.gdb"), 
                query = "SELECT * from Actv_CommonAttribute_PL WHERE FISCAL_YEAR_PLANNED > 2005")

facts_proj_lst <- c()

x <- c(reg1, reg2, reg3, reg4, reg5, reg6, reg8, reg9)

#for (i in x) {
#  proj <- unique(i$NEPA_DOC_NBR)
#  facts_proj_lst <- append(facts_proj_lst, list(proj))
#}
# I want to make a loop for this as well
proj1 <- unique(reg1$NEPA_DOC_NBR)
proj2 <- unique(reg2$NEPA_DOC_NBR)
proj3 <- unique(reg3$NEPA_DOC_NBR)
proj4 <- unique(reg4$NEPA_DOC_NBR)
proj5 <- unique(reg5$NEPA_DOC_NBR)
proj6 <- unique(reg6$NEPA_DOC_NBR)
proj8 <- unique(reg8$NEPA_DOC_NBR)
proj9 <- unique(reg9$NEPA_DOC_NBR)

facts_proj_lst <- append(facts_proj_lst, c(proj1, proj2, proj3, proj4, proj5, proj6, proj8, proj9))

# Filter the pals ongoing data for project numbers in the facts project list (facts_proj_lst)
pals_facts <- pals_ongoing %>%
  filter(as.character(`PROJECT NUMBER`) %in% facts_proj_lst) 
           

pals_facts$`DECISION SIGNED` <- as.Date.character(pals_facts$`DECISION SIGNED`, format = "%m/%d/%Y")

pals_facts_2009 <- filter(pals_facts, `DECISION SIGNED` > as.Date("2009-01-01"))

write.csv(pals_facts_2009, file = here::here("data/processed/pals-in-facts_2009.csv"))










