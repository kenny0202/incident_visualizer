library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(bootstrapPage(theme = "bootstrap.css",
  #add tag to hide the error message
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  # Application title
  navbarPage("Support Incident Visualizer", collapsible = TRUE,
    tabPanel("Home", icon = icon("home"),
      wellPanel(
        helpText(h4("Introduction"))
      ),
      wellPanel(
        helpText(h4("Examples")),
        p("Below images are exmaples of newly created incidents coming in for a specific product."),
        img(src="siv.png", width="608"),
        img(src="siv2.png", width="608"),
        img(src="siv3.png", width="608")
      ),
      wellPanel(
        helpText(h4("Getting started")),
        p("Head over to the Data Tab and upload your csv file. Make sure that the file is following the following format 'yyyy-mm-dd,day,#ofincident'.
          An example input would be '2016-10-24,monday,5'."),
        p("A data table will be generated containing the header of the columns and the data will be loaded. From here on you can either modify the table
          or head over to the Graph Tab to visualize the data or the Table Tab to read the data in a table format.")
      )
    ), 
    tabPanel("Data", icon = icon("file-text"),
      sidebarLayout(
        sidebarPanel(
          fileInput("file", h3("Upload CSV File"), accept=c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
          p("Contents in the file must be in the following format:"),
          p("This must be at the very top: 'date,day_of_week,num_of_inc'"),
          p("The contents following the header must be in the following format: '2016-10-24,monday,5'"),
          tags$hr(),
          checkboxInput("header", "Header", TRUE),
          radioButtons("sep", "Separator", c(Comma=','), ','),
          tags$hr(),
          uiOutput("dataModify"),
          uiOutput("columnName"),
          uiOutput("new_columnName"),
          uiOutput("updateButton")
        ),
        mainPanel(
          h3(textOutput("caption")),
          tableOutput('createTable')
        )
      )
    ),         
    tabPanel("Graph", icon = icon("bar-chart"),
      
      dateRangeInput("dateRange", h3("Date Selection: "), start="2016-10-24", end=NULL, format="yyyy-mm-dd", min="2016-10-24", language = "en", width="100%"),
      fluidRow(column(6, verbatimTextOutput("date"))),
        
      #Test table creation
      #fluidRow(column(6,tableOutput('table'))),
        
      mainPanel(height = '100%', width = 12,
        #graph the plot using plotly instead.
        plotlyOutput("incidentPlot"),
        tags$br(),
        wellPanel(
          h3("Statistics"),
          tags$hr(),
          fluidRow(column(1, tags$b("Mean :")), 
                   column(3, verbatimTextOutput("meanCalculation")),
                   column(1, tags$b("Mode :")), 
                   column(3, verbatimTextOutput("modeCalculation")),
                   column(1, tags$b("Median :")), 
                   column(3, verbatimTextOutput("medianCalculation"))),
          fluidRow(column(2, tags$b("Total incident filtered by date :")), 
                   column(2, verbatimTextOutput("totalIncidentRange")),
                   column(2, tags$b("Total incident filtered by month :")), 
                   column(2, verbatimTextOutput("totalMonthly"))
                   )
        )
      )
    ),
    tabPanel("Table", icon = icon("table"),
      sidebarLayout(
        sidebarPanel(h3("Table Filter"),
          dateRangeInput("tabledateRange", "Date Selection: ", start="2016-10-24", end=NULL, format="yyyy-mm-dd", min="2016-10-24", language = "en", width="100%"),
          fluidRow(column(6, verbatimTextOutput("tableDate")))
        ),
        mainPanel(
          fluidRow(column(6,DT::dataTableOutput('sltincidents')))
        )
      ) 
    )
  )
))



