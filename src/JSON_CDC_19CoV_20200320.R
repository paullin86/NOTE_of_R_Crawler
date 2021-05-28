# JSON https://data.gov.tw/dataset/118038
# JSON https://data.gov.tw/dataset/118039
url <- "https://od.cdc.gov.tw/eic/Weekly_Age_County_Gender_19CoV.json"
# url <- "https://od.cdc.gov.tw/eic/Age_County_Gender_19Cov.json"
library(jsonlite)
t <- fromJSON(url)
library(readr)
result_ori <- read_csv("data/CDC_19CoV_temp_Big5.csv", 
                   col_types = cols("發病年份" = col_character(), 
                                    "發病週別" = col_character(), 
                                    "確定病例數" = col_character()),
                   locale = locale(encoding = "BIG5"))# View(result)
library(data.table)
result_ori.dt <- data.table(result_ori)
t.dt <- data.table(t)
result_ori.dt$'確定病例數' <- as.integer(result_ori.dt$'確定病例數')
t.dt$'確定病例數' <- as.integer(t.dt$'確定病例數')
t.dt[,.(Sum_ALL=sum(確定病例數)),]  # result_ori.dt[,.(Sum_ALL=sum(確定病例數)),]
# -------------
# str(result_ori.dt);str(t.dt)
# diff value
t2 <- t.dt[!result_ori.dt, on = names(t.dt)]
t3 <- result_ori.dt[!t.dt, on = names(result_ori.dt)]
# t_diff <- merge(t2,t3,all = TRUE)  #can't join together
t_diff <- merge(t2,t3,by=c("確定病名","發病年份","發病週別","縣市","鄉鎮","性別","是否為境外移入","年齡層"),all = TRUE)

# names(result_ori.dt)<- names(t.dt)
# 
time <- Sys.time()
time <- gsub("[^0-9]",replacement="",time) 
time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=16))
result <- t
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
savef <- function(time){
  write.csv(result,paste0("./data/CDC_19CoV_",time,"_Big5",".csv"),row.names = FALSE);
  write.csv(result,paste0("./data/CDC_19CoV_","temp","_Big5",".csv"),row.names = FALSE);
  write.csv(result_op.dt,paste0("./data/CDC_19CoV_County_",time,"_Big5",".csv"),row.names = FALSE);
   write.csv(t_diff,paste0("./data/CDC_19CoV_diff_",time,"_Big5",".csv"),row.names = FALSE);
  print(paste0(paste(result_op.dt$縣市, collapse="、"),"等",length(result_op.dt$縣市),"縣市，共",t.dt[,.(Sum_ALL=sum(確定病例數)),],"例。"))
}

if(nrow(t2)>0){
  savef(time)}else{
    print("not yet updated")}
