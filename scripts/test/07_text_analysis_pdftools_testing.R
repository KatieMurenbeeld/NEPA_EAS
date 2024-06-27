library(pdftools)



unzip(here::here("data/original/NEPA_DOCS/2011 Motor Vehicle Use Map Update (35135).zip"), 
      exdir = here::here("data/original/"))

test_dnfonsi <- pdf_text(here::here("data/original/2011 Motor Vehicle Use Map Update (35135)/Decision/2011_CNNF_MVUM_DNFONSI.pdf"))
test_covlett <- pdf_text(here::here("data/original/2011 Motor Vehicle Use Map Update (35135)/Decision/20110803_CNNF_MVUM_DN_coverletter.pdf"))
test_legal <- pdf_text(here::here("data/original/2011 Motor Vehicle Use Map Update (35135)/Decision/20110805_CNNF_MVUM_DNFONSI_ legal notice.pdf"))

cat(test_dnfonsi)
cat(test_covlett)
cat(test_legal)


