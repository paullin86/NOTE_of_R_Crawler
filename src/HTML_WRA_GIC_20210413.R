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
MD_ <- as.integer(MD_)



Path_title ="///td[2]"
titles= htmlContent  %>% html_nodes(xpath=Path_title) %>% html_text()
titles <- gsub("[\r\n|| ||\U00A0]","",titles)
head(titles)

Path_type ="///td[3]"
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
result.dt <- result.df%>% data.table() %>% 
  .[,c("ID","MataData_URL","MataData_XML","URL_data"):=list(paste0("MD_ID=",MD_,"&type=",type),
                                                      paste0(URL_Meta,MD_,"&type=",type),
                                                      paste0(URL_XML,MD_,"&type=",type),
                                                      paste0(URL_DL,fname,"&filetype=",type)), ] %>% 
  .[,.(MD_,type,ID,fname,DataName,geometry,buildtime,releasetime,MataData_URL,MataData_XML,URL_data),]

colnames(result.dt)

type<-c('SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP','SHP119','SHP119','SHP119','SHP119','SHP119','SHP119','SHP119','SHP119','SHP119')
fname<-c('RIVWLSTA_e','RIVWLSTA_a','RIVQASTA_e','RIVQASTA_a','RIVSESTA','RCROSPIL','rcrossec','RIVERLIN','RIVERPOLY','BASIN','RVB','gwobwell_e','gwobwell_a','LASUBSTA','SWWRB','subasta','gwconare','gwconare2','GWREGION','WATRELIN','SWRESOIR','ressub','TWQPROT','wratb','WEBREG','reservoir','DIKEGATE','PUMP_DRAIN','rivdike','RIVERL','coastdik','REGDL','gwobwell_e_119','gwobwell_a_119','gwconare2_119','GWREGION_119','SWRESOIR_119','ressub_119','TWQPROT_119','reservoir_119','coastdik_119')
圖徵NO<-as.integer(c('7','7','5','5','6','3','4','1','1','2','22','12','12','17','15','16','14','14','13','19','28','30','27','20','21','29','31','32','33','37','34','23','12','12','14','13','28','30','27','29','34'))
HYD類別<-c('HRV_河川水位測站','HRV_河川水位測站','HRV_河川流量測站','HRV_河川流量測站','HRV_河川含沙量測站','HRV_河川斷面樁','HRV_河川斷面線','HRV_河川','HRV_河川','HRV_河川流域','HRA_河川局管轄範圍','HGW_地下水觀測井','HGW_地下水觀測井','HLS_地層下陷GPS監測站','HLS_地層下陷水準高程檢測點','HLS_磁環分層式地層下陷監測井','HGW_地下水管制區','HGW_地下水管制區','HGW_地下水分區','HRA_水利署及所屬單位位置','HRS_水庫','HRS_水庫蓄水範圍','HSE_自來水水質水量保護區','HRA_水源特定區','HRA_水資源分區','HRS_水庫集水區','HFP_水門','HFP_抽水站','HFP_堤防或護岸','HFP_河川區域線','HFP_海堤','HDF_排水設施範圍','HGW_地下水觀測井','HGW_地下水觀測井','HGW_地下水管制區','HGW_地下水分區','HRS_水庫','HRS_水庫蓄水範圍','HSE_自來水水質水量保護區','HRS_水庫集水區','HFP_海堤')
DataName<-c('河川水位測站位置圖_現存站','河川水位測站位置圖_已廢站','河川流量測站位置圖_現存站','河川流量測站位置圖_已廢站','含沙量測站位置圖','河川斷面樁位置圖','河川斷面線位置圖','河川(支流)','河川(河道)','河川流域範圍圖','河川局管轄範圍圖','地下水觀測井位置圖_現存站','地下水觀測井位置圖_已廢站','地層下陷GPS監測站','地層下陷水準高程檢測點','磁環分層式地層下陷監測井','地下水第一級管制區','地下水第二級管制區','地下水分區範圍圖','水利署及所屬單位位置圖','水庫堰壩位置圖','水庫蓄水範圍','自來水水質水量保護區圖','台北水源特定區圖','水資源分區圖','水庫集水區','水門位置圖','抽水站位置圖','堤防或護岸位置圖','中央管河川區域線','一般性海堤區域','中央管排水設施範圍','地下水觀測井位置圖_現存站','地下水觀測井位置圖_已廢站','地下水第二級管制區','地下水分區範圍圖','水庫堰壩位置圖','水庫蓄水範圍','自來水水質水量保護區圖','水庫集水區','一般性海堤區域')

feather <- data.frame(type,fname,圖徵NO,HYD類別,DataName) %>% data.table() %>% 
  .[,.(type,fname,圖徵NO,HYD類別),]

t2 <- feather[result.dt, on = names(feather)[1:2]]%>% 
  .[,.(MD_,type,ID,fname,圖徵NO,HYD類別,DataName,geometry,buildtime,releasetime,MataData_URL,MataData_XML,URL_data),] %>% 
  .[order(圖徵NO,-type,MD_)]
# t2[is.na(t2)] <- "-"  #以空值取代NA

# save
time <- Sys.time()
time <- gsub("[^0-9]",replacement="",time) 
time <- paste0(substr(time,start=1,stop=4),"-",substr(time,start=5,stop=6),"-",substr(time,start=7,stop=8))
write.csv(result.dt,paste0("./data/GIC_",time,"_Big5",".csv"),row.names = FALSE, na = "")
write.csv(t2,paste0("./data/GIC_DataDownload_",time,"_Big5",".csv"),row.names = FALSE, na = "")
