# https://1968.freeway.gov.tw/api/getCrowdData?action=crowd&area=A
url <- "https://1968.freeway.gov.tw/api/getCrowdData?action=crowd&area=A"
library(jsonlite)
t <- fromJSON(url)
result <- t$response
data_time <- max(result$time)
time <- gsub("[^0-9]",replacement="",data_time) 
time <- paste0(substr(time,start=1,stop=4),"-",substr(time,start=5,stop=6),"-",substr(time,start=7,stop=8),"-",substr(time,start=9,stop=12))
# readr::write_csv(result,paste0("./data/MOTC_crow_",time,".csv")) #,row.names = FALSE,fileEncoding = "UTF-8"
write.csv(result,paste0("./data/MOTC_crow_",time,"_Big5",".csv"),row.names = FALSE)
table(result$city);table(result$level_web)
