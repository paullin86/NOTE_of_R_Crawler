# https://data.taipei/#/dataset/detail?id=4d29818c-a3ee-425d-b88a-22ac0c24c712
# https://tpnco.blob.core.windows.net/blobfs/Todaywork.json
url <- "https://tpnco.blob.core.windows.net/blobfs/Todaywork.json"
library(jsonlite)
t <- fromJSON(url)
result <- t$features$properties
str(result)
result$Start <- as.Date(result$Start,format='%Y/%m/%d')
result$stop <- as.Date(result$Start,format='%Y/%m/%d')
data_time <- max(result$Start)
time <- gsub("[^0-9]",replacement="",data_time) 
# time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=16))
# readr::write_csv(result,paste0("./data/MOTC_incident_",time,".csv")) #,row.names = FALSE,fileEncoding = "UTF-8"
write.csv(result,paste0("./data/TP_roadConstruction_",time,"_Big5",".csv"),row.names = FALSE)
