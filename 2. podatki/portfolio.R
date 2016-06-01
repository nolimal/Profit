portfolio<-data.frame(row.names(WFC))
names(portfolio)<-c("date")
n<-length(all.tickers$ticker)
nn<-nrow(stockData$WFC)

vektor<-seq(1,n,nn)
for (i in 1:(nn-1)){
  a<-seq(1,n,nn)+i
  vektor<-c(vektor,a)
  price<-c()
  for (j in a){
    b<-all.tickers[[j,9]]
    price<-c(price,b)
  }
  dy<-sort(price,decreasing = TRUE)[1:3]
#   majstore<-c()
#   for (k in a){
#     ifelse(all.tickers[[k,9]]%in%dy, majstore<-c(majstore,all.tickers[[k,2]]),break)
#   }
}