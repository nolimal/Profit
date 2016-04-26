setwd("U:/OPB/backup")
Energy<-read.csv("Energy1.csv", sep=";")
Technology<-read.csv("Technology1.csv", sep=";")
Finance<-read.csv("Finance1.csv", sep=";")

Energy_symbols<-Energy$Symbol[c(52,115,123,223,286)]
Technology_symbols<-Technology$Symbol[c(33,34,48,211,365)]
Finance_symbol<-Finance$Symbol[c(121,227,493,532,993)]
Energy5<-Energy[c(52,115,123,223,286),c(-5,-9)]
Finance5<-Finance[c(121,227,493,532,993),c(-5,-9)]
Technology5<-Technology[c(33,34,48,211,365),c(-5,-9)]
