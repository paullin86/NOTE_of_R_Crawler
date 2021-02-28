# https://data.taipei/#/dataset/detail?id=4d29818c-a3ee-425d-b88a-22ac0c24c712
# https://tpnco.blob.core.windows.net/blobfs/Todaywork.json
url <- "https://tpnco.blob.core.windows.net/blobfs/Todaywork.json"
library(jsonlite)
t <- fromJSON(url)
result <- t$features$properties
# str(result)
result <-result[,-c(22)] #remove column
colnames(result)
# return 日期由民國年轉為西元年
result$AppDate <- substr(result$AppTime,1,9)
result$AppDate <- as.Date(unlist(lapply(result$AppDate, function(x) {
  if (nchar(x) == 8) return(paste0(as.numeric(substr(x,1,2))+1911, "-", substr(x,4,5), "-", substr(x,7,8)))
  if (nchar(x) == 9) return(paste0(as.numeric(substr(x,1,3))+1911, "-", substr(x,5,6), "-", substr(x,8,9)))
})))
# result$stop <- as.Date(result$Start,format='%Y/%m/%d')
data_time <- max(result$AppDate)
time <- gsub("[^0-9]",replacement="",data_time) 

#diff
library(readr)
result_ori <- read_csv("data/TP_roadConstruction_temp_Big5.csv", 
                       col_types = cols("St_no" = col_character(), 
                                        "sno" = col_character(), 
                                        "X" = col_character(), 
                                        "Y" = col_character(), 
                                        "DType" = col_character(), 
                                        "DLen" = col_character()), 
                       locale = locale(encoding = "BIG5"))
library(data.table)
result_ori.dt <- data.table(result_ori)
result.dt <- data.table(result)
result_ori.dt[is.na(result_ori.dt$DType)]$DType <- ''
str(result_ori.dt);str(result.dt)
t2 <- result.dt[!result_ori.dt, on = names(result.dt)]

# time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=16))
# readr::write_csv(result,paste0("./data/MOTC_incident_",time,".csv")) #,row.names = FALSE,fileEncoding = "UTF-8"
write.csv(result,paste0("./data/TP_roadConstruction_",time,"_Big5",".csv"),row.names = FALSE)
write.csv(result,paste0("./data/TP_roadConstruction_temp_Big5",".csv"),row.names = FALSE)
write.csv(t2,paste0("./data/TP_roadConstruction_diff_",time,"_Big5",".csv"),row.names = FALSE)
