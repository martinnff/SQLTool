library(shiny)
library(dbplyr)
library(DBI)
library(DT)
library(RMariaDB)


ui <- fluidPage(
  fluidRow(
    column(
      6,
      textAreaInput('query',h2('Query'),height = '250px',width='400px')
      ),
    column(
      6,
      textInput('username',h6('Username'),''),
      textInput('password',h6('Password'),''),
      textInput('host',h6('Host'),''),
      textInput('port',h6('Port'),''),
      textInput('database',h6('Database'),'')
    )
    ),
  fluidRow(
    DT::dataTableOutput("table")
  )


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
  output$table = DT::renderDataTable({
    out()
  })
  
}

shinyApp(ui,server)


