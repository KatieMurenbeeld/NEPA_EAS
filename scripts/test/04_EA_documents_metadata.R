library(here)
library(tidyverse)
library(stringr)
library(ggplot2)

# set output directory
outdir <- here::here("/data/original/NEPA_DOCS")
# for each project
## unzip documents
## count total documents and documents by type (based on folder names)

#folder_list <- list.dirs( path = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS", full.names = TRUE, recursive = FALSE)
zip_list <- list.files(path = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS", pattern=".zip")

#unzip(paste0(outdir, "/", zip_list[1]), exdir = outdir)

meta_data <- data.frame()

# May want to make a list of key words to search for if projects not organized correctly
#grep_list <- c("")

for (i in zip_list) {
  print(i)
  unzip(paste0(outdir, "/", i), exdir = outdir)
}
folder_list <- list.dirs( path = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS", full.names = TRUE, recursive = FALSE)
for (n in folder_list){
  tmp <- list.files(path = paste0(n, "/"), pattern = ".pdf", recursive = TRUE)
  project_num <- str_extract(n, "(?<=\\().+?(?=\\))") 
  # if project number already in meta_data df then skip
  prescoping <- length(str_subset(tmp, "Pre-Scoping/"))
  scoping <- length(str_subset(tmp, "Scoping/"))
  supporting <- length(str_subset(tmp, "Supporting/"))
  analysis <- length(str_subset(tmp, "Analysis/"))
  assessment <- length(str_subset(tmp, "Assessment/"))
  decision <- length(str_subset(tmp, "Decision/"))
  postdecision <- length(str_subset(tmp, "Post-Decision/"))
  appeals <- length(str_subset(tmp, "Post-Decision/Appeals/"))
  output <- c(project_num, prescoping, scoping, supporting, analysis, assessment, decision, postdecision, appeals)
  meta_data <- rbind(meta_data, as.numeric(output))
}

colnames(meta_data) <- c("Project_Number", "Prescoping", "Scoping", "Supporting", "Analysis", "Assessment", "Decision", "Postdecision", "Postdecision_Appeals")

# Not all post decision documents are appeals
# Subtract the postdecision from the postdecision_appeals
# So that appeals documents don't get counted twice
meta_data <- meta_data %>%
  mutate(Postdecision = Postdecision - Postdecision_Appeals)

## write meta_data to a csv
write_csv(meta_data, here::here(paste0("data/processed/", Sys.Date(), "_metadata_29-projects.csv")))

files <- list.files(outdir, pattern = ".pdf", recursive = TRUE)

# rename all documents with project number and document type in the file name?



