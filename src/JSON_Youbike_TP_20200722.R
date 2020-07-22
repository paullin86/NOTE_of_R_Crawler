# 	https://tcgbusfs.blob.core.windows.net/blobyoubike/YouBikeTP.json
# https://data.taipei/#/dataset/detail?id=8ef1626a-892a-4218-8344-f7ac46e1aa48
url <- "https://tcgbusfs.blob.core.windows.net/blobyoubike/YouBikeTP.json"
library(jsonlite)
t <- fromJSON(url)
result <- t$retVal
result.df <-do.call("rbind", lapply(result, as.data.frame))   #R list(structure(list())) to data frame
result.df <- data.frame(result.df,stringsAsFactors = FALSE)
as.character.Date(result.df$mday)
data_time <- max(as.character.Date(result.df$mday))
time <- gsub("[^0-9]",replacement="",data_time) 
time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=16))
write.csv(result.df,paste0("./data/Youbike_TP_",time,"_Big5",".csv"),row.names = FALSE)
