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
  tbl.company <- tbl(conn, "company")
  tbl.stock <- tbl(conn, "stock")
  tbl.stock1 <- tbl(conn, "stock")
  tbl.portfolio <- tbl(conn, "portfolio")
  
######################################################
#Companies by type  
  
  # Fill in the spot we created for a plot
  output$company <- renderPlot({
    tab <- tbl.company
    if (input$type != "All") {
      tab <- tab %>% filter(type == input$type)
    }
    
    ggplot(data.frame(tab), aes_string(x = "ticker", y = "market_cap")) + geom_bar(stat = "identity") +
      ggtitle(input$type) + xlab("Ticker") + ylab("Market cap")
  })
  
######################################################
#Companies by ticker 
   
  output$stock <- renderPlot({
    validate(need(length(input$ticker) > 0, "Izberi vsaj en ticker!"))
    tab <- tbl.stock
    if (length(input$ticker) == 1) {
      tab <- tab %>% filter(ticker == input$ticker)
    } else {
      tab <- tab %>% filter(ticker %in% input$ticker)
    }
    
    ggplot(data.frame(tab), aes_string(x = "date", y = input$value, color="ticker",fill="ticker")) + geom_bar(stat = "identity") +
      ggtitle(input$ticker) + xlab("Date") + ylab(input$value) + 
      geom_point(aes_string(x = "date", y = input$value), colour='blue', size=0.5)
  })
  
######################################################
#Stock Data  
  
  
  output$stock1 <- renderPlot({
    tab <- tbl.stock1
    if (input$ticker1 == "All") { # prikazujemo vse delnice
      max.index <- tab %>% summarise(max(index)) %>% data.frame() %>% .[,1] %>%
        strftime() # pridobimo čas najnovejših vrednosti in samo te prikažemo
      graf <- ggplot(tab %>% filter(index == max.index) %>% data.frame(),
                     aes_string(x = "ticker", y = input$value1, fill="ticker")) +
        geom_bar(stat = "identity")
      graf + ggtitle("All")+ xlab("Ticker") 
    } else { # prikazujemo posamezno delnico
      graf <- ggplot(tab %>% filter(ticker == input$ticker1) %>% data.frame(),
                     aes_string(x = "index", y = input$value1, fill="ticker")) + geom_line()
      graf + ggtitle(input$ticker1) + xlab("Date") + ylab(input$value1)
    }
  })
  

  
  ######################################################
  #Portfolio Analysis
  
  portfolio.data <- reactive({
    data <- tbl.portfolio
    if (input$index != "All") {
      data <- data %>% filter(index == input$index)
    }
    data <- data %>% filter(date2 >= input$daterange[1],
                            date2 <= input$daterange[2]) %>%
      group_by(index, date2)
    if (input$index == "All") {
      data <- data %>% summarise(am = sum(am))
    } else {
      data <- data %>% summarise(am = sum(am),
                                 tickers = string_agg(sel_tickers, ","))%>%
        arrange(date2)
    }
    data <- data %>% data.frame()
    data$date2 <- as.Date(data$date2)
    data
  })
  
  output$portfolio <- renderPlot({
    if (input$index == "All") {
      guide <- guide_legend(title = "Index")
    } else {
      guide <- FALSE
    }
    ggplot(portfolio.data(),
           aes(x = date2, y = am, color = factor(index), group = index)) +
      geom_line() + xlab("Date") + ylab("Asset Movement") +
      scale_color_discrete(guide = guide)
  })
  
  output$tickers <- renderTable({
    validate(need(input$index != "All", ""))
    data <- portfolio.data()
    tickers <- data$tickers %>% strsplit(",") %>% as.data.frame() %>% t()
    rownames(tickers) <- NULL
    df <- data.frame(as.character(data$date2), tickers)
    names(df) <- c("Datum", paste("Ticker", 1:input$index))
    df
  })
  
})