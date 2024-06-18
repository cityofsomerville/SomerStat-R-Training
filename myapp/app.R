library(shiny)
library(learnr)

# Define UI for app that displays the learnr tutorial ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Hello Shiny!"),
  
  # iframe to include the learnr tutorial ----
  tags$iframe(
    id = "learnr_tutorial",
    style = "height:600px; width:100%; border:none;",
    src = "index.html"
  )
  
)

# Define server logic required to render and display the learnr tutorial ----
server <- function(input, output, session) {
  
  # Render the learnr tutorial ----
  observe({
    learnr::run_tutorial(
      name = "docs/index.Rmd"


    )
  })
  
}

shinyApp(ui = ui, server = server)