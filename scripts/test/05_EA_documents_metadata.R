library(here)
library(tidyverse)
library(stringr)
library(ggplot2)

# set output directory
zipdir <- ("/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS")
# for each project
## unzip documents to tmp folder
## count total documents and documents by type (based on folder names)

#folder_list <- list.dirs( path = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS", full.names = TRUE, recursive = FALSE)
zip_list <- list.files(path = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS", pattern=".zip")

#unzip(paste0(outdir, "/", zip_list[1]), exdir = outdir)

meta_data <- data.frame() 

# May want to make a list of key words to search for if projects not organized correctly
#grep_list <- c("")

for (i in zip_list[1:100]) {
  print(i)
  tmp <- tempfile()
  unzip(paste0(zipdir, "/", i), exdir = tmp)
  folder_list <- list.dirs(path = tmp, full.names = TRUE, recursive = FALSE)
  for (n in folder_list){
    print(i)
    tmp_list <- list.files(path = paste0(n, "/"), pattern = ".pdf", recursive = TRUE)
    project_num <- str_extract(i, "(?<=\\()[0-9]+?(?=\\).z)") 
    # if project number already in meta_data df then skip
    total <- length(tmp_list)
    prescoping <- length(str_subset(tmp_list, "Pre-Scoping/"))
    scoping <- length(str_subset(tmp_list, "\\bScoping/\\b"))
    supporting <- length(str_subset(tmp_list, "Supporting/"))
    analysis <- length(str_subset(tmp_list, "Analysis/"))
    assessment <- length(str_subset(tmp_list, "Assessment/"))
    decision <- length(str_subset(tmp_list, "Decision/"))
    postdecision <- length(str_subset(tmp_list, "Post-Decision/"))
    appeals <- length(str_subset(tmp_list, "Post-Decision/Appeals/"))
    output <- c(project_num, total, prescoping, scoping, supporting, analysis, assessment, decision, postdecision, appeals)
    meta_data <- rbind(meta_data, as.numeric(output))
  }
}

colnames(meta_data) <- c("Project_Number", "Total_Files", "Prescoping", "Scoping", "Supporting", "Analysis", "Assessment", "Decision", "Postdecision", "Postdecision_Appeals")


folder_list <- list.dirs(path = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS", 
                         full.names = TRUE, 
                         recursive = FALSE)

for (n in folder_list){
  tmp_list <- list.files(path = paste0(n, "/"), pattern = ".pdf", recursive = TRUE)
  project_num <- str_extract(n, "(?<=\\().+?(?=\\))") 
  # if project number already in meta_data df then skip
  total <- length(tmp_list)
  prescoping <- length(str_subset(tmp_list, "Pre-Scoping/"))
  scoping <- length(str_subset(tmp_list, "\\bScoping/\\b"))
  supporting <- length(str_subset(tmp_list, "Supporting/"))
  analysis <- length(str_subset(tmp_list, "Analysis/"))
  assessment <- length(str_subset(tmp_list, "Assessment/"))
  decision <- length(str_subset(tmp_list, "Decision/"))
  postdecision <- length(str_subset(tmp_list, "Post-Decision/"))
  appeals <- length(str_subset(tmp_list, "Post-Decision/Appeals/"))
  output <- c(project_num, total, prescoping, scoping, supporting, analysis, assessment, decision, postdecision, appeals)
  meta_data <- rbind(meta_data, as.numeric(output))
}

colnames(meta_data) <- c("Project_Number", "Total_Files", "Prescoping", "Scoping", "Supporting", "Analysis", "Assessment", "Decision", "Postdecision", "Postdecision_Appeals")

# Not all post decision documents are appeals
# Subtract the postdecision from the postdecision_appeals
# So that appeals documents don't get counted twice
meta_data <- meta_data %>%
  mutate(Postdecision = Postdecision - Postdecision_Appeals) %>%
  mutate(Scoping = Scoping - Prescoping)

## write meta_data to a csv
write_csv(meta_data, here::here(paste0("data/processed/", format(Sys.Date(), format = "%m-%d-%Y"), "_metadata_EAs.csv")))

#files <- list.files(outdir, pattern = ".pdf", recursive = TRUE)

# rename all documents with project number and document type in the file name?



