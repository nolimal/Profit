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
    data <- tab %>% filter(index == input$index,
                           date2 >= input$daterange[1],
                           date2 <= input$daterange[2]) %>%
      group_by(date2) %>% summarise(am = sum(am)) %>% data.frame()
    data$date2 <- as.Date(data$date2)
    graf<-ggplot(data, aes(x = date2, y = am)) +
      geom_line() + xlab("Date") + ylab("Asset Movement")
    graf
  })
  
})

