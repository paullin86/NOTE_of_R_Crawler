# https://gic.wra.gov.tw/Gis/Gic/API/Google/Index.aspx
# https://gic.wra.gov.tw/Gis/gic/ApplyIntra/Svr_ApplyList.aspx
# https://gic.wra.gov.tw/Gis/Gic/ApplyWeb/ApplyWms.aspx

# remove.packages("rvest", lib="~/R/win-library/3.6")
# package_url <- "https://cran.r-project.org/src/contrib/Archive/rvest/rvest_0.3.6.tar.gz"
# install.packages(package_url, repos=NULL, type="source")
library(rvest)
htmlContent  <- read_html("https://gic.wra.gov.tw/Gis/Gic/API/Google/Index.aspx")


# Path_T ="///td[6]"
# T <- htmlContent  %>% html_nodes("table") %>% html_table(
#   # htmlContent,
#   header = TRUE,
#   trim = TRUE,
#   fill = deprecated(),
#   dec = "."#,
#   # na.strings = "NA",
#   # convert = TRUE
# )


fileNames= htmlContent  %>% html_nodes(".Btn_Orange_view") #%>% 
target  <- grep(pattern ="downloadFile\\(.*\\)",fileNames)
fileNames
fileNames<-html_attr(fileNames[target],"onclick")
# fname <- gsub("[downloadFile\\(||\\);|| ||SHP||KML||,||'||SHP119||\\\",\\\"]","",fileNames)
# fname <- grep(pattern="\\((.*)\\)",fileNames)
fname <- gsub("downloadFile\\(","",fileNames)
fname <- gsub("[\\\"||\\)]","",fname)

# type <- grep("[^SHP.*]",fname)
# head(type)

# grep("downloadFile\\([A-z]+[1-9]+.*\\)",fileNames)

MDs= htmlContent  %>% html_nodes(".Btn_Orange_new") #%>% 
target  <- grep("go_MetaData_Detail\\([1-9]+.*\\)",MDs)
MDs
MDs<-html_attr(MDs[target],"onclick")
MD_ <- gsub("[go_MetaData_Detail\\(||\\);|| ||SHP||KML||,||']","",MDs)
MD_



Path_title ="///td[2]"
titles= htmlContent  %>% html_nodes(xpath=Path_title) %>% html_text()
titles <- gsub("[\r\n|| ||\U00A0]","",titles)
head(titles)

geometry ="///td[3]"
geometry= htmlContent  %>% html_nodes(xpath=Path_type) %>% html_text()
geometry <- gsub("\r\n","",geometry)
geometry <- gsub(" {2,}","",geometry)


Path_buildtime ="///td[4]"
buildtime= htmlContent  %>% html_nodes(xpath=Path_buildtime) %>% html_text()

Path_releasetime ="///td[5]"
releasetime= htmlContent  %>% html_nodes(xpath=Path_releasetime) %>% html_text()

result.df <- data.frame(MD_=MD_,fname_type=fname,DataName=titles,geometry=geometry,buildtime=buildtime,releasetime=releasetime)
head(result.df)
# 將每一字串分割成 2 欄，並新增至 Data Frame 中
library(tidyr)
result.df <- separate(result.df,fname_type,c("fname","type"),",")

#組URL字串
URL_Meta <- "https://gic.wra.gov.tw/Gis/Gic/DataIndex/MetaData/ShowDetail.aspx?MD_ID="
URL_XML <- "https://gic.wra.gov.tw/Gis/Gic/DataIndex/MetaData/ShowXML.aspx?MD_ID="
URL_DL <- "https://gic.wra.gov.tw/Gis/gic/API/Google/DownLoad.aspx?fname="
  
library(data.table)
result.dt <- result.df%>% data.table() %>% .[,.(MataData_URL:=paste0(URL_Meta,MD_,"&type=",type),
                                              MataData_XML:=paste0(URL_XML,MD_,"&type=",type),
                                              URL_data:=paste0(URL_DL,fname,"&filetype=",type))]

# save
time <- Sys.time()
time <- gsub("[^0-9]",replacement="",time) 
time <- paste0(substr(time,start=1,stop=4),"-",substr(time,start=5,stop=6),"-",substr(time,start=7,stop=8))
write.csv(result.df,paste0("./data/GIC_",time,"_Big5",".csv"),row.names = FALSE)