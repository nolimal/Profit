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

write.csv(all.tickers,"2. podatki/Stock.csv")