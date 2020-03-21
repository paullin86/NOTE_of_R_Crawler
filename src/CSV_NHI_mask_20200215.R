# http://data.nhi.gov.tw/Datasets/Download.ashx?rid=A21030000I-D50001-001&l=https://data.nhi.gov.tw/resource/mask/maskdata.csv
url <- "https://data.nhi.gov.tw/resource/mask/maskdata.csv"
library(readr)
result <- read_csv(url,
                   col_types =  cols(
                     "醫事機構代碼" = col_character(),
                     "醫事機構名稱" = col_character(),
                     "醫事機構地址" = col_character(),
                     "醫事機構電話" = col_character(),
                     "成人口罩剩餘數" = col_integer(),
                     "兒童口罩剩餘數" = col_integer(),
                     "來源資料時間" = col_character()
                   ))
# str(t)
# colnames(t)
data_time <- max(result$"來源資料時間")
time <- gsub("[^0-9]",replacement="",data_time) 
time <- paste0(substr(time,start=1,stop=4),"-",
               substr(time,start=5,stop=6),"-",
               substr(time,start=7,stop=8),"-",
               substr(time,start=9,stop=16))
setwd("~/R/mask")
write.csv(result,paste0("./data/maskdata_",time,".csv"),row.names = FALSE)

