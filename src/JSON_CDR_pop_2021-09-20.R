# https://sheets.googleapis.com/v4/spreadsheets/1ImBcGTr_Peaj7X2OI2Tydxhm2QFs3JapChDgBLImF3g/values/now?alt=json&key=AIzaSyDWGy_OmiMZgNE81M0_Tba0656P5K8t7E0
url <- "https://sheets.googleapis.com/v4/spreadsheets/1ImBcGTr_Peaj7X2OI2Tydxhm2QFs3JapChDgBLImF3g/values/now?alt=json&key=AIzaSyDWGy_OmiMZgNE81M0_Tba0656P5K8t7E0"
library(jsonlite)

?fromJSON
t <- fromJSON(url, simplifyVector = FALSE,flatten = TRUE) #,simplifyDataFrame = FALSE  
t$majorDimension
class(t$values)
str(t$values)
colnames <- as.character(t$values[1])
t$values[11]
dim(as.data.frame(t$values))
library(dplyr)
t.df<-lapply((t$values[2:13234]), as.data.frame())
t.df <- do.call("rbind", t.df) #%>%distinct()
  as.matrix(as.character(t$values))
t$values
# install.packages("googlesheets4")
library(googlesheets4)
t <- read_sheet("https://docs.google.com/spreadsheets/d/1ImBcGTr_Peaj7X2OI2Tydxhm2QFs3JapChDgBLImF3g/edit#gid=0",sheet = "now",)
t <- read_sheet("1ImBcGTr_Peaj7X2OI2Tydxhm2QFs3JapChDgBLImF3g")
