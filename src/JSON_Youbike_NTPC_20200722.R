# https://data.ntpc.gov.tw/datasets/71CD1490-A2DF-4198-BEF1-318479775E8A
# https://data.ntpc.gov.tw/api/datasets/71CD1490-A2DF-4198-BEF1-318479775E8A/json?page=0&size=500
url <- "https://data.ntpc.gov.tw/api/datasets/71CD1490-A2DF-4198-BEF1-318479775E8A/json?page=0&size=700"
library(jsonlite)
t <- fromJSON(url)
# result <- t$retVal
# result.df <-do.call("rbind", lapply(result, as.data.frame))   #R list(structure(list())) to data frame
result.df <- t
# as.character.Date(result.df$mday)
data_time <- max(as.character.Date(result.df$mday))
time <- gsub("[^0-9]",replacement="",data_time) 
time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=16))
write.csv(result.df,paste0("./data/Youbike_NTPC_",time,"_Big5",".csv"),row.names = FALSE)
