library(tidyverse)
library(boxr)
library(curl)


## 1) Make a list of all the file names

project_names <- list.files("/Users/kathrynmurenbeeld/Desktop/NEPA_EAS/data/original/Priest Lake Ranger District (11010408)",
                            all.files = TRUE)
project_names

## 2) From project_names, extract the project numbers, the last digits in parentheses

str_extract_all(project_names, "\\([^()]+\\)")

str_extract_all(project_names, "\\(([^()]+)\\)")

str_extract_all(project_names, regex("?<=()+[0-9]+(?=))"))
#str_extract_all(project_names, regex("(?<=()(.*)(?=))"))

project_numbers <- str_extract_all(project_names, "\\([^()]+\\)")

file_names <- list.files("/Users/kathrynmurenbeeld/Desktop/NEPA_EAS/data/original/Priest Lake Ranger District (11010408)",
                         all.files = TRUE, full.names = TRUE, pattern = "pdf$", recursive = TRUE)


# from other script -------------------------------------------------------


#files <- list.files(pattern = "pdf$")
#files
#length(files)
## Use lapply to to extract the text from all of the pdf files in the list 
## In this case the files are all in the working directory
#vip <- lapply(files, pdf_text) 

#lapply(vip, length)
#length(vip)


# -------------------------------------------------------------------------

file_names


# -------------------------------------------------------------------------
## Testing with boxr
# supply your own "your_client_id" & "your_client_secret"
box_auth(client_id = "ij540gs8d73q3raloecezxf8gmskryyr", client_secret = "BJMsqc71949Tzd35mH21qqnlITOdzgJW")


box_fetch(dir_id = "158017966393",
          local_dir = "247318806274", recursive = TRUE,
          overwrite = FALSE, delete = FALSE)
