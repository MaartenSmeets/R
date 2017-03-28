# Calculate the number of cores
no_cores <- detectCores() - 1

cl <- makeCluster(no_cores)

clusterEvalQ(cl, {
  library(XML)
  library(RCurl)
  library(parallel)
  }
)

baseurl <- "https://biz.yahoo.com/p/"

hrefFun <- function(x){
  xpathSApply(x,'./a',xmlAttrs)  
}

htmlParseFunc <- function(x) {
  htmlRaw <- getURLContent(x,followlocation = TRUE, binary = TRUE)
  htmlAsc <- htmlRaw
  # find where the NULLs are
  htmlNul <- htmlRaw == as.raw(0)
  # modify the new vector NULLs to SPACEs
  htmlAsc[htmlNul] <- as.raw(20)
  # you can now convert these to Char
  return (rawToChar(htmlAsc))
}

clusterExport(cl, "htmlParseFunc")
clusterExport(cl, "hrefFun")

mypage <- readHTMLTable(htmlParseFunc(baseurl), elFun = hrefFun,stringsAsFactors = FALSE)

#grab 4th table
sectorurls <- mypage[[4]]$V1

#prepend baseurl
sectorurls <- paste0(baseurl,sectorurls) 

#fetch all data (raw)
sectorpages <- parLapply(cl,sectorurls,htmlParseFunc)

#list of list of data.frame (parsed data)
sectorpagedata <- parLapply(cl,sectorpages,readHTMLTable,elFun = hrefFun,stringsAsFactors = FALSE)

#list of data.frame
industryurls <- parLapply(cl,sectorpagedata, function (x) x[[4]]$V1)

#remove first 3 rows -> no relevant data there
industryurls <- parLapply(cl,industryurls,function(x) tail(x,length(x)-3))

#create one big list
industryurls <- unlist(industryurls)

#prepend base url
industryurls <- paste0(baseurl,industryurls) 

#fetch all data (raw)
industrypages <- parLapply(cl,industryurls,htmlParseFunc)

#parse data
industrypagedata <- parLapply(industrypages,readHTMLTable,elFun = hrefFun,stringsAsFactors = FALSE)

stopCluster(cl)

industrypagedata

