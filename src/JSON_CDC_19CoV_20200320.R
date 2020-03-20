# JSON https://data.gov.tw/dataset/118038
# JSON https://data.gov.tw/dataset/118039
url <- "https://od.cdc.gov.tw/eic/Weekly_Age_County_Gender_19CoV.json"
library(jsonlite)
t <- fromJSON(url)
library(readr)
result <- read_csv("data/CDC_19CoV_20200320_105658_Big5.csv", 
                                           locale = locale(encoding = "BIG5"))
# View(result)
library(data.table)
result.dt <- data.table(result)
t.dt <- data.table(t)
# dplyr::anti_join(t,result)
t.dt[!result.dt,]
# result <-t
# data_time <- max(result$inc_notify_time)
time <- Sys.time()
time <- gsub("[^0-9]",replacement="",time) 
time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=16))
result$'確定病例數' <- as.integer(result$'確定病例數')

result.dt<-data.table(result)
class(result.dt)
str(result.dt)
colnames(result.dt)
# result.dt[是否為境外移入=='是',.(.N,Sum=sum(確定病例數)),by='縣市']
# result.dt[,.(Sum=sum(確定病例數)),by=.(縣市,是否為境外移入)][order(縣市,是否為境外移入)]
X <- result.dt[是否為境外移入=='是',.(Sum_Inter=sum(確定病例數)),by='縣市']
Y <- result.dt[是否為境外移入=='否',.(Sum_Local=sum(確定病例數)),by='縣市']
result_op.dt <- merge(X,Y,all=TRUE)
# save result
# readr::write_csv(result,paste0("./data/MOTC_incident_",time,".csv")) #,row.names = FALSE,fileEncoding = "UTF-8"
write.csv(result,paste0("./data/CDC_19CoV_",time,"_Big5",".csv"),row.names = FALSE)
write.csv(result_op.dt,paste0("./data/CDC_19CoV_County_",time,"_Big5",".csv"),row.names = FALSE)
