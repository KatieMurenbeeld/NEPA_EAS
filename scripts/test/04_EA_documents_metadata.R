library(tidyverse)
library(stringr)
library(ggplot2)

# set output directory
outdir <- "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS"
# for each project
## unzip documents
## count total documents and documents by type (based on folder names)

#folder_list <- list.dirs( path = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS", full.names = TRUE, recursive = FALSE)
zip_list <- list.files(path = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS", pattern=".zip")

#unzip(paste0(outdir, "/", zip_list[1]), exdir = outdir)

meta_data <- data.frame()

for (i in zip_list[1:3]) {
  print(i)
  unzip(paste0(outdir, "/", i), exdir = outdir)
}
folder_list <- list.dirs( path = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS", full.names = TRUE, recursive = FALSE)
for (n in folder_list){
  tmp <- list.files(path = paste0(n, "/"), pattern = ".pdf", recursive = TRUE)
  project_num <- str_extract(n, "(?<=\\().+?(?=\\))") 
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

colnames(meta_data) <- c("Project_Number", "Prescoping", "Scoping", "Supporting", "Analysis", "Assessment", "Decision", "Appeals")


# rename all documents with project number and document type in the file name



