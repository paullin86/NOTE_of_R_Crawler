# http://data.nhi.gov.tw/Datasets/Download.ashx?rid=A21030000I-D50001-001&l=https://data.nhi.gov.tw/resource/mask/maskdata.csv
url <- "https://data.nhi.gov.tw/resource/mask/maskdata.csv"
library(readr)
result <- read_csv(url,
                   col_types =  cols(
                     .default = col_character(),
                     "成人口罩剩餘數" = col_integer(),
                     "兒童口罩剩餘數" = col_integer()
                   ))
# str(t)
# colnames(t)
data_time <- max(result$"來源資料時間")
time <- gsub("[^0-9]",replacement="",data_time) 
time <- paste0(substr(time,start=1,stop=4),"-",
               substr(time,start=5,stop=6),"-",
               substr(time,start=7,stop=8),"-",
               substr(time,start=9,stop=16))
# setwd("~/R/mask")
write.csv(result,paste0("./data/maskdata_",time,".csv"),row.names = FALSE)
readr::write_csv(result,paste0("./data/maskdata_",time,"_uni.csv")) #,row.names = FALSE,fileEncoding = "UTF-8"
