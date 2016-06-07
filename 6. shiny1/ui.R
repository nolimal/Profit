library(shiny)

# Izbira
#library(datasets)

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    -
    # Give the page a title
    titlePanel("Stock"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        wellPanel(
          p(strong("Stocks"))
        ),
        selectInput("ticker", "Ticker", 
                    choices=c("All","WFC","JPM","BAC","C","HSBC","AAPL","GOOGL",
                              "GOOG","MSFT","FB","XOM","GE","CVX","PTR","TOT")),
        selectInput("value", "Vrednost", 
                    choices=c("open", "high", "low",
                              "close", "volume", "adjusted","change"),
                    selected = "close"),
        hr(),
        helpText("Izbira delnice in vrednosti.")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        plotOutput("stock")  
      )
      
    )
  )
)

