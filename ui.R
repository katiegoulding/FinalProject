library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)

ui <- navbarPage(
    navbarPage(
    "Speed Dating!",
    tabPanel("Home"),
    tabPanel("Match Percentage",
             sidebarLayout()),
    tabPanel("Characteristics",
             sidebarLayout()),
    tabPanel("Confidence & Success",
             sidebarLayout()),
    tabPanel("Works Cited")
  
    )
)

shinyUI(ui)