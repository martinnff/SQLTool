library(shiny)
library(dbplyr)
library(DBI)
library(DT)
library(RMariaDB)
library(shinythemes)

ui <- fluidPage(theme = shinytheme('cosmo'),
                h1('SQLTool'),
  fluidRow(
    column(
      6,
      textAreaInput('query',h2('Query'),height = '300px',width='400px'),
      downloadButton('download',"Download the data")),
    column(
      6,
      textInput('username',h6('Username'),''),
      textInput('password',h6('Password'),''),
      textInput('host',h6('Host'),''),
      textInput('port',h6('Port'),''),
      textInput('database',h6('Database'),'')
    )
    ),
  
  fluidRow(column(12,DTOutput('dto')))


)

server <- function(input,output){
  out = reactive(
    tryCatch({
      con <- dbConnect(
        drv = RMariaDB::MariaDB(), 
        username = input$username,
        password = input$password, 
        host = input$host, 
        port = input$port,
        dbname = input$database
      )
    dbGetQuery(con, input$query)
      },
      error = function(e){data.frame(Empty='Empty')}))
  output$dto <- renderDataTable(
    out()
  )
  output$download <- downloadHandler(
    filename = function(){'download.csv'}, 
    content = function(fname){
      write.csv(out(), fname)
    }
  )
  
}

shinyApp(ui,server)


