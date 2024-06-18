

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
  titlePanel("App.R in Documents!"),
  

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