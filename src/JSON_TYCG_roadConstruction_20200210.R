# https://data.tycg.gov.tw/opendata/datalist/datasetMeta?oid=56c616fe-07d7-4b0c-bb75-e8f8cd75500a	
# https://data.tycg.gov.tw/opendata/datalist/datasetMeta/download?id=56c616fe-07d7-4b0c-bb75-e8f8cd75500a&rid=52de3762-1490-4a86-a074-0062d746873b
url <- "https://data.tycg.gov.tw/opendata/datalist/datasetMeta/download?id=56c616fe-07d7-4b0c-bb75-e8f8cd75500a&rid=52de3762-1490-4a86-a074-0062d746873b"
library(jsonlite)
t <- fromJSON(url)
result <- t
result$Start <- as.Date(result$Start,format='%Y/%m/%d')
result$stop <- as.Date(result$Start,format='%Y/%m/%d')
data_time <- max(result$Start)
time <- gsub("[^0-9]",replacement="",data_time) 
# time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=16))
# readr::write_csv(result,paste0("./data/MOTC_incident_",time,".csv")) #,row.names = FALSE,fileEncoding = "UTF-8"
write.csv(result,paste0("./data/TYCG_roadConstruction_",time,"_Big5",".csv"),row.names = FALSE)
