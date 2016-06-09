library(shiny)

# Define the overall UI
shinyUI(
  fluidPage(
    
    titlePanel("Profit"),
    
    tabsetPanel(
      
######################################################
      
      tabPanel("Companies by type",
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
               ),

######################################################
      
      tabPanel("Companies by ticker",
               sidebarLayout(      
                 
                 # Define the sidebar with one input
                 sidebarPanel(
                   # wellPanel(
                   #   p(strong("stock")),
                   #   checkboxInput(inputId = "AAPL", label = "Apple (AAPL)",     value = TRUE)
                   # ),
                   # selectInput(inputId="ticker",
                   #             label="Ticker",
                   #             choices = c("Candlestick" = "candlesticks",
                   #                         "Matchstick" = "matchsticks",
                   #                         "Bar" = "bars",
                   #                         "Line" = "line")
                   #             ),
                   selectInput("ticker", "Ticker:",
                               choices=c("TOT","PTR","CVX","GE","XOM","FB","MSFT","GOOG",
                                         "GOOGL","AAPL","HSBC","C","BAC","JPM","WFC"),
                               selected = "TOT", multiple = TRUE
                   ),
                   selectInput("value", "Vrednost", 
                               choices=c("open", "high", "low",
                                         "close", "volume", "adjusted","change"),
                               selected = "open"),
                   hr(),
                   helpText("Izbira tickerjev in vrednosti")
                 ),
                 
                 # Create a spot for the barplot
                 mainPanel(
                   plotOutput("stock")
                   # plotOutput("stock_open")
                   # plotOutput("stock_close"),
                   # plotOutput("stock_volume")
                 )
                 
               )
               ),

######################################################
      
      tabPanel("Stock Data",
               sidebarLayout(      
                 
                 # Define the sidebar with one input
                 sidebarPanel(
                   wellPanel(
                     p(strong("Stocks"))
                   ),
                   selectInput("ticker1", "Ticker", 
                               choices=c("All","WFC","JPM","BAC","C","HSBC","AAPL","GOOGL",
                                         "GOOG","MSFT","FB","XOM","GE","CVX","PTR","TOT")),
                   selectInput("value1", "Vrednost", 
                               choices=c("open", "high", "low",
                                         "close", "volume", "adjusted","change"),
                               selected = "close"),
                   hr(),
                   helpText("Izbira delnice in vrednosti. Pri izbiri All se prikažejo različne vrednosti
                            zadnjega dne")
                 ),
                 
                 # Create a spot for the barplot
                 mainPanel(
                   plotOutput("stock1")  
                 )
                 
               )
               ),

######################################################
      
      tabPanel("Portfolio Analysis",
               sidebarLayout(      
                 
                 # Define the sidebar with one input
                 sidebarPanel(
                   wellPanel(
                     p(strong("Portfolio"))
                   ),
                   dateRangeInput(inputId = "daterange", label = "Date range",
                                  start = "2015-01-05", end = Sys.Date()),
                   selectInput("index", "Index", 
                               choices=c("All", "1", "3", "7")
                   ),
                   hr(),
                   helpText("Izbira časovnega obdobja in strategije. Indeks i označuje strategijo i,
                            ki nam pove: vsak dan izberi i najbolj donosnih delnic prejšnjega dne in jih 
                            kupi po open price tega dne. Tabela pod grafom nam izpiše katere delnice
                            naj kupimo v določenem dnevu.")
                 ),
                 
                 # Create a spot for the barplot
                 mainPanel(
                   plotOutput("portfolio"),
                   tableOutput("tickers")
                 )
                 
               )
               )
      
    )
    
  )
)