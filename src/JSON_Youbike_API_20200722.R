# https://apis.youbike.com.tw/api/front/station/all?lang=tw&type=1
url <- "https://apis.youbike.com.tw/api/front/station/all?lang=tw&type=1"
library(jsonlite)
t <- fromJSON(url)
result.df <- t$retVal
# result.df <-do.call("rbind", lapply(result, as.data.frame))   #R list(structure(list())) to data frame
# result.df <- data.frame(result.df,stringsAsFactors = FALSE)
# as.character.Date(result.df$mday)
data_time <- max(as.character.Date(result.df$time))
time <- gsub("[^0-9]",replacement="",data_time) 
time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=16))
write.csv(result.df,paste0("./data/Youbike_API_",time,"_Big5",".csv"),row.names = FALSE)
readr::write_csv(result,paste0("./data/Youbike_API_",time,"_uni.csv")) #,row.names = FALSE,fileEncoding = "UTF-8"
