library(here)
library(tidyverse)
library(stringr)
library(ggplot2)

# set output directory for zip files
zipdir <- ("/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS")
zipdir_eis <- ("/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS/EISs")

# Load data with pinyon public urls and project number
pin_proj <- read.csv(here::here("data/processed/projects_pinyon_2009.csv"))

#folder_list <- list.dirs( path = "/Users/katiemurenbeeld/Analysis/NEPA_EAs/data/original/NEPA_DOCS", full.names = TRUE, recursive = FALSE)
zip_list <- list.files(path = zipdir, pattern=".zip")
zip_list_eis <- list.files(path = zipdir_eis, pattern = ".zip")

#unzip(paste0(outdir, "/", zip_list[1]), exdir = outdir)

meta_data <- data.frame() 
meta_data_eis <- data.frame()

# May want to make a list of key words to search for if projects not organized correctly
#grep_list <- c("")

for (i in zip_list) { #may need to do in chunks zip_list[1:100]?
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

for (i in zip_list_eis) { #may need to do in chunks zip_list[1:100]?
  print(i)
  tmp <- tempfile()
  unzip(paste0(zipdir_eis, "/", i), exdir = tmp)
  folder_list <- list.dirs(path = tmp, full.names = TRUE, recursive = FALSE)
  for (n in folder_list){
    print(i)
    tmp_list <- list.files(path = paste0(n, "/"), pattern = ".pdf", recursive = TRUE)
    project_num <- str_extract(i, "(?<=\\()[0-9]+?(?=\\).z)") 
    # if project number already in meta_data df then skip
    total <- length(tmp_list)
    forest_plan <- length(str_subset(tmp_list, "Forest Plan/"))
    prescoping <- length(str_subset(tmp_list, "Pre-Scoping/"))
    scoping <- length(str_subset(tmp_list, "\\bScoping/\\b"))
    supporting <- length(str_subset(tmp_list, "Supporting/"))
    analysis <- length(str_subset(tmp_list, "Analysis/"))
    assessment <- length(str_subset(tmp_list, "Assessment/"))
    decision <- length(str_subset(tmp_list, "Decision/"))
    implementation <- length(str_subset(tmp_list, "Implementation/"))
    monitoring <- length(str_subset(tmp_list, "Monitoring/"))
    postdecision <- length(str_subset(tmp_list, "Post-Decision/"))
    appeals <- length(str_subset(tmp_list, "Post-Decision/Appeals/"))
    output <- c(project_num, total, prescoping, scoping, supporting, analysis, assessment, decision, postdecision, appeals)
    meta_data_eis <- rbind(meta_data_eis, as.numeric(output))
  }
}
colnames(meta_data_eis) <- c("Project_Number", "Total_Files", "Prescoping", "Scoping", "Supporting", "Analysis", "Assessment", "Decision", "Postdecision", "Postdecision_Appeals")

#---Same code but if the files were already unzipped----

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

#---------------------------------

# Not all post decision documents are appeals
# Subtract the postdecision from the postdecision_appeals
# So that appeals documents don't get counted twice
meta_data <- meta_data %>%
  mutate(Postdecision = Postdecision - Postdecision_Appeals) %>%
  mutate(Scoping = Scoping - Prescoping)

meta_data_eis <- meta_data_eis %>%
  mutate(Postdecision = Postdecision - Postdecision_Appeals) %>%
  mutate(Scoping = Scoping - Prescoping)

# Join to the pin_proj data frame with the urls

meta_data_url <- left_join(meta_data, pin_proj, by = c("Project_Number" = "project_number"))
meta_data_eis_url <- left_join(meta_data_eis, pin_proj, by = c("Project_Number" = "project_number"))

# Check for duplicated projects
n_occur <- data.frame(table(meta_data_url$Project_Number))
n_occur[n_occur$Freq > 1,]

n_occur_eis <- data.frame(table(meta_data_eis_url$Project_Number))
n_occur_eis[n_occur_eis$Freq > 1,]

## write meta_data to a csv
write_csv(meta_data_url, here::here(paste0("data/processed/", format(Sys.Date(), format = "%m-%d-%Y"), "_metadata_urls_EAs.csv")))
write_csv(meta_data_eis_url, here::here(paste0("data/processed/", format(Sys.Date(), format = "%m-%d-%Y", "_metadata_urls_EISs.csv"))))

