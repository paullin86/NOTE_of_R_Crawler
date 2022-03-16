# https://dataapi.ncdr.nat.gov.tw/NCDRAPI/Opendata/NCDR/EQ
url <- "https://dataapi.ncdr.nat.gov.tw/NCDRAPI/Opendata/NCDR/EQ"
library(jsonlite)
t <- fromJSON(url, simplifyVector = FALSE,flatten = TRUE) #,simplifyDataFrame = FALSE  
t <- fromJSON(url)
library(data.table)
t.dt <- data.table(t$Data)
# result
# str(t.dt)
# colnames(t.dt)
t.dt$EventName <- t$EventName
t.dt$EventDateTime <-t$EventDateTime
t.dt$Magnitude <-t$Magnitude
t.dt$EQ_WGS84_Lon <-t$EQ_WGS84_Lon
t.dt$EQ_WGS84_Lat <-t$EQ_WGS84_Lat
t.dt$Depth <-t$Depth
result <- t.dt[,.(EventName, EventDateTime,Magnitude,EQ_WGS84_Lon,EQ_WGS84_Lat,Depth,WGS84_Lon,WGS84_Lat,PGA,PGV,Intensity),]

data_time <- max(t.dt$EventDateTime, na.rm = TRUE)
 time <- gsub("[^0-9]",replacement="",data_time) 
 time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=12))
 print((paste0(t$EventName,"，發生時間：",t$EventDateTime,"，規模：",t$Magnitude,"，深度：",t$Depth,"公里，最大震度：",max(t$Data$Intensity),"級(PGA：",max(t$Data$PGA),")")))

# save result
# readr::write_csv(result,paste0("./data/MOTC_incident_",time,".csv")) #,row.names = FALSE,fileEncoding = "UTF-8"
setwd("D:/OP/github/NOTE_of_R_Crawler")
savef <- function(time){
  # write.csv(t_diff,paste0("./data/SWCB_UAV_diff_",data_time,"_Big5",".csv"),row.names = FALSE);
  # write.csv(result.dt,paste0("./data/SWCB_UAV_temp_Big5",".csv"),row.names = FALSE);
  readr::write_csv(result,paste0("./data/CDR_eq_",time,"_uni.csv"))
  # readr::write_csv(result,paste0("./data/SWCB_UAV_temp_uni.csv"))
  # print(paste0(paste(result_op.dt$縣市, collapse="、"),"等",length(result_op.dt$縣市),"縣市，共",t.dt[,.(Sum_ALL=sum(確定病例數)),],"例。"))
}

if(nrow(t.dt)>0){
  savef(time)}else{
    print("not yet updated")}
