library(shiny)
library(plotly)
library(DT)
#library(ggplot2)

source("R/functions.R")

shinyServer(function(input, output) {
  
  #HOME SECTION
  output$text1 <- renderText(paste("date,day_of_week,num_of_inc"))
  output$text2 <- renderText(paste("2016-10-24,monday,5"))
  output$text3 <- renderText(paste("2016-10-25,tuesday,1"))
  output$text4 <- renderText(paste("2016-10-26,wednesday,6"))
  output$text5 <- renderText(paste("2016-10-27,thursday,7"))
  output$text6 <- renderText(paste("2016-10-28,friday,2"))
  #END OF HOME
  
  #DATA SECTION
  
  #read in any csv file with specific format and will create a data frame in the variable csv_to_Table
  #input any csv file
  readFile <- reactive({
    infile <- input$file
    if (is.null(infile)){
      return(NULL)      
    }
    csv_to_Table <- read.csv(infile$datapath, header=input$header, sep=input$sep)
  })
  
  #using the reactive expression readFile(), take the result and generate the table.
  output$createTable <- renderTable({
    readFile()
  })
  
  output$dataModify <- renderUI({
    df <- readFile()
    if (is.null(df)) 
      return(NULL)
    h3("Data Modification")
  })
  
  output$columnName <- renderUI({
    df <- readFile()
    if (is.null(df)) 
      return(NULL)
    items = names(df)
    names(items) = items
    selectInput("rename_column", "Select a column to rename", items)
  })
  
  output$new_columnName <- renderUI({
    df <- readFile()
    if (is.null(df)) 
      return(NULL)
    items = names(df)
    names(items) = items
    textInput("new_column","Enter new column name",items)
  })
  
  output$updateButton <- renderUI({
    df <- readFile()
    if (is.null(df)) 
      return(NULL)
    items = names(df)
    names(items) = items
    submitButton("Update")
  })
  #END OF DATA
  
  #GRAPH sECTION
  
  #date selection range
  output$date <- renderPrint({input$dateRange})
  
  #read in the csv file.
  #hardcode to read specific file
  #slt <- reactive({
  #read.csv("data/slt_inc.csv")
  #})
  
  #creating a subset of the original slt dataframe.
  slt_subset <- reactive({
    slt_sub <- subset(readFile(), as.Date(readFile()$date) >= input$dateRange[1] & as.Date(readFile()$date) <= input$dateRange[2])
    return(slt_sub)
  })
  
  #generate a graph using plotly library
  output$incidentPlot <- renderPlotly({
    plot_ly(y=(slt_subset()$num_of_inc), x=(slt_subset()$date), type="bar", color = I("blue")) %>% 
      layout(title="SLT Incidents", xaxis = list(title="Date"), yaxis = list(title="# of Incidents"))
  })
  
  #calculate the mean of incidents, average number
  output$meanCalculation <- renderPrint({
    mean(slt_subset()$num_of_inc)
  })
  
  #calculate the mode of incidents
  #mode is a custom function in R/functions.R, most occurrence
  output$modeCalculation <- renderPrint({
    mode(slt_subset()$num_of_inc)
  })
  
  #calculate the median of the incidents, middle number
  output$medianCalculation <- renderPrint({
    median(slt_subset()$num_of_inc)
  })
  
  #Calculate total number of incident specified within the date range filter.
  output$totalIncidentRange <- renderPrint({
    sum(slt_subset()$num_of_inc)
  })
  
  #calculate total number of incident created within a month.
  output$totalMonthly <- renderPrint({
    
  })
  
  #machine learning to estimate how many incidents will be created in the next month
  output$estimatedMonthly <- renderPrint({
    
  })
  #END OF GRAPH
  
  #TABLE SECTION
  
  #not yet working, may throw away this code
  #output$tableDate <- renderPrint({input$tabledateRange})
  
  #generate a data table from the read in csv file
  output$sltincidents <- DT::renderDataTable({readFile()})
  
  #END OF TABLE
  
  
  
  #test table creation in ui.R
  #output$table <- renderTable({slt_subset()})
  
})
