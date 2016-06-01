portfolio<-data.frame(row.names(WFC))
names(portfolio)<-c("date")
n<-length(all.tickers$ticker)
nn<-nrow(stockData$WFC)

m<-c()
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
}





