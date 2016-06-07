library(shiny)
library(dplyr)
library(RPostgreSQL)
library(ggplot2)

if ("server.R" %in% dir()) {
  setwd("..")
}
source("3. baza/auth_public.R",encoding='UTF-8')



# Define a server for the Shiny app
shinyServer(function(input, output) {
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  tbl.portfolio <- tbl(conn, "portfolio") # tabela s portfelji
  
  # Fill in the spot we created for a plot
  output$portfolio <- renderPlot({
    tab <- tbl.portfolio
    data <- tab %>% filter(index == indeks.portfelja, date2 == datum) %>%
      select(ticker, am) %>% data.frame()
    if (input$type != "All") {
      graf<-ggplot(data, aes_string(x = "date", y = input$sel_tickers)) +
        geom_bar(stat = "identity")
    } else {
      graf<-ggplot(data, aes_string(x = "date", y = input$sel_tickers)) + geom_bar(stat = "identity")
  }
    graf + xlab("Date") + ylab("Asset Movement")
  })
  
})
