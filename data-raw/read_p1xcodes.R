# read p1x table into R
p1xcodes <- read.csv("./data_raw/names_p1xdump.csv", stringsAsFactors = F)
p1xcodes$description <- trimws(p1xcodes$description)
p1xcodes$description <- snakecase::to_any_case(p1xcodes$description)
devtools::use_data(p1xcodes,internal = TRUE, overwrite = TRUE)
