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
  tbl.stock <- tbl(conn, "stock")
  
  # Fill in the spot we created for a plot
  output$stock <- renderPlot({
    tab <- tbl.stock
    if (input$ticker == "All") { # prikazujemo vse delnice
      max.index <- tab %>% summarise(max(index)) %>% data.frame() %>% .[,1] %>%
        strftime() # pridobimo čas najnovejših vrednosti in samo te prikažemo
      graf <- ggplot(tab %>% filter(index == max.index) %>% data.frame(),
                     aes_string(x = "ticker", y = input$value)) +
        geom_bar(stat = "identity")
    } else { # prikazujemo posamezno delnico
      graf <- ggplot(tab %>% filter(ticker == input$ticker) %>% data.frame(),
                     aes_string(x = "index", y = input$value)) + geom_line()
    }
    graf + ggtitle(input$ticker) + xlab("Ticker") + ylab(input$value)
  })
  
})


