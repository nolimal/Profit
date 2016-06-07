library(shiny)
library(dplyr)
library(RPostgreSQL)
library(ggplot2)

if ("server.R" %in% dir()) {
  setwd("..")
}
source("3. baza/auth_public.R",encoding='UTF-8')


# shinyServer(function(input, output) {
#   # Vzpostavimo povezavo
#   conn <- src_postgres(dbname = db, host = host,
#                        user = user, password = password)
#   # Pripravimo tabelo
#   tbl.company <- tbl(conn, "type")
#   
#   output$transakcije <- renderTable({
#     # Naredimo poizvedbo
#     # x %>% f(y, ...) je ekvivalentno f(x, y, ...)
#     t <- tbl.transakcija %>% filter(znesek > input$min) %>%
#       arrange(znesek) %>% data.frame()
#     # ÄŚas izpiĹˇemo kot niz
#     t$cas <- as.character(t$cas)
#     # Vrnemo dobljeno razpredelnico
#     t
#   })
#   
# })


# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
# library(datasets)

# Define a server for the Shiny app
shinyServer(function(input, output) {
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  tbl.company <- tbl(conn, "company")
  
  # Fill in the spot we created for a plot
  output$company <- renderPlot({
    tab <- tbl.company
    if (input$type != "All") {
      tab <- tab %>% filter(type == input$type)
    }
    
    ggplot(data.frame(tab), aes_string(x = "ticker", y = "market_cap")) + geom_bar(stat = "identity") +
      ggtitle(input$type) + xlab("Ticker") + ylab("Market cap")
  })
})


