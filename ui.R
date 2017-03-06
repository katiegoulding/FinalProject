library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

simpleSpeedDating.df <- read.csv("data/simpleSpeedDating.df.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("confidence", label = h5("Select confidence range:"), min = 0,  max = 1, value = c(0, .1)
      ),
                  
      sliderInput("success", label = h5("Select success range:"), min = 0,  max = 1, value = c(0, .1)
      )
    ),
    mainPanel(
      plotlyOutput("third.vis")
    )
  )
)



shinyUI(ui)