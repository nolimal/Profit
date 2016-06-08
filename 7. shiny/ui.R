library(shiny)

# Izbira
#library(datasets)

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel("Asset movement"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        wellPanel(
          p(strong("Portfolio"))
        ),
        dateRangeInput(inputId = "daterange", label = "Date range",
                       start = startDate, end = Sys.Date()),
        selectInput("index", "Index", 
                  choices=c("1", "3", "7"),
                  ),
        hr(),
        helpText("Izbira datuma in portfolia.")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        plotOutput("portfolio")  
      )
      
    )
  )
)

