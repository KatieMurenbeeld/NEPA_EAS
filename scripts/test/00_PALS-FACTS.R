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


