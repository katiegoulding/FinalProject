library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

# setwd("~/Desktop/INFO 201 Autumn 17 HW/FinalProject")
speedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)


server <- function(input, output) {
  
  function(input, output) {

    output$table <- renderDataTable({
      speed.data
    })
  }
}
shinyServer(server)