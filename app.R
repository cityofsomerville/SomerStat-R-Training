

# Load required libraries
library(shiny)
library(learnr)
library(tidyverse)
library(Lahman)
library(RSocrata)
library(stringr)

# Define UI for app that displays the learnr tutorial ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Hello Shiny!"),
  
  # iframe to include the learnr tutorial ----
  tags$iframe(
    id = "learnr_tutorial",
    style = "height:600px; width:100%; border:none;",
    src = "tutorial.html"
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