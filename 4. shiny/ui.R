library(shiny)

# shinyUI(fluidPage(
#   
#   titlePanel("Company"),
#   
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("min",
#                   "Minimalni znesek transakcije:",
#                   min = -10000,
#                   max = 10000,
#                   value = 1000)
#     ),
#     
#     mainPanel(
#       tableOutput("transakcije")
#     )
#   )
# ))


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
        selectInput("type", "Type:", 
                    choices=c("All", "Energy","Finance","Technology")),
        hr(),
        helpText("Izbira tipa.")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        plotOutput("company")  
      )
      
    )
  )
)

