library(shiny)
library(dplyr)
library(RPostgreSQL)
library(ggplot2)

if ("server.R" %in% dir()) {
  setwd("..")
}
source("3. baza/auth.R",encoding='UTF-8')

# library(datasets)

# Define a server for the Shiny app
shinyServer(function(input, output) {
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  tbl.stock <- tbl(conn, "stock")
  
  # Fill in the spot we created for a plot
  output$stock <- renderPlot({
    tab <- tbl.stock
    if (input$ticker != "All") {
      tab <- tab %>% filter(ticker == input$ticker)
    }
    
    ggplot(data.frame(tab), aes_string(x = "ticker", y = "close")) + geom_bar(stat = "identity") +
      ggtitle(input$ticker) + xlab("Ticker") + ylab("Close")
  })
  
})


