# --------------------------
# https://tonyelhabr.rbind.io/post/nested-json-to-tidy-data-frame-r/
# 
# --------------------------
dir()
library(jsonlite)
t <- fromJSON('CDC_hospital.json')
time <- Sys.time()
time <- gsub("[^0-9]",replacement="",time) 
time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=16))
write.csv(t,paste0("./data/CDC_hospital_19CoV_",time,"_Big5",".csv"),row.names = FALSE)
