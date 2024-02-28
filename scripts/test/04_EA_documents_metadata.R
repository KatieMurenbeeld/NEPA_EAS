library(tidyverse)
library(stringr)
library(ggplot2)


# for each project
## unzip documents
## count total documents and documents by type (based on folder names)

folder_list <- list.dirs( path = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS", full.names = TRUE, recursive = FALSE)



for (i in folder_list[1:3]) {
  #print(paste0(i, "/"))
  tmp <- list.files(path = paste0(i, "/"), pattern = ".pdf", recursive = TRUE)
  project_num <- str_extract(folder_list[1], "(?<=\\().+?(?=\\))") 
  prescoping <- length(str_subset(tmp, "/Pre-Scoping/"))
  scoping <- length(str_subset(tmp, "/Scoping/"))
  supporting <- length(str_subset(tmp, "Supporting"))
  analysis <- length(str_subset(tmp, "Analysis"))
  assessment <- length(str_subset(tmp, "Assessment"))
  decision <- length(str_subset(tmp, "Decision"))
  appeals <- length(str_subset(tmp, "Appeals"))
  output <- c(project_num, prescoping, scoping, supporting, analysis, assessment, decision, appeals)
  meta_data <- rbind(meta_data, output)
}

# rename all documents with project number and document type in the file name


str_extract(folder_list[1], "(?<=\\().+?(?=\\))")

