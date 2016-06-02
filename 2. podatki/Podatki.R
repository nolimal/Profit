Energy<-read.csv("2. podatki/Energy1.csv", sep=";")
Technology<-read.csv("2. podatki/Technology1.csv", sep=";")
Finance<-read.csv("2. podatki/Finance1.csv", sep=";")

Energy_symbols<-Energy$Symbol[c(52,115,123,223,286)]
Technology_symbols<-Technology$Symbol[c(33,34,48,211,365)]
Finance_symbol<-Finance$Symbol[c(121,227,493,532,993)]
Energy5<-Energy[c(52,115,123,223,286),c(-5,-9)]
Finance5<-Finance[c(121,227,493,532,993),c(-5,-9)]
Technology5<-Technology[c(33,34,48,211,365),c(-5,-9)]

sektor<-merge(Energy5,Finance5,all=TRUE)
Sektor<-merge(sektor,Technology5,all=TRUE)
names(Sektor)<-c("Ticker","Name","LastSale","MarketCap","IPOyear", "Type", "Industry")

ceo<-c("John S. Watson","Jeffrey R. Immelt","Dongjin Wang","Patrick Pouyanné","Rex W. Tillerson",
       "Brian T. Moynihan","Francisco A. Aristeguieta","Stuart Gulliver","James Dimon","John G. Stumpf",
       "Tim Cook","Mark Zuckerberg","Larry Page","Larry Page","Satya Nadella")
Sektor[,8]<-ceo
colnames(Sektor)[8]<-"CEO"

Company<-Sektor[,c(1,2,5,8,4,6,7)]

change<-c()
for (i in 1:(nrow(stockData$WFC)-1)){
  change<-c(change,round((stockData$WFC[[i+1,4]]/stockData$WFC[[i,4]])-1,5))
}
change<-c(0,change)
stockData$WFC<-merge(stockData$WFC,change)

for (j in stocksLst[2:length(stocksLst)]){
  change<-c()
  for (i in 1:(nrow(stockData[[j]])-1)){
    change<-c(change,round((stockData[[j]][[i+1,4]]/stockData[[j]][[i,4]])-1,7))
  }
  change<-c(0,change)
  stockData[[j]]<-merge(stockData[[j]],change)
}

write.csv(Energy5, "2. podatki/Energy5.csv")
write.csv(Finance5, "2. podatki/Finance5.csv")
write.csv(Technology5, "2. podatki/Technology5.csv")
write.csv(Company,"2. podatki/Company.csv")

write.csv(WFC,"2. podatki/WFC.csv")
write.csv(AAPL,"2. podatki/AAPL.csv")


# # ne deluje ker je problem pri prehodu na drug ticker
# #dodam stolpec daily.change(%)
# change<-c()
# for (i in 1:(nrow(all.tickers)-1)){
#   change<-c(change,round((all.tickers[i+1,6]/all.tickers[i,6])-1,2)[[1]])
# }
# change<-c(0,change)
# all.tickers["daily.change"]<-change

library(dplyr)
#load("2. podatki/stockdata.RData")
tickers <- stockData$.getSymbols %>% names()
all.tickers <- tickers %>% lapply(. %>% {
  data <- data.frame(stockData[[.]])
  names(data) <- c("Open", "High", "Low", "Close", "Volume", "Adjusted", "Change")
  data.frame(ticker = factor(., levels = tickers),
             index = attr(stockData[[.]], "index"),
             data)
}) %>% bind_rows()
levels(all.tickers$ticker) <- levels(all.tickers$ticker) %>% trimws()

date<-row.names(WFC)
date<-rep(date,15)
all.tickers["date"]<-date

write.csv(all.tickers,"2. podatki/Stock.csv")
