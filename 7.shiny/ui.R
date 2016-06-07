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
        selectInput("portfolio", "Portfolio", 
                    choices=c("All","Portfolio1","Portfolio3","Portfolio7")),
                    selected = "close"),
        hr(),
        helpText("Izbira portfolia.")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        plotOutput("portfolio")  
      )
      
    )
  )

