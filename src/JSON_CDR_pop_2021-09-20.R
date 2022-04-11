rm(list=ls())
# https://sheets.googleapis.com/v4/spreadsheets/1ImBcGTr_Peaj7X2OI2Tydxhm2QFs3JapChDgBLImF3g/values/now?alt=json&key=AIzaSyDWGy_OmiMZgNE81M0_Tba0656P5K8t7E0
url <- "https://sheets.googleapis.com/v4/spreadsheets/1ImBcGTr_Peaj7X2OI2Tydxhm2QFs3JapChDgBLImF3g/values/now?alt=json&key=AIzaSyDWGy_OmiMZgNE81M0_Tba0656P5K8t7E0"
library(jsonlite)

?fromJSON
# t <- fromJSON(url, simplifyVector = FALSE,flatten = TRUE) #,simplifyDataFrame = FALSE  
t <- fromJSON(url,flatten = TRUE)
# t$majorDimension
class(t$values)
# str(t$values)
colnames <- as.character(t$values[[1]])
# t$values[11]
# dim(as.data.frame(t$values))
length(t$values)
library(dplyr)
t.df <- as.data.frame(do.call(rbind, t$values[2:length(t$values)]),stringsAsFactors = FALSE)
colnames(t.df) <- colnames
head(t.df)
result <- t.df
data_time <- max(result$time)
time <- gsub("[^0-9]",replacement="",data_time) 
time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=12))
# readr::write_csv(result,paste0("./data/MOTC_incident_",time,".csv")) #,row.names = FALSE,fileEncoding = "UTF-8"
write.csv(result,paste0("./data/CDR_pop_",time,"_Big5",".csv"),row.names = FALSE)
