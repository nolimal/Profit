setwd("U:/opb")
#install.packages("quantmod")
library("quantmod")
#Script to download prices from yahoo
#and Save the prices to a RData file
#The tickers will be loaded from a csv file

#Script Parameters
tickerlist <- "tickers.txt"  #CSV containing tickers on rows
savefilename <- "stockdata.RData" #The file to save the data in
startDate = as.Date("2015-01-01") #Specify what date to get the prices from
maxretryattempts <- 5 #If there is an error downloading a price how many times to retry

#Load the list of ticker symbols from a csv, each row contains a ticker
stocksLst <- read.csv("tickers.txt", header = F, stringsAsFactors = F)
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
DF<-merge(stockData$"WFC"[,4],
           stockData$` AAPL`[,4],
           stockData$` BAC`[,4],
           stockData$` C`[,4],
           stockData$` CVX`[,4],
           stockData$` FB`[,4],
           stockData$` GE`[,4],
           stockData$` GOOG`[,4],
           stockData$` GOOGL`[,4],
           stockData$` HSBC`[,4],
           stockData$` JPM`[,4],
           stockData$` MSFT`[,4],
           stockData$` PTR`[,4],
           stockData$` TOT`[,4],
           stockData$` XOM`[,4],
           all=TRUE)
# it has to be data.frame for easier work
Data <- as.data.frame(DF)

# Izbrani tickerji
# View(stocksLst)

# Vsi izbrani s podatki close
# View(Data)

# Vsi podatki za ticker WFC
# View(stockData$WFC)

# View(stockData$` AAPL`)
# names(stockData$WFC


cat("Končana vizualizacija.r.\n")
#Proba
