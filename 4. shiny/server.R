library(shiny)
library(dplyr)
library(RPostgreSQL)

source("3. baza/auth.R",encoding='UTF-8')

shinyServer(function(input, output) {
  # Vzpostavimo povezavo
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  # Pripravimo tabelo
  tbl.company <- tbl(conn, "type")
  
  output$transakcije <- renderTable({
    # Naredimo poizvedbo
    # x %>% f(y, ...) je ekvivalentno f(x, y, ...)
    t <- tbl.transakcija %>% filter(znesek > input$min) %>%
      arrange(znesek) %>% data.frame()
    # ÄŚas izpiĹˇemo kot niz
    t$cas <- as.character(t$cas)
    # Vrnemo dobljeno razpredelnico
    t
  })
  
})


# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)

# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  # Fill in the spot we created for a plot
  output$phonePlot <- renderPlot({
    
    # Render a barplot
    barplot(WorldPhones[,input$region]*1000, 
            main=input$region,
            ylab="Market cap",
            xlab="Company name")
  })
})


