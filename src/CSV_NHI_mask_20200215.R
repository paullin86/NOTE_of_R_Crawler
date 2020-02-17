# https://github.com/kiang/pharmacies
# http://data.nhi.gov.tw/Datasets/Download.ashx?rid=A21030000I-D50001-001&l=https://data.nhi.gov.tw/resource/mask/maskdata.csv
# https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json
url <- "http://data.nhi.gov.tw/Datasets/Download.ashx?rid=A21030000I-D50001-001&l=https://data.nhi.gov.tw/resource/mask/maskdata.csv"
result <- read_csv(url)
# str(t)
# colnames(t)
data_time <- max(result$來源資料時間)
time <- gsub("[^0-9]",replacement="",data_time) 
time <- paste0(substr(time,start=1,stop=4),"-",
               substr(time,start=5,stop=6),"-",
               substr(time,start=7,stop=8),"-",
               substr(time,start=9,stop=16))
write.csv(result,paste0("./data/maskdata_",time,".csv"),row.names = FALSE)

