# https://data.gov.tw/datasets/export/json?type=dataset&order=pubdate&qs=&uid=
url <- "https://data.gov.tw/datasets/export/json?type=dataset&order=pubdate&qs=&uid="
library(jsonlite)
t <- fromJSON(url)
result <- fromJSON("./data/datagovtw_dataset_20200401.json")

str(result)
data_time <- max(result$"修訂時間")
time <- gsub("[^0-9]",replacement="",data_time) 
time <- paste0(substr(time,start=1,stop=4),"-",
               substr(time,start=5,stop=6),"-",
               substr(time,start=7,stop=8),"-",
               substr(time,start=9,stop=16))
library(data.table)
result.dt<-data.table(result)
class(result.dt)
result_town.dt <- result.dt[主要欄位說明 %like% '鄉鎮',,]
setwd("./data")
getwd()
write.csv(result_town.dt,paste0("datagovtw_dataset_town_20200401",".csv"),row.names = FALSE)
#-------------- HTML Table
library(DT)
table <-datatable(
  result_town.dt,
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
# table <- datatable(result_town.dt, 
#                    rownames = FALSE,
#                    # filter = "top",
#                    extensions = list('Buttons'), options = list(
#                      # deferRender = TRUE,
#                      # scrollY = 600,
#                      # scroller = TRUE,
#                      autoWidth=TRUE,
#                      dom = 'Bfrtip',
#                      buttons = 
#                        list('copy', 'print', list(
#                          extend = 'collection',
#                          buttons = c('csv', 'excel', 'pdf'),
#                          text = 'Download'
#                        ))
#                           ))
DT::saveWidget(table,"datagovtw_dataset_town_0401.html")
