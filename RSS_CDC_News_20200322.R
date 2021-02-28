# https://www.cdc.gov.tw/RSS/RssXml/Hh094B49-DRwe2RR4eFfrQ?type=3
# https://www.cdc.gov.tw/RSS/RssXml/Hh094B49-DRwe2RR4eFfrQ?type=1


url <- "https://www.cdc.gov.tw/RSS/RssXml/Hh094B49-DRwe2RR4eFfrQ?type=1"
# install.packages("tidyRSS")
library(tidyRSS)
t <- tidyRSS::tidyfeed(url,parse_dates = TRUE,)

# raw <-readr::read_lines_raw(url, skip = 0, n_max = -1L)
raw <-readr::read_lines(url, skip = 0, n_max = -1L)

raw <- gsub("a10:",replacement="",raw)
raw <-noquote(raw)
# raw <-print(cat(raw))
# raw <-cat(raw)
# Encoding(raw) <- "UTF-8"

# raw <- paste0(raw)
write.table(raw, file = paste0("./data/CDC_RSS_temp",".XML"), sep = "",row.names = FALSE,col.names = FALSE,append = TRUE)
  # readr::write_file(raw,paste0("./data/CDC_RSS_temp",".XML")) #,row.names = FALSE,fileEncoding = "UTF-8"
t <- tidyRSS::tidyfeed("CDC_RSS_temp.XML",parse_dates = TRUE,)

# install.packages("jsonlite")
# =====================================
# raw <- readLines(url,encoding = "UTF-8")

library(XML)
xf <- htmlTreeParse(raw,
                    error = function (...) {}, useInternalNodes = F) #,encoding = "UTF-8"
# xf <- htmlTreeParse(XML::xml(raw),
                    # error = function (...) {}, useInternalNodes = F,encoding = "UTF-8") 
XML::isXMLString(raw)
XML::x(raw)
class(xf$children$html)
XML::getNodeSet(xf$children$html,'/link')
link <- xpathSApply(xf$children$html, path ="//item/link", xmlValue)
link <- xpathSApply(xf$children$html, path ="//item/link", xmlValue)
updated <- xpathSApply(xf$children$html, path ="//item/updated", xmlValue)
link <- xpathSApply(xf$children$html, path ="//item/link", xmlValue)

# =====================================
library(xml2)

xfile <- xml2::read_xml("./data/CDC_RSS_temp.XML",as_html =TRUE,encoding = "UTF-8")
# xfile <- xml2::read_xml(url,as_html =TRUE,encoding = "UTF-8")
link<-xml_text(xml_find_all(xfile,"//item/link"))
title<-xml_text(xml_find_all(xfile,"//item/title"))
description<-xml_text(xml_find_all(xfile,"//item/description"))
updated<-xml_text(xml_find_all(xfile,"//updated'"))
link<-xml_text(xml_find_all(xfile,"//item/link"))
# =====================================
library(rvest)
doc <- read_html(url)
doc%>% html_nodes("tr:nth-child(2) li")
t <- doc %>% html_nodes(xpath ="/html/body/form[@id='form1']/div[@class='container']/div[@class='content titleBG']/div[@class='mainpanes']/div[@id='JsonDiv']/div[@class='mainBOX'][2]/table[@class='win_list']//tr[2]//ul[@class='JSONList']/li") %>% 
  html_text()  # 取得text
