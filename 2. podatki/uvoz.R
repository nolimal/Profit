#install.packages("quantmod")
library("quantmod")
#Script to download prices from yahoo
#and Save the prices to a RData file
#The tickers will be loaded from a csv file

#Script Parameters
tickerlist <- "2. podatki/tickers.txt"  #CSV containing tickers on rows
savefilename <- "stockdata.RData" #The file to save the data in
startDate = as.Date("2015-01-01") #Specify what date to get the prices from
maxretryattempts <- 5 #If there is an error downloading a price how many times to retry

#Load the list of ticker symbols from a csv, each row contains a ticker
stocksLst <- read.csv("2. podatki/tickers.txt", header = F, stringsAsFactors = F)
stocksLst <- t(stocksLst)
stockData <- new.env() #Make a new environment for quantmod to store data in
nrstocks = length(stocksLst[,1]) #The number of stocks to download

#Download all the stock data
for (i in 1:nrstocks){
  for(t in 1:maxretryattempts){
    
    tryCatch(
      {
        #This is the statement to Try
        #Check to see if the variables exists
        #NEAT TRICK ON HOW TO TURN A STRING INTO A VARIABLE
        #SEE  http://www.r-bloggers.com/converting-a-string-to-a-variable-name-on-the-fly-and-vice-versa-in-r/
        if(!is.null(eval(parse(text=paste("stockData$",stocksLst[i,1],sep=""))))){
          #The variable exists so dont need to download data for this stock
          #So lets break out of the retry loop and process the next stock
          #cat("No need to retry")
          break
        }
        
        #The stock wasnt previously downloaded so lets attempt to download it
        cat("(",i,"/",nrstocks,") ","Downloading ", stocksLst[i,1] , "\t\t Attempt: ", t , "/", maxretryattempts,"\n")
        getSymbols(stocksLst[i,1], env = stockData, src = "yahoo", from = startDate)
      }
      #Specify the catch function, and the finally function
      , error = function(e) print(e))
  }
}

#Lets save the stock data to a data file
tryCatch(
  {
    save(stockData, file=savefilename)
    cat("Sucessfully saved the stock data to %s",savefilename,"\n")
  }
  , error = function(e) print(e))
cat("Končan uvoz.r.\n")


#Making "double" about stock prices on daily basis
# MATRIX
DF<-merge(stockData$"WFC"[,1:6],
           stockData$` AAPL`[,1:6],
           stockData$` BAC`[,1:6],
           stockData$` C`[,1:6],
           stockData$` CVX`[,1:6],
           stockData$` FB`[,1:6],
           stockData$` GE`[,1:6],
           stockData$` GOOG`[,1:6],
           stockData$` GOOGL`[,1:6],
           stockData$` HSBC`[,1:6],
           stockData$` JPM`[,1:6],
           stockData$` MSFT`[,1:6],
           stockData$` PTR`[,1:6],
           stockData$` TOT`[,1:6],
           stockData$` XOM`[,1:6],
           all=TRUE)
# it has to be data.frame for easier work
Data <- as.data.frame(DF)

# Izbrani tickerji
# View(stocksLst)

# Vsi izbrani s podatki close
# View(Data)

# Vsi podatki za ticker WFC
# View(stockData$WFC)
# names(stockData$WFC)
WFC<-as.data.frame(stockData$WFC)
WFC[,"id"]<-c(1:length(WFC[,1]))
WFC<-WFC[,c(7,1,2,3,4,5,6)]
# View(WFC)

# View(stockData$` AAPL`)
AAPL<-as.data.frame(stockData$` AAPL`)
AAPL[,"id"]<-c((length(AAPL[,1])+1):(length(AAPL[,1])*2))
AAPL<-AAPL[,c(7,1,2,3,4,5,6)]

library(dplyr)
load("2. podatki/stockdata.RData")
tickers <- stockData$.getSymbols %>% names()
all.tickers <- tickers %>% lapply(. %>% {
  data <- data.frame(stockData[[.]])
  names(data) <- c("Open", "High", "Low", "Close", "Volume", "Adjusted")
  data.frame(ticker = factor(., levels = tickers),
             index = attr(stockData[[.]], "index"),
             data)
}) %>% bind_rows()
levels(all.tickers$ticker) <- levels(all.tickers$ticker) %>% trimws()

cat("Končana vizualizacija.r.\n")
