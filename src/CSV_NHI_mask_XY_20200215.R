# https://github.com/kiang/pharmacies
# http://data.nhi.gov.tw/Datasets/Download.ashx?rid=A21030000I-D50001-001&l=https://data.nhi.gov.tw/resource/mask/maskdata.csv
# https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json
url <- "https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json"
library(jsonlite)
t <- fromJSON(url)
str(t$features$geometry$coordinates[1])


library(tidyverse)
t2 <- unlist(t$features$geometry$coordinates) %>% 
  matrix(nrow=6864, ncol=2,byrow = TRUE) %>% as.data.frame() 
colnames(t2)=c("lon","lat")
result <- cbind(t$features$properties,t2)
# remove(result)
head(result)
data_time <- max(result$updated)
time <- gsub("[^0-9]",replacement="",data_time) 
time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=16))
write.csv(result,paste0("./data/NHI_mask_XY_Big5_",time,".csv"),row.names = FALSE)

