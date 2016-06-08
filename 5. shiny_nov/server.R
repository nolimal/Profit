library(shiny)
library(dplyr)
library(RPostgreSQL)
library(ggplot2)

if ("server.R" %in% dir()) {
  setwd("..")
}
source("3. baza/auth_public.R",encoding='UTF-8')


# library(datasets)

# Define a server for the Shiny app
shinyServer(function(input, output) {
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  tbl.stock <- tbl(conn, "company")
  tbl.company <- tbl(conn, "company")
  tbl.stock <- tbl(conn, "company")
  
  # Fill in the spot we created for a plot
  output$stock <- renderPlot({
    tab <- tbl.stock
    if (input$ticker != "All") {
      tab <- tab %>% filter(ticker == input$ticker)
    }
    
    ggplot(data.frame(tab), aes_string(x = "date", y = "open")) + geom_bar(stat = "identity") +
      ggtitle(input$ticker) + xlab("Ticker") + ylab("Market cap")
  })
})



# library(shiny)
# library(dplyr)
# library(RPostgreSQL)
# library(ggplot2)
# 
# if ("server.R" %in% dir()) {
#   setwd("..")
# }
# source("3. baza/auth.R",encoding='UTF-8')
# 
# # if (!require(quantmod)) {
# #   stop("Run 'install.packages(\"quantmod\")'.\n")
# # }
# 
# # Download data for a stock if needed, and return the data
# require_symbol <- function(symbol, envir = parent.frame()) {
#   if (is.null(envir[[symbol]])) {
#     envir[[symbol]] <- getSymbols(symbol, auto.assign = FALSE)
#   }
#   
#   envir[[symbol]]
# }
# 
# 
# shinyServer(function(input, output) {
#   conn <- src_postgres(dbname = db, host = host,
#                        user = user, password = password)
#   tbl.company <- tbl(conn, "company")
#   tbl.stock <- tbl(conn, "stock")
#   tbl.portfolio <- tbl(conn, "portfolio")
#   
#   # Create an environment for storing data
#   symbol_env <- new.env()
#   
#   # Make a chart for a symbol, with the settings from the inputs
#   make_chart <- function(symbol) {
#     symbol_data <- require_symbol(symbol, symbol_env)
#     
#     chartSeries(symbol_data,
#                 name      = symbol,
#                 type      = input$chart_type,
#                 subset    = paste(input$daterange, collapse = "::"),
#                 log.scale = input$log_y,
#                 theme     = "white")
#   }
#   
#   output$plot_aapl <- renderPlot({ make_chart("AAPL") })
#   output$plot_msft <- renderPlot({ make_chart("MSFT") })
#   output$plot_ibm  <- renderPlot({ make_chart("IBM")  })
#   output$plot_goog <- renderPlot({ make_chart("GOOG") })
#   output$plot_yhoo <- renderPlot({ make_chart("YHOO") })
#   # output$plot_aapl <- renderPlot({ make_chart("AAPL") })
#   # output$plot_msft <- renderPlot({ make_chart("MSFT") })
#   # output$plot_ibm  <- renderPlot({ make_chart("IBM")  })
#   # output$plot_goog <- renderPlot({ make_chart("GOOG") })
#   # output$plot_yhoo <- renderPlot({ make_chart("YHOO") })
#   # output$plot_aapl <- renderPlot({ make_chart("AAPL") })
#   # output$plot_msft <- renderPlot({ make_chart("MSFT") })
#   # output$plot_ibm  <- renderPlot({ make_chart("IBM")  })
#   # output$plot_goog <- renderPlot({ make_chart("GOOG") })
#   # output$plot_yhoo <- renderPlot({ make_chart("YHOO") })
# })