library(parallel)
library(XML)
library(RCurl)

no_cores <- detectCores() - 1

# Calculate the number of cores
cl <- makeCluster(no_cores)

#make libraries available in other nodes
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

#make functions available in other nodes
clusterExport(cl, "htmlParseFunc")
clusterExport(cl, "hrefFun")

mypage <- readHTMLTable(htmlParseFunc(baseurl), elFun = hrefFun,stringsAsFactors = FALSE)

#grab 5th table
sectorurls <- mypage[[5]]$`SectorÂ `

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
industrypagedata <- parLapply(cl,industrypages,readHTMLTable,stringsAsFactors = FALSE)

#first 4 entries don't matter
industrypagedata <- parLapply(cl,industrypagedata,function(x) tail(x[[4]][[1]],length(x[[4]][[1]])-4))

#make one big list
industrypagedata <- unlist(industrypagedata)

#remove companies string. some tables had them as 5th entry and some didn't
industrypagedata <- industrypagedata[industrypagedata != "Companies"]

stocks <- sub("\\).*", "", sub(".*\\(", "", industrypagedata)) 

stocks

#and we're done!
stopCluster(cl)