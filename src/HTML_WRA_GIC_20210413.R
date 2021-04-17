# https://gic.wra.gov.tw/Gis/Gic/API/Google/Index.aspx
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
target  <- grep("downloadFile\\(.*\\)",fileNames)
fileNames
fileNames<-html_attr(fileNames[target],"onclick")

MDs= htmlContent  %>% html_nodes(".Btn_Orange_new") #%>% 
target  <- grep("go_MetaData_Detail\\([1-9]+.*\\)",MDs)
MDs
MDs<-html_attr(MDs[target],"onclick")

Path_title ="///td[2]"
titles= htmlContent  %>% html_nodes(xpath=Path_title) %>% html_text()
titles <- gsub("\r\n","",titles)
titles <- gsub(" ","",titles)
titles <- gsub("\U00A0","",titles)
head(titles)

Path_type ="///td[3]"
type= htmlContent  %>% html_nodes(xpath=Path_type) %>% html_text()
type <- gsub("\r\n","",type)
type <- gsub(" {2,}","",type)


Path_buildtime ="///td[4]"
buildtime= htmlContent  %>% html_nodes(xpath=Path_buildtime) %>% html_text()

Path_releasetime ="///td[5]"
releasetime= htmlContent  %>% html_nodes(xpath=Path_releasetime) %>% html_text()

result.df <- data.frame(DataName=titles,type=type,buildtime=buildtime,releasetime=releasetime)
head(result.df)

# save
time <- Sys.time()
time <- gsub("[^0-9]",replacement="",time) 
time <- paste0(substr(time,start=1,stop=4),"-",substr(time,start=5,stop=6),"-",substr(time,start=7,stop=8))
write.csv(result.df,paste0("./data/GIC_",time,"_Big5",".csv"),row.names = FALSE)