# https://wr.wra.gov.tw/WRTInfoAPI/api/Announce?Gov_code_sn=0&search=%E5%B7%A5%E6%A5%AD
# https://wr.wra.gov.tw/WRTInfoAPI/api/Announce?Gov_code_sn=0&search=%E8%BE%B2%E6%A5%AD%E7%94%A8%E6%B0%B4
url <- "https://wr.wra.gov.tw/WRTInfoAPI/api/Announce?Gov_code_sn=0&search=%E8%BE%B2%E6%A5%AD%E7%94%A8%E6%B0%B4"
# cond
library(jsonlite)
t <- fromJSON(url)
result <- fromJSON(t)
colnames(result)
# result$Start <- as.Date(result$Start,format='%Y/%m/%d')
# result$stop <- as.Date(result$Start,format='%Y/%m/%d')
data_time <- max(result$IssueDate)
time <- gsub("[^0-9]",replacement="",data_time) 
time <- paste0(substr(time,start=1,stop=4),substr(time,start=5,stop=8))
# readr::write_csv(result,paste0("./data/MOTC_incident_",time,".csv")) #,row.names = FALSE,fileEncoding = "UTF-8"
write.csv(result,paste0("./data/WRA_Announce_",time,"_Big5",".csv"),row.names = FALSE)
