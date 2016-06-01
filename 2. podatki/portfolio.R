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
sez<-c()
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
  sez<-c(sez,length(m))
}
sel.tickers<-m
#problem, na en dan(na 182 dan) smo zbrali 4 delnice!!
sez[180:190]

#portfolio<-data.frame(date,sel.tickers)





