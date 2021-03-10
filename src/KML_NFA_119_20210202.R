# https://gis2.emic.gov.tw/emicdata/378.kml?
setwd("data/")
getwd()
Sys.getlocale()
Sys.setlocale(category='LC_ALL', locale='C')
# Sys.setlocale(category = "LC_ALL", locale = "UTF-8")
Sys.setlocale(category='LC_ALL', locale='')
library(rgdal)
download.file("https://gis2.emic.gov.tw/emicdata/378.kml",destfile = "NFA119.kml")
filename<- "NFA119.kml"
# function-------------
KML2df<-function(filename){
  # import <- ogrListLayers(filename)
  # import <- iconv(import, from='UTF-8', to='BIG-5')
  Sys.setlocale(category='LC_ALL', locale='C')
  t <- read.table(filename,sep ="" ,fileEncoding ="UTF-8-BOM", fill=TRUE,stringsAsFactors = FALSE)
  t <- readLines(filename,encoding ="UTF-8-BOM",n = 100000)
  # t <- iconv(t, "UTF-8-BOM", "UTF-8") # 將資料轉成 UTF-8
  t <- enc2utf8(t)
  Encoding(t)
  write.table(t,file = "t.kml",fileEncoding = "UTF-8",row.names=FALSE,quote = FALSE)
  Test <- readOGR(filename, ogrListLayers(filename), use_iconv = TRUE, encoding="UTF-8-BOM", stringsAsFactors = FALSE)
  Test2 <- as.data.frame(Test@coords)
  result.df <- list()
  result.df <-data.frame(Name=Test@data$Name,description=Test@data$Description,lon=Test2$coords.x1,lat=Test2$coords.x2)
  result.df
}

lapply('NFA119.kml', KML2df)
