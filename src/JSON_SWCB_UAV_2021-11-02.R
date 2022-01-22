# JSON https://gis.swcb.gov.tw/api/swcb/tiles/ortho
url <- "https://gis.swcb.gov.tw/api/swcb/tiles/ortho"
# install.packages(c("data.table", "jsonlite", "readr"))
# install.packages('curl')
library(jsonlite)
t <- fromJSON(url)
library(readr)
result_ori <- read_csv("data/SWCB_UAV_temp_uni.csv", 
                        col_types = cols("Date" = col_character()
                        ),locale = locale(encoding = "UTF-8")
                       )# View(result)
library(data.table)
t.dt <- data.table(t)
result_ori.dt <- data.table(result_ori)

# result
str(t.dt)
colnames(t.dt)
# result_ori.dt$'確定病例數' <- as.integer(result_ori.dt$'確定病例數')
# t.dt$'確定病例數' <- as.integer(t.dt$'確定病例數')
# t.dt[,.(Sum_ALL=sum(確定病例數)),]  # result_ori.dt[,.(Sum_ALL=sum(確定病例數)),]
# -------------
# str(result_ori.dt);str(t.dt)
# diff value
t2 <- t.dt[!result_ori.dt, on = names(t.dt)]
t3 <- result_ori.dt[!t.dt, on = names(result_ori.dt)]
# t_diff <- merge(t2,t3,all = TRUE)  #can't join together
t_diff <- merge(t2,t3,by=c("Id","CenterLatitude","CenterLongitude","AccessURL","Title","ProjectNo","ProjectName","Date"),all = TRUE)
# names(result_ori.dt)<- names(t.dt)
# 
data_time <- max(t.dt$Date, na.rm = TRUE)
range(t.dt$Date, na.rm = TRUE)
# time <- gsub("[^0-9]",replacement="",time) 
# time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=16))
result <- t

result.dt<-data.table(result)
class(result.dt)
str(result.dt)
colnames(result.dt)
# result.dt[是否為境外移入=='是',.(.N,Sum=sum(確定病例數)),by='縣市']
# result.dt[,.(Sum=sum(確定病例數)),by=.(縣市,是否為境外移入)][order(縣市,是否為境外移入)]
# X <- result.dt[是否為境外移入=='是',.(Sum_Inter=sum(確定病例數)),by='縣市']
# Y <- result.dt[是否為境外移入=='否',.(Sum_Local=sum(確定病例數)),by='縣市']
# result_op.dt <- merge(X,Y,all=TRUE)

# save result
# readr::write_csv(result,paste0("./data/MOTC_incident_",time,".csv")) #,row.names = FALSE,fileEncoding = "UTF-8"
setwd("D:/OP/github/NOTE_of_R_Crawler")
savef <- function(time){
  write.csv(t_diff,paste0("./data/SWCB_UAV_diff_",data_time,"_Big5",".csv"),row.names = FALSE);
  # write.csv(result.dt,paste0("./data/SWCB_UAV_temp_Big5",".csv"),row.names = FALSE);
  readr::write_csv(result,paste0("./data/SWCB_UAV_",data_time,"_uni.csv"))
  readr::write_csv(result,paste0("./data/SWCB_UAV_temp_uni.csv"))
  # print(paste0(paste(result_op.dt$縣市, collapse="、"),"等",length(result_op.dt$縣市),"縣市，共",t.dt[,.(Sum_ALL=sum(確定病例數)),],"例。"))
}

if(nrow(t2)>0){
  savef(time)}else{
    print("not yet updated")}

