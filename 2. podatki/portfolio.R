datum<-data.frame(row.names(WFC))
names(datum)<-c("date")
w<-c()
for (i in (2:nrow(datum))){
  w<-c(w,rep(datum[i,1],3))
}
date<-w


#stoplec selected tickers
n<-length(all.tickers$ticker)
nn<-nrow(stockData$WFC)
#sez<-c()
m<-c()
am<-c()
budget<-1000
for (i in 1:(nn-1)){
  a<-seq(1,n,nn)+i
  price<-c()
  for (j in a){
    b<-all.tickers[[j,9]]
    price<-c(price,b)
  }
  dy<-sort(price,decreasing = TRUE)[1:3]
  for (k in a){
    if(all.tickers[[k,9]]%in%dy){
      m<-c(m,all.tickers[[k,1]])
    }
  }
  vsota<-c()
  for (l in m[(length(m)-2):length(m)]){
    tickers <- stockData$.getSymbols %>% names()
    izbrani<-tickers[l]
    kupimo<-stockData[[izbrani]][[i+1,7]]
    am<-c(am,(budget/3)+kupimo*(budget/3))
  }
  vsota<-sum(am[(length(am)-2):length(am)])
  budget[1]<-vsota
  }
sel.tickers<-m


portfolio<-data.frame(date,sel.tickers,am)


