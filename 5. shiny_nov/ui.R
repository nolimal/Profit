library(shiny)



# Izbira
library(datasets)

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel("Companies by type"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        selectInput("ticker", "Ticker:", 
                    choices=c("All", "TOT","PTR","CVX","GE","XOM","FB","MSFT","GOOG",
                              "GOOGL","AAPL","HSBC","C","BAC","JPM","WFC")),
        hr(),
        helpText("Izbira tipa.")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        plotOutput("stock")  
      )
      
    )
  )
)



# shinyUI(pageWithSidebar(
#   headerPanel("Stocks"),
#   
#   sidebarPanel(
#     wellPanel(
#       p(strong("Stocks")),
#       checkboxInput(inputId = "stock_aapl", label = "Apple (AAPL)",     value = TRUE),
#       checkboxInput(inputId = "stock_msft", label = "Microsoft (MSFT)", value = FALSE),
#       checkboxInput(inputId = "stock_ibm",  label = "IBM (IBM)",        value = FALSE),
#       checkboxInput(inputId = "stock_goog", label = "Google (GOOG)",    value = FALSE),
#       checkboxInput(inputId = "stock_yhoo", label = "Yahoo (YHOO)",     value = FALSE),
#       checkboxInput(inputId = "stock_ticker", label = "full_name (ticker)",    value = FALSE)
#     ),
#     
#     selectInput(inputId = "chart_type",
#                 label = "Chart type",
#                 choices = c("Candlestick" = "candlesticks",
#                             "Matchstick" = "matchsticks",
#                             "Bar" = "bars",
#                             "Line" = "line")
#     ),
#     
#     dateRangeInput(inputId = "daterange", label = "Date range",
#                    start = startDate, end = Sys.Date()),
#     
#     checkboxInput(inputId = "log_y", label = "log y axis", value = FALSE)
#   ),
#   
#   mainPanel(
#     conditionalPanel(condition = "input.stock_aapl",
#                      br(),
#                      div(plotOutput(outputId = "plot_aapl"))),
#     
#     conditionalPanel(condition = "input.stock_msft",
#                      br(),
#                      div(plotOutput(outputId = "plot_msft"))),
#     
#     conditionalPanel(condition = "input.stock_ibm",
#                      br(),
#                      div(plotOutput(outputId = "plot_ibm"))),
#     
#     conditionalPanel(condition = "input.stock_goog",
#                      br(),
#                      div(plotOutput(outputId = "plot_goog"))),
#     
#     conditionalPanel(condition = "input.stock_yhoo",
#                      br(),
#                      plotOutput(outputId = "plot_yhoo"))
#   )
# ))