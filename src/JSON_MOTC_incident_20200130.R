# https://1968.freeway.gov.tw/getIncidentData?action=incident&area=A
url <- "https://1968.freeway.gov.tw/getIncidentData?action=incident&area=A"
library(jsonlite)
t <- fromJSON(url)
result <- t$response
data_time <- max(result$inc_notify_time)
time <- gsub("[^0-9]",replacement="",data_time) 
time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=16))
# readr::write_csv(result,paste0("./data/MOTC_incident_",time,".csv")) #,row.names = FALSE,fileEncoding = "UTF-8"
write.csv(result,paste0("./data/MOTC_incident_",time,"_Big5",".csv"),row.names = FALSE)
