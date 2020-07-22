# https://opendata.taichung.gov.tw/dataset/3ac86a9b-1a9f-11e8-8f43-00155d021202	
# http://datacenter.taichung.gov.tw/swagger/OpenData/b77b2146-9e3f-4e5f-a31b-cef171c0285b
url <- "https://datacenter.taichung.gov.tw/swagger/OpenData/e8323bd0-3d05-47e0-a8c1-3a13bbb95716"
# 利用readLines讀取網路上的資料
# dump <- readLines(url, warn=F) # utf8 編碼
# head(dump)
# 利用iconv轉換文字編碼 (windows user only)
# t	<-	iconv(dump,	from="utf8")
library(jsonlite)
t <- fromJSON(url)
result <- t
time <- Sys.time()
time <- gsub("[^0-9]",replacement="",time) 
time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=12))
type <- data.frame(table(t$案件類別))
piptype <- data.frame(table(t$管線工程類別))
# time <- paste0(substr(time,start=1,stop=8),"_",substr(time,start=9,stop=16))
# readr::write_csv(result,paste0("./data/MOTC_incident_",time,".csv")) #,row.names = FALSE,fileEncoding = "UTF-8"
write.csv(result,paste0("./data/TC_roadConstruction_",time,"_Big5",".csv"),row.names = FALSE)
#-------------- HTML Table
library(DT)
table <-datatable(
  result,
  rownames = FALSE,
  extensions = 'Buttons', options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy', 'print', list(
        extend = 'collection',
        buttons = c('csv', 'excel', 'pdf'),
        text = 'Download'
      )),
    pageLength = 50
    
  )
)
DT::saveWidget(table,paste0("./data/TC_roadConstruction_",time,".html"))
