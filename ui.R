library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("confidence", label = h5("Select confidence range:"), 
                  min = 0,
                  max = 10,
                  value = 0
      ),
                  
      sliderInput("success", label = h5("Select sucess range:"), 
                  min = 0,
                  max = 10,
                  value = 0
                  
      )
    ),
    mainPanel(
      plotlyOutput("third.vis")
    )
  )
 )


shinyUI(ui)